//
//  LoginViewController.swift
//  WeAchieve
//
//  Created by Miguel Batilando on 8/5/18.
//  Copyright © 2018 Make School. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var backToHomeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        loginButton.layer.cornerRadius = loginButton.frame.size.height/2
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor.white.cgColor
        loginButton.layer.masksToBounds = true
        backToHomeButton.layer.cornerRadius = backToHomeButton.frame.size.height/2
        backToHomeButton.layer.borderWidth = 1
        backToHomeButton.layer.borderColor = UIColor.white.cgColor
        backToHomeButton.layer.masksToBounds = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Actions
    @IBAction func loginButtonTapped(_ sender: Any) {
        if let email = emailTextField.text , let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if user != nil {
                    self.performSegue(withIdentifier: "goToHome", sender: self)
                } else {
                    let alert = UIAlertController(title: "Error occurred", message: nil, preferredStyle: .alert)
                    let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func backToHomeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
