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
import FirebaseDatabase

class SearchViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate, SearchCellDelegate, UITableViewDelegate {
    
    // User ID
    let userID = Auth.auth().currentUser?.uid
    
    // Variables
    var incrementInternshipIndex = 0
    var incrementScholarshipIndex = 0
    var isLiked = false
    
    // Firebase Databse ref
    var ref: DatabaseReference! = Database.database().reference()
    
    // Liked stuff stored in these arrays
    var likedInternships = [Internship]()
    var likedScholarships = [Scholarship]()
    
    // NS Arrays
    var uploadInternships: NSMutableArray? // = [Internship]() as! NSMutableArray
    
    // Like button pressed
    func likeButtonPressedForInternship(intershipVar: Internship) {
        intershipVar.isLiked = !intershipVar.isLiked
        if intershipVar.isLiked == true {
            likedInternships.append(intershipVar)
        } else {
            // remove it from array
            // change ui button color
        }
        // likedInternships.append(intershipVar)
        let dict = intershipVar.convertToDict()
        ref?.child("Users").child(userID!).child("Internships").child(String(incrementInternshipIndex)).updateChildValues(dict)
        incrementInternshipIndex += 1
    }
    
    func likeButtonPressedForScholarship(scholarshipVar: Scholarship) {
        scholarshipVar.isLiked = !isLiked
        if scholarshipVar.isLiked == true {
            likedScholarships.append(scholarshipVar)
        } else {
            // remove from array
            // uncolor button
        }
        let dict = scholarshipVar.convertToDict()
        ref?.child("Users").child(userID!).child("Scholarships").child(String(incrementScholarshipIndex)).updateChildValues(dict)
        incrementScholarshipIndex += 1
    }
    
    
    // Variables
    var internshipArray = [Internship]()
    var scholarshipArray = [Scholarship]()
    var buttonState = false
    let favoritesVC = FavoritesViewController(nibName: "FavoritesViewController", bundle: nil)
    
    // Outlets
    @IBOutlet weak var opportunityTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        setupInternships()
        setupScholarships()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
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
        internshipCell.delegate = self
        internshipCell.isScholarship = false
        internshipCell.internshipVar = internshipArray[indexPath.row]
        
        
        scholarshipCell.title.text = scholarshipArray[indexPath.row].title
        scholarshipCell.companyOrAmount.text = scholarshipArray[indexPath.row].amount
        scholarshipCell.locationOrDeadline.text = scholarshipArray[indexPath.row].deadline
        scholarshipCell.delegate = self
        scholarshipCell.isScholarship = true
        scholarshipCell.schoalrshipVar = scholarshipArray[indexPath.row]
        
        if searchBar.selectedScopeButtonIndex == 0 {
            return internshipCell
        } else {
            return scholarshipCell
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchBar.selectedScopeButtonIndex == 0 {
        let InternshipVC = storyboard?.instantiateViewController(withIdentifier: "InternshipViewController") as! InternshipDetailsViewController
        InternshipVC.internshipName = internshipArray[indexPath.row].title
        InternshipVC.internshipCo = internshipArray[indexPath.row].company
        InternshipVC.internshipLoc = internshipArray[indexPath.row].location
        self.navigationController?.pushViewController(InternshipVC, animated: true)
        } else {
            let ScholarshipsVC = storyboard?.instantiateViewController(withIdentifier: "ScholarshipViewController") as! ScholarshipsDetailsViewController
            ScholarshipsVC.scholarshipName = scholarshipArray[indexPath.row].title
            ScholarshipsVC.scholarshipAmnt = scholarshipArray[indexPath.row].amount
            ScholarshipsVC.scholarshipDueDate = scholarshipArray[indexPath.row].deadline
            self.navigationController?.pushViewController(ScholarshipsVC, animated: true)
        }
    }
    
    // Data
    private func setupInternships() {
        internshipArray.append(Internship(title: "iOS Developer", company: "Apple", location: "Cupertino", description: "", isLiked: false))
        internshipArray.append(Internship(title: "iOS Engineer", company: "Facebook", location: "Menlo Park", description: "", isLiked: false))
        internshipArray.append(Internship(title: "Expert", company: "Large Co.", location: "You", description: "", isLiked: false))
    }
    
    private func setupScholarships() {
        scholarshipArray.append(Scholarship(title: "Latinos for America", amount: "$20000", deadline: "02/22/2019", description: "", isLiked: false))
        scholarshipArray.append(Scholarship(title: "African-American Community", amount: "$3200", deadline: "03/12/2018", description: "", isLiked: false))
        scholarshipArray.append(Scholarship(title: "Women in Tech", amount: "$5000", deadline: "02/22/2020", description: "", isLiked: false))
    }
}

