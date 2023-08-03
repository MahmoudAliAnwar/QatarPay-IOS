//
//  JobseekerPersonalDetalsViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 29/05/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import UIKit
import SafariServices

class JobseekerPersonalDetalsViewController: ViewController {
    
    @IBOutlet weak var ProfileImageViewDesign : ImageViewDesign!
    
    @IBOutlet weak var nameLabel              : UILabel!
    
    @IBOutlet weak var jobTitleLabel          : UILabel!
    
    @IBOutlet weak var dateLabel              : UILabel!
    
    @IBOutlet weak var employmentTypeLabel    : UILabel!
    
    @IBOutlet weak var industryAreaLabel      : UILabel!
    
    @IBOutlet weak var languagesLabel         : UILabel!
    
    @IBOutlet weak var yearsOfExperienceLabel : UILabel!
    
    @IBOutlet weak var skillsLabel            : UILabel!
    
    @IBOutlet weak var residenceLabel         : UILabel!
    
    @IBOutlet weak var nationalityLabel       : UILabel!
    
    @IBOutlet weak var emailLabel             : UILabel!
    
    @IBOutlet weak var phoneLabel             : UILabel!
    
    @IBOutlet weak var genderLabel            : UILabel!
    
    @IBOutlet weak var editDeleteStackView    : UIStackView!
        
    @IBOutlet weak var cvFileURL              : UILabel!
    
    var jobDetails : JobHunterList?
    var status     : Status = .fromSearch
    
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension JobseekerPersonalDetalsViewController {
    
    func setupView() {
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
        guard let dataJob = jobDetails else {
            return
        }
        
        self.nameLabel.text               = dataJob._employerName
        self.jobTitleLabel.text           = dataJob._jobTitle
        self.employmentTypeLabel.text     = dataJob._employType
        
        self.industryAreaLabel.text       = dataJob._industry
        self.industryAreaLabel.sizeToFit()
        
        self.languagesLabel.text          = dataJob._language
        self.languagesLabel.sizeToFit()
        
        self.yearsOfExperienceLabel.text  = dataJob._yearOfExperience
        
        self.skillsLabel.text             = dataJob._skills
        self.skillsLabel.sizeToFit()
        
        self.residenceLabel.text          = dataJob._resident
        self.nationalityLabel.text        = dataJob._nationality
        self.emailLabel.text              = dataJob._email
        self.phoneLabel.text              = dataJob._phoneNumber
        self.genderLabel.text             = dataJob._gender
        
         if dataJob._CV_URL.isNotEmpty {
            self.cvFileURL.text = "Open CV File"
             self.cvFileURL.textColor = .mYellow
             
        } else {
            self.cvFileURL.text = "No CV Available"
        }
        
        if let postDate = dataJob._postDate.convertFormatStringToDate(ServerDateFormat.Server1.rawValue) {
            self.dateLabel.text = "\(postDate.formatDate("MMM d, yyyy"))"
        }
        
        self.ProfileImageViewDesign.kf.setImage(with: URL(string: dataJob._profilePictureURL),
                                                placeholder: UIImage.job_hunt_profile_image)
    }
    
    func fetchData() {
    }
}

// MARK: - ACTION

extension JobseekerPersonalDetalsViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editAction(_ sender: UIButton) {
        let vc      = self.getStoryboardView(EditAddMyJobtViewController.self)
        vc.type     = .edit
        vc.jobData  = self.jobDetails
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func deleteAction(_ sender: UIButton) {
        guard let id = jobDetails?._jobSeekerID else { return }
        
        self.requestProxy.requestService()?.deleteJobHunt(id: id, { response in
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
    
    @IBAction func cvDownLoadAction(_ sender: UIButton) {
        guard let stringURL = self.jobDetails?._CV_URL,
        let url = URL(string: stringURL) else {
            return
        }
        
        guard UIApplication.shared.canOpenURL(url) else {
            return
        }
        
        UIApplication.shared.open(url)
        
//        let safariController = SFSafariViewController(url: url)
//        self.present(safariController, animated: true)
    }
}

extension JobseekerPersonalDetalsViewController : EditAddMyJobtViewControllerDelegate {
    
    func didTapEdit(_ controller: EditAddMyJobtViewController, myJob: JobHunterList?) {
        guard let data                    = myJob else { return }
        
        self.nameLabel.text               = data._employerName
        self.jobTitleLabel.text           = data._jobTitle
        self.dateLabel.text               = data._postDate
        self.employmentTypeLabel.text     = data._employType
        self.industryAreaLabel.text       = data._industry
        self.languagesLabel.text          = data._language
        self.yearsOfExperienceLabel.text  = data._yearOfExperience
        self.skillsLabel.text             = data._skills
        self.residenceLabel.text          = data._resident
        self.nationalityLabel.text        = data._nationality
        self.emailLabel.text              = data._email
        self.phoneLabel.text              = data._phoneNumber
        self.genderLabel.text             = data._gender
        
        if data._CV_URL.isNotEmpty {
            self.cvFileURL.text = "Open CV File"
        } else {
            self.cvFileURL.text = "No CV Available"
        }
        self.ProfileImageViewDesign.kf.setImage(with: URL(string: data._profilePictureURL),
                                                placeholder: UIImage.job_hunt_profile_image)
    }
}

// MARK: - Requests Delegate

extension JobseekerPersonalDetalsViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .deleteJobHunt        {
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
                if request == .deleteJobHunt  {
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

