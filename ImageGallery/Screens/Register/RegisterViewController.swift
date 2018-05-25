//
//  RegisterViewController.swift
//  TestTask
//
//  Created by Serhiy on 5/21/18.
//  Copyright © 2018 Serhiy. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class RegisterViewController: UIViewController, UINavigationControllerDelegate {
    @IBOutlet weak var userNameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    var viewModel = RegisterModelFactory.default()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupNavigationController()
    }
    
    private func setupNavigationController() {
        
    }
    
    private func setupView() {
        passwordTextField.isSecureTextEntry = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.view.addGestureRecognizer(tapGesture)
        
        let imageGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTouchUpInside))
        self.avatarImageView.isUserInteractionEnabled = true
        self.avatarImageView.addGestureRecognizer(imageGesture)
    }
    
    @objc func handleTap(_ sender: UIGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func sendButtonTouchUpInside(_ sender: UIButton) {
        validate()
    }
    
    @objc func imageViewTouchUpInside(_ sender: UIGestureRecognizer) {
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func showImagesScreen(token: AuthInfo) {
        if let controller: AllImagesViewController = Storyboard.main.instantiateViewController() {
            controller.viewModel = AllImagesFactory.default(token: token)
            self.navigationController?.setViewControllers([controller], animated: true)
        }
    }
    
    deinit {
        print("RegisterViewController - deinit")
    }
    
}

extension RegisterViewController {
    @objc func validate() {
        guard let data = viewModel.avatar else { AlertHelper.showAlert("You need select avatar first"); return }
        guard let email = emailTextField.text, email.count > 0 else { AlertHelper.showAlert("Please, enter email"); return }
        guard let password = passwordTextField.text, password.count > 0 else { AlertHelper.showAlert("Please, enter password"); return }
        
        if !ValidationHelper.isValidEmail(email) {
            AlertHelper.showAlert("Please, enter valid email")
            return
        }
        
        let user = UserForm(userName: userNameTextField.text, email: email, password: password, avatar: data)
        
        HUDRenderer.showHUD()
        viewModel.register(userForm: user, completion: { [weak self] result in
            guard let `self` = self else { return }
            
            switch result {
            case .result(let info):
                self.showImagesScreen(token: info)
            case .error(let error):
                AlertHelper.showAlert(error.localizedDescription)
            }
            
        })
    }
}

extension RegisterViewController: UIImagePickerControllerDelegate {
    // MARK: - UIImagePickerControllerDelegate Methods
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])  {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            if let image = ImageResizer.resizeImage(image: pickedImage, targetSize: CGSize(width: 600, height: 400)) {
                viewModel.avatar = UIImagePNGRepresentation(image)
                self.avatarImageView.image = image
            } else {
                viewModel.avatar = UIImagePNGRepresentation(pickedImage)
                self.avatarImageView.image = pickedImage
            }
            
//            viewModel.avatar = UIImagePNGRepresentation(pickedImage)
//            self.avatarImageView.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
}

extension RegisterViewController: StoryboardIdentifiable {}

