//
//  PopupViewController.swift
//  WeAchieve
//
//  Created by Miguel Batilando on 8/3/18.
//  Copyright © 2018 Make School. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var popupView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    func create() -> UIViewController {
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PopupViewController") as! PopupViewController
        
        return storyboard
    }
}
