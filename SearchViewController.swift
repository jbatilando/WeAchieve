//
//  ViewController.swift
//  WeAchieve
//
//  Created by Miguel Batilando on 7/23/18.
//  Copyright © 2018 Make School. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource {
    
    // Variables
    var internshipArray = [Internship]()
    var scholarshipArray = [Scholarship]()
    
    // Outlets
    @IBOutlet weak var opportunityTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // Actions
    @IBAction func likeButtonPressed(_ sender: Any) {
        print("like button pressed")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInternships()
        setupScholarships()
        print(searchBar.selectedScopeButtonIndex)
    }
    
    private func setupInternships() {
        internshipArray.append(Internship(title: "iOS Developer", company: "Apple", location: "Cupertino"))
        internshipArray.append(Internship(title: "iOS Engineer", company: "Facebook", location: "Menlo Park"))
        internshipArray.append(Internship(title: "Munchie Expert", company: "Large Co.", location: "Your ass"))
    }
    
    private func setupScholarships() {
        scholarshipArray.append(Scholarship(title: "Latinos for America", amount: "$20000", deadline: "02/22/2019"))
        scholarshipArray.append(Scholarship(title: "African-American Community", amount: "$3200", deadline: "03/12/2018"))
        scholarshipArray.append(Scholarship(title: "Women in Tech", amount: "$5000", deadline: "02/22/2020"))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchBar.selectedScopeButtonIndex == 0 {
            return internshipArray.count
        } else {
            return scholarshipArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let internshipCell = tableView.dequeueReusableCell(withIdentifier: "internshipCell", for: indexPath) as! SearchViewControllerCell
        let scholarshipCell = tableView.dequeueReusableCell(withIdentifier: "scholarshipCell", for: indexPath) as! SearchViewControllerCell
        
        internshipCell.title.text = internshipArray[indexPath.row].title
        internshipCell.companyOrAmount.text = internshipArray[indexPath.row].company
        internshipCell.locationOrDeadline.text = internshipArray[indexPath.row].location
        
        scholarshipCell.title.text = scholarshipArray[indexPath.row].title
        scholarshipCell.companyOrAmount.text = scholarshipArray[indexPath.row].amount
        scholarshipCell.locationOrDeadline.text = scholarshipArray[indexPath.row].deadline
        
        if searchBar.selectedScopeButtonIndex == 0 {
            return internshipCell
        } else {
            return scholarshipCell
        }
        
    }


}

