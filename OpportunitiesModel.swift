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
    
    init(title: String, company: String, location: String, description: String) {
        self.title = title
        self.company = company
        self.location = location
    }
    
    func convertToDict() -> [String: Any]{
        let dict = ["title": title,
                    "company": company,
                    "location": location]
        return dict
    }
}

class Scholarship {
    let title: String
    let amount: String
    let deadline: String
    
    init(title: String, amount: String, deadline: String, description: String) {
        self.title = title
        self.amount = amount
        self.deadline = deadline
    }
    
    func convertToDict() -> [String: Any]{
        let dict = ["title": title,
                    "amount": amount,
                    "deadline": deadline]
        return dict
    }
}
