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
    var isLiked: Bool
    
    init(title: String, company: String, location: String, description: String, isLiked: Bool) {
        self.title = title
        self.company = company
        self.location = location
        self.isLiked = isLiked
    }
    
    func convertToDict() -> [String: Any]{
        let dict = ["title": title,
                    "company": company,
                    "location": location]
        return dict
    }
    
    convenience init(dict: [String: Any]) {
        self.init(title: dict["title"] as! String, company: dict["company"] as! String, location: dict["location"] as! String, description: "", isLiked: true)
    }
}

class Scholarship {
    let title: String
    let amount: String
    let deadline: String
    var isLiked: Bool
    
    init(title: String, amount: String, deadline: String, description: String, isLiked: Bool) {
        self.title = title
        self.amount = amount
        self.deadline = deadline
        self.isLiked = isLiked
    }
    
    func convertToDict() -> [String: Any]{
        let dict = ["title": title,
                    "amount": amount,
                    "deadline": deadline]
        return dict
    }
    
    convenience init(dict: [String: Any]) {
        self.init(title: dict["title"] as! String, amount: dict["amount"] as! String, deadline: dict["deadline"] as! String, description: "", isLiked: true)
    }
}
