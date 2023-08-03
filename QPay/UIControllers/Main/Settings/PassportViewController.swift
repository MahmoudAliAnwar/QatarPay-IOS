//
//  PassportViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/3/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit
import DropDown
import QKMRZScanner
import Alamofire

class PassportViewController: MainController {
    
    @IBOutlet weak var frontSideImageView: UIImageView!
    
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var passportErrorImageView: UIImageView!
    
    @IBOutlet weak var dateOfExpiryTextField: UITextField!
    @IBOutlet weak var dateOfExpiryErrorImageView: UIImageView!
    
    @IBOutlet weak var reminderExpiryLabel: UILabel!
    @IBOutlet weak var reminderExpiryButton: UIButton!
    
    @IBOutlet weak var updateButtonDesign: ButtonDesign!
    
    private var reminderDropDown = DropDown()
    private var expiryReminderSelected: ExpiryReminder = .Before1Month
    private var datePicker = UIDatePicker()
    private let dateFormat = "dd-MM-yyyy"
    
    var isCompletePassportNumber = false {
        willSet {
            self.showHidePassportNumberError(newValue)
        }
    }
    
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
        
    }
}

extension PassportViewController {
    
    func setupView() {
        self.requestProxy.requestService()?.delegate = self
        
        self.numberTextField.addTarget(self,
                                       action: #selector(self.textFieldDidChange(_:)),
                                       for: .editingChanged)
        
        self.createDateOfExpiryPicker()
        self.setupReminderDropDown()
    }
    
    func localized() {
    }
    
    func setupData() {
        guard let parentVC = self.navigationController?.getPreviousView() else { return }
        guard parentVC is PersonalInfoViewController else {
            return
        }
        
        self.requestProxy.requestService()?.getPassportDetails { (status, psssport) in
            guard status,
                  let passp = psssport else {
                return
            }
            
            self.userCanUpdate(!passp._isVerified || passp._expiryStatus)
            
            self.numberTextField.text = passp._number
            self.textFieldDidChange(self.numberTextField)
            
            if let dateString = passp.expiryDate,
               let date = dateString.server2StringToDate() {
                self.setDateOfExpiryTextField(date)
            }
            
            if let passportReminder = passp.reminderTypeID,
               let reminder = ExpiryReminder.getObjectByNumber(passportReminder.description) {
                self.selectExpiryReminder(reminder)
            }
            
            if let frontUrl = passp.frontSide {
                frontUrl.getImageFromURLString { (status, image) in
                    guard status,
                          let img = image else {
                        return
                    }
                    self.frontSideImageView.image = img
                }
            }
        }
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension PassportViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func updateAction(_ sender: UIButton) {
        
        guard let number = self.numberTextField.text, number.isNotEmpty,
              let dateString = self.dateOfExpiryTextField.text, dateString.isNotEmpty,
              let reminder = Int(self.expiryReminderSelected.serverType) else {
            return
        }
        guard let date = dateString.formatToDate(self.dateFormat) else { return }
        
        var passportDetails = PassportDetails()
        passportDetails.number = number
        passportDetails.expiryDate = date.server1DateToString()
        passportDetails.reminderTypeID = reminder
        
        self.requestProxy.requestService()?.updatePassportDetails(passportDetails) { (status, response) in
            guard status == true else { return }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                if let qidVC = self.navigationController?.getPreviousView() as? QIDViewController {
                    qidVC.setPassportNumberToField(number)
                }
                self.showSuccessMessage(response?.message ?? "Passport data saved successfully")
                DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    @IBAction func uploadAction(_ sender: UIButton) {
        self.showPassportScannerView()
    }
    
    @IBAction func reminderDropDownAction(_ sender: UIButton) {
        self.reminderDropDown.show()
    }
}

// MARK: - UPDATE PASSPORT IMAGE DELEGATE

extension PassportViewController: UpdateViewElement {
    
    func elementUpdated(fromSourceView view: UIViewController, status: Bool, data: Any?) {
        
        if view is PassportScannerViewController,
           let result = data as? QKMRZScanResult {
            
            self.numberTextField.text?.removeAll()
            self.numberTextField.text = result.documentNumber
            self.textFieldDidChange(self.numberTextField)
            
            if let expiry = result.expiryDate {
                self.setDateOfExpiryTextField(expiry)
            }
            
            self.frontSideImageView.image = result.documentImage
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                self.uploadPassportImage(result.documentImage)
            }
        }
    }
}

// MARK: - TEXT FIELD DELEGATE

extension PassportViewController: UITextFieldDelegate {
    
    @objc func textFieldDidChange(_ textField : UITextField) {
        guard let number = numberTextField.text, number.isNotEmpty else {
            self.isCompletePassportNumber = false
            return
        }
        self.isCompletePassportNumber = number.count >= 7
    }
}

// MARK: - REQUESTS DELEGATE

extension PassportViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .getPassportImage ||
            request == .updatePassportDetails {
            self.showLoadingView(self)
        }
    }
    
    func requestFinished(request: RequestType, result: ResponseResult) {
        hideLoadingView()
        
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

// MARK: - PRIVATE FUNCTIONS

extension PassportViewController {
    
    private func uploadPassportImage(_ image: UIImage) {
        
        guard let imageData = image.jpegData(compressionQuality: imagesCompressionQuality),
              let user = self.userProfile.getUser() else {
            return
        }
        
        let url = "\(UPLOAD_PASSPORT_IMAGE)"
        
        var headers: HTTPHeaders = [:]
        let requestController = RequestsController.shared
        headers = requestController.getAuthorizationAcceptHeaders(user._access_token)
        
        AF.upload(multipartFormData: { multiPart in
            
            multiPart.append(imageData,
                             withName: "file",
                             fileName: "passport.jpg",
                             mimeType: "image/jpg")
            
            DispatchQueue.main.async {
                self.customUploadView.show()
            }
            
        }, to: url, method: .post, headers: headers) .uploadProgress(queue: .main, closure: { progress in
            let value = Float(progress.fractionCompleted)
            self.customUploadView.progressValue = value
            
        }).responseObject { (response: DataResponse<BaseResponse, AFError>) in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                self.customUploadView.hide()
                
                switch response.result {
                case .success(let response):
                    if response.success == true {
                        self.showSuccessMessage(response.message ?? "Image uploaded successfully")
                    }else {
                        guard showUserExceptions else { return }
                        self.showErrorMessage(response.message)
                    }
                    
                case .failure(let err):
                    guard showAlamofireErrors else { return }
                    self.showSnackMessage(err.localizedDescription)
                }
            }
        }
    }
    
    private func showPassportScannerView() {
        let vc = self.getStoryboardView(PassportScannerViewController.self.self)
        vc.updateViewElementDelegate = self
        self.present(vc, animated: true)
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
        let formattedDate = date.formatDate(self.dateFormat)
        self.dateOfExpiryTextField.text = formattedDate
        self.datePicker.date = date
        self.showHideDateOfExpiryError(true)
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
        
        appearance.cellHeight = 40
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
    
    private func showHidePassportNumberError(_ isComplete: Bool) {
        self.dateOfExpiryErrorImageView.image = isComplete ? .none : .errorCircle
    }
    
    private func showHideDateOfExpiryError(_ isNotEmpty: Bool) {
        self.dateOfExpiryErrorImageView.image = isNotEmpty ? .none : .errorCircle
    }
    
    private func userCanUpdate(_ status: Bool) {
        self.updateButtonDesign.isEnabled = status
        self.updateButtonDesign.backgroundColor = status ? .mLight_Red : .mLight_Gray
        self.updateButtonDesign.shadowColor = status ? .mDark_Red : .mDark_Gray
    }
}
