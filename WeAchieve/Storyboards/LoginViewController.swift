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

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Variables
    var signInState: Bool = true
    
    // Outlets
    @IBOutlet weak var signInSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var signInLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    
    // Actions
    @IBAction func signInSegmentedControlChanged(_ sender: UISegmentedControl) {
        signInState = !signInState
        
        if signInState {
            signInLabel.text = "Log In"
            signInButton.setTitle("Sign In", for: .normal)
        } else {
            signInLabel.text = "Register"
            signInButton.setTitle("Register", for: .normal)
        }
    }
    
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {

            if signInState {
                // Sign in with Firebase
                Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                    // Check if user is not nil
                    if error == nil && user != nil {
                        // User not found, alert
                        let alert = UIAlertController(title: "Error occurred", message: nil, preferredStyle: .alert)
                        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alert.addAction(okButton)
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        // User found, go to home
                        self.performSegue(withIdentifier: "goToHome", sender: self)
                    }
                }
            } else  {
                // Register with Firebase
                Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                if error == nil && user != nil {
                    print("user created")
                    self.performSegue(withIdentifier: "goToGome", sender: self)
                } else {
                        print("error")
                    }
                }
            }
        }
        
        
    }
    
}
