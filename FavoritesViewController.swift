//
//  FavoritesViewController.swift
//  WeAchieve
//
//  Created by Miguel Batilando on 7/24/18.
//  Copyright © 2018 Make School. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController, UITableViewDataSource {

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
    
    // Need to fetch data and display onto table view
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let favoritedInternshipCell = favoritesTableView.dequeueReusableCell(withIdentifier: "favoriteInternshipCell", for: indexPath)
        let favoritedScholarshipcell = favoritesTableView.dequeueReusableCell(withIdentifier: "favoriteScholarshipCell", for: indexPath)
        
        favoritedInternshipCell.textLabel?.text = "Internship"
        favoritedScholarshipcell.textLabel?.text = "Scholarship"
        
        if segmentedControl.selectedSegmentIndex == 0 {
            return favoritedInternshipCell
        } else {
            return favoritedScholarshipcell
        }
        
    }
    
}
