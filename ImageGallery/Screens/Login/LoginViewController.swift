//
//  LoginViewController.swift
//  TestTask
//
//  Created by Serhiy on 5/21/18.
//  Copyright © 2018 Serhiy. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var fieldsContainerView: UIView!
    
    var viewModel = LoginModelFactory.default()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIDevice.isSimulator {
            emailTextField.text = "sergey.pritula@onix-systems.com"
            passwordTextField.text = "123456"
        }
        
        setupView()
        setupNavigationController()
    }
    
    deinit {
        print("LoginViewController - deinit")
    }
    
    private func setupNavigationController() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setupView() {
        passwordTextField.isSecureTextEntry = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(_ sender: UIGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    private func showImagesScreen(token: AuthInfo) {
        if let controller: AllImagesViewController = Storyboard.main.instantiateViewController() {
            controller.viewModel = AllImagesFactory.default(token: token)
            self.navigationController?.setViewControllers([controller], animated: true)
        }
    }
    
    @IBAction func sendTouchUpInside(_ sender: UIButton) {
        validate()
    }
    
    @IBAction func registerTouchUpInside(_ sender: UIButton) {
        if let controller: RegisterViewController = Storyboard.landing.instantiateViewController() {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}

extension LoginViewController: StoryboardIdentifiable {}

extension LoginViewController {
    
    @objc func validate() {
        guard let email = emailTextField.text, email.count > 0 else { AlertHelper.showAlert("Please, enter email"); return }
        guard let password = passwordTextField.text, password.count > 0 else { AlertHelper.showAlert("Please, enter password"); return }
        
        if !ValidationHelper.isValidEmail(email) {
            AlertHelper.showAlert("Please, enter valid email")
            return
        }
        
        HUDRenderer.showHUD()
        viewModel.confirmLogin(email: email, password: password, completion: { [weak self] result in
            DispatchQueue.main.async {
                HUDRenderer.hideHUD()
                guard let `self` = self else { return }
                
                switch result {
                case .result(let info):
                    self.showImagesScreen(token: info)
                case .error(let error):
                    AlertHelper.showAlert(error.localizedDescription)
                }
            }
        })
    }
}
