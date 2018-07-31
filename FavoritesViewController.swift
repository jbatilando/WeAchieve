//
//  FavoritesViewController.swift
//  WeAchieve
//
//  Created by Miguel Batilando on 7/24/18.
//  Copyright © 2018 Make School. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Firebase ref
    var ref: DatabaseReference! = Database.database().reference()
    let userID = Auth.auth().currentUser?.uid
    
    // Outlets
    @IBOutlet weak var favoritesTableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    // Action
    @IBAction func segmentedControlDidChange(_ sender: UISegmentedControl) {
        favoritesTableView.reloadData()
    }
    
    // Arrays
    var favoritedInternshipsArray = [Internship]()
    var favoritedScholarshipsArray = [Scholarship]()
    var index = 0
    
    // Need to fetch data and display onto table view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoritesTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        ref?.child("Users").child(userID!).child("Internships").observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children {
                let childSnapshot = snapshot.childSnapshot(forPath: String(self.index))
                if let childValue = childSnapshot.value as? [String: Any]? {
                    let internship = Internship.init(dict: childValue!)
                    if self.favoritedInternshipsArray.isEmpty {
                        self.favoritedInternshipsArray.append(internship)
                    } else  {
                        for i in (0 ..< self.favoritedInternshipsArray.count) {
                        var cur = self.favoritedInternshipsArray[i]
                        if cur.title != internship.title && cur.company != internship.company {
                            if cur.location != internship.location {
                                // && other attribute {
                                // append
                                self.favoritedInternshipsArray.append(internship)
                            }
                        }
                }
            }
                    self.index += 1
                }
            }
        })
        
        ref?.child("Users").child(userID!).child("Scholarships").observeSingleEvent(of: .value, with: { (snapshot) in
            self.index = 0
            for child in snapshot.children {
                let childSnapshot = snapshot.childSnapshot(forPath: String(self.index))
                if let childValue = childSnapshot.value as? [String: Any]? {
                    let scholarship = Scholarship.init(dict: childValue!)
                    if self.favoritedScholarshipsArray.isEmpty {
                        self.favoritedScholarshipsArray.append(scholarship)
                    } else {
                    for i in (0 ..< self.favoritedScholarshipsArray.count) {
                        var cur = self.favoritedScholarshipsArray[i]
                        if cur.title != scholarship.title && cur.amount != scholarship.amount {
                            if cur.deadline != scholarship.deadline {
                                self.favoritedScholarshipsArray.append(scholarship)
                            }
                        }
                    }
                }
                    self.index += 1
                }
            }
        })
    }
    
    // Table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            index = 0
            return favoritedInternshipsArray.count
        } else {
            index = 0
            return favoritedScholarshipsArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let favoritedInternshipCell = favoritesTableView.dequeueReusableCell(withIdentifier: "favoriteInternshipCell", for: indexPath) as! FavoritesCell
        let favoritedScholarshipcell = favoritesTableView.dequeueReusableCell(withIdentifier: "favoriteScholarshipCell", for: indexPath) as! FavoritesCell
        
        if !favoritedInternshipsArray.isEmpty {
        favoritedInternshipCell.positionTitle?.text = favoritedInternshipsArray[indexPath.row].title
        favoritedInternshipCell.companyOrAMount?.text = favoritedInternshipsArray[indexPath.row].company
        favoritedInternshipCell.locationOrDeadline?.text = favoritedInternshipsArray[indexPath.row].location
        }
        
        if !favoritedScholarshipsArray.isEmpty {
        favoritedScholarshipcell.positionTitle?.text = favoritedScholarshipsArray[indexPath.row].title
        favoritedScholarshipcell.companyOrAMount?.text = favoritedScholarshipsArray[indexPath.row].amount
        favoritedScholarshipcell.locationOrDeadline?.text = favoritedScholarshipsArray[indexPath.row].deadline
        }

        if segmentedControl.selectedSegmentIndex == 0 {
            return favoritedInternshipCell
        } else {
            return favoritedScholarshipcell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segmentedControl.selectedSegmentIndex == 0 {
            let InternshipVC = storyboard?.instantiateViewController(withIdentifier: "InternshipViewController") as! InternshipDetailsViewController
            InternshipVC.internshipName = favoritedInternshipsArray[indexPath.row].title
            InternshipVC.internshipCo = favoritedInternshipsArray[indexPath.row].company
            InternshipVC.internshipLoc = favoritedInternshipsArray[indexPath.row].location
            self.navigationController?.pushViewController(InternshipVC, animated: true)
        } else {
            let ScholarshipsVC = storyboard?.instantiateViewController(withIdentifier: "ScholarshipViewController") as! ScholarshipsDetailsViewController
            ScholarshipsVC.scholarshipName = favoritedScholarshipsArray[indexPath.row].title
            ScholarshipsVC.scholarshipAmnt = favoritedScholarshipsArray[indexPath.row].amount
            ScholarshipsVC.scholarshipDueDate = favoritedScholarshipsArray[indexPath.row].deadline
            self.navigationController?.pushViewController(ScholarshipsVC, animated: true)
        }
    }
}
