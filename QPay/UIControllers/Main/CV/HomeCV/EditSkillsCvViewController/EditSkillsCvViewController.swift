//
//  EditSkillsCvViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 09/05/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import UIKit

class EditSkillsCvViewController: MainController {
   
    @IBOutlet weak var skillsTextView       : UITextView!
    
    @IBOutlet weak var residenceLabel       : UILabel!
    
    @IBOutlet weak var nationalityLabel     : UILabel!
    
    @IBOutlet weak var languagesTextField   : UITextField!
    
    @IBOutlet weak var maleCheckBox         : CheckBox!
    
    @IBOutlet weak var femaleCheckBox       : CheckBox!
    
    @IBOutlet weak var emailTextField       : UITextField!
    
    @IBOutlet weak var websiteTextField     : UITextField!
    
    @IBOutlet weak var IMTextField          : UITextField!
    
    @IBOutlet weak var twitterTextField     : UITextField!
    
    @IBOutlet weak var facebookTextField    : UITextField!
    
    private var selectedGender: Gender = .male
    
    private enum Gender: String {
        case male    = "Male"
        case female  = "Female"
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

extension EditSkillsCvViewController {
    
    func setupView() {
        self.requestProxy.requestService()?.delegate = self
        
        [
            self.maleCheckBox,
            self.femaleCheckBox,
        ].forEach { check in
            check.style        = .circle
            check.borderStyle  = .rounded
            check.tintColor    = .black
            check.borderWidth  = 1.5
        }
        
        self.maleCheckBox.addTarget(self, action: #selector(didChangeMaleCheckBox(_:)), for: .valueChanged)
        self.femaleCheckBox.addTarget(self, action: #selector(didChangeFemaleCheckBox(_:)), for: .valueChanged)
    }
    
    func localized() {
    }
    
    func setupData() {
        guard let cv                   = self.userProfile.cv else { return }
        self.skillsTextView.text       = cv.skills
        self.residenceLabel.text       = cv.resident
        self.nationalityLabel.text     = cv.nationality
        self.languagesTextField.text   = cv.languages
        self.maleCheckBox.isChecked    = cv._gender == "Male"
        self.femaleCheckBox.isChecked  = cv._gender == "Female"
        self.emailTextField.text       = cv.email
        self.websiteTextField.text     = cv.website
        self.IMTextField.text          = cv.im
        self.twitterTextField.text     = cv.twitter
        self.facebookTextField.text    = cv.facebook
    }
    
    func fetchData() {
    }
}

// MARK: - Action

extension EditSkillsCvViewController {
    
    @IBAction func backAction(_ sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doneAction(_ sender : UIButton) {
        
        guard var cv = self.userProfile.cv else {
            print("no cv")
            return
        }
        
        guard let email = self.emailTextField.text,
              let website = self.websiteTextField.text else {
            return
        }
        
        guard email.isEmpty || isValidEmail(email) else {
            self.showErrorMessage("Please enter valid email")
            return
        }
        
        guard website.isEmpty || isValidURL(website) else {
            self.showErrorMessage("Please enter valid website")
            return
        }
        
        cv.skills       = self.skillsTextView.text
        cv.resident     = self.residenceLabel.text
        cv.nationality  = self.nationalityLabel.text
        cv.languages    = self.languagesTextField.text
        cv.gender       = self.selectedGender.rawValue
        cv.email        = email
        cv.website      = website
        cv.im           = self.IMTextField.text
        cv.twitter      = self.twitterTextField.text
        cv.facebook     = self.facebookTextField.text
        
        self.requestProxy.requestService()?.addUpdateCV(cv: cv, { response in
            guard let resp = response else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                self.showSuccessMessage(resp._message)
            }
        })
    }
    
    @IBAction func selecrResidenceAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(SelectDataViewController.self)
        vc.onSelect = { [weak self] (selectedString) in
            guard let self = self else { return }
            self.residenceLabel.text = selectedString
        }
        vc.list = Constant.residency
        self.present(vc, animated: true)
        
    }
    
    @IBAction func selectNationalityAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(SelectDataViewController.self)
        vc.onSelect = { [weak self] (selectedString) in
            guard let self = self else { return }
            self.nationalityLabel.text = selectedString
            
        }
        vc.list = Constant.nationality
        self.present(vc, animated: true)
    }
}

// MARK: - REQUESTS DELEGATE

extension EditSkillsCvViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .addUpdateCV {
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

// MARK: - CUSTOM FUNCTIONS...

extension EditSkillsCvViewController {
    
    @objc
    private func didChangeMaleCheckBox(_ checkBox: CheckBox) {
        self.femaleCheckBox.isChecked = !checkBox.isChecked
        self.selectedGender = .male
    }
    
    @objc
    private func didChangeFemaleCheckBox(_ checkBox: CheckBox) {
        self.maleCheckBox.isChecked = !checkBox.isChecked
        self.selectedGender = .female
    }
    
    func getDataFromTextField(cv : CV) -> CV{
        if var cv = self.userProfile.cv {
            
            cv.skills       = self.skillsTextView.text
            cv.resident     = self.residenceLabel.text
            cv.nationality  = self.nationalityLabel.text
            cv.languages    = self.languagesTextField.text
            cv.gender       = self.selectedGender.rawValue
            cv.email        = self.emailTextField.text
            cv.website      = self.websiteTextField.text
            cv.im           = self.IMTextField.text
            cv.twitter      = self.twitterTextField.text
        }
        return cv
    }
}
