//
//  AboutMeTableViewController.swift
//  Filipe Alvarenga
//
//  Created by Filipe Alvarenga on 26/03/17.
//  Copyright (c) 2015 Filipe Alvarenga. All rights reserved.
//

import UIKit

class AboutMeTableViewController: UITableViewController {

    // MARK: - Properties
    
    lazy var projects: [Project] = {
        let pathToAboutMe = Bundle.main.path(forResource: "AboutMe", ofType: "plist")!
        let aboutMe = NSDictionary(contentsOfFile: pathToAboutMe) as! [String: AnyObject]
        let projects = aboutMe["projects"] as! [[String: AnyObject]]
        
        return projects.map({Project(dict: $0)})
    }()
    
    lazy var educationItems: [EducationItem] = {
        let pathToAboutMe = Bundle.main.path(forResource: "AboutMe", ofType: "plist")!
        let aboutMe = NSDictionary(contentsOfFile: pathToAboutMe) as! [String: AnyObject]
        let educationItems = aboutMe["educationItems"] as! [[String: AnyObject]]
        
        return educationItems.map({EducationItem(dict: $0)})
    }()
    
    lazy var aboutMeHeader: UIView = {
        let aboutMeHeader =  Bundle.main.loadNibNamed("AboutMeHeader", owner: self, options: nil)![0] as! UIView
        aboutMeHeader.frame = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: CGSize(width: self.frameToDisplay.size.width, height: 265))
        
        return aboutMeHeader
    }()
    
    let projectCellIdentifier = "projectCell"
    let educationItemCellIdentifier = "educationItemCell"
    
    let frameToDisplay = CGRect(x: 0, y: 0, width: 500, height: 500)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController!.navigationBar.isTranslucent = false
        navigationController!.navigationBar.barTintColor = .white
        navigationController!.navigationBar.tintColor = .black
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
        
        let close = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(AboutMeTableViewController.closeAboutMe(sender:)))
        navigationItem.leftBarButtonItem = close
        navigationItem.title = "About Me"
        
        configureTableView()
    }
    
    // MARK: - Custom Configurations
    
    func configureTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
    
        let projectNib = UINib(nibName: "ProjectCell", bundle: nil)
        tableView.register(projectNib, forCellReuseIdentifier: projectCellIdentifier)
        
        let educationItemNib = UINib(nibName: "EducationItemCell", bundle: nil)
        tableView.register(educationItemNib, forCellReuseIdentifier: educationItemCellIdentifier)
        
        tableView.tableHeaderView = aboutMeHeader
    }
    
    // MARK: - Actions
    
    @IBAction func closeAboutMe(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension AboutMeTableViewController {

    // MARK: - UITableViewDataSource
    
    override public func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return projects.count
        } else {
            return educationItems.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let project = projects[indexPath.row]
            
            let projectCell = tableView.dequeueReusableCell(withIdentifier: projectCellIdentifier, for: indexPath)
            projectCell.selectionStyle = .none
            let titleLabel = projectCell.viewWithTag(1400) as! UILabel
            let description = projectCell.viewWithTag(1500) as! UILabel
            let icon = projectCell.viewWithTag(1600) as! UIImageView
            icon.contentMode = .scaleAspectFit
            
            titleLabel.text = project.name
            description.text = project.description
            icon.image = project.image
            
            icon.layer.borderWidth = 1.0
            icon.layer.borderColor = UIColor.groupTableViewBackground.cgColor
            
            return projectCell
        } else {
            let educationItem = educationItems[indexPath.row]
        
            let educationItemCell = tableView.dequeueReusableCell(withIdentifier: educationItemCellIdentifier, for: indexPath)
            educationItemCell.selectionStyle = .none
            let educationTitle = educationItemCell.viewWithTag(900) as! UILabel
            let educationDescription = educationItemCell.viewWithTag(1000) as! UILabel
            let educationStartDate = educationItemCell.viewWithTag(1100) as! UILabel
            let educationEndDate = educationItemCell.viewWithTag(1200) as! UILabel
            let educationIcon = educationItemCell.viewWithTag(1300) as! UIImageView
            
            educationTitle.text = educationItem.title
            educationDescription.text = educationItem.description
            educationStartDate.text = educationItem.startDate
            educationEndDate.text = educationItem.endDate
            educationIcon.image = educationItem.image
            
            educationIcon.layer.borderWidth = 1.0
            educationIcon.layer.borderColor = UIColor.groupTableViewBackground.cgColor
            
            return educationItemCell
        }

    }
    
}

extension AboutMeTableViewController {

    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = Bundle.main.loadNibNamed("AboutMeSectionHeader", owner: self, options: nil)![0] as! UIView
        let sectionTitle = sectionHeader.viewWithTag(100) as! UILabel
        
        if section == 0 {
            sectionTitle.text = "Projects"
        } else {
            sectionTitle.text = "Education"
        }
        
        return sectionHeader
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: view.bounds.width, height: 1.0))
        footerView.backgroundColor = UIColor.groupTableViewBackground
        
        return footerView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layoutIfNeeded()
    }
    
}
