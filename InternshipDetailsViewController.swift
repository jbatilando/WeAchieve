//
//  DetailsViewController.swift
//  
//
//  Created by Miguel Batilando on 7/24/18.
//

import UIKit

class InternshipDetailsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var internshipPosition: UILabel?
    @IBOutlet weak var internshipCompany: UILabel?
    @IBOutlet weak var internshipLocation: UILabel?
    @IBOutlet weak var internshipDescription: UITextView?
    
    // MARK: - Variables
    var internship: Internship?
    var internshipName = "Desc"
    var internshipCo = "Co"
    var internshipLoc = "Loc"
    var internshipDesc = "Desc"
    var internshipURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        internshipPosition?.text = internshipName
        internshipCompany?.text = internshipCo
        internshipLocation?.text = internshipLoc
        internshipDescription?.text = internshipDesc
    }
    
    // MARK: - Actions
    @IBAction func applyButtonTapped(_ sender: Any) {
        let urlString = internshipURL
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
}
