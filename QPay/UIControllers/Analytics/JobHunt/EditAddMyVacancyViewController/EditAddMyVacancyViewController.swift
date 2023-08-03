//
//  EditAddMyVacancyViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 29/05/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import UIKit
import Alamofire

protocol EditAddMyVacancyViewControllerDelegate:AnyObject {
    func didTapEdit(_ controller : EditAddMyVacancyViewController , employer:EmployerList? )
}

class EditAddMyVacancyViewController: ViewController {
    
    @IBOutlet weak var imageView               : ImageViewDesign!
    
    @IBOutlet weak var employerNameTextField   : UITextField!
    
    @IBOutlet weak var employmentTypeLabel     : UILabel!
    
    @IBOutlet weak var jobTitleLabel           : UILabel!
    
    @IBOutlet weak var industryAreaLabel       : UILabel!
    
    @IBOutlet weak var languagesTextField      : UITextField!
    
    @IBOutlet weak var yearsOfExperienceLabel  : UILabel!
    
    @IBOutlet weak var skillsTextField         : UITextField!
    
    @IBOutlet weak var jobDescriptionTextField : UITextField!
    
    @IBOutlet weak var websiteextField         : UITextField!
    
    @IBOutlet weak var genderLabel             : UILabel!
        
    @IBOutlet weak var emailTextField          : UITextField!
    
    @IBOutlet weak var phoneTextField          : UITextField!
        
    var type     : ViewType = .add
    var employer :EmployerList?
    weak var delegate : EditAddMyVacancyViewControllerDelegate?
    var updateViewElementDelegate: UpdateViewElement?
    
    private let imagePicker = UIImagePickerController()
    
    private var imageID : Int?
    private var imageLocationURL : String?
    
    private lazy var customUploadView: CustomUploadView = {
        let custom = CustomUploadView(self.view)
        return custom
    }()
    
    enum ViewType {
        case add
        case edit
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

extension EditAddMyVacancyViewController {
    func setupView() {
        self.requestProxy.requestService()?.delegate = self
        self.imagePicker.delegate = self
     }
    
    func localized() {
    }
    
    func setupData() {
      
        switch type {
        case .add:
            break
            
        case .edit:
             guard let  data = employer else { return }
            self.employerNameTextField.text    = data._employer_name
            self.employmentTypeLabel.text      = data._employment_type
            self.jobTitleLabel.text            = data._job_title
            self.industryAreaLabel.text        = data._industry
            self.languagesTextField.text       = data._empLanguages
            self.yearsOfExperienceLabel.text   = data._yearofexperience
            self.skillsTextField.text          = data._desired_Skills
            self.jobDescriptionTextField.text  = data._job_description
            self.websiteextField.text          = data._website
            self.genderLabel.text              = data._gender
            self.emailTextField.text           = data._email
            self.phoneTextField.text           = data._phone_number
            self.imageView.kf.setImage(with: URL(string: data._logo),
                                       placeholder: UIImage.ic_avatar)
        }
    }
    
    func fetchData() {
    }
}

// MARK: - Action

extension EditAddMyVacancyViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func changeImageAction(_ sender: UIButton) {
        // TODO: CHANGE IMAGE
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] (action) in
            guard let self = self else { return }
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { [weak self] (action) in
            guard let self = self else { return }
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true)
    }
    
    @IBAction func employmentTypeAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(SelectDataViewController.self)
        vc.onSelect = {[weak self] (selectedString) in
            guard let self = self else { return }
            self.employmentTypeLabel.text = selectedString
        }
        vc.list = Constant.emptypeType
        self.present(vc, animated: true)
    }
    
    @IBAction func jobTitleAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(SelectDataViewController.self)
        vc.onSelect = {[weak self] (selectedString) in
            guard let self = self else { return }
            self.jobTitleLabel.text = selectedString
        }
        vc.list = Constant.jobTitles
        self.present(vc, animated: true)
    }
    
    @IBAction func industryAreaAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(SelectDataViewController.self)
        vc.onSelect = {[weak self] (selectedString) in
            guard let self = self else { return }
            self.industryAreaLabel.text = selectedString
        }
        vc.list = Constant.industry
        self.present(vc, animated: true)
    }
    
    @IBAction func yearsOfExperienceAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(SelectDataViewController.self)
        vc.onSelect = {[weak self] (selectedString) in
            guard let self = self else { return }
            self.yearsOfExperienceLabel.text = selectedString
        }
        vc.list = Constant.experience
        self.present(vc, animated: true)
    }
    
    @IBAction func genderAction(_ sender: UIButton) {
        let vc     = self.getStoryboardView(SelectDataViewController.self)
        vc.onSelect = {[weak self] (selectedString) in
            guard let self = self else { return }
            self.genderLabel.text = selectedString
        }
        vc.list = Constant.gender
        self.present(vc, animated: true)
    }
    
    @IBAction func submitAction(_ sender: ButtonDesign) {
    
        guard let employerName       = self.employerNameTextField.text, employerName.isNotEmpty,
              let employmentType     = self.employmentTypeLabel.text ,
              let jobTitle           = self.jobTitleLabel.text ,
              let industryArea       = self.industryAreaLabel.text,
              let languages          = self.languagesTextField.text,
              let yearsOfExperience  = self.yearsOfExperienceLabel.text,
              let skills             = self.skillsTextField.text,
              let jobDescription     = self.jobDescriptionTextField.text,
              let website            = self.websiteextField.text,
              let gender             = self.genderLabel.text,
              let email              = self.emailTextField.text,
              let phone              = self.phoneTextField.text else {
            self.showErrorMessage("Enter Company Name")
            return
        }
        
        guard email.isEmpty || isValidEmail(email) else {
            self.showErrorMessage("Please enter valid email")
            return
        }
        
        if  var employer = self.employer {
            employer.employer_name     = employerName
            employer.employment_type   = employmentType
            employer.job_title         = jobTitle
            employer.industry          = industryArea
            employer.empLanguages      = languages
            employer.yearofexperience  = yearsOfExperience
            employer.desired_Skills    = skills
            employer.job_description   = jobDescription
            employer.website           = website
            employer.gender            = gender
            employer.email             = email
            employer.phone_number      = phone
            employer.logo              = self.imageLocationURL
            self.requestProxy.requestService()?.updateEmployer(employer: employer, companyLogoID: self.imageID, { response in
                guard let resp = response else {
                    return
                }
                
                switch resp._success {
                case true:
                    self.showSuccessMessage(resp._message)
                    self.delegate?.didTapEdit(self, employer: employer)
                    break
                    
                case false:
                    self.showErrorMessage(resp._message)
                    break
                }
            })
        }else{
            self.employer         = EmployerList()
            guard var  data       = self.employer else { return }
            
            data.employer_name    = employerName
            data.employment_type  = employmentType
            data.job_title        = jobTitle
            data.industry         = industryArea
            data.empLanguages     = languages
            data.yearofexperience = yearsOfExperience
            data.desired_Skills   = skills
            data.job_description  = jobDescription
            data.website          = website
            data.gender           = gender
            data.email            = email
            data.phone_number     = phone

            self.requestProxy.requestService()?.addEmployer(employer: data,companyLogoID: self.imageID, { response in
                guard let resp = response else {
                    return
                }
                
                if resp._success {
                     self.showSuccessMessage(resp._message)
                 } else {
                     self.showErrorMessage(resp._message)
                }
            })
        }
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension EditAddMyVacancyViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage,
              let user = self.userProfile.getUser() else {
            return
        }
        guard let imageData = image.jpegData(compressionQuality: imagesCompressionQuality) else { return }
        
        // MARK: - Send Profile Image
        
        var headers: HTTPHeaders = [:]
        let requestController = RequestsController.shared
        headers = requestController.getAuthorizationAcceptHeaders(user._access_token)
        
        DispatchQueue.global(qos: .background).async {
            
            AF.upload(multipartFormData: { multiPart in
                
                multiPart.append(imageData,
                                 withName: "CompanyLogoID",
                                 fileName: "file.jpg",
                                 mimeType: "image/jpg")
                DispatchQueue.main.async {
                    self.customUploadView.show()
                }
                
            }, to: UPLOAD_CV_PROFILE_IMAGE,
                      method: .post,
                      headers: headers ) .uploadProgress(queue: .main, closure: { progress in
                let value = Float(progress.fractionCompleted)
                self.customUploadView.progressValue = value
                
            }).responseObject { (response: DataResponse<BaseResponse, AFError>) in

                DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                    self.customUploadView.hide()
                    
                    switch response.result {
                    case .success(let response):
                        if response.success == true {
                            guard let id = response.imageID else { return }
                            self.imageID = id
                            self.imageLocationURL = response.imageLocation
                            self.closeView(true, data: response.message ?? "")
                            self.imageView.image = image
                            
                        }else {
                            if showUserExceptions {
                                self.showErrorMessage(response.message)
                            }
                        }
                    case .failure(let err):
                        if showAlamofireErrors {
                            self.showSnackMessage(err.localizedDescription)
                        }
                    }
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

// MARK: - REQUESTS DELEGATE

extension EditAddMyVacancyViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .addEmployer {
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
                if request == .addEmployer  {
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

// MARK: - CUSTOM FUNCTIONS...

extension EditAddMyVacancyViewController {
    private func closeView(_ status: Bool, data: Any?) {
        self.dismiss(animated: true)
        self.updateViewElementDelegate?.elementUpdated(fromSourceView: self, status: status, data: data)
    }
}
