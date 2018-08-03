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
    
    let userID = Auth.auth().currentUser?.uid
    var ref: DatabaseReference! = Database.database().reference()
    var userEmail: String = "email"
    
    // Need to display user email
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = loginButton.frame.size.height/2
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor.white.cgColor
        loginButton.layer.masksToBounds = true
        
        ref?.child("Users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let userData = snapshot.value as? [String:Any]
            self.userEmail = userData!["email"] as! String
            if self.userNameLabel.text != "" {
                self.userNameLabel.text = userData!["name"] as? String
            }
            self.userEmailLabel.text = self.userEmail
        })
        
        UIApplication.shared.statusBarStyle = .lightContent
        
    }
    
    @IBAction func logOutButtonPressed(_ sender: UIButton) {
        try! Auth.auth().signOut()
        self.dismiss(animated: false, completion: nil)
    }
    
}
