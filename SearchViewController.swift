//
//  ViewController.swift
//  WeAchieve
//
//  Created by Miguel Batilando on 7/23/18.
//  Copyright © 2018 Make School. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SearchViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate {
    
    // Variables
    var internshipArray = [Internship]()
    var scholarshipArray = [Scholarship]()
    var buttonState = false
    let favoritesVC = FavoritesViewController(nibName: "FavoritesViewController", bundle: nil)
    
    // Outlets
    @IBOutlet weak var opportunityTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // Actions
    @IBAction func likeButtonPressed(_ sender: UIButton) {
        print("like button pressed")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        setupInternships()
        setupScholarships()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let user = Auth.auth().currentUser {
            self.performSegue(withIdentifier: "goToHome", sender: self)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        print(searchBar.selectedScopeButtonIndex)
        opportunityTableView.reloadData()
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
        
        return UITableViewCell()
    }
    
    private func setupInternships() {
        internshipArray.append(Internship(title: "iOS Developer", company: "Apple", location: "Cupertino", description: ""))
        internshipArray.append(Internship(title: "iOS Engineer", company: "Facebook", location: "Menlo Park", description: ""))
        internshipArray.append(Internship(title: "Munchie Expert", company: "Large Co.", location: "Your ass", description: ""))
    }
    
    private func setupScholarships() {
        scholarshipArray.append(Scholarship(title: "Latinos for America", amount: "$20000", deadline: "02/22/2019", description: ""))
        scholarshipArray.append(Scholarship(title: "African-American Community", amount: "$3200", deadline: "03/12/2018", description: ""))
        scholarshipArray.append(Scholarship(title: "Women in Tech", amount: "$5000", deadline: "02/22/2020", description: ""))
    }


}

