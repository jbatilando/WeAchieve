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
    
    var ref: DatabaseReference! = Database.database().reference()
    let userID = Auth.auth().currentUser?.uid
    
    @IBOutlet weak var favoritesTableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func segmentedControlDidChange(_ sender: UISegmentedControl) {
        favoritesTableView.reloadData()
    }

    var favoritedInternshipsArray = [Internship](){
        didSet{
            DispatchQueue.main.async {
                self.favoritesTableView.reloadData()
            }
        }
    }
    var favoritedScholarshipsArray = [Scholarship]()
    
    var index = 0
    
    func loadAllOpportunities() {
        
        ref?.child("Users").child(userID!).child("Internships").observeSingleEvent(of: .value, with: { (snapshot) in
            var intrarray = [Internship]()
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                if let childValue = snap.value as? [String: Any]? {
                    let internship = Internship.init(dict: childValue!)
                    intrarray.append(internship)
                }
            }
            self.favoritedInternshipsArray = intrarray
        })
        
        ref?.child("Users").child(userID!).child("Scholarships").observeSingleEvent(of: .value, with: { (snapshot) in
            var scharray = [Scholarship]()
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                if let childValue = snap.value as? [String: Any]? {
                    let scholarship = Scholarship.init(dict: childValue!)
                    scharray.append(scholarship)
                }
            }
            self.favoritedScholarshipsArray = scharray
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAllOpportunities()
        
//        ref?.child("Users").child(userID!).child("Internships").observeSingleEvent(of: .value, with: { (snapshot) in
//            var intrarray = [Internship]()
//            for child in snapshot.children {
//                let snap = child as! DataSnapshot
//                if let childValue = snap.value as? [String: Any]? {
//                    let internship = Internship.init(dict: childValue!)
//                    intrarray.append(internship)
//                }
//            }
//            self.favoritedInternshipsArray = intrarray
//        })
//
//        ref?.child("Users").child(userID!).child("Scholarships").observeSingleEvent(of: .value, with: { (snapshot) in
//            var scharray = [Scholarship]()
//            for child in snapshot.children {
//                let snap = child as! DataSnapshot
//                if let childValue = snap.value as? [String: Any]? {
//                    let scholarship = Scholarship.init(dict: childValue!)
//                    scharray.append(scholarship)
//                }
//            }
//            self.favoritedScholarshipsArray = scharray
//        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        favoritesTableView.reloadData()
    }
    
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
        
        if segmentedControl.selectedSegmentIndex == 0{
        favoritedInternshipCell.positionTitle?.text = favoritedInternshipsArray[indexPath.row].title
        favoritedInternshipCell.companyOrAMount?.text = favoritedInternshipsArray[indexPath.row].company
        favoritedInternshipCell.locationOrDeadline?.text = favoritedInternshipsArray[indexPath.row].location
        return favoritedInternshipCell
        }
        
       else {
        favoritedScholarshipcell.positionTitle?.text = favoritedScholarshipsArray[indexPath.row].title
        favoritedScholarshipcell.companyOrAMount?.text = favoritedScholarshipsArray[indexPath.row].amount
        favoritedScholarshipcell.locationOrDeadline?.text = favoritedScholarshipsArray[indexPath.row].deadline
        return favoritedScholarshipcell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segmentedControl.selectedSegmentIndex == 0 {
            let InternshipVC = storyboard?.instantiateViewController(withIdentifier: "InternshipViewController") as! InternshipDetailsViewController
            InternshipVC.internshipName = favoritedInternshipsArray[indexPath.row].title
            InternshipVC.internshipCo = favoritedInternshipsArray[indexPath.row].company
            InternshipVC.internshipLoc = favoritedInternshipsArray[indexPath.row].location
            InternshipVC.internshipDesc = favoritedInternshipsArray[indexPath.row].description
            tableView.deselectRow(at: indexPath, animated: true)
            self.navigationController?.pushViewController(InternshipVC, animated: true)
        } else {
            let ScholarshipsVC = storyboard?.instantiateViewController(withIdentifier: "ScholarshipViewController") as! ScholarshipsDetailsViewController
            ScholarshipsVC.scholarshipName = favoritedScholarshipsArray[indexPath.row].title
            ScholarshipsVC.scholarshipAmnt = favoritedScholarshipsArray[indexPath.row].amount
            ScholarshipsVC.scholarshipDueDate = favoritedScholarshipsArray[indexPath.row].deadline
            ScholarshipsVC.scholarshipDesc = favoritedScholarshipsArray[indexPath.row].description
            tableView.deselectRow(at: indexPath, animated: true)
            self.navigationController?.pushViewController(ScholarshipsVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if segmentedControl.selectedSegmentIndex == 0 {
                let index = indexPath.row
                let strIndex = String(index)
                self.favoritedInternshipsArray.remove(at: indexPath.row)
                ref?.child("Users").child(userID!).child("Internships").child(strIndex).setValue(nil)
                loadAllOpportunities()
                favoritesTableView.reloadData()
            } else {
                let index = indexPath.row
                let strIndex = String(index)
                self.favoritedScholarshipsArray.remove(at: indexPath.row)
                ref?.child("Users").child(userID!).child("Scholarships").child(strIndex).setValue(nil)
                loadAllOpportunities()
                favoritesTableView.reloadData()
            }
        }
    }
    
}
