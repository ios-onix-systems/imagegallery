//
//  AddImageViewController.swift
//  TestTask
//
//  Created by Serhiy on 5/22/18.
//  Copyright © 2018 Serhiy. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class AddImageViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var hashtagTextField: SkyFloatingLabelTextField!
    
    var viewModel: AddImageModelType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationController()
        setupView()
        bindModel()
    }
    
    private func setupNavigationController() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func bindModel() {
        viewModel.subscribeOnLocationError(closure: { [weak self] error in
            DispatchQueue.main.async {
                guard let `self` = self else { return }
                
                AlertHelper.showAlert("Location service error")
                self.navigationController?.popViewController(animated: true)
            }
        })
    }
    
    private func setupView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.view.addGestureRecognizer(tapGesture)
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(selectImageTouchUpInside))
        self.imageView.isUserInteractionEnabled = true
        self.imageView.addGestureRecognizer(imageTap)
    }
    
    @objc func handleTap(_ sender: UIGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @objc func selectImageTouchUpInside(_ sender: UIGestureRecognizer) {
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func submitButtonTouchUpInside(_ sender: UIButton) {
        guard let imageData = viewModel.imageData else { AlertHelper.showAlert("You need to select image first"); return }
        guard let longitude = viewModel.longitude, let latitude = viewModel.latitude else { AlertHelper.showAlert("Couldn't get current location"); return }
        
        let imageForm = ImageForm(image: imageData, description: descriptionTextField.text, hashtag: hashtagTextField.text, latitude: latitude, longitude: longitude)
        
        HUDRenderer.showHUD()
        viewModel.uploadImage(imageForm: imageForm, completion: { [weak self] result in
            DispatchQueue.main.async {
                HUDRenderer.hideHUD()
                guard let `self` = self else { return }
                
                switch result {
                case .result( _):
                    self.navigationController?.popViewController(animated: true)
                case .error(let error):
                    AlertHelper.showAlert(error.localizedDescription)
                }
            }
        })
    }
    
    @IBAction func backTouchUpInside(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    deinit {
        print("AddImageViewController - deinit")
    }
}

extension AddImageViewController: UIImagePickerControllerDelegate {
    // MARK: - UIImagePickerControllerDelegate Methods
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])  {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            // TODO : - remove after tests
            if let image = ImageResizer.resizeImage(image: pickedImage, targetSize: imageView.frame.size) {
                viewModel.imageData = UIImagePNGRepresentation(image)
                self.imageView.image = image
            } else {
                viewModel.imageData = UIImagePNGRepresentation(pickedImage)
                self.imageView.image = pickedImage
            }

//            viewModel.imageData = UIImagePNGRepresentation(pickedImage)
//            self.imageView.image = pickedImage
        }
        
       dismiss(animated: true, completion: nil)
    }
}

extension AddImageViewController: StoryboardIdentifiable {}
