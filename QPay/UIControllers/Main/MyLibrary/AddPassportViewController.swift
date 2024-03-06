//
//  AddPassportViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 10/18/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit
import DropDown
import Alamofire

class AddPassportViewController: MainController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var viewTypeLabel: UILabel!
    
    @IBOutlet weak var deleteImageView: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var passportNumberTextField: UITextField!
    @IBOutlet weak var passportNumberErrorImageView: UIImageView!
    
    @IBOutlet weak var passportTypeTextField: UITextField!
    @IBOutlet weak var passportTypeErrorImageView: UIImageView!
    
    @IBOutlet weak var codeOfIssuingStateTextField: UITextField!
    @IBOutlet weak var codeOfIssuingStateErrorImageView: UIImageView!
    
    @IBOutlet weak var surNameTextField: UITextField!
    @IBOutlet weak var surNameErrorImageView: UIImageView!
    
    @IBOutlet weak var givenNamesTextField: UITextField!
    @IBOutlet weak var givenNamesErrorImageView: UIImageView!
    
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var dateOfBirthErrorImageView: UIImageView!
    
    @IBOutlet weak var placeOfIssueTextField: UITextField!
    @IBOutlet weak var placeOfIssueErrorImageView: UIImageView!
    
    @IBOutlet weak var dateOfIssueTextField: UITextField!
    @IBOutlet weak var dateOfIssueErrorImageView: UIImageView!
    
    @IBOutlet weak var dateOfExpiryTextField: UITextField!
    @IBOutlet weak var dateOfExpiryErrorImageView: UIImageView!
    
    @IBOutlet weak var reminderExpiryLabel: UILabel!
    @IBOutlet weak var reminderExpiryButton: UIButton!
    
    var viewType: String?
    var passport: Passport?
    
    private var reminderDropDown = DropDown()
    private var imagePicker = UIImagePickerController()
    
    private var datePicker = UIDatePicker()
    
    private var expiryReminderSelected: ExpiryReminder = .Before1Month
    private var imageID: Int?
    
    private lazy var customUploadView: CustomUploadView = {
        let custom = CustomUploadView(self.view)
        return custom
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupView()
        localized()
        setupData()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.requestProxy.requestService()?.delegate = self
    }
}

extension AddPassportViewController {
    
    func setupView() {
        
        if #available(iOS 13.4, *) {
            self.datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        
        self.createDateOfBirthPicker()
        self.createDateOfIssuePicker()
        self.createDateOfExpiryPicker()

        self.setupReminderDropDown()
                
        self.imagePicker.delegate = self
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
        
        if let type = self.viewType {
            self.viewTypeLabel.text = type
        }
        
        self.setIsUpdateView(self.passport != nil)
        
        guard let passport = self.passport else { return }
        self.imageID = 0
        
        self.passportNumberTextField.text = passport._number
        self.passportTypeTextField.text = passport.type ?? ""
        self.surNameTextField.text = passport.surName ?? ""
        self.givenNamesTextField.text = passport.givenName ?? ""
        self.placeOfIssueTextField.text = passport._placeOfIssue
        
        if let dateOfBirth = passport.dateOfBirth,
           let date = dateOfBirth.server2StringToDate() {
            self.setDateOfBirthTextField(date)
        }
        
        if let dateOfIssue = passport.dateOfIssue,
           let date = dateOfIssue.server2StringToDate() {
            self.setDateOfIssueTextField(date)
        }
        
        if let dateOfExpiry = passport.dateOfExpiry,
           let date = dateOfExpiry.server2StringToDate() {
            self.setDateOfExpiryTextField(date)
        }
        
        if let passportReminder = passport.reminderType,
           let reminder = ExpiryReminder.getObjectByNumber(passportReminder) {
            self.selectExpiryReminder(reminder)
        }
    }
}

// MARK: - ACTIONS

extension AddPassportViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addAnotherLanguageAction(_ sender: UIButton) {
    }
    
    @IBAction func takePhotoAction(_ sender: UIButton) {
        self.imagePicker.sourceType = .camera
        self.imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true)
    }
    
    @IBAction func uploadPhotoAction(_ sender: UIButton) {
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true)
    }
    
    @IBAction func reminderDropDownAction(_ sender: UIButton) {
        self.reminderDropDown.show()
    }
    
    @IBAction func saveAction(_ sender: UIButton) {

        guard self.checkViewFieldsErrors() else { return }
        
        guard let imageId = self.imageID else {
            self.showErrorMessage("Please, upload passport image")
            return
        }
        
        guard let passportNumber = self.passportNumberTextField.text, passportNumber.isNotEmpty,
              let passportType = self.passportTypeTextField.text, passportType.isNotEmpty,
              let surName = self.surNameTextField.text, surName.isNotEmpty,
              let givenNames = self.givenNamesTextField.text, givenNames.isNotEmpty,
              let dateOfBirth = self.dateOfBirthTextField.text, dateOfBirth.isNotEmpty,
              let placeOfIssue = self.placeOfIssueTextField.text, placeOfIssue.isNotEmpty,
              let dateOfIssue = self.dateOfIssueTextField.text, dateOfIssue.isNotEmpty,
              let dateOfExpiry = self.dateOfExpiryTextField.text, dateOfExpiry.isNotEmpty else {
            return
        }
        
        var finalPassport = Passport()
        finalPassport.number = passportNumber
        finalPassport.type = passportType
        finalPassport.placeOfIssue = placeOfIssue
        finalPassport.surName = surName
        finalPassport.givenName = givenNames
        if let dob = dateOfBirth.formatToDate(libraryFieldsDateFormat) {
            finalPassport.dateOfBirth = dob.description
        }
        if let doi = dateOfIssue.formatToDate(libraryFieldsDateFormat) {
            finalPassport.dateOfIssue = doi.description
        }
        if let doe = dateOfExpiry.formatToDate(libraryFieldsDateFormat) {
            finalPassport.dateOfExpiry = doe.description
        }
        finalPassport.reminderType = self.expiryReminderSelected.serverType
        
        if let myPassport = self.passport {
            guard let passportID = myPassport.id else { return }
            
            self.requestProxy.requestService()?.updatePassport(passportID, passport: finalPassport, passportImageID: imageId) { (status, passports) in
                guard status else { return }
            }
            
        }else {
            self.requestProxy.requestService()?.addPassport(finalPassport, passportImageID: imageId) { (status, passports) in
                guard status else { return }
            }
        }
    }
    
    @IBAction func deleteAction(_ sender: UIButton) {
        guard let myPassport = self.passport,
              let id = myPassport.id else {
            return
        }
        self.showConfirmation(message: "you want to delete your passport ?") {
            self.requestProxy.requestService()?.deletePassport(id: id) { (status, passports) in
                guard status else { return }
            }
        }
    }
}

// MARK: - REQUESTS DELEGATE

extension AddPassportViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .addPassport ||
            request == .updatePassport ||
            request == .deletePassport {
            showLoadingView(self)
        }
    }
    
    func requestFinished(request: RequestType, result: ResponseResult) {
        hideLoadingView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
            switch result {
            case .Success(let data):
                guard let response = data as? BaseArrayResponse<Passport> else { return }
                self.showSuccessMessage(response.message ?? "")
                
                if request == .addPassport || request == .updatePassport || request == .deletePassport {
                    self.navigationController?.popViewController(animated: true)
                }
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

// MARK: - IMAGE PICKER DELEGATE

extension AddPassportViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage,
              let user = self.userProfile.getUser() else {
            return
        }
        
        guard let imageData = image.jpegData(compressionQuality: imagesCompressionQuality) else { return }
        // print out the image size as a test
//            print(image.size)
        
        // MARK: - Send Passport Image
        
        var headers: HTTPHeaders = [:]
        let requestController = RequestsController.shared
        headers = requestController.getAuthorizationAcceptHeaders(user._access_token)
        
        self.customUploadView.show()
        
        DispatchQueue.global(qos: .background).async {
            AF.upload(multipartFormData: { multiPart in
                
                multiPart.append(imageData,
                                 withName: "file",
                                 fileName: "Passport.jpg",
                                 mimeType: "image/jpg")
                
            }, to: UPLOAD_LIBRARY_IMAGE, method: .post, headers: headers).uploadProgress(queue: .main, closure: { progress in
                
                let value = Float(progress.fractionCompleted)
                self.customUploadView.progressValue = value
                
            }).responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                self.customUploadView.hide()
                
                switch response.result {
                case .success(let response):
                    guard response.success == true else {
                        if showUserExceptions {
                            self.showErrorMessage(response.message)
                        }
                        return
                    }
                    guard let id = response.imageID else { return }
                    self.imageID = id
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                        self.showSuccessMessage("Image Uploaded Successfully")
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

// MARK: - PRIVATE FUNCTIONS

extension AddPassportViewController {
    
    private func checkViewFieldsErrors() -> Bool {
        let isPassportNumberNotEmpty = self.passportTypeTextField.text!.isNotEmpty
        self.showHidePassportNumberError(isPassportNumberNotEmpty)

        let isPassportTypeNotEmpty = self.passportTypeTextField.text!.isNotEmpty
        self.showHidePassportTypeError(isPassportTypeNotEmpty)
        
        let isSurNameNotEmpty = self.surNameTextField.text!.isNotEmpty
        self.showHideSurNameError(isSurNameNotEmpty)

        let isGivenNamesNotEmpty = self.givenNamesTextField.text!.isNotEmpty
        self.showHideGivenNamesError(isGivenNamesNotEmpty)

        let isDateOfBirthNotEmpty = self.dateOfBirthTextField.text!.isNotEmpty
        self.showHideDateOfBirthError(isDateOfBirthNotEmpty)

        let isPlaceOfIssueNotEmpty = self.placeOfIssueTextField.text!.isNotEmpty
        self.showHidePlaceOfIssueError(isPlaceOfIssueNotEmpty)

        let isDateOfIssueNotEmpty = self.dateOfIssueTextField.text!.isNotEmpty
        self.showHideDateOfIssueError(isDateOfIssueNotEmpty)

        let isDateOfExpiryNotEmpty = self.dateOfExpiryTextField.text!.isNotEmpty
        self.showHideDateOfExpiryError(isDateOfExpiryNotEmpty)

        return isPassportNumberNotEmpty && isPassportTypeNotEmpty && isSurNameNotEmpty && isGivenNamesNotEmpty && isDateOfBirthNotEmpty && isPlaceOfIssueNotEmpty && isDateOfIssueNotEmpty && isDateOfExpiryNotEmpty
    }
    
    private func showHidePassportNumberError(_ isNotEmpty: Bool) {
        self.passportNumberErrorImageView.image = isNotEmpty ? .none : .errorCircle
    }
    
    private func showHidePassportTypeError(_ isNotEmpty: Bool) {
        self.passportTypeErrorImageView.image = isNotEmpty ? .none : .errorCircle
    }
    
    private func showHideCodeOfIssuingStateError(_ isNotEmpty: Bool) {
        self.codeOfIssuingStateErrorImageView.image = isNotEmpty ? .none : .errorCircle
    }
    
    private func showHideSurNameError(_ isNotEmpty: Bool) {
        self.surNameErrorImageView.image = isNotEmpty ? .none : .errorCircle
    }
    
    private func showHideGivenNamesError(_ isNotEmpty: Bool) {
        self.givenNamesErrorImageView.image = isNotEmpty ? .none : .errorCircle
    }
    
    private func showHideDateOfBirthError(_ isNotEmpty: Bool) {
        self.dateOfBirthErrorImageView.image = isNotEmpty ? .none : .errorCircle
    }
    
    private func showHidePlaceOfIssueError(_ isNotEmpty: Bool) {
        self.placeOfIssueErrorImageView.image = isNotEmpty ? .none : .errorCircle
    }
    
    private func showHideDateOfIssueError(_ isNotEmpty: Bool) {
        self.dateOfIssueErrorImageView.image = isNotEmpty ? .none : .errorCircle
    }
    
    private func showHideDateOfExpiryError(_ isNotEmpty: Bool) {
        self.dateOfExpiryErrorImageView.image = isNotEmpty ? .none : .errorCircle
    }
    
    private func createDateOfBirthPicker() {
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let centerSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dateOfBirthDonePressed))
        let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.dateCancelPressed))
        
        toolbar.setItems([cancelBtn, centerSpace,doneBtn], animated: true)

        self.dateOfBirthTextField.inputAccessoryView = toolbar
        self.dateOfBirthTextField.inputView = self.datePicker
        
        self.datePicker.datePickerMode = .date
    }
    
    @objc private func dateOfBirthDonePressed() {
        self.setDateOfBirthTextField(self.datePicker.date)
    }
    
    private func setDateOfBirthTextField(_ date: Date) {
        
        let formattedDate = date.formatDate(libraryFieldsDateFormat)
        self.dateOfBirthTextField.text = formattedDate
        self.showHideDateOfBirthError(self.dateOfBirthTextField.text!.isNotEmpty)
        self.dateCancelPressed()
    }
    
    private func createDateOfIssuePicker() {
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let centerSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dateOfIssueDonePressed))
        let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.dateCancelPressed))
        
        toolbar.setItems([cancelBtn, centerSpace,doneBtn], animated: true)

        self.dateOfIssueTextField.inputAccessoryView = toolbar
        self.dateOfIssueTextField.inputView = self.datePicker
        
        self.datePicker.datePickerMode = .date
    }
    
    @objc private func dateOfIssueDonePressed() {
        self.setDateOfIssueTextField(self.datePicker.date)
    }
    
    private func setDateOfIssueTextField(_ date: Date) {
        
        let formattedDate = date.formatDate(libraryFieldsDateFormat)
        self.dateOfIssueTextField.text = formattedDate
        self.showHideDateOfIssueError(self.dateOfIssueTextField.text!.isNotEmpty)
        self.dateCancelPressed()
    }
    
    private func createDateOfExpiryPicker() {
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let centerSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dateOfExpiryDonePressed))
        let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.dateCancelPressed))
        
        toolbar.setItems([cancelBtn, centerSpace,doneBtn], animated: true)

        self.dateOfExpiryTextField.inputAccessoryView = toolbar
        self.dateOfExpiryTextField.inputView = self.datePicker
        
        self.datePicker.datePickerMode = .date
    }
    
    @objc private func dateOfExpiryDonePressed() {
        
        self.setDateOfExpiryTextField(self.datePicker.date)
    }
    
    private func setDateOfExpiryTextField(_ date: Date) {
        
        let formattedDate = date.formatDate(libraryFieldsDateFormat)
        self.dateOfExpiryTextField.text = formattedDate
        self.showHideDateOfExpiryError(self.dateOfExpiryTextField.text!.isNotEmpty)
        self.dateCancelPressed()
    }
    
    @objc private func dateCancelPressed() {
        self.view.endEditing(true)
    }
    
    private func setupReminderDropDown() {
        
        let appearance = DropDown.appearance()
        
        self.reminderDropDown.anchorView = self.reminderExpiryButton
        
        self.reminderDropDown.topOffset = CGPoint(x: 0, y: self.reminderExpiryButton.bounds.height)
        self.reminderDropDown.direction = .any
        self.reminderDropDown.dismissMode = .automatic
        
        appearance.cellHeight = self.reminderExpiryLabel.bounds.height
        appearance.backgroundColor = UIColor(white: 1, alpha: 1)
        appearance.selectionBackgroundColor = UIColor(red: 0.6494, green: 0.8155, blue: 1.0, alpha: 0.2)
        appearance.separatorColor = UIColor(white: 0.7, alpha: 0.8)
        appearance.cornerRadius = 10
        appearance.shadowColor = UIColor(white: 0.6, alpha: 1)
        appearance.shadowOpacity = 0.8
        appearance.shadowRadius = 25
        appearance.animationduration = 0.25
        appearance.textColor = appBackgroundColor
        
        for reminder in ExpiryReminder.allCases {
            self.reminderDropDown.dataSource.append(reminder.rawValue)
        }
        
        self.selectExpiryReminder(self.expiryReminderSelected)
        
        self.reminderDropDown.selectionAction = { [weak self] (index, item) in
            
            let selectedReminder = ExpiryReminder(rawValue: item)
            if let selected = selectedReminder {
                self?.selectExpiryReminder(selected)
            }
        }
    }
    
    private func selectExpiryReminder(_ reminder: ExpiryReminder) {
        
        for (index, value) in ExpiryReminder.allCases.enumerated() {
            if reminder == value {
                self.reminderDropDown.selectRow(index)
                self.reminderExpiryLabel.text = value.rawValue
                self.expiryReminderSelected = value
                break
            }
        }
    }
    
    private func setIsUpdateView(_ status: Bool) {
        self.showHideDeleteButton(status)
        self.isUpdateTitle(status)
    }
    
    private func showHideDeleteButton(_ status: Bool) {
        self.deleteImageView.isHidden = !status
        self.deleteButton.isHidden = !status
    }
    
    private func isUpdateTitle(_ status: Bool) {
        self.titleLabel.text = status ? "Update" : "Add New Data"
    }
}
