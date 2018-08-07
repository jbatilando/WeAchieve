//
//  LoginViewController.swift
//  WeAchieve
//
//  Created by Miguel Batilando on 7/25/18.
//  Copyright © 2018 Make School. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var backToHomeButton: UIButton!
    
    // MARK: - Variables
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        registerButton.layer.cornerRadius = registerButton.frame.size.height/2
        registerButton.layer.borderWidth = 1
        registerButton.layer.borderColor = UIColor.white.cgColor
        registerButton.layer.masksToBounds = true
        backToHomeButton.layer.cornerRadius = backToHomeButton.frame.size.height/2
        backToHomeButton.layer.borderWidth = 1
        backToHomeButton.layer.borderColor = UIColor.white.cgColor
        backToHomeButton.layer.masksToBounds = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Actions
    @IBAction func registerButtonTapped(_ sender: Any) {
        if let email = emailTextField.text , let password = passwordTextField.text, let name = nameTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if user != nil {
                let userID = user!.user.uid
                self.ref = Database.database().reference()
                self.ref.child("Users").child(userID).setValue(["email" : email, "name": name])
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
                self.nameTextField.text = ""
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
