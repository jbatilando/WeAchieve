//
//  ProfileViewController.swift
//  WeAchieve
//
//  Created by Miguel Batilando on 7/25/18.
//  Copyright © 2018 Make School. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    // Need to display user email
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = loginButton.frame.size.height/2
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor.white.cgColor
        loginButton.layer.masksToBounds = true
    }
    
    @IBAction func logOutButtonPressed(_ sender: UIButton) {
        try! Auth.auth().signOut()
        self.dismiss(animated: false, completion: nil)
    }
    
}
