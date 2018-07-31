//
//  ScholarshipsDetailsViewController.swift
//  WeAchieve
//
//  Created by Miguel Batilando on 7/24/18.
//  Copyright © 2018 Make School. All rights reserved.
//

import UIKit

class ScholarshipsDetailsViewController: UIViewController {
    
    var scholarship: Scholarship?
    var scholarshipName = ""
    var scholarshipAmnt = ""
    var scholarshipDueDate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scholarshipTitle?.text =  scholarshipName
        scholarshipAmount?.text = scholarshipAmnt
        scholarshipDeadline?.text = scholarshipDueDate
    }
    
    @IBOutlet weak var scholarshipTitle: UILabel!
    @IBOutlet weak var scholarshipAmount: UILabel!
    @IBOutlet weak var scholarshipDeadline: UILabel!
}
