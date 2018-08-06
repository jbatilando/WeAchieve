//
//  FirstViewController.swift
//  WeAchieve
//
//  Created by Miguel Batilando on 8/5/18.
//  Copyright © 2018 Make School. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = loginButton.frame.size.height/2
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor.white.cgColor
        loginButton.layer.masksToBounds = true
        registerButton.layer.cornerRadius = registerButton.frame.size.height/2
        registerButton.layer.borderWidth = 1
        registerButton.layer.borderColor = UIColor.white.cgColor
        registerButton.layer.masksToBounds = true
    }
    
    // MARK: - Actions
    @IBAction func registerButtonTapped(_ sender: Any) {
//        let viewController = (self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController"))!
//        self.present(viewController, animated: true, completion: nil)
        performSegue(withIdentifier: "goToRegister", sender: self)
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
//        let viewController = (self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController"))!
//        self.present(viewController, animated: true, completion: nil)
        performSegue(withIdentifier: "goToLogin", sender: self)
    }
    
    
}
