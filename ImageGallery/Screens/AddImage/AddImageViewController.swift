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
    }
    
    private func setupNavigationController() {
        self.navigationController?.navigationBar.isHidden = true
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
        //guard let longitude = viewModel.longitude, let latitude = viewModel.latitude else { AlertHelper.showAlert("Couldn't get current location"); return }
        
        let imageForm = ImageForm(image: imageData, description: descriptionTextField.text, hashtag: hashtagTextField.text, latitude: 0, longitude: 0)
        
        HUDRenderer.showHUD()
        viewModel.uploadImage(imageForm: imageForm, completion: { [weak self] result in
            HUDRenderer.hideHUD()
            guard let `self` = self else { return }
            
            switch result {
            case .result(let _):
                self.navigationController?.popViewController(animated: true)
            case .error(let error):
                AlertHelper.showAlert(error.localizedDescription)
            }
        })
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
            if let image = ImageResizer.resizeImage(image: pickedImage, targetSize: CGSize(width: 600, height: 400)) {
                viewModel.imageData = UIImagePNGRepresentation(image)
                self.imageView.image = image
            } else {
                viewModel.imageData = UIImagePNGRepresentation(pickedImage)
                self.imageView.image = pickedImage
            }
            
//            viewModel.imageData = UIImagePNGRepresentation(pickedImage)
//            self.imageButton.setImage(pickedImage, for: .normal)
        }
        
       dismiss(animated: true, completion: nil)
    }
}

extension AddImageViewController: StoryboardIdentifiable {}
