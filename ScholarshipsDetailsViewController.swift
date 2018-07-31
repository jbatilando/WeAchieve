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
    var scholarshipName = "Name"
    var scholarshipAmnt = "Amount"
    var scholarshipDueDate = "Due"
    var scholarshipDesc = "Desc"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scholarshipTitle?.text =  scholarshipName
        scholarshipAmount?.text = scholarshipAmnt
        scholarshipDeadline?.text = scholarshipDueDate
        scholarshipDescription?.text = scholarshipDesc
    }
    
    @IBOutlet weak var scholarshipTitle: UILabel!
    @IBOutlet weak var scholarshipAmount: UILabel!
    @IBOutlet weak var scholarshipDeadline: UILabel!
    @IBOutlet weak var scholarshipDescription: UITextView!
}
