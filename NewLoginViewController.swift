//
//  NewLoginViewController.swift
//  WeAchieve
//
//  Created by Miguel Batilando on 7/31/18.
//  Copyright © 2018 Make School. All rights reserved.
//

import UIKit

class NewLoginViewController: UIViewController {
    
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius =  loginButton.frame.size.height/2
        loginButton.layer.masksToBounds = true
        registerButton.layer.cornerRadius =  registerButton.frame.size.height/2
        registerButton.layer.masksToBounds = true
        loginView.setGradientBackground(colorOne: Colors.blue, colorTwo: Colors.green)
        loginButton.setGradientBackground(colorOne: Colors.white, colorTwo: Colors.lightGrey)
        registerButton.setGradientBackground(colorOne: Colors.white, colorTwo: Colors.lightGrey)
        
    }
    
    
}
