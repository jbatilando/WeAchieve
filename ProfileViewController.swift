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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logOutButtonPressed(_ sender: UIButton) {
        try! Auth.auth().signOut()
        self.dismiss(animated: false, completion: nil)
    }
    
}
