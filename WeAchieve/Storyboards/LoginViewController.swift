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

class LoginViewController: UIViewController {
    
    // Firebase ref
    var ref: DatabaseReference!
    
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
        
        // Check if email and password are filled in
        if let email = emailTextField.text , let password = passwordTextField.text {
            if signInState {
                // Sign in with Firebase
                Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                    // Check if user is not nil
                    if user != nil {
                        // User found, go to home
                        self.dismiss(animated: false, completion: nil)
                        self.performSegue(withIdentifier: "goToHome", sender: self)
                        self.emailTextField.text = ""
                        self.passwordTextField.text = ""
                    } else {
                        // User not found, alert
                        let alert = UIAlertController(title: "Error occurred", message: nil, preferredStyle: .alert)
                        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alert.addAction(okButton)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            } else  {
                // Register with Firebase
                Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                if user != nil {
                    print("user created")
                    let userID = user!.user.uid
                    self.ref = Database.database().reference()
                    self.ref.child("Users").child(userID).setValue(["email" : email, "password": password])
                    self.performSegue(withIdentifier: "goToHome", sender: self)
                } else {
                        print("error")
                    }
                }
            }
        }
        
        
    }
    
}
