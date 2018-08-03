//
//  OpportunitiesTableView.swift
//  WeAchieve
//
//  Created by Miguel Batilando on 7/23/18.
//  Copyright © 2018 Make School. All rights reserved.
//

import UIKit

protocol SearchCellDelegate {
    func likeButtonPressedForInternship(intershipVar: Internship)
    func likeButtonPressedForScholarship(scholarshipVar: Scholarship)
}

class SearchViewControllerCell: UITableViewCell {
    
    // Outlets
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var companyOrAmount: UILabel!
    @IBOutlet weak var locationOrDeadline: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    // Variables
    var delegate: SearchCellDelegate?
    var isScholarship: Bool?
    var internshipVar: Internship?
    var schoalrshipVar: Scholarship?
    var hasBeenLiked: Bool = false

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func likeButtonPressed(_ sender: Any) {
        if isScholarship == true {
            delegate?.likeButtonPressedForScholarship(scholarshipVar: schoalrshipVar!)
            //likeButton.setImage(#imageLiteral(resourceName: "icons8-star-filled-24"), for: .normal)
        } else {
            delegate?.likeButtonPressedForInternship(intershipVar: internshipVar!)
            //likeButton.setImage(#imageLiteral(resourceName: "icons8-star-filled-24"), for: .normal)
        }
    }
}
