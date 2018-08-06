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
    
    // MARK: - Outlets
    @IBOutlet var searchView: UIView!
    @IBOutlet weak var opportunityTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Variables
    let userID = Auth.auth().currentUser?.uid
    let favoritesVC = FavoritesViewController(nibName: "FavoritesViewController", bundle: nil)
    var incrementInternshipIndex = 0
    var incrementScholarshipIndex = 0
    var isLiked = false
    var ref: DatabaseReference! = Database.database().reference()
    var likedInternships = [Internship]()
    var likedScholarships = [Scholarship]()
    var internshipArray = [Internship]()
    var scholarshipArray = [Scholarship]()
    var searchInternship = [Internship]()
    var searchScholarship = [Scholarship]()
    var isSearching = false
    var buttonState = false
    
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
            searchInternship = internshipArray.filter({$0.description.contains(searchText)})
            isSearching = true
            opportunityTableView.reloadData()
        } else {
            searchScholarship = scholarshipArray.filter({$0.description.contains(searchText)})
            isSearching = true
            opportunityTableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        view.endEditing(true)
        opportunityTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        opportunityTableView.reloadData()
    }
    
    func likeButtonPressedForInternship(intershipVar: Internship) {
        intershipVar.isLiked = !intershipVar.isLiked
        if intershipVar.isLiked == true {
            if likedInternships.contains(where: {$0.title == intershipVar.title}) {
                let alert = UIAlertController(title: "Already in favorites!", message: nil, preferredStyle: .alert)
                let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Added to favorites! ", message: nil, preferredStyle: .alert)
                let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
                likedInternships.append(intershipVar)
            }
        }
        let dict = intershipVar.convertToDict()
        ref?.child("Users").child(userID!).child("Internships").childByAutoId().updateChildValues(dict)
        incrementInternshipIndex += 1
    }
    
    func likeButtonPressedForScholarship(scholarshipVar: Scholarship) {
        scholarshipVar.isLiked = !isLiked
        if scholarshipVar.isLiked == true {
            if likedScholarships.contains(where: {$0.title == scholarshipVar.title}) {
                let alert = UIAlertController(title: "Already in favorites!", message: nil, preferredStyle: .alert)
                let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Added to favorites!", message: nil, preferredStyle: .alert)
                let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
                likedScholarships.append(scholarshipVar)
            }
        }
        let dict = scholarshipVar.convertToDict()
        ref?.child("Users").child(userID!).child("Scholarships").childByAutoId().updateChildValues(dict)
        incrementScholarshipIndex += 1
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
                internshipCell.title.lineBreakMode = .byTruncatingTail
                internshipCell.companyOrAmount.text = searchInternship[indexPath.row].company
                internshipCell.locationOrDeadline.text = searchInternship[indexPath.row].location
                internshipCell.delegate = self
                internshipCell.isScholarship = false
                internshipCell.internshipVar = searchInternship[indexPath.row]
                return internshipCell
            } else {
                scholarshipCell.title.text = searchScholarship[indexPath.row].title
                scholarshipCell.companyOrAmount.text = searchScholarship[indexPath.row].amount
                scholarshipCell.locationOrDeadline.text = searchScholarship[indexPath.row].deadline
                scholarshipCell.delegate = self
                scholarshipCell.isScholarship = true
                scholarshipCell.schoalrshipVar = searchScholarship[indexPath.row]
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
        let InternshipVC = storyboard?.instantiateViewController(withIdentifier: "InternshipViewController") as! InternshipDetailsViewController
        let ScholarshipsVC = storyboard?.instantiateViewController(withIdentifier: "ScholarshipViewController") as! ScholarshipsDetailsViewController
        
        if searchBar.selectedScopeButtonIndex == 0 && !searchInternship.isEmpty {
        InternshipVC.internshipName = searchInternship[indexPath.row].title
        InternshipVC.internshipCo = searchInternship[indexPath.row].company
        InternshipVC.internshipLoc = searchInternship[indexPath.row].location
        InternshipVC.internshipDesc = searchInternship[indexPath.row].description
        InternshipVC.internshipURL = searchInternship[indexPath.row].url
        tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(InternshipVC, animated: true)
        } else if searchBar.selectedScopeButtonIndex == 0 && !searchScholarship.isEmpty {
            ScholarshipsVC.scholarshipName = searchScholarship[indexPath.row].title
            ScholarshipsVC.scholarshipAmnt = searchScholarship[indexPath.row].amount
            ScholarshipsVC.scholarshipDueDate = searchScholarship[indexPath.row].deadline
            ScholarshipsVC.scholarshipDesc = searchScholarship[indexPath.row].description
            ScholarshipsVC.scholarshipURL = searchScholarship[indexPath.row].url
            tableView.deselectRow(at: indexPath, animated: true)
            self.navigationController?.pushViewController(ScholarshipsVC, animated: true)
        } else if searchBar.selectedScopeButtonIndex == 0 {
            InternshipVC.internshipName = internshipArray[indexPath.row].title
            InternshipVC.internshipCo = internshipArray[indexPath.row].company
            InternshipVC.internshipLoc = internshipArray[indexPath.row].location
            InternshipVC.internshipDesc = internshipArray[indexPath.row].description
            InternshipVC.internshipURL = internshipArray[indexPath.row].url
            tableView.deselectRow(at: indexPath, animated: true)
            self.navigationController?.pushViewController(InternshipVC, animated: true)
        } else {
            ScholarshipsVC.scholarshipName = scholarshipArray[indexPath.row].title
            ScholarshipsVC.scholarshipAmnt = scholarshipArray[indexPath.row].amount
            ScholarshipsVC.scholarshipDueDate = scholarshipArray[indexPath.row].deadline
            ScholarshipsVC.scholarshipDesc = scholarshipArray[indexPath.row].description
            ScholarshipsVC.scholarshipURL = scholarshipArray[indexPath.row].url
            tableView.deselectRow(at: indexPath, animated: true)
            self.navigationController?.pushViewController(ScholarshipsVC, animated: true)
        }
        
        
    }
    
    // MARK: - Opportunities
    private func setupInternships() {
        internshipArray.append(Internship(title: "AAAS Minority Science Writers Internship", company: "AAAS", location: "New York", description: "This program places minority students interested in journalism as a career and who want to learn about science writing at Science Magazine for 10 weeks over the summer. Interns experience what it's like to cover the scientific and technological issues that shape our global community. The internship is open to any minority undergraduate with a serious interest in science writing. Preference will be given to those students pursuing a degree in journalism. You must be enrolled in an academic program at the time you submit your application. Required materials: Resume, including any honors, awards, and relevant activities, unofficial transcripts of your undergraduate course work, Two writing samples. At least one should be about a news event that took place after October 15. Application Essay: In less than 800 words, tell us about yourself and why you are interested in this internship including: commitment to journalism; Your thoughts about science and science writing; your career goals; what you hope to get out of this opportunity. include any classes, experiences, affiliations, etc. that you think will make you an ideal candidate for this internship. ", url: "https://www.aaas.org/page/aaas-minority-science-writers-internship", isLiked: false))
        internshipArray.append(Internship(title: "Interpublic Group Scholarship and Internship", company: "Interpublic Group", location: "New York, NY", description: "The New York Women in Communications Foundation, in conjunction with New York Women in Communications, awards the Interpublic Group (IPG) Scholarship and Internship annually based on academic excellence, need and involvement in the field of communications. Each is awarded to an ethnically diverse student who is currently a college junior and has a demonstrated interest in a career in advertising or public relations. Candidates must be able to fulfill a paid internship during the summer prior to the academic year the scholarship is awarded. Eligibility: U.S. citizens or permanent residents who live in NY, NJ, CT, or PA, college undergraduate and graduate students who are permanent residents of one of these states, be majoring, planning to declare a major, or pursuing an advanced degree in advertising or public relationsh ave an overall GPA of 3.2 or better (or the recalculated high school equivalent).", url: "https://scholarships.nywici.org/sponsored-scholarships", isLiked: false))
        internshipArray.append(Internship(title: "Smithsonian Institution James E. Webb Internship", company: "Smithsonian", location: "Washington, DC", description: "This program was established in honor of the late James. E. Webb, Regent Emeritus and former Administrator of the National Aeronautics and Space Administration (NASA), to promote excellence in the management of not-for-profit organizations. These opportunities are intended to increase participation of minority groups who are under-represented in the management of scientific and cultural organizations. Interns are placed in offices, museums, and research institutes throughout the Smithsonian Institution. Eligibility: U.S. Citizens and U.S. permanent residents must be formally enrolled in an undergraduate or in a graduate program of study in business or public administration, students are generally expected to have a 3.0 GPA", url: "https://www.smithsonianofi.com/internship-opportunities/james-e-webb-internship/", isLiked: false))
        internshipArray.append(Internship(title: "Tampa Bay Times Peterman Scholarship/News Internship", company: "Tampa Bay Times", location: "St. Petersburg, FL", description: "Only students who are hired as part of the Summer Internship Program at the Times are eligible to apply for these awards. Scholarships are worth up to $3,500 for returning full-time undergraduate students and up to $1,500 for returning full-time graduate students. The Peggy Peterman Scholarship targets minority students in journalism. It is worth $5,000 and includes a paid internship at the Times. Applicants must be full-time undergraduate or graduate minority students who are committed to careers in journalism, with at least one newspaper or news website internship or equivalent professional experience. Indicate in your application that you are applying for the Peterman Scholarship/News Internship.", url: "http://company.tampabay.com:2052/times-fund/scholarships", isLiked: false))
        internshipArray.append(Internship(title: "UNCF/Carnival Corporate Scholars Program", company: "Carnival Corp.", location: "Nationwide", description: "The UNCF/Carnival Corporate Scholars Program, sponsored in partnership with Carnival Corporation, is seeking college sophomores with an interest in pursuing a career in the hospitality industry and whose experience in their first two years of college demonstrates leadership and strategic and analytical ability. Candidates will be selected to participate in a two-year scholarship and internship at various Carnival Corporation host sites for the Minority sophomore undergraduate student enrolled full-time at a U.S. located, accredited four-year institution or a transfer student from a community college that has been accepted into an accredited four-year college or university -Community college students should select four-year under the enrollment status within the application, minimum GPA of 2.75; minimum GPA of 3.0 required for renewal, U.S. citizen or a permanent resident, majoring in hospitality management and/or administration, tourism, culinary arts, business, finance, communications, marketing or related field.", url: "https://scholarships.gmsp.org/Program/Details/39a4e769-abbf-467c-9af8-8f0163bfee37", isLiked: false))
        // MARK - 5
        internshipArray.append(Internship(title: "Bilingual Internship - PR & Influencer Marketing", company: "H+M Communications", location: "Los Angeles, CA", description: "H+M Communications is a full-service boutique and consumer-marketing consultancy with offices located in Los Angeles, New York, Miami and Seattle. H+M is dedicated to multicultural marketing with special focus on the U.S. Hispanic market and has become one of the top multicultural agencies trusted by many brands, film studios, television networks, content producers and distributors over the past fifteen years. H+M's expertise spans media and community relations, influencer outreach, grassroots/experiential marketing, and sponsorship development and activation. Some of our clients include: Universal Pictures, Telemundo, Fox Searchlight, Paramount, Comcast, Pantelion, STRONG by Zumba, and Sony Pictures Television among others.", url: "https://www.indeed.com/q-PR-Marketing-Internship-jobs.html?vjk=8a88bf619b55b7b2", isLiked: false))
        internshipArray.append(Internship(title: "CONGRESSIONAL INTERNSHIP PROGRAM", company: "Congressional Hispanic Caucus Institute", location: "Washington, D.C.", description: "CHCI Interns will meet accomplished leaders—including CHCI Alumni— dedicated to improving the Latino community. These leaders come from a wide range of professional backgrounds, including Capitol Hill, Fortune 500 companies, NGOs, nonprofits, and other organizations that support Latino education and leadership development.", url: "https://chci.org/programs/congressional-internship-program/", isLiked: false))
        internshipArray.append(Internship(title: "Inroads", company: "INROADS", location: "Varies", description: "INROADS accepts applications year-round, however for priority consideration, we recommend college undergraduates submit their online internship application by March 31st. Our mission has changed thousands of lives worldwide – you could be next. If you have what it takes, the INROADS Application is the first step to becoming an INROADS Intern. Students applying to Canada or Mexico opportunities should email recruitment@inroads.org for unique application qualifications.", url: "https://inroads.org/internships/apply/", isLiked: false))
        internshipArray.append(Internship(title: "ACLU Immigrants' Rights Project Undergraduate Internship Program", company: "ACLU", location: "Varies", description: "The ACLU is an equal opportunity employer.  We value a diverse workforce and an inclusive culture.  The ACLU encourages applications from all qualified individuals without regard to race, color, religion, gender, sexual orientation, gender identity or expression, age, national origin, marital status, citizenship, disability, veteran status, and record of arrest or conviction. The ACLU undertakes affirmative action strategies in its recruitment and employment efforts to assure that persons with disabilities have full opportunities for employment in all positions. Applicants are not required or expected to provide any current salary and compensation information, or salary history during any phase of the recruitment process. Job candidates may provide salary expectations or request information regarding the salary for the position(s) to which they are applying.", url: "https://www.aclu.org/careers", isLiked: false))
        internshipArray.append(Internship(title: "American Economic Association Summer Minority Program", company: "American Economic Association", location: "Chicago, IL", description: "Since 1974, the AEA Summer Training Program and Scholarship Program have increased diversity in the field of economics by preparing talented undergraduates for doctoral programs in economics and related disciplines. AEASP is a prestigious program that enables students to develop and solidify technical skills in preparation for the rigors of graduate studies. As many as 20% of PhDs awarded to minorities in economics over the past 20 years are graduates of the program. All students receive 2 months of intensive training in microeconomics, math, econometrics and research methods with leading faculty. At 3 credits per class, students have the opportunity to earn 12 college credits.", url: "https://scholarships.gmsp.org/Program/Details/39a4e769-abbf-467c-9af8-8f0163bfee37", isLiked: false))
        // MARK - 10
        internshipArray.append(Internship(title: "Center for the Advancement of Hispanics in Science and Engineering Education", company: "CASHEE", location: "Landover, MD", description: "The Center for the Advancement of Hispanics in Science and Engineering Education is a national educational and scientific non-profit organization based in Washington DC created by Latino scientists and engineers. Our mission is to prepare talented Hispanic and other underrepresented minority science and engineering students achieve academic excellence and professional success through CAHSEE's pipeline of rigorous educational and leadership development programs.", url: "http://www.cahsee.org/", isLiked: false))
        internshipArray.append(Internship(title: "Diversity Programs", company: "Barclays", location: "Varies", description: "Diversity programs We offer a wide range of career opportunities to help you expand your learning and find smarter solutions. You'll find an overview of all our diversity programs below, so use our dropdown filters to find the ones that suit you best. Then, just click to find out more or use the star in the bottom left to save your perfect roles to your wishlist for later.", url: "https://joinus.barclays/americas/diversity-programs/", isLiked: false))
        internshipArray.append(Internship(title: "ASPIRA Programs", company: "ASPIRA", location: "Varies", description: "ASPIRA has had over forty-nine years of experience creating and implementing  informal education programs that build up self-esteem, cultural awareness, and leadership abilities. Those programs include but are not limited to the programs listed on this section. ", url: "http://www.aspira.org/book/programs", isLiked: false))
//        internshipArray.append(Internship(title: "Advocacy and Social Justice Intern", company: "AFT’s Human Rights and Community Relations Department Internship Program is a project-oriented internship coupled with the exposure to the roles that advocacy, communications, research, administrative and marketing functions play in the department’s daily operations. The Human Rights and Community Relations Department grapples with some of the leading public policy issues affecting working families which include education, immigration, civil, human and women’s rights, gender, LGBT, ELL instruction, achievement gap, and faith-based initiatives. ", url: "https://www.aft.org/careers/internship-opportunities/human-rights-internships", isLiked: false))
        internshipArray.append(Internship(title: "American Economic Association Summer Minority Program", company: "American Economic Association", location: "Chicago, IL", description: "Since 1974, the AEA Summer Training Program and Scholarship Program have increased diversity in the field of economics by preparing talented undergraduates for doctoral programs in economics and related disciplines. AEASP is a prestigious program that enables students to develop and solidify technical skills in preparation for the rigors of graduate studies. As many as 20% of PhDs awarded to minorities in economics over the past 20 years are graduates of the program. All students receive 2 months of intensive training in microeconomics, math, econometrics and research methods with leading faculty. At 3 credits per class, students have the opportunity to earn 12 college credits.", url: "https://scholarships.gmsp.org/Program/Details/39a4e769-abbf-467c-9af8-8f0163bfee37", isLiked: false))
        // MARK - 15
    }
    
    private func setupScholarships() {
        scholarshipArray.append(Scholarship(title: "¡Adelante! Fund Ford Motor Company/Future Leaders Scholarship", amount: "$1,500", deadline: "Deadline Varies", description: "The ¡Adelante! U.S. Education Leadership Fund is a leadership development, non-profit organization dedicated to Hispanic college students. Our Mission is to inspire the best and brightest Latino students to graduate and lead through scholarships, internships, and leadership training. Applicants must have completed at least 30 credit hours of college coursework prior to the upcoming fall semester and must have attended a San Antonio area high school (50-mile radius) and be a U.S. Citizen or permanent resident who is of Hispanic descent and has a minimum 2.75 GPA. Must maintain full-time enrollment status (12 hours) for the duration of the scholarship period. For more information or to apply, please visit the scholarship provider's website.", url: "https://www.adelantefund.org/#!scholarships/cee5", isLiked: false))
        scholarshipArray.append(Scholarship(title: "¡Adelante! Fund Gilbert G. Pompa Memorial Scholarship", amount: "$1000", deadline: "July 03, 2019", description: "The ¡Adelante! U.S. Education Leadership Fund is a leadership development, non-profit organization dedicated to Hispanic college students. Our Mission is to inspire the best and brightest Latino students to graduate and lead through scholarships, internships, and leadership training. All majors are welcome to apply for this scholarship, but students must be pursuing a pre-law program and/or planning to attend law school. Applicants must be enrolled at an accredited university or public/private college in the state of Texas and have completed 90 credit hours before the fall semester. All majors are eligible but students must be pursuing a pre-law program and/or planning to attend law school. Applicants must have and maintain a 2.75 GPA or above and must be a U.S. Citizen or permanent resident. Preference will be given to female students of Hispanic descent. For more information or to apply, please visit the scholarship provider's website.", url: "https://www.adelantefund.org/#!scholarships/cee5", isLiked: false))
        scholarshipArray.append(Scholarship(title: "¡Adelante! Fund MillerCoors Colorado Scholarship", amount: "$3000", deadline: "July 03, 2019", description: "The ¡Adelante! U.S. Education Leadership Fund is a leadership development, non-profit organization dedicated to Hispanic college students. Our mission is to inspire the best and brightest Latino students to graduate and lead through scholarships, internships, and leadership training. Must be a junior or senior university classification by the fall semester. Open only to Chicagoland partnering universities. Applicants must be of Hispanic descent and must be a US citizen or legal permanent resident with a GPA of 3.0 or higher on a 4.0 scale. For more information or to apply, please visit the scholarship provider's website.", url: "https://www.adelantefund.org/#!scholarships/cee5", isLiked: false))
        scholarshipArray.append(Scholarship(title: "¡Adelante! Fund MillerCoors Engineering and Science Scholarship", amount: "$3000", deadline: "July 03, 2019", description: "The ¡Adelante! U.S. Education Leadership Fund is a leadership development, non-profit organization dedicated to Hispanic college students. Our mission is to inspire the best and brightest Latino students to graduate and lead through scholarships, internships, and leadership training. Must be a college junior or senior by the fall semester of the award and must be a U.S. Citizen or permanent resident who is of Hispanic descent. Applicants must have a 3.0 GPA or above and maintain full-time enrollment status (12 hours) for the duration of the scholarship period. For more information or to apply, please visit the scholarship provider's website.", url: "https://www.adelantefund.org/#!scholarships/cee5", isLiked: false))
        scholarshipArray.append(Scholarship(title: "¡Adelante! HOPE Alamo Community College District Scholarship", amount: "$1000", deadline: "March 18, 2019", description: "The Hispanic Organization for Public Employees is pleased to offer the following scholarships to any incoming freshmen or current students attending an Alamo Community College District Campus (San Antonio College, Palo Alto College, St. Phillip's College, Northwest Vista, Northeast Lakeview College). Students must have a minimum 2.75 GPA, participate in community service, complete a FAFSA and pursue an undergraduate degree in any concentration. For more information or to apply, please visit the scholarship provider's website.", url: "https://www.adelantefund.org/#!scholarships/cee5", isLiked: false))
        // MARK - 5
        scholarshipArray.append(Scholarship(title: "ALLIES Scholarship for Student Leadership Development", amount: "$500", deadline: "March 15, 2019", description: "This scholarship was created in 2001 by ALLIES at Northern Michigan University. Applicants must be full-time students at Northern Michigan University in good academic standing and show documented leadership, support, or involvement in organizations, activities, or issues that promote awareness and acceptance of the gay/lesbian/bisexual/transgender (GLBT) community at Northern Michigan University. For more information or to apply, please visit the scholarship provider's website.", url: "http://www.nmu.edu/multiculturaledandres/node/9#__utma", isLiked: false))
        scholarshipArray.append(Scholarship(title: "Audria M. Edwards Scholarship Fund", amount: "Varies", deadline: "May 01, 2019", description: "The Audria M. Edwards Scholarship Fund are for students who will be pursuing post-secondary, undergraduate education in an accredited institution or program during the coming school year and who are lesbian, gay, bisexual, or transgender or have a LGBT parent. Applicants must have resided for at least one year in the State of Oregon or in Clack, Cowlitz, Skamania, or Wahkiakum Counties in Washington.", url: "http://www.peacockinthepark.org/scholarship/", isLiked: false))
        scholarshipArray.append(Scholarship(title: "Better Brothers LA Book Scholarship", amount: "$1500", deadline: "January 19, 2019", description: "Having tuition paid is challenge enough for any student, but not having all the right materials on the first day of class hinders many students from starting a successful educational journey. Better Brothers LA assists Black LGBTQ youth with avoiding this hindrance by offering book scholarships. The scholarships support youth who have been admitted to or are attending an accredited degree, licensing or vocational program anywhere in the country. Scholarships range from $500 to $1,500 and will be presented to recipients during the annual Truth Awards. For more information or to apply, please visit the scholarship provider's website.", url: "http://betterbrothersla.com/book-scholarship.shtml", isLiked: false))
        scholarshipArray.append(Scholarship(title: "CFPCA LGBT Endowed Scholarship", amount: "$500", deadline: "February 01, 2019", description: "The CFPCA LGBT Endowed Scholarship provides financial support and hope to meritorious students who demonstrate positive sensitivity to and involvement in LGBT issues. Preference is given to LGBT students although all students are invited to apply. All current undergraduate and graduate students enrolled at least half-time with majors in the College of Fine, Performing and Communication Arts who are in good academic standing may apply. Applicants should demonstrate positive sensitivity to and involvement in LGBT issues. For more information or to apply, please visit the scholarship provider's website.", url: "http://cfpca.wayne.edu/scholarships.php", isLiked: false))
        scholarshipArray.append(Scholarship(title: "Chely Wright Like Me Scholarship", amount: "$1250", deadline: "May 31, 2019", description: "The Chely Wright LIKE ME Scholarship provides financial support for students pursuing a college degree who actively advocate for LGBT youth and/or to students who are severely affected by teen bullying or suicide of an LGBT youth. Through this scholarship, LGBT affected youth can apply for funding to pay for educational expenses to pursue a degree from an accredited college, university, or technical/vocational program. Graduating high school seniors who can show that they have actively advocated for LGBT issues, such as respect and inclusion for LGBT youth, community service at an LGBT resource, involvement and/or attendance of LGBT events, working against teen bullying or teen suicide, and any other activities that improve the condition of the LGBT community and/or improve cultural conditions for LGBT youth are eligible to apply. For more information or to apply, please visit the scholarship provider's website.", url: "http://likeme.org/chely-wright-scholarship/", isLiked: false))
        // MARK - 10
        scholarshipArray.append(Scholarship(title: "Ann Seki Memorial Scholarship", amount: "Varies", deadline: "April 30, 2019", description: "This scholarship, sponsored by Chevron, is awarded in memory of Ann Seki, an original member of the Chevron Hispanic Recruiting Team. For 30 years, she had a determined viewpoint in ensuring Chevron met diversity hiring goals and was instrumental in developing a process to identify and select Chevron employees for higher recognition outside Chevron. This scholarship has been awarded since 2010. Eligibility: Hispanic/Latino, be a freshmen, sophomore, or junior in college, major in Engineering (Civil, Chemical, Electrical, Facilities, Mechanical, and Petroleum), minimum 3.3 GPA, a U.S. Citizen/Permanent Resident", url: "http://www.greatmindsinstem.org/college/ann-seki-memorial-scholarship", isLiked: false))
        scholarshipArray.append(Scholarship(title: "APA Judith McManus Price Scholarship", amount: "$4000", deadline: "April 30, 2019", description: "Women and minority (African American, Hispanic American, or Native American) students enrolled in an approved Planning Accreditation Board (PAB) planning program who are citizens of the United States, intend to pursue careers as practicing planners in the public sector, and are able to demonstrate a genuine financial need are eligible to apply for a scholarship. Eligibility: women and members of one of the following minority groups: African American, Hispanic American or Native American, citizens of the United States, students enrolled or officially accepted for enrollment in an undergraduate or graduate, students who intend to work as practicing planners in the public sector (which includes local, state & federal government, and not-for-profit careers), students able to document their need for financial assistance, prior winners of any APA-administered fellowship or scholarship program are not eligible", url: "https://www.planning.org/foundation/scholarships/", isLiked: false))
        scholarshipArray.append(Scholarship(title: "APSA Minority Fellowship Program", amount: "$4000", deadline: "October 30, 2018", description: "Minority Fellows Program is a fellowship competition for individuals from under-represented backgrounds applying to doctoral programs in political science. The MFP was established in 1969 (originally as the Black Graduate Fellowship) to increase the number of minority scholars in the discipline. Eligibility: Be a member of one of the following racial/ethnic minority groups: African Americans, Asian Pacific Americans, Latinos/as, and Native Americans, Be college/university seniors, college/university graduates, or students currently enrolled in a master's program, demonstrate an interest in teaching and potential for research in political science, be a U.S. citizen at time of application, if you are not admitted for the current year, you may request that your award be deferred for one year, to be administered only if you are admitted to a political science graduate program beginning in upcoming fall. Deferment requests for the following year will be reviewed by the committee. Deferments are not guaranteed, if you are not admitted for next year, you will be required to reapply to the MFP.", url: "https://www.apsanet.org/mfp", isLiked: false))
        scholarshipArray.append(Scholarship(title: "ASA Minority Fellowship Program", amount: "$18000", deadline: "January 31, 2019", description: "Minority Fellowship Program applicants can be new or continuing graduate students. However, the MFP is primarily designed for minority students entering a doctoral program in sociology for the first time or for those who are in the early stages of their graduate programs. MFP applicants must be applying to or enrolled in sociology departments which have strong mental health research programs and/or faculty who are currently engaged in research focusing on mental health issues. MFP Fellows are selected on the basis of their commitment to research in mental health and mental illness, academic achievement, scholarship, writing ability, research potential, financial need, and racial/ethnic minority background. Specifically, applicants must be members of one of the following racial/ethnic groups: Blacks/African Americans, Latinos/as (e.g., Mexican Americans, Puerto Ricans, Cubans), American Indians or Alaskan Natives, and Asians (e.g., Chinese, Japanese, Korean, Southeast Asian), or Pacific Islanders (e.g., Hawaiian, Guamanian, Samoan, Filipino). Fellows must be citizens or non-citizen nationals of the United States, or have been lawfully admitted to the United States for permanent residence and have in their possession an Alien Registration Card.", url: "http://www.asanet.org/career-center/grants-and-fellowships/minority-fellowship-program", isLiked: false))
        scholarshipArray.append(Scholarship(title: "ALA - LITA/LSSI Scholarship", amount: "$2500", deadline: "March 01, 2019", description: "ACS awards renewable scholarships to underrepresented minority students who want to enter the fields of chemistry or chemistry-related fields. Awards are given to qualified students. African American, Hispanic, or American Indian high school seniors or college freshman, sophomores, or juniors pursuing a college degree in the chemical sciences or chemical technology are eligible to apply. To be considered for a scholarship through the ACS Scholars Program, candidates must: be African-American, Hispanic/Latino, or American Indian, be a U.S. citizen or permanent U.S. resident, be a full-time student at a high school or accredited college, university, or community college, demonstrate high academic achievement in chemistry or science (Grade Point Average 3.0, 'B' or better), demonstrate financial need according to the Free Application for Federal Student Aid form (FAFSA) and the Student Aid Report (SAR) form, be a graduating high school senior or college freshman, sophomore or junior intending to or already majoring in chemistry, biochemistry, chemical engineering or a chemically-related science OR intending to or already pursuing a degree in chemical technology, be planning a career in the chemical sciences. Please note that students intending to enter Pre-Med programs or pursuing a degree in Pharmacy are not eligible for this scholarship. For more information or to apply, please visit the scholarship provider's website.", url: "http://www.ala.org/lita/awards/lssi", isLiked: false))
        scholarshipArray.append(Scholarship(title: "Augustana University Diversity Scholarships", amount: "Varies", deadline: "Varies", description: "Diversity Scholarships are for full-time students who are members of a minority ethnic group and bring diversity to campus. Ethnicity and financial need are two of the factors considered. Verify your eligibility with the Office of Admission or Financial Aid.", url: "http://www.augie.edu/admission/financing-your-education/scholarships", isLiked: false))
        // MARK - 15
        scholarshipArray.append(Scholarship(title: "Jesse L. Jackson-Fellows Toyota Scholarship", amount: "$20000", deadline: "May 01, 2019", description: "The Jesse Jackson Fellows-Toyota Scholarship is a renewable scholarship that awards up to $25,000 dollars annually to deserving African-American college sophomores. Students who are interested in applying for the scholarship must have a minimum cumulative 3.0 GPA, be a business or STEM (Science, technology, engineering and/or math) major that can be applied to the automotive industry, demonstrated participation in community service and need for financial assistance. For more information or to apply, please visit the scholarship provider's website.", url: "http://www.pushexcel.org/scholarships/", isLiked: false))
        scholarshipArray.append(Scholarship(title: "Jonathan LaRon Skinner Memorial Scholarship", amount: "$500", deadline: "April 01, 2019", description: "The Jonathan LaRon Skinner Memorial Scholarship was established by the family and friends of Jonathan Skinner in 2010 in memory of Jonathan LaRon Skinner to provide scholarships to graduating high school seniors. To receive consideration, applicants must attend a Forsyth County high school and reside in The Winston-Salem Foundation's service area with preference given to students attending Quality Education High School of Business and Entrepreneurship; have a minimum 3.0 GPA and be African American. A need for financial aid must be demonstrated as well. For more information or to apply, please visit the scholarship provider's website.", url: "https://www.wsfoundation.org/sslpage.aspx?pid=745", isLiked: false))
        scholarshipArray.append(Scholarship(title: "Juanita Crippen Memorial Scholarship", amount: "$500", deadline: "April 30, 2019", description: "To recognize a senior high school student from a migrant farm-worker family in Franklin, St. Lawrence, or Clinton Counties in New York State needing post-secondary scholarship assistance who has demonstrated a caring and giving attitude toward another individual or community with a scholarship. Requirements: Two reference letters from a school representative (such as a counselor, teacher, coach, or other) addressing your educational commitment, grades, etc. and supporting the need for financial assistance. A reference letter may not be written by you, anyone under 21 years of age, or anyone related to you or serving as a legal guardian, Personal essay (250-300 words) including information about what service to others means to you and how you have benefited by assisting someone else. What did you learn from the experience? Proof of acceptance/enrollment at a college/university Proof of migrant education eligibility with a Certificate of Eligibility (COE) showing qualifications as a migrant student during the past three years or any time during high school.", url: "http://migrant.net/migrant/scholarships/crippen.htm", isLiked: false))
        scholarshipArray.append(Scholarship(title: "Kahdine Ann DaCosta Scholarship for Excellence in Leadership", amount: "$1000", deadline: "March 01, 2019", description: "The Kahdine Ann DaCosta Memorial Scholarship for Excellence in Leadership was established on October 15, 2011 in honor of Kahdine Ann DaCosta. Every year, I AM O'KAH! searches for students that embody Kahdine’s tenacious drive and unwavering dedication to the community. Applicants must attend a high school in the Baltimore Metro area (Baltimore City, Baltimore County and Ann Arundel County) and be a senior in good standing, as defined by school and verified by official transcript. Applicants must have a minimum cumulative grade point average of 2.5 out of 4.0 or equivalent. Have demonstrated leadership abilities through their participation in community service, extracurricular activities, or other activities shown to foster leadership skills. A minimum of two consecutive years of community service/activities is required. Will enroll for the first time at an accredited two- or four-year college/university (including trade/vocational school where they will earn an associate degree) located in the United States in the upcoming academic year. Have a demonstrated financial need, verified through the Free Application for Federal Student Aid (FAFSA)", url: "http://www.iamokah.org/scholarship/", isLiked: false))
        scholarshipArray.append(Scholarship(title: "Kevin W. Scott Memorial Scholarship", amount: "Varies", deadline: "February 15, 2019", description: "Kelvin W. Scott, an outstanding member of the basketball and track teams at Arthur Hill High School, set remaining track records before graduating in 1980. Kelvin continued on to be a Big Ten champion and record setter in indoor and outdoor track at Michigan State University in the 1 mile, 1,600 meter and the 4×400-meter relay teams in 1982 and 1983. After graduating from MSU in 1984, Kelvin went on to receive a Juris Doctorate degree from Georgetown University Law Center in 1987. An attorney in both corporate and governmental fields and a member of various legal organizations, Kelvin served as the director of the Michigan Department of Civil Rights at the time of his passing where he championed the rights of people without full equality in Michigan. Requirements: Graduating senior from Arthur Hill High School, Saginaw High School or Saginaw Arts & Sciences Academy, minimum 3.2 GPA, pursuing an undergraduate degree in pre-law.", url: "http://www.saginawfoundation.org/site/kelvin-w-scott-memorial-scholarship/", isLiked: false))
        // Mark - 20
    }
}
