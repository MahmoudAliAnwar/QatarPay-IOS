//
//  VacancPersonalDetalsViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 31/05/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation

class VacancPersonalDetalsViewController: ViewController {
    
    @IBOutlet weak var ProfileImageViewDesign : ImageViewDesign!
    
    @IBOutlet weak var nameLabel              : UILabel!
    
    @IBOutlet weak var jobTitleLabel          : UILabel!
    
    @IBOutlet weak var dateLabel              : UILabel!
    
    @IBOutlet weak var employmentTypeLabel    : UILabel!
    
    @IBOutlet weak var industryAreaLabel      : UILabel!
    
    @IBOutlet weak var languagesLabel         : UILabel!
    
    @IBOutlet weak var yearsOfExperienceLabel : UILabel!
    
    @IBOutlet weak var yearsExperiLabel       : UILabel!
    
    @IBOutlet weak var skillsLabel            : UILabel!
        
    @IBOutlet weak var jobDescriptionLabel    : UILabel!
    
    @IBOutlet weak var websiteLabel           : UILabel!
    
    @IBOutlet weak var emailLabel             : UILabel!
    
    @IBOutlet weak var phoneLabel             : UILabel!
    
    @IBOutlet weak var genderLabel            : UILabel!
    
    @IBOutlet weak var editDeleteStackView    : UIStackView!
    
    var detalsEmployer  : EmployerList?
    var status : Status = .fromSearch
    
    enum Status {
        case fromSearch
        case myList
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        localized()
        setupData()
        fetchData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}

extension VacancPersonalDetalsViewController {
    func setupView() {
        self.requestProxy.requestService()?.delegate = self
        
        switch status {
        case .fromSearch:
            self.editDeleteStackView.isHidden = true
            
        case .myList:
            self.editDeleteStackView.isHidden = false
        }
    }
    
    func localized() {
    }
    
    func setupData() {
        guard let dataEmployer = detalsEmployer else {
            return
        }
        self.nameLabel.text                = dataEmployer._employer_name
        self.jobTitleLabel.text            = dataEmployer._job_title
        self.yearsOfExperienceLabel.text   = "\(dataEmployer._yearofexperience) experience"
        self.employmentTypeLabel.text      = dataEmployer._employment_type
        
        self.industryAreaLabel.text        = dataEmployer._industry
        self.industryAreaLabel.sizeToFit()
        
        self.languagesLabel.text           = dataEmployer._empLanguages
        self.languagesLabel.sizeToFit()
        
        self.yearsExperiLabel.text         = dataEmployer._yearofexperience
        self.genderLabel.text              = dataEmployer._gender
        
        self.jobDescriptionLabel.text      = dataEmployer._job_description
        self.jobDescriptionLabel.sizeToFit()
        
        self.skillsLabel.text              = dataEmployer._desired_Skills
        self.skillsLabel.sizeToFit()
        
        self.websiteLabel.text             = dataEmployer._website
        self.emailLabel.text               = dataEmployer._email
        self.phoneLabel.text               = dataEmployer._phone_number
        
        if let postDate = dataEmployer._postDate.convertFormatStringToDate(ServerDateFormat.Server1.rawValue) {
            self.dateLabel.text = "\(postDate.formatDate("MMM d, yyyy"))"
        }
        self.ProfileImageViewDesign.kf.setImage(with: URL(string: dataEmployer._logo), placeholder: UIImage.company_logo_image)
    }
    
    func fetchData() {
    }
}

// MARK: - ACTION

extension VacancPersonalDetalsViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editAction(_ sender: UIButton) {
        let vc      = self.getStoryboardView(EditAddMyVacancyViewController.self)
        vc.employer = self.detalsEmployer
        vc.delegate = self
        vc.type     = .edit
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func deleteAction(_ sender: UIButton) {
        guard let id = self.detalsEmployer?._employer_id else { return }
        self.requestProxy.requestService()?.deleteEmployer(employerID: id, { response in
            guard let resp = response else { return }
            switch resp._success {
            case true:
                self.showSuccessMessage(resp._message)
                self.dismiss(animated: true)
                break
                
            case false:
                self.showErrorMessage(resp._message)
                break
            }
        })
    }
}

extension VacancPersonalDetalsViewController : EditAddMyVacancyViewControllerDelegate {
    func didTapEdit(_ controller: EditAddMyVacancyViewController, employer: EmployerList?) {
        guard let  data = employer else { return }
        
        self.nameLabel.text                = data._employer_name
        self.jobTitleLabel.text            = data._job_title
        self.yearsOfExperienceLabel.text   = "\(data._yearofexperience) experience"
        self.employmentTypeLabel.text      = data._employment_type
        self.industryAreaLabel.text        = data._industry
        self.languagesLabel.text           = data._empLanguages
        self.yearsExperiLabel.text         = data._yearofexperience
        self.genderLabel.text              = data._gender
        self.jobDescriptionLabel.text      = data._job_description
        self.skillsLabel.text              = data._desired_Skills
        self.websiteLabel.text             = data._website
        self.emailLabel.text               = data._email
        self.phoneLabel.text               = data._phone_number
        
        if let postDate = data._postDate.convertFormatStringToDate(ServerDateFormat.Server1.rawValue) {
            self.dateLabel.text = "\(postDate.formatDate("MMM d, yyyy"))"
        }
        self.ProfileImageViewDesign.kf.setImage(with: URL(string: data._logo), placeholder: UIImage.company_logo_image)
    }
}

// MARK: - Requests Delegate

extension VacancPersonalDetalsViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .deleteEmployer {
            showLoadingView(self)
        }
    }
    
    func requestFinished(request: RequestType, result: ResponseResult) {
        self.hideLoadingView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
            
            switch result {
            case .Success(_):
                break
            case .Failure(let errorType):
                if request == .deleteEmployer {
                    switch errorType {
                    case .Exception(let exc):
                        if showUserExceptions {
                            self.showErrorMessage(exc)
                        }
                        break
                    case .AlamofireError(let err):
                        if showAlamofireErrors {
                            self.showSnackMessage(err.localizedDescription)
                        }
                        break
                    case .Runtime(_):
                        break
                    }
                }
            }
        }
    }
}

