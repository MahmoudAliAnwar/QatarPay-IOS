//
//  ShowCVDetailsViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 07/05/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import UIKit

class ShowCVDetailsViewController: ViewController {
    
    @IBOutlet weak var avaterImageView     : ImageViewDesign!
    
    @IBOutlet weak var nameLabel           : UILabel!
    
    @IBOutlet weak var jobTitleLabel       : UILabel!
    
    @IBOutlet weak var companyLabel        : UILabel!
    
    @IBOutlet weak var countryLabel        : UILabel!
    
    @IBOutlet weak var universityLabel     : UILabel!
    
    @IBOutlet weak var stackAction         : UIStackView!
    
    @IBOutlet weak var skillsLabel         : UILabel!
    
    @IBOutlet weak var rsidenceLabel       : UILabel!
    
    @IBOutlet weak var nationalityLabel    : UILabel!
    
    @IBOutlet weak var languagesLabel      : UILabel!
    
    @IBOutlet weak var genderLabel         : UILabel!
    
    @IBOutlet weak var emailLabel          : UILabel!
    
    @IBOutlet weak var websiteLabel        : UILabel!
    
    @IBOutlet weak var IMLabel             : UILabel!
    
    @IBOutlet weak var twitterLabel        : UILabel!
    
    @IBOutlet weak var facebookLabel       : UILabel!
    
    @IBOutlet weak var industryAreaLabel   : UILabel!
    
    @IBOutlet weak var professionAreaLabel : UILabel!
    
    @IBOutlet weak var salaryExpectLabel   : UILabel!
    
    @IBOutlet weak var graduateLabel       : UILabel!
    
    @IBOutlet weak var icLockPublicButton  : UIButton!
    
    @IBOutlet weak var icLockPrivateButton : UIButton!
    
    @IBOutlet weak var editSkillsStackView : UIStackView!
    
    @IBOutlet weak var editExpertiseStackView: UIStackView!
    
    @IBOutlet weak var searchCVButton: ButtonDesign!
    
    var cv     : CV?
    var status : Status = .myCV
    
    enum Status {
        case myCV
        case searchCV
        
        var isMyCV : Bool {
            get {
                switch self {
                case .myCV     : return true
                case .searchCV : return false
                }
            }
        }
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        switch status {
        case .myCV:
            guard let user = self.userProfile.getUser() else {
                self.showSnackMessage("Something went wrong")
                return
            }
            
            self.requestProxy.requestService()?.getCVList(phoneNumber: user._mobileNumber, { (response) in
                guard let resp = response , let cv = resp._list.first else {
                    self.showSnackMessage("Something went wrong")
                    return
                }
                self.cv = cv
                self.setData()
                self.userProfile.cv = cv
            })
            
        case .searchCV:
            self.setData()
        }
    }
}

extension ShowCVDetailsViewController {
    
    func setupView() {
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
     
    }
}

// MARK: - ACTION

extension ShowCVDetailsViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func searchCvAction(_ sender : UIButton) {
        let vc = self.getStoryboardView(SearchCvViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func publicLockAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(EditPersonalResumeViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func privateLockAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(EditPersonalResumeViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func shareAction(_ sender: UIButton) {
        self.shareCV()
    }
    
    @IBAction func editAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(EditPersonalResumeViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func editSkillsAction(_ sender: UIButton){
        let vc = self.getStoryboardView(EditSkillsCvViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func editExpertiseAction(_ sender: UIButton){
        let vc = self.getStoryboardView(EditExpertiseViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//// MARK: - Requests Delegate
//extension ShowCVDetailsViewController: RequestsDelegate {
//
//    func requestStarted(request: RequestType) {
//        if request == .getCVList {
//            showLoadingView(self)
//        }
//    }
//
//    func requestFinished(request: RequestType, result: ResponseResult) {
//        self.hideLoadingView()
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
//
//            switch result {
//            case .Success(_):
//                break
//            case .Failure(let errorType):
//                switch errorType {
//                case .Exception(let exc):
//                    if showUserExceptions {
//                        self.showErrorMessage(exc)
//                    }
//                    break
//                case .AlamofireError(let err):
//                    if showAlamofireErrors {
//                        self.showSnackMessage(err.localizedDescription)
//                    }
//                    break
//                case .Runtime(_):
//                    break
//                }
//            }
//        }
//    }
//}

// MARK: - CUSTOM FUNC

extension ShowCVDetailsViewController {
    
    private func setData() {
        switch status {
        case .myCV:
            self.stackAction.isHidden = false
            self.editSkillsStackView.isHidden = false
            self.editExpertiseStackView.isHidden = false
            self.searchCVButton.isHidden = false
            
        case .searchCV:
            self.stackAction.isHidden = true
            self.editSkillsStackView.isHidden = true
            self.editExpertiseStackView.isHidden = true
            self.searchCVButton.isHidden = true
        }
        
        guard let cv = self.cv else { return }
        
        ///--------------------------------
        self.nameLabel.text            = cv._name
        self.jobTitleLabel.text        = cv._currentJobList.first?.jobTitle
        self.countryLabel.text         = cv._currentJobList.first?.country
        self.universityLabel.text      = cv._educationList.first?.educationUniversity
        
        if cv._privacyStatus == "private" {
            self.icLockPublicButton.isHidden = true
            self.icLockPrivateButton.isHidden = false
        }else {
            self.icLockPublicButton.isHidden = false
            self.icLockPrivateButton.isHidden = true
            
        }
        
        ///---------------------------------
        self.skillsLabel.text          = cv._skills
        self.skillsLabel.sizeToFit()
        
        ///---------------------------------
        self.rsidenceLabel.text        = cv._resident
        self.nationalityLabel.text     = cv._nationality
        self.languagesLabel.text       = cv._languages
        self.languagesLabel.sizeToFit()
        
//        let attributedString       = NSAttributedString(string: cv._languages)
//        self.languagesLabel.attributedText       = attributedString
//        self.languagesLabel.sizeThatFits(CGSize(width: .zero, height: attributedString.size().height))
        
        self.genderLabel.text         = cv._gender
        self.emailLabel.text          = cv._email
        self.websiteLabel.text        = cv._website
        self.IMLabel.text             = cv._im
        self.twitterLabel.text        = cv._twitter
        self.facebookLabel.text       = cv._facebook
        
        ///--------------------------------
        self.industryAreaLabel.text   = cv._industry_Area
        
        self.professionAreaLabel.text = cv._profession_Area
        self.professionAreaLabel.sizeToFit()
        
        self.graduateLabel.text       = cv._graduate
        self.salaryExpectLabel.text   = cv._salaryExpect
        
        cv._profilePicture.getImageFromURLString { (status, image) in
            guard status else { return }
            self.avaterImageView.image = image
        }
    }
    
    private func shareCV() {
        guard let cv = self.cv else { return }
        if let name = URL(string: "https://qatarpay.com/cv/index.html?key=abbdfer5477djdnnndgdhhsfs555llkkfvv6ff36k&CVID=\(cv._cVID)"), name.absoluteString.isNotEmpty {
            let objectsToShare = [ name ]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
            
        } else {
            self.showAlertMessage(message: "Not Available")
        }
    }
}
