//
//  ViewController.swift
//  [P02] OnTheMap
//
//  Created by aia on 06/11/2023.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoading(false)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    @IBAction func LoginAction(_ sender: Any) {
        showLoading(true)
        if emailTextField.text != nil && passwordTextField.text != nil {
            OnTheMapService.login(email: emailTextField.text ?? "", password: passwordTextField.text ?? "") { success, error in
                self.showLoading(false)
                if success {
                    self.performSegue(withIdentifier: "Login", sender: self)
                } else {
                    self.showAlert(title: "Error", message: error?.localizedDescription ?? "Login Failed")
                }
            }
        }
    }
    
    private func showLoading(_ showIndicator: Bool) {
        if showIndicator {
            self.indicator.startAnimating()
        } else {
            self.indicator.stopAnimating()
        }
        
        self.indicator.isHidden = !showIndicator
        self.emailTextField.isEnabled = !showIndicator
        self.passwordTextField.isEnabled = !showIndicator
        self.loginButton.isEnabled = !showIndicator
    }
}

