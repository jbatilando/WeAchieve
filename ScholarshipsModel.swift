//
//  ScholarshipsModel.swift
//  WeAchieve
//
//  Created by Miguel Batilando on 7/23/18.
//  Copyright © 2018 Make School. All rights reserved.
//

import UIKit

class Scholarship {
    let title: String
    let location: String
    let deadline: String
    
    init(title: String, location: String, deadline: String) {
        self.title = title
        self.location = location
        self.deadline = deadline
    }
}
