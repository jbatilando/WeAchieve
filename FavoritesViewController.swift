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

class FavoritesViewController: UIViewController, UITableViewDataSource {
    
    // Firebase ref
    var ref: DatabaseReference! = Database.database().reference()
    var databaseHandle: DatabaseHandle?
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
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Retrieve Posts and listen for changes
        ref?.child("Users").child(userID!).child("Internships").observeSingleEvent(of: .value, with: { (snapshot) in
            // Take data from snapshot and put it into an array
            print(snapshot.value!)
            for child in snapshot.children {
                let childSnapshot = snapshot.childSnapshot(forPath: String(self.index))
                let childValue = childSnapshot.value as! [String: Any]
                let internship = Internship.init(dict: childValue)
                self.favoritedInternshipsArray.append(internship)
                self.index += 1
                print(self.favoritedInternshipsArray)
            }
        })
    }
    
    // Table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            return favoritedInternshipsArray.count
        } else {
            return favoritedScholarshipsArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let favoritedInternshipCell = favoritesTableView.dequeueReusableCell(withIdentifier: "favoriteInternshipCell", for: indexPath) as! FavoritesCell
        let favoritedScholarshipcell = favoritesTableView.dequeueReusableCell(withIdentifier: "favoriteScholarshipCell", for: indexPath) as! FavoritesCell

        favoritedInternshipCell.positionTitle?.text = favoritedInternshipsArray[indexPath.row].title
//        favoritedInternshipCell.positionTitle?.text = favoritedInternshipsArray[indexPath.row].company
//        favoritedInternshipCell.positionTitle?.text = favoritedInternshipsArray[indexPath.row].company
//
        favoritedScholarshipcell.textLabel?.text = "Scholarship"

        if segmentedControl.selectedSegmentIndex == 0 {
            return favoritedInternshipCell
        } else {
            return favoritedScholarshipcell
        }
    }
    
}
