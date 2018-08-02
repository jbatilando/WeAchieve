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
    
    let userID = Auth.auth().currentUser?.uid
    
    var incrementInternshipIndex = 0
    var incrementScholarshipIndex = 0
    var isLiked = false
    
    var ref: DatabaseReference! = Database.database().reference()
    
    var likedInternships = [Internship]()
    var likedScholarships = [Scholarship]()
    
    func likeButtonPressedForInternship(intershipVar: Internship) {
        intershipVar.isLiked = !intershipVar.isLiked
        if intershipVar.isLiked == true {
            likedInternships.append(intershipVar)
        } else {
            // remove it from array
            // change ui button color
        }
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
    
    var internshipArray = [Internship]()
    var scholarshipArray = [Scholarship]()
    var searchInternship = [Internship]()
    var searchScholarship = [Scholarship]()
    var isSearching = false
    var buttonState = false
    let favoritesVC = FavoritesViewController(nibName: "FavoritesViewController", bundle: nil)
    
    @IBOutlet weak var opportunityTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = Colors.linkedInBlue.cgColor
        setupInternships()
        setupScholarships()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        opportunityTableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.selectedScopeButtonIndex == 0 {
            searchInternship = internshipArray.filter({$0.title.lowercased().prefix(searchText.count) == searchText.lowercased()})
            isSearching = true
            opportunityTableView.reloadData()
        } else {
            searchScholarship = scholarshipArray.filter({$0.title.lowercased().prefix(searchText.count) == searchText.lowercased()})
            isSearching = true
            opportunityTableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        view.endEditing(true)
        opportunityTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearching {
            if searchBar.selectedScopeButtonIndex == 0 {
                return searchInternship.count
            } else {
                return searchScholarship.count
            }
        } else {
            if searchBar.selectedScopeButtonIndex == 0 {
                return internshipArray.count
            } else {
                return scholarshipArray.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let internshipCell = tableView.dequeueReusableCell(withIdentifier: "internshipCell", for: indexPath) as! SearchViewControllerCell
        let scholarshipCell = tableView.dequeueReusableCell(withIdentifier: "scholarshipCell", for: indexPath) as! SearchViewControllerCell
        
        if isSearching {
            if searchBar.selectedScopeButtonIndex == 0 {
                internshipCell.title.text = searchInternship[indexPath.row].title
                internshipCell.companyOrAmount.text = searchInternship[indexPath.row].company
                internshipCell.locationOrDeadline.text = searchInternship[indexPath.row].location
                internshipCell.delegate = self
                internshipCell.isScholarship = false
                internshipCell.internshipVar = searchInternship[indexPath.row]
//                internshipCell.title.adjustsFontSizeToFitWidth = false
//                internshipCell.title.lineBreakMode = .byTruncatingTail
                return internshipCell
            } else {
                scholarshipCell.title.text = searchScholarship[indexPath.row].title
                scholarshipCell.companyOrAmount.text = searchScholarship[indexPath.row].amount
                scholarshipCell.locationOrDeadline.text = searchScholarship[indexPath.row].deadline
                scholarshipCell.delegate = self
                scholarshipCell.isScholarship = true
                scholarshipCell.schoalrshipVar = searchScholarship[indexPath.row]
//                scholarshipCell.title.adjustsFontSizeToFitWidth = false
//                scholarshipCell.title.lineBreakMode = .byTruncatingTail
                return scholarshipCell
            }
        } else {
        if searchBar.selectedScopeButtonIndex == 0 {
            internshipCell.title.text = internshipArray[indexPath.row].title
            internshipCell.companyOrAmount.text = internshipArray[indexPath.row].company
            internshipCell.locationOrDeadline.text = internshipArray[indexPath.row].location
            internshipCell.delegate = self
            internshipCell.isScholarship = false
            internshipCell.internshipVar = internshipArray[indexPath.row]
            return internshipCell
        } else {
            scholarshipCell.title.text = scholarshipArray[indexPath.row].title
            scholarshipCell.companyOrAmount.text = scholarshipArray[indexPath.row].amount
            scholarshipCell.locationOrDeadline.text = scholarshipArray[indexPath.row].deadline
            scholarshipCell.delegate = self
            scholarshipCell.isScholarship = true
            scholarshipCell.schoalrshipVar = scholarshipArray[indexPath.row]
            return scholarshipCell
        }
    }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchBar.selectedScopeButtonIndex == 0 {
        let InternshipVC = storyboard?.instantiateViewController(withIdentifier: "InternshipViewController") as! InternshipDetailsViewController
        InternshipVC.internshipName = internshipArray[indexPath.row].title
        InternshipVC.internshipCo = internshipArray[indexPath.row].company
        InternshipVC.internshipLoc = internshipArray[indexPath.row].location
        InternshipVC.internshipDesc = internshipArray[indexPath.row].description
        tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(InternshipVC, animated: true)
        } else {
            let ScholarshipsVC = storyboard?.instantiateViewController(withIdentifier: "ScholarshipViewController") as! ScholarshipsDetailsViewController
            ScholarshipsVC.scholarshipName = scholarshipArray[indexPath.row].title
            ScholarshipsVC.scholarshipAmnt = scholarshipArray[indexPath.row].amount
            ScholarshipsVC.scholarshipDueDate = scholarshipArray[indexPath.row].deadline
            ScholarshipsVC.scholarshipDesc = internshipArray[indexPath.row].description
            tableView.deselectRow(at: indexPath, animated: true)
            self.navigationController?.pushViewController(ScholarshipsVC, animated: true)
        }
    }
    
    // Data
    private func setupInternships() {
        internshipArray.append(Internship(title: "Year Up IT Internship Program", company: "Year Up", location: "San Francisco", description: "Year Up is an intensive training program that helps urban young adults increase their technical skills and prepare for a career in information technology. The program combines teaching students valuable IT, communication, and professional skills, plus internships at top companies. Year Up offers training programs in Boston, Atlanta, Baltimore, Chicago, New York, Seattle, San Francisco and other locations. Students spend six months learning IT skills and are then placed in an internship with a company needing IT skills. Students are paid a stipend during the internship program. Students also receive mentoring, guidance and expert career advice during the program. To apply, students are not required to have strong technical skills, but they do need basic computer skills. They must have a strong interest in IT and a willingness to work hard and learn. Students applying will be evaluated on their technical and writing skills at the time of admission. About 84 percent of students who graduate from the program are employed or attending college full-time within four months of completing the program. The program is offered by Year Up, a non-profit organization founded in 2000 in Boston, Massachusetts. Their mission is to give urban young adults the skills, experience, and support they need to reach their potential through professional careers and higher education.", isLiked: false))
        internshipArray.append(Internship(title: "Explore Microsoft Internship Program For Women and Minorities", company: "Microsoft", location: "Redmond, Washington", description: "Explore Microsoft Internship Program is for current college undergraduate minority students pursuing a degree in computer science or software engineering. Students may apply in their freshman or sophomore year of college. Women, minorities (African American, American Indian, Hispanic), and individuals with disabilities are encouraged to apply. The internship program is 12 weeks during the summer at Microsoft. This opportunity gives students first-hand experience in software development and exposure to the field of computer science, computer engineering, or related technical areas. Work includes hands-on projects as well as group projects. Students must be freshman or sophomores in order to apply. They must also have completed an Introduction to Computer Science course or similar class in addition to one semester of calculus by the time the program begins. They must have a passion for a career in technology and an interest in working in the software industry. Microsoft is the largest software developer in the world with over 90,000 employees in more than 100 countries. Their work hard play hard atmosphere attracts top talent from all over the world. The company provides opportunities to grow with the Microsoft Mentor Program, visiting speakers, breakfast meets to discuss new business plans and products, and more. Company employees also enjoy recreation such as company sports teams, singing groups, theater productions, and orchestra performances all planned and performed by Microsoft employees.", isLiked: false))
        internshipArray.append(Internship(title: "TV One Internship Program", company: "TV One", location: "Nationwide", description: "TV One Internship Program offers internships to undergraduate college students in the Fall, Spring and Summer. The internships are for students interested in a career in the media industry. Internships provide real, practical work experience for students in the fields in which they are studying. Whether it's marketing and sales, finance, legal, human resources, digital media, production or programming, students will find an internship opportunity that will enrich their learning and give them insight into their career options. What do interns do? Meaningful work! A marketing intern, for example, will assist in developing creative ideas to pitch TV One shows. A student with digital media experience will get to help design the network's web site. Each internship position has its own criteria for required skills and experience. Students are encouraged to read the postings carefully before applying. The internships are sponsored by TV One, a popular television media production company that produces shows for African American adults. Their shows include sitcoms, reality shows, games, and information on food, health and celebrities. ", isLiked: false))
        internshipArray.append(Internship(title: "The Minority Access Internship Program", company: "Minority Access Inc.", location: "District of Columbia", description: "TV One Internship Program offers internships to undergraduate college students in the Fall, Spring and Summer. The internships are for students interested in a career in the media industry. Internships provide real, practical work experience for students in the fields in which they are studying. Whether it's marketing and sales, finance, legal, human resources, digital media, production or programming, students will find an internship opportunity that will enrich their learning and give them insight into their career options. What do interns do? Meaningful work! A marketing intern, for example, will assist in developing creative ideas to pitch TV One shows. A student with digital media experience will get to help design the network's web site. Each internship position has its own criteria for required skills and experience. Students are encouraged to read the postings carefully before applying. The internships are sponsored by TV One, a popular television media production company that produces shows for African American adults. Their shows include sitcoms, reality shows, games, and information on food, health and celebrities. ", isLiked: false))
        internshipArray.append(Internship(title: "Congressional Black Caucus Foundation Internships", company: "Congressional Black Caucus Foundation, Inc. (CBCF)", location: "District of Columbia", description: "TV One Internship Program offers internships to undergraduate college students in the Fall, Spring and Summer. The internships are for students interested in a career in the media industry. Internships provide real, practical work experience for students in the fields in which they are studying. Whether it's marketing and sales, finance, legal, human resources, digital media, production or programming, students will find an internship opportunity that will enrich their learning and give them insight into their career options. What do interns do? Meaningful work! A marketing intern, for example, will assist in developing creative ideas to pitch TV One shows. A student with digital media experience will get to help design the network's web site. Each internship position has its own criteria for required skills and experience. Students are encouraged to read the postings carefully before applying. The internships are sponsored by TV One, a popular television media production company that produces shows for African American adults. Their shows include sitcoms, reality shows, games, and information on food, health and celebrities. ", isLiked: false))
    }
    
    private func setupScholarships() {
        scholarshipArray.append(Scholarship(title: "AAMA Houston Chapter Health Training Scholarship", amount: "$3000", deadline: "Varies", description: "The Houston Chapter established a scholarship award and is inviting applications at this time. The purpose of the award is to provide guidance and financial assistance to eligible medical, nursing, dental, pharmacy, osteopathy, optometry, chiropractor and post-doctoral students of Arab Heritage in obtaining elective training at one of Houston's medical institutions. Eligibility: Of Arab Heritage, full-time enrollment in an internationally recognized healthcare related school, expected to spend 3 months at one of Houston's medical institutions or any affiliated hospitals for research or clinical activities, willing to attend AAMA meetings during the training months in Houston, applicant needs to indicate a financial need of these funds For more information or to apply, please visit the scholarship provider's website.", isLiked: false))
        scholarshipArray.append(Scholarship(title: "AEF Scholarship", amount: "$20000", deadline: "February 02, 2019", description: "Ascend Educational Fund awards scholarships to immigrant students and children of immigrants who are graduating from a New York City high school to attend public or private colleges and universities, regardless of ethnicity, national origin, or immigration status. Applicants must be born outside the United States or have two parents born outside the United States, must be a graduating senior at a high school in the boroughs of New York City and must enroll full-time at an accredited public or private college/university in the upcoming academic year. For more information or to apply, please visit the scholarship provider's website.", isLiked: false))
        scholarshipArray.append(Scholarship(title: "Actuarial Diversity Scholarship", amount: "$4000", deadline: "May 02, 2019", description: "The Actuarial Diversity Scholarship promotes diversity within the profession through an annual scholarship program for Black/African American, Hispanic, Native North American and Pacific Islander students. Each applicant must fulfill all the requirements listed: Intent on pursuing a career in the actuarial profession. Must have at least one birth parent who is a member of one of the following minority groups: Black/African American, Hispanic, Native North American, Pacific Islander. Will be a full-time undergraduate student at a U.S. accredited educational institution. Minimum GPA of 3.0 (on a 4.0 scale), emphasis on math or actuarial courses. Entering college freshmen must have a minimum ACT math score of 28 or SAT math score of 600. Actuarial exams will be an important factor in evaluating scholarship qualifications for applicants entering their junior year and beyond. Additionally, exams passed will also be a consideration for previous award recipients applying to renew the scholarship. For more information or to apply, please visit the scholarship provider's website.", isLiked: false))
        scholarshipArray.append(Scholarship(title: "ACS Scholars Program", amount: "$5000", deadline: "March 01, 2019", description: "ACS awards renewable scholarships to underrepresented minority students who want to enter the fields of chemistry or chemistry-related fields. Awards are given to qualified students. African American, Hispanic, or American Indian high school seniors or college freshman, sophomores, or juniors pursuing a college degree in the chemical sciences or chemical technology are eligible to apply. To be considered for a scholarship through the ACS Scholars Program, candidates must: be African-American, Hispanic/Latino, or American Indian, be a U.S. citizen or permanent U.S. resident, be a full-time student at a high school or accredited college, university, or community college, demonstrate high academic achievement in chemistry or science (Grade Point Average 3.0, 'B' or better), demonstrate financial need according to the Free Application for Federal Student Aid form (FAFSA) and the Student Aid Report (SAR) form, be a graduating high school senior or college freshman, sophomore or junior intending to or already majoring in chemistry, biochemistry, chemical engineering or a chemically-related science OR intending to or already pursuing a degree in chemical technology, be planning a career in the chemical sciences. Please note that students intending to enter Pre-Med programs or pursuing a degree in Pharmacy are not eligible for this scholarship. For more information or to apply, please visit the scholarship provider's website.", isLiked: false))
        scholarshipArray.append(Scholarship(title: "ALA - LITA/LSSI Scholarship", amount: "$2500", deadline: "March 01, 2019", description: "ACS awards renewable scholarships to underrepresented minority students who want to enter the fields of chemistry or chemistry-related fields. Awards are given to qualified students. African American, Hispanic, or American Indian high school seniors or college freshman, sophomores, or juniors pursuing a college degree in the chemical sciences or chemical technology are eligible to apply. To be considered for a scholarship through the ACS Scholars Program, candidates must: be African-American, Hispanic/Latino, or American Indian, be a U.S. citizen or permanent U.S. resident, be a full-time student at a high school or accredited college, university, or community college, demonstrate high academic achievement in chemistry or science (Grade Point Average 3.0, 'B' or better), demonstrate financial need according to the Free Application for Federal Student Aid form (FAFSA) and the Student Aid Report (SAR) form, be a graduating high school senior or college freshman, sophomore or junior intending to or already majoring in chemistry, biochemistry, chemical engineering or a chemically-related science OR intending to or already pursuing a degree in chemical technology, be planning a career in the chemical sciences. Please note that students intending to enter Pre-Med programs or pursuing a degree in Pharmacy are not eligible for this scholarship. For more information or to apply, please visit the scholarship provider's website.", isLiked: false))
    }
}

