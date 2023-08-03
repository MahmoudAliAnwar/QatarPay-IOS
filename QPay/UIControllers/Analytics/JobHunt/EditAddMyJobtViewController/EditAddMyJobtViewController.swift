//
//  EditAddMyJobtViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 29/05/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import UIKit
import Alamofire

protocol EditAddMyJobtViewControllerDelegate: AnyObject {
    func didTapEdit(_ controller: EditAddMyJobtViewController , myJob : JobHunterList?)
}

class EditAddMyJobtViewController: ViewController {
    
    @IBOutlet weak var imageView              : ImageViewDesign!
    
    @IBOutlet weak var nameTextField          : UITextField!
    
    @IBOutlet weak var employmentTypeLabel    : UILabel!
    
    @IBOutlet weak var jobTitleLabel          : UILabel!
    
    @IBOutlet weak var industryAreaLabel      : UILabel!
    
    @IBOutlet weak var languagesTextField     : UITextField!
    
    @IBOutlet weak var yearsOfExperienceLabel : UILabel!
    
    @IBOutlet weak var skillsTextField        : UITextField!
    
    @IBOutlet weak var residenceLabel         : UILabel!
    
    @IBOutlet weak var nationalityLabel       : UILabel!
    
    @IBOutlet weak var maleCheckBox           : CheckBox!
    
    @IBOutlet weak var femaleCheckBox         : CheckBox!
    
    @IBOutlet weak var emailTextField         : UITextField!
    
    @IBOutlet weak var phoneTextField         : UITextField!
    
    @IBOutlet weak var cvFileName             : ButtonDesign!
    
    var jobData : JobHunterList?
    var type    : ViewType = .add
    var updateViewElementDelegate: UpdateViewElement?
    weak var delegate : EditAddMyJobtViewControllerDelegate?

    private var selectedGender: Gender = .male
    private let imagePicker = UIImagePickerController()
    private var imageID          : Int?
    private var fileID           : Int?
    private var imageLocationURL : String?
    private var fileLocationURL  : String?
    private var fileName         : String?
    
    private enum Gender: String {
        case male    = "Male"
        case female  = "Female"
    }
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.requestProxy.requestService()?.delegate = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}

extension EditAddMyJobtViewController {
    
    func setupView() {
        self.imagePicker.delegate = self
        
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
        switch type {
            
        case .add:
            break
            
        case .edit:
            guard let job = jobData else { return }
            self.nameTextField.text           = job._employerName
            self.employmentTypeLabel.text     = job._employType
            self.jobTitleLabel.text           = job._jobTitle
            self.industryAreaLabel.text       = job._industry
            self.languagesTextField.text      = job._language
            self.yearsOfExperienceLabel.text  = job._yearOfExperience
            self.skillsTextField.text         = job._skills
            self.residenceLabel.text          = job._resident
            self.nationalityLabel.text        = job._nationality
            self.maleCheckBox.isChecked       = job._gender == "Male"
            self.femaleCheckBox.isChecked     = job._gender == "Female"
            self.emailTextField.text          = job._email
            self.phoneTextField.text          = job._phoneNumber
            self.imageView.kf.setImage(with: URL(string: job._profilePictureURL),
                                       placeholder: UIImage.ic_avatar)
        }
    }
    
    func fetchData() {
    }
}

// MARK: - Action

extension EditAddMyJobtViewController {
    
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
    
    @IBAction func residenceAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(SelectDataViewController.self)
        vc.onSelect = {[weak self] (selectedString) in
            guard let self = self else { return }
            self.residenceLabel.text = selectedString
        }
        vc.list = Constant.residency
        self.present(vc, animated: true)
    }
    
    @IBAction func nationalityAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(SelectDataViewController.self)
        vc.onSelect = {[weak self] (selectedString) in
            guard let self = self else { return }
            self.nationalityLabel.text = selectedString
        }
        vc.list = Constant.nationality
        self.present(vc, animated: true)
    }
    
    @IBAction func cvAttachedAction(_ sender: UIButton) {
        
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["com.adobe.pdf"], in: .import)
        //Call Delegate
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        self.present(documentPicker, animated: true)
    }
    
    @IBAction func submitAction(_ sender: ButtonDesign) {
        
        guard  let name              = self.nameTextField.text,name.isNotEmpty,
               let employmentType    = self.employmentTypeLabel.text,
               let jobTitle          = self.jobTitleLabel.text,
               let industryArea      = self.industryAreaLabel.text,
               let languages         = self.languagesTextField.text,
               let yearsOfExperience = self.yearsOfExperienceLabel.text,
               let skills            = self.skillsTextField.text,
               let residence         = self.residenceLabel.text,
               let nationality       = self.nationalityLabel.text,
               let email             = self.emailTextField.text,
               let phone             = self.phoneTextField.text else {
            
            self.showErrorMessage("Enter your name")
            return
        }
        
        guard email.isEmpty || isValidEmail(email) else {
            self.showErrorMessage("Please enter valid email")
            return
        }
        
        if var job = self.jobData {
            job.employerName      = name
            job.employType        = employmentType
            job.jobTitle          = jobTitle
            job.industry          = industryArea
            job.language          = languages
            job.yearOfExperience  = yearsOfExperience
            job.skills            = skills
            job.resident          = residence
            job.nationality       = nationality
            job.gender            = self.selectedGender.rawValue
            job.email             = email
            job.phoneNumber       = phone
            job.CV_URL            = self.fileLocationURL
            job.profilePictureURL = self.imageLocationURL
            
            self.requestProxy.requestService()?.updateJobHunt(job: job, profilePicture: self.imageID, fileID: self.fileID, { response in
                guard let resp = response else {
                    return
                }
                switch resp._success {
                case true:
                    self.showSuccessMessage(resp._message)
                    self.delegate?.didTapEdit(self, myJob: job)
                     break
                    
                case false:
                    self.showErrorMessage(resp._message)
                    break
                }
            })
            
        } else {
            
            self.jobData           = JobHunterList()
            guard var data         = self.jobData else {return}
            data.employerName      = name
            data.employType        = employmentType
            data.jobTitle          = jobTitle
            data.industry          = industryArea
            data.language          = languages
            data.yearOfExperience  = yearsOfExperience
            data.skills            = skills
            data.resident          = residence
            data.nationality       = nationality
            data.gender            = self.selectedGender.rawValue
            data.email             = email
            data.phoneNumber       = phone
            data.CV_URL            = self.fileLocationURL
            
            self.requestProxy.requestService()?.addJobHunt(job: data,profilePicture: self.imageID, fileID: self.fileID, { response in
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

// MARK: - DOCUMENT PICKER DELEGATE

extension EditAddMyJobtViewController : UIDocumentPickerDelegate, UIDocumentBrowserViewControllerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        controller.dismiss(animated: true)
        
        guard let url  = urls.first else { return }
        let doc        = UIDocument(fileURL: url)
        self.fileName  = doc.fileURL.lastPathComponent
        guard let data = try? Data(contentsOf: url),
              let user = self.userProfile.getUser() else {
            return
        }
        var headers: HTTPHeaders = [:]
        let requestController = RequestsController.shared
        headers = requestController.getAuthorizationAcceptHeaders(user._access_token)
        
        DispatchQueue.global(qos: .background).async {
            AF.upload(multipartFormData: { multiPart in
                
                multiPart.append(data,
                                 withName: "file",
                                 fileName: doc.fileURL.lastPathComponent,
                                 mimeType: "file/pdf")
                
                DispatchQueue.main.async {
                    self.customUploadView.show()
                }
                
            }, to: UPLOAD_CV_FILE,
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
                            if let docID = response.imageID , let fileUrl = response.imageLocation {
                                self.fileID = docID
                                self.fileLocationURL = fileUrl
                                
                                self.showSuccessMessage("Upload successfully")
                                self.cvFileName.setTitle(self.fileName, for: .normal)
                            }
                        }else {
                            if showUserExceptions {
                                if let msg = response.message {
                                    self.showErrorMessage(msg)
                                }else {
                                    self.showErrorMessage()
                                }
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
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true)
    }
}

// MARK: - IMAGE PICKER DELEGATE

extension EditAddMyJobtViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage,
              let user = self.userProfile.getUser() else {
            return
        }
        guard let imageData = image.jpegData(compressionQuality: imagesCompressionQuality) else { return }
        
        var headers: HTTPHeaders = [:]
        let requestController = RequestsController.shared
        headers = requestController.getAuthorizationAcceptHeaders(user._access_token)
        
        DispatchQueue.global(qos: .background).async {
            
            AF.upload(multipartFormData: { multiPart in
                
                multiPart.append(imageData,
                                 withName: "ProfilePicture",
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

extension EditAddMyJobtViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .addJobHunt ||
            request == .updateJobHunt{
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
                if request == .addJobHunt ||
                    request == .updateJobHunt {
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

extension EditAddMyJobtViewController {
    
    private func closeView(_ status: Bool, data: Any?) {
        self.dismiss(animated: true)
        self.updateViewElementDelegate?.elementUpdated(fromSourceView: self, status: status, data: data)
    }
    
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
}
