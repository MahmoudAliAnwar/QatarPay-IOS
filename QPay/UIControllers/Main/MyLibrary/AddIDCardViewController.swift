//
//  AddIDCardViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 10/18/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit
import DropDown
import Alamofire

class AddIDCardViewController: MainController {
    
    @IBOutlet weak var viewTypeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var containerViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var deleteImageView: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    
    /// Identification Outlets
    @IBOutlet weak var identificationStackView: UIStackView!
    @IBOutlet weak var identificationCheckBox: CheckBox!
    @IBOutlet weak var identificationSelectionButton: UIButton!
    
    @IBOutlet weak var idNumberTextField: UITextField!
    @IBOutlet weak var idNumberErrorImageView: UIImageView!
    
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var dateOfBirthErrorImageView: UIImageView!
    
    @IBOutlet weak var placeOfIssueTextField: UITextField!
    @IBOutlet weak var placeOfIssueErrorImageView: UIImageView!
    
    @IBOutlet weak var dateOfIssueTextField: UITextField!
    @IBOutlet weak var dateOfIssueErrorImageView: UIImageView!
    
    @IBOutlet weak var dateOfExpiryTextField: UITextField!
    @IBOutlet weak var dateOfExpiryErrorImageView: UIImageView!
    
    /// Driving License Outlets
    @IBOutlet weak var licenseStackView: UIStackView!
    @IBOutlet weak var licenseNumberStackView: UIStackView!
    @IBOutlet weak var licenseCheckBox: CheckBox!
    @IBOutlet weak var licenseSelectionButton: UIButton!
    
    @IBOutlet weak var licenseNumberTextField: UITextField!
    @IBOutlet weak var licenseNumberErrorImageView: UIImageView!
    
    @IBOutlet weak var licenseDateOfBirthTextField: UITextField!
    @IBOutlet weak var licenseDateOfBirthErrorImageView: UIImageView!
    
    @IBOutlet weak var bloodGroupLabel: UILabel!
    @IBOutlet weak var bloodGroupErrorImageView: UIImageView!
    @IBOutlet weak var bloodGroupButton: UIButton!
    
    @IBOutlet weak var firstIssueTextField: UITextField!
    @IBOutlet weak var firstIssueErrorImageView: UIImageView!
    
    @IBOutlet weak var validityTextField: UITextField!
    @IBOutlet weak var validityErrorImageView: UIImageView!
    
    /// Combined Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameErrorImageView: UIImageView!

    @IBOutlet weak var nationalityLabel: UILabel!
    @IBOutlet weak var nationalityErrorImageView: UIImageView!
    @IBOutlet weak var nationalityButton: UIButton!

    @IBOutlet weak var reminderExpiryLabel: UILabel!
    @IBOutlet weak var reminderExpiryButton: UIButton!
    
    var viewType: String?
    
    var idCard: IDCard?
    var drivingLicense: DrivingLicense?
    
    /// Private Variables
    private var reminderDropDown = DropDown()
    private var nationalityDropDown = DropDown()
    private var bloodGroupDropDown = DropDown()
    
    private var imagePicker = UIImagePickerController()
    
    private var datePicker = UIDatePicker()
    
    private var idTypeSelected: IDType = .Identification
    
    private enum IDType {
        case Identification, License
    }
    
    private enum BloodGroup: String, CaseIterable {
        case A, B, AB, O
    }
    
    private var expiryReminderSelected: ExpiryReminder = .Before1Month
    private var nationalitySelected: String?
    private var bloodGroupSelected: BloodGroup?
    private var frontImageID: Int?
    private var backImageID: Int?
    
    private var isFrontImageUploaded: Bool = false
    
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

extension AddIDCardViewController {
    
    func setupView() {
        
        self.setupDropDownAppearance()
        self.setupReminderDropDown()
        self.setupNationalityDropDown()
        self.setupBloodGroupDropDown()
        
        if #available(iOS 13.4, *) {
            self.datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        
        self.createDateOfBirthPicker()
        self.createDateOfIssuePicker()
        self.createDateOfExpiryPicker()
        
        self.createLicenseDateOfBirthPicker()
        self.createLicenseFirstIssuePicker()
        self.createLicenseValidityPicker()
        
        self.setupIdentificationCheckBox()
        self.setupLicenseCheckBox()
        
        self.imagePicker.delegate = self
    }
    
    func localized() {
    }
    
    func setupData() {
        
        if let type = self.viewType {
            self.viewTypeLabel.text = type
        }
        
        self.setIsUpdateView(self.idCard != nil || self.drivingLicense != nil)
        
        if let card = self.idCard {
            self.setViewCardTypeTo(.Identification)
            self.setUpdateView(to: .Identification)
            self.frontImageID = 0
            self.backImageID = 0
            
            self.nameTextField.text = card.name ?? ""
            self.idNumberTextField.text = card.number ?? ""
            self.placeOfIssueTextField.text = card.placeOfIssue ?? ""
            
            if !self.nationalityDropDown.dataSource.isEmpty,
               let nationality = card.nationality {
                self.selectLoyaltyNationality(nationality)
            }
            
            if let dateOfBirth = card.dateofBirth,
               let date = dateOfBirth.server2StringToDate() {
                self.setDateOfBirthTextField(date)
            }
            
            if let dateOfIssue = card.dateofIssue,
               let date = dateOfIssue.server2StringToDate() {
                self.setDateOfIssueTextField(date)
            }
            
            if let dateOfExpiry = card.dateofExpiry,
               let date = dateOfExpiry.server2StringToDate() {
                self.setDateOfExpiryTextField(date)
            }
            
            if let reminderType = card.reminderType,
               let reminder = ExpiryReminder.getObjectByNumber(reminderType) {
                self.selectExpiryReminder(reminder)
            }
            
        }else if let license = self.drivingLicense {
            self.setViewCardTypeTo(.License)
            self.setUpdateView(to: .License)
            self.frontImageID = 0
            self.backImageID = 0
            
            self.nameTextField.text = license.name ?? ""
            self.licenseNumberTextField.text = license.number ?? ""
            
            if !self.nationalityDropDown.dataSource.isEmpty,
               let nationality = license.nationality {
                self.selectLoyaltyNationality(nationality)
            }
            
            if let dateOfBirth = license.dateofBirth,
               let date = dateOfBirth.server2StringToDate() {
                self.setLicenseDateOfBirthTextField(date)
            }
            
            if let bloodType = license.bloodType,
               let blood = BloodGroup(rawValue: bloodType) {
                self.selectBloodGroup(blood)
            }
            
            if let firstIssueDate = license.firstIssueDate,
               let date = firstIssueDate.server2StringToDate() {
                self.setLicenseFirstIssueTextField(date)
            }
            
            if let validity = license.validity,
               let date = validity.server2StringToDate() {
                self.setLicenseValidityTextField(date)
            }
            
            if let reminderType = license.reminderType,
               let reminder = ExpiryReminder.getObjectByNumber(reminderType) {
                self.selectExpiryReminder(reminder)
            }
            
        }else {
            self.setViewCardTypeTo(.Identification)
        }
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension AddIDCardViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addAnotherLanguageAction(_ sender: UIButton) {
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        
        let frontImageErrorMessage = "Please, upload front side image"
        let backImageErrorMessage = "Please, upload back side image"
        
        switch self.idTypeSelected {
        case .Identification:
            
            guard self.checkIdentificationViewFieldsErrors() else { return }
            
            guard let frontImageId = self.frontImageID else {
                self.showErrorMessage(frontImageErrorMessage)
                return
            }
            guard let backImageId = self.backImageID else {
                self.showErrorMessage(backImageErrorMessage)
                return
            }
            
            guard let name = self.nameTextField.text, name.isNotEmpty,
                  let nationality = self.nationalitySelected,
                  let idNumber = self.idNumberTextField.text, idNumber.isNotEmpty,
                  let dateOfBirth = self.dateOfBirthTextField.text, dateOfBirth.isNotEmpty,
                  let placeOfIssue = self.placeOfIssueTextField.text, placeOfIssue.isNotEmpty,
                  let dateOfIssue = self.dateOfIssueTextField.text, dateOfIssue.isNotEmpty,
                  let dateOfExpiry = self.dateOfExpiryTextField.text, dateOfExpiry.isNotEmpty else {
                return
            }
            
            var finalCard = IDCard()
            finalCard.name = name
            finalCard.nationality = nationality
            if let dob = dateOfBirth.formatToDate(libraryFieldsDateFormat) {
                finalCard.dateofBirth = dob.description
            }
            if let doi = dateOfIssue.formatToDate(libraryFieldsDateFormat) {
                finalCard.dateofIssue = doi.description
            }
            if let doe = dateOfExpiry.formatToDate(libraryFieldsDateFormat) {
                finalCard.dateofExpiry = doe.description
            }
            finalCard.placeOfIssue = placeOfIssue
            finalCard.number = idNumber
            finalCard.reminderType = self.expiryReminderSelected.serverType
            
            if let card = self.idCard {
                guard let id = card.id else { return }
                self.requestProxy.requestService()?.updateIDCard(id: id, card: finalCard, frontSideImageID: frontImageId, backSideImageID: backImageId) { (status, card) in
                    guard status else { return }
                }
                
            }else {
                self.requestProxy.requestService()?.addIDCard(finalCard, frontSideImageID: frontImageId, backSideImageID: backImageId) { (status, card) in
                    guard status else { return }
                }
            }
            
        case .License:
            
            guard self.checkLicenseViewFieldsErrors() else { return }
            guard let frontImageId = self.frontImageID else {
                self.showErrorMessage(frontImageErrorMessage)
                return
            }
            guard let backImageId = self.backImageID else {
                self.showErrorMessage(backImageErrorMessage)
                
                return
            }
            guard let name = self.nameTextField.text, name.isNotEmpty,
                  let number = self.licenseNumberTextField.text, number.isNotEmpty,
                  let nationality = self.nationalitySelected,
                  let blood = self.bloodGroupSelected,
                  let firstIssue = self.firstIssueTextField.text, firstIssue.isNotEmpty,
                  let validity = self.validityTextField.text, validity.isNotEmpty,
                  let dateOfBirth = self.licenseDateOfBirthTextField.text, dateOfBirth.isNotEmpty else {
                return
            }
            
            var finalLicense = DrivingLicense()
            finalLicense.name = name
            finalLicense.nationality = nationality
            finalLicense.bloodType = blood.rawValue
            if let fIssue = firstIssue.formatToDate(libraryFieldsDateFormat) {
                finalLicense.firstIssueDate = fIssue.description
            }
            if let dob = dateOfBirth.formatToDate(libraryFieldsDateFormat) {
                finalLicense.dateofBirth = dob.description
            }
            if let valid = validity.formatToDate(libraryFieldsDateFormat) {
                finalLicense.validity = valid.description
            }
            finalLicense.number = number
            finalLicense.reminderType = self.expiryReminderSelected.serverType
            
            if let license = self.drivingLicense {
                guard let id = license.id else { return }
                self.requestProxy.requestService()?.updateDrivingLicense(id, license: finalLicense, frontSideImageID: frontImageId, backSideImageID: backImageId) { (status, license) in
                    guard status else { return }
                }
            }else {
                self.requestProxy.requestService()?.addDrivingLicense(finalLicense, frontSideImageID: frontImageId, backSideImageID: backImageId) { (status, license) in
                    guard status else { return }
                }
            }
        }
    }
    
    @IBAction func deleteAction(_ sender: UIButton) {
        
        switch self.idTypeSelected {
        case .Identification:
            guard let identification = self.idCard,
                  let id = identification.id else {
                return
            }
            self.showConfirmation(message: "you want to delete your id ?") {
                self.requestProxy.requestService()?.deleteIDCard(id: id) { (status, idCards) in
                    guard status else { return }
                }
            }
            break
            
        case .License:
            guard let license = self.drivingLicense,
                  let id = license.id else {
                return
            }
            self.showConfirmation(message: "you want to delete your driving license ?") {
                self.requestProxy.requestService()?.deleteDrivingLicense(id: id) { (status, licenses) in
                    guard status else { return }
                }
            }
            break
        }
    }
    
    @IBAction func reminderDropDownAction(_ sender: UIButton) {
        self.reminderDropDown.show()
    }
    
    @IBAction func nationalityDropDownAction(_ sender: UIButton) {
        self.nationalityDropDown.show()
    }
    
    @IBAction func bloodGroupDropDownAction(_ sender: UIButton) {
        self.bloodGroupDropDown.show()
    }
    
    @IBAction func identificationAction(_ sender: UIButton) {
        self.setViewCardTypeTo(.Identification)
    }
    
    @IBAction func drivingAction(_ sender: UIButton) {
        self.setViewCardTypeTo(.License)
    }
    
    @IBAction func takePhotoAction(_ sender: UIButton) {
        
        self.imagePicker.sourceType = .camera
        self.imagePicker.allowsEditing = false
        self.imagePicker.showsCameraControls = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func galleryAction(_ sender: UIButton) {
        
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
}

// MARK: - REQUESTS DELEGATE

extension AddIDCardViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .addIDCard || request == .addDrivingLicense ||
            request == .updateIDCard || request == .updateDrivingLicense ||
            request == .deleteIDCard || request == .deleteDrivingLicense {
            showLoadingView(self)
        }
    }
    
    func requestFinished(request: RequestType, result: ResponseResult) {
        hideLoadingView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
            switch result {
            case .Success(let data):
                guard let response = data as? IDLicenses else { return }
                self.showSuccessMessage(response.message ?? "")
                
                if request == .addIDCard || request == .updateIDCard || request == .deleteIDCard
                    || request == .addDrivingLicense || request == .updateDrivingLicense || request == .deleteDrivingLicense {
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

extension AddIDCardViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage,
              let user = self.userProfile.getUser() else {
            return
        }
        guard let imageData = image.jpegData(compressionQuality: imagesCompressionQuality) else { return }
        
        // print out the image size as a test
//        print(image.size)
        
        var headers: HTTPHeaders = [:]
        let requestController = RequestsController.shared
        headers = requestController.getAuthorizationAcceptHeaders(user._access_token)
        
        self.customUploadView.show()
        
        DispatchQueue.global(qos: .background).async {
            AF.upload(multipartFormData: { multiPart in
                
                multiPart.append(imageData,
                                 withName: "file",
                                 fileName: "ID/License.jpg",
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
                    
                    if self.isFrontImageUploaded {
                        self.backImageID = id
                        self.showSuccessMessage("Back side image Uploaded Successfully")
                    } else {
                        self.frontImageID = id
                        self.isFrontImageUploaded = !self.isFrontImageUploaded
                        self.showSuccessMessage("Front side image Uploaded Successfully\nplease upload back side image")
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

extension AddIDCardViewController {
    
    private func checkIdentificationViewFieldsErrors() -> Bool {
        
        let isNationalityNotEmpty = self.nationalitySelected != nil
        self.showHideNationalityError(isNationalityNotEmpty)
        
        let isIdNumberNotEmpty = self.idNumberTextField.text!.isNotEmpty
        self.showHideIdNumberError(isIdNumberNotEmpty)
        
        let isDateOfBirthNotEmpty = self.dateOfBirthTextField.text!.isNotEmpty
        self.showHideDateOfBirthError(isDateOfBirthNotEmpty)
        
        let isPlaceOfIssueNotEmpty = self.placeOfIssueTextField.text!.isNotEmpty
        self.showHidePlaceOfIssueError(isPlaceOfIssueNotEmpty)
        
        let isDateOfIssueNotEmpty = self.dateOfIssueTextField.text!.isNotEmpty
        self.showHideDateOfIssueError(isDateOfIssueNotEmpty)
        
        let isDateOfExpiryNotEmpty = self.dateOfExpiryTextField.text!.isNotEmpty
        self.showHideDateOfExpiryError(isDateOfExpiryNotEmpty)
        
        return self.isNameNotEmpty() && isNationalityNotEmpty && isIdNumberNotEmpty && isDateOfBirthNotEmpty && isPlaceOfIssueNotEmpty && isDateOfIssueNotEmpty && isDateOfExpiryNotEmpty
    }
    
    private func checkLicenseViewFieldsErrors() -> Bool {
        
        let isLicenseNumberNotEmpty = self.licenseNumberTextField.text!.isNotEmpty
        self.showHideLicenseNumberError(isLicenseNumberNotEmpty)
        
        let isNationalityNotEmpty = self.nationalitySelected != nil
        self.showHideNationalityError(isNationalityNotEmpty)
        
        let isLicenseDateOfBirthNotEmpty = self.licenseDateOfBirthTextField.text!.isNotEmpty
        self.showHideLicenseDateOfBirthError(isLicenseDateOfBirthNotEmpty)
        
        let isBloodGroupNotEmpty = self.bloodGroupSelected != nil
        self.showHideBloodGroupError(isBloodGroupNotEmpty)
        
        let isFirstIssueNotEmpty = self.firstIssueTextField.text!.isNotEmpty
        self.showHideFirstIssueError(isFirstIssueNotEmpty)
        
        let isValidityNotEmpty = self.validityTextField.text!.isNotEmpty
        self.showHideValidityError(isValidityNotEmpty)
        
        return self.isNameNotEmpty() && isLicenseNumberNotEmpty && isNationalityNotEmpty && isLicenseDateOfBirthNotEmpty && isBloodGroupNotEmpty && isFirstIssueNotEmpty && isValidityNotEmpty
    }
    
    private func isNameNotEmpty() -> Bool {
        let isNameNotEmpty = self.nameTextField.text!.isNotEmpty
        self.showHideNameError(isNameNotEmpty)
        
        return isNameNotEmpty
    }
    
    /// Identification Errors
    private func showHideNameError(_ isNotEmpty: Bool) {
        self.nameErrorImageView.image = isNotEmpty ? .none : .errorCircle
    }
    
    
    private func showHideIdNumberError(_ isNotEmpty: Bool) {
        self.idNumberErrorImageView.image = isNotEmpty ? .none : .errorCircle
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
    
    /// License Errors
    private func showHideLicenseNumberError(_ isNotEmpty: Bool) {
        self.licenseNumberErrorImageView.image = isNotEmpty ? .none : .errorCircle
    }
    
    private func showHideNationalityError(_ isNotEmpty: Bool) {
        self.nationalityErrorImageView.image = isNotEmpty ? .none : .errorCircle
    }
    
    private func showHideLicenseDateOfBirthError(_ isNotEmpty: Bool) {
        self.licenseDateOfBirthErrorImageView.image = isNotEmpty ? .none : .errorCircle
    }
    
    private func showHideBloodGroupError(_ isNotEmpty: Bool) {
        self.bloodGroupErrorImageView.image = isNotEmpty ? .none : .errorCircle
    }
    
    private func showHideFirstIssueError(_ isNotEmpty: Bool) {
        self.firstIssueErrorImageView.image = isNotEmpty ? .none : .errorCircle
    }
    
    private func showHideValidityError(_ isNotEmpty: Bool) {
        self.validityErrorImageView.image = isNotEmpty ? .none : .errorCircle
    }
    
    @objc private func onIdentificationBoxValueChange(_ sender: CheckBox) {
        self.setViewCardTypeTo(.Identification)
    }
    
    @objc private func onDrivingBoxValueChange(_ sender: CheckBox) {
        self.setViewCardTypeTo(.License)
    }
    
    private func setViewCardTypeTo(_ type: IDType) {
        
        self.setRadioButton(type)
        self.nameErrorImageView.image = .none
        self.nationalityErrorImageView.image = .none
        
        self.idTypeSelected = type

        UIView.animate(withDuration: 0.3) {
            self.identificationStackView.isHidden = type == .License
            self.licenseStackView.isHidden = type == .Identification
        }
    }
    
    private func setRadioButton(_ type: IDType) {
        self.identificationCheckBox.isChecked = type == .Identification
        self.licenseCheckBox.isChecked = type == .License
    }
    
    private func setUpdateView(to type: IDType) {
        
        self.identificationCheckBox.isEnabled = type == .Identification
        self.licenseCheckBox.isEnabled = type == .License
        
        self.identificationSelectionButton.isEnabled = type == .Identification
        self.licenseSelectionButton.isEnabled = type == .License
        
        self.identificationSelectionButton.setTitleColor(type == .Identification ? .black : .mLight_Gray, for: .normal)
        self.licenseSelectionButton.setTitleColor(type == .License ? .black : .mLight_Gray, for: .normal)
    }
    
    /// Identification Date Pickers ...
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
    
    /// License Date Pickers ...
    private func createLicenseDateOfBirthPicker() {
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let centerSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.licenseDateOfBirthDonePressed))
        let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.dateCancelPressed))
        
        toolbar.setItems([cancelBtn, centerSpace,doneBtn], animated: true)

        self.licenseDateOfBirthTextField.inputAccessoryView = toolbar
        self.licenseDateOfBirthTextField.inputView = self.datePicker
        
        self.datePicker.datePickerMode = .date
    }
    
    @objc private func licenseDateOfBirthDonePressed() {
        
        self.setLicenseDateOfBirthTextField(self.datePicker.date)
    }
    
    private func setLicenseDateOfBirthTextField(_ date: Date) {
        
        let formattedDate = date.formatDate(libraryFieldsDateFormat)
        self.licenseDateOfBirthTextField.text = formattedDate
        self.showHideLicenseDateOfBirthError(self.licenseDateOfBirthTextField.text!.isNotEmpty)
        self.dateCancelPressed()
    }
    
    private func createLicenseFirstIssuePicker() {
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let centerSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.licenseFirstIssueDonePressed))
        let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.dateCancelPressed))
        
        toolbar.setItems([cancelBtn, centerSpace,doneBtn], animated: true)

        self.firstIssueTextField.inputAccessoryView = toolbar
        self.firstIssueTextField.inputView = self.datePicker
        
        self.datePicker.datePickerMode = .date
    }
    
    @objc private func licenseFirstIssueDonePressed() {
        
        self.setLicenseFirstIssueTextField(self.datePicker.date)
    }
    
    private func setLicenseFirstIssueTextField(_ date: Date) {
        
        let formattedDate = date.formatDate(libraryFieldsDateFormat)
        self.firstIssueTextField.text = formattedDate
        self.showHideFirstIssueError(self.firstIssueTextField.text!.isNotEmpty)
        self.dateCancelPressed()
    }
    
    private func createLicenseValidityPicker() {
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let centerSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.licenseValidityDonePressed))
        let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.dateCancelPressed))
        
        toolbar.setItems([cancelBtn, centerSpace,doneBtn], animated: true)

        self.validityTextField.inputAccessoryView = toolbar
        self.validityTextField.inputView = self.datePicker
        
        self.datePicker.datePickerMode = .date
    }
    
    @objc private func licenseValidityDonePressed() {
        
        self.setLicenseValidityTextField(self.datePicker.date)
    }
    
    private func setLicenseValidityTextField(_ date: Date) {
        
        let formattedDate = date.formatDate(libraryFieldsDateFormat)
        self.validityTextField.text = formattedDate
        self.showHideValidityError(self.validityTextField.text!.isNotEmpty)
        self.dateCancelPressed()
    }
    
    @objc private func dateCancelPressed() {
        self.view.endEditing(true)
    }
    
    private func setupIdentificationCheckBox() {
        
        self.identificationCheckBox.style = .circle
        self.identificationCheckBox.borderStyle = .rounded
        self.identificationCheckBox.borderWidth = 1
        self.identificationCheckBox.addTarget(self, action: #selector(self.onIdentificationBoxValueChange(_:)), for: .valueChanged)
    }
    
    private func setupLicenseCheckBox() {
        
        self.licenseCheckBox.style = .circle
        self.licenseCheckBox.borderStyle = .rounded
        self.licenseCheckBox.borderWidth = 1
        self.licenseCheckBox.addTarget(self, action: #selector(self.onDrivingBoxValueChange(_:)), for: .valueChanged)
    }
    
    private func setupDropDownAppearance() {
        
        let appearance = DropDown.appearance()
        appearance.cellHeight = 36
        appearance.backgroundColor = UIColor(white: 1, alpha: 1)
        appearance.selectionBackgroundColor = UIColor(red: 0.6494, green: 0.8155, blue: 1.0, alpha: 0.2)
        appearance.separatorColor = UIColor(white: 0.7, alpha: 0.8)
        appearance.cornerRadius = 10
        appearance.shadowColor = UIColor(white: 0.6, alpha: 1)
        appearance.shadowOpacity = 0.8
        appearance.shadowRadius = 25
        appearance.animationduration = 0.25
        appearance.textColor = appBackgroundColor
    }
    
    private func setupNationalityDropDown() {
        
        self.nationalityDropDown.anchorView = self.nationalityButton
        
        self.nationalityDropDown.topOffset = CGPoint(x: 0, y: self.nationalityButton.bounds.height)
        self.nationalityDropDown.direction = .any
        self.nationalityDropDown.dismissMode = .automatic
        
        self.dispatchGroup.enter()
        self.requestProxy.requestService()?.countriesList { (status, countryList) in
            if status {
                let countries = countryList ?? []
                
                for country in countries {
                    if let name = country.name {
                        self.nationalityDropDown.dataSource.append(name)
                    }
                }
                self.dispatchGroup.leave()
            }
        }
        
        self.dispatchGroup.notify(queue: .main) {
            if let license = self.drivingLicense, let nationality = license.nationality {
                self.selectLoyaltyNationality(nationality)
            }else if let card = self.idCard, let nationality = card.nationality {
                self.selectLoyaltyNationality(nationality)
            }
        }
        
        self.nationalityDropDown.selectionAction = { [weak self] (index, item) in
            self?.selectLoyaltyNationality(item)
        }
    }
    
    private func selectLoyaltyNationality(_ nationality: String) {
        
        for (index, value) in self.nationalityDropDown.dataSource.enumerated() {
            if nationality == value {
                self.nationalityDropDown.selectRow(index)
                self.nationalityLabel.text = value
                self.nationalitySelected = value
                self.nationalityErrorImageView.image = .none
                break
            }
        }
    }
    
    private func setupBloodGroupDropDown() {
        
        self.bloodGroupDropDown.anchorView = self.bloodGroupButton
        
        self.bloodGroupDropDown.topOffset = CGPoint(x: 0, y: self.bloodGroupButton.bounds.height)
        self.bloodGroupDropDown.direction = .any
        self.bloodGroupDropDown.dismissMode = .automatic
        
        for group in BloodGroup.allCases {
            self.bloodGroupDropDown.dataSource.append(group.rawValue)
        }
        
        self.bloodGroupDropDown.selectionAction = { [weak self] (index, item) in
            self?.bloodGroupLabel.text = item
            
            let selectedGroup = BloodGroup(rawValue: item)
            if let group = selectedGroup {
                self?.bloodGroupSelected = group
                self?.bloodGroupErrorImageView.image = .none
            }
        }
    }
    
    private func selectBloodGroup(_ blood: BloodGroup) {
        
        for (index, value) in BloodGroup.allCases.enumerated() {
            if blood == value {
                self.bloodGroupDropDown.selectRow(index)
                self.bloodGroupLabel.text = value.rawValue
                self.bloodGroupSelected = value
                break
            }
        }
    }
    
    private func setupReminderDropDown() {
        
        self.reminderDropDown.anchorView = self.reminderExpiryButton
        
        self.reminderDropDown.topOffset = CGPoint(x: 0, y: self.reminderExpiryButton.bounds.height)
        self.reminderDropDown.direction = .any
        self.reminderDropDown.dismissMode = .automatic
        
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
