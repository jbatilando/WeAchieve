//
//  DetailsViewController.swift
//  
//
//  Created by Miguel Batilando on 7/24/18.
//

import UIKit

class InternshipDetailsViewController: UIViewController {
    
    var internship: Internship?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Outlets
    @IBOutlet weak var internshipPosition: UILabel!
    @IBOutlet weak var internshipCompany: UILabel!
    @IBOutlet weak var internshipLocation: UILabel!
    
    
}
