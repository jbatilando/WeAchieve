//
//  InternshipsModel.swift
//  WeAchieve
//
//  Created by Miguel Batilando on 7/23/18.
//  Copyright © 2018 Make School. All rights reserved.
//

import UIKit

class Internship {
    let title: String
    let company: String
    let location: String
    // let deadline: String
    
    init(title: String, company: String, location: String) {
        self.title = title
        self.company = company
        self.location = location
        // self.deadline = deadline
    }
}

class Scholarship {
    let title: String
    let amount: String
    let deadline: String
    
    init(title: String, amount: String, deadline: String) {
        self.title = title
        self.amount = amount
        self.deadline = deadline
    }
}
