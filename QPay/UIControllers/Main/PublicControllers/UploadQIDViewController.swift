//
//  UploadQIDViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/3/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit
import Alamofire
import BarcodeScanner
import DropDown

class UploadQIDViewController: ViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var actionButton: ButtonDesign!
    
    @IBOutlet weak var frontSideImageView: UIImageView!
    @IBOutlet weak var backSideImageView: UIImageView!
    
    @IBOutlet weak var fieldsViewDesign: ViewDesign!
    
    @IBOutlet weak var qidNumberTextField: UITextField!
    @IBOutlet weak var qidNumberErrorImageView: UIImageView!
    
    @IBOutlet weak var dateOfExpiryTextField: UITextField!
    @IBOutlet weak var dateOfExpiryErrorImageView: UIImageView!
    
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var dateOfBirthErrorImageView: UIImageView!
    
    @IBOutlet weak var nationalityLabel: UILabel! {
        willSet {
            newValue.textColor = .black
        }
    }
    
    @IBOutlet weak var nationalityErrorImageView: UIImageView!
    @IBOutlet weak var nationalityButton: UIButton!
    
    // MARK: - Private Properties
    
    private var nationalityDropDown: DropDown!
    private var nationalityIndexSelected: Int?
    private var countries = [Country]()
    
    private var dateOfExpiryPicker: UIDatePicker!
    private var dateOfBirthPicker: UIDatePicker!
    private let dateFormat = "dd-MM-yyyy"
    private let cardDateFormat: String = "yyyy-MM-dd'T'hh:mm:ss"
    
    private var cardSide: CardSide?
    private var cardImages = [CardSide : UIImage]()
    
    private var userCanUpdate: Bool = true {
        willSet {
            self.onUserCanUpdateChanged(to: newValue)
        }
    }
    
    private var isCompleteDateOfExpiry: Bool = false {
        willSet {
            self.showHideDateOfExpiryError(newValue)
        }
    }
    
    private var isCompleteDateOfBirth: Bool = false {
        willSet {
            self.showHideDateOfBirthError(newValue)
        }
    }
    
    private var isCompleteNationality: Bool = false {
        willSet {
            self.showHideNationalityError(newValue)
        }
    }
    
    private var isCompleteQIDNumber: Bool = false {
        willSet {
            self.showHideQIDNumberError(newValue)
        }
    }
    
    private enum CardSide: String {
        case front = "front-side"
        case back = "back-side"
    }
    
    private lazy var customUploadView: CustomUploadView = {
        let custom = CustomUploadView(self.view)
        return custom
    }()
    
    // MARK: - Life Cycle
    
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
        
        self.changeStatusBarBG()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension UploadQIDViewController {
    
    func setupView() {
        self.requestProxy.requestService()?.delegate = self
        
        self.qidNumberTextField.isEnabled = false
        self.dateOfExpiryTextField.isEnabled = false
        self.dateOfBirthTextField.isEnabled = false
        self.nationalityButton.isEnabled = false
        
        self.nationalityDropDown = DropDown()
        self.dateOfExpiryPicker = UIDatePicker()
        self.dateOfBirthPicker = UIDatePicker()
        
        self.createDateOfExpiryPicker()
        self.createDateOfBirthPicker()
        self.setupDropDownAppearance()
        self.setupNationalityDropDown()
    }
    
    func localized() {
    }
    
    func setupData() {
        guard let parentVC = self.navigationController?.getPreviousView() else { return }
        self.isQIDParent(parentVC is QIDViewController)
        
        self.setNotAvailableTextToFields()
        
        guard parentVC is PersonalInfoViewController else {
            self.isUserHasData(false)
            self.userCanUpdate = true
            return
        }
        
        self.requestProxy.requestService()?.getQIDImage { (status, qidCard) in
            guard status,
                  let qid = qidCard else {
                return
            }
            
            let isHasData = (qid._number.isNotEmpty && qid._number.lowercased() != "na") ||
                (qid._nationality.isNotEmpty && qid._nationality.lowercased() != "na") ||
                qid._dateOfBirth.isNotEmpty ||
                qid._expiryDate.isNotEmpty
            
            self.isUserHasData(isHasData)
            
            if qid._number.isNumeric {
                self.setQIDNumberToField(qid._number)
            }
            
            if qid._nationality.isNotEmpty {
                self.setNationalityTextField(qid._nationality)
            }
            
            if let dateString = qid.expiryDate,
               let date = dateString.server2StringToDate() {
                self.setDateOfExpiryTextField(date)
                self.userCanUpdate = !qid._isVerified || date.isBeforeToday
            }
            
            if let dobString = qid.dateOfBirth,
               let date = dobString.server2StringToDate() {
                self.setDateOfBirthTextField(date)
            }
            
            if let frontUrl = qid.frontSide {
                frontUrl.getImageFromURLString { (status, image) in
                    guard status else { return }
                    self.frontSideImageView.image = image
                }
            }
            
            if let backUrl = qid.backSide {
                backUrl.getImageFromURLString { (status, image) in
                    guard status else { return }
                    self.backSideImageView.image = image
                }
            }
        }
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension UploadQIDViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func frontSideAction(_ sender: UIButton) {
        guard self.userCanUpdate else { return }
        self.showQIDScanner(for: .front)
    }
    
    @IBAction func backSideAction(_ sender: UIButton) {
        guard self.userCanUpdate else { return }
        self.showQIDScanner(for: .back)
    }
    
    @IBAction func nationalityDropDownAction(_ sender: UIButton) {
        self.nationalityDropDown.show()
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        
        guard self.checkViewFieldsErrors() else {
            return
        }
        
        guard let dateOfExpiry = self.dateOfExpiryTextField.text, dateOfExpiry.isNotEmpty,
              let expiry = dateOfExpiry.formatToDate(self.dateFormat),
              let dateOfBirth = self.dateOfBirthTextField.text, dateOfBirth.isNotEmpty,
              let dob = dateOfBirth.formatToDate(self.dateFormat),
              let number = self.qidNumberTextField.text, number.isNotEmpty,
              let nationality = self.nationalityLabel.text, nationality.isNotEmpty else {
                  return
              }
        
        var qid = QID()
        qid.number = number
        qid.expiryDate = expiry.server1DateToString()
        qid.dateOfBirth = dob.server1DateToString()
        qid.countryName = nationality
        
        self.updateQIDDetails(qid)
    }
}

// MARK: - RECTANGLE VISION DELEGATE

extension UploadQIDViewController: RectangleVisionViewControllerDelegate {
    
    func didDetectImage(_ image: UIImage) {
        guard let side = self.cardSide else { return }
        self.didCaptureCardImage(image, to: side)
    }
}

// MARK: - QID SCANNER DELEGATE

//extension UploadQIDViewController: QIDCardScannerViewControllerDelegate {
//
//    func didDetectQIDText(_ cardData: [QIDCardScannerViewController.CardData : String], image: UIImage?) {
//
//        self.fieldsViewDesign.isHidden = false
//        self.setNotAvailableTextToFields()
//
//        if let expiry = cardData[.Expiry],
//           let date = expiry.formatToDate(self.cardDateFormat) {
//            self.setDateOfExpiryTextField(date)
//        }
//
//        if let dob = cardData[.DOB],
//           let date = dob.formatToDate(self.cardDateFormat) {
//            self.setDateOfBirthTextField(date)
//        }
//
//        if let nationality = cardData[.Nationality] {
//            self.setNationalityTextField(nationality)
//        }
//
//        if let number = cardData[.Number],
//           number.isNumeric {
//            self.setQIDNumberToField(number)
//            self.showSuccessMessage("ID Number scanned successfully\nyou can now upload back side of card")
//        }
//
//        guard let side = self.cardSide,
//              let img = image else {
//            return
//        }
//
//        self.didCaptureCardImage(img, to: side)
//    }
//}

// MARK: - REQUESTS DELEGATE

extension UploadQIDViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .getQIDImage ||
            request == .uploadQIDDetails {
            showLoadingView(self)
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

// MARK: - CUSTOM FUNCTIONS

extension UploadQIDViewController {
    
    private func showQIDScanner(for side: CardSide) {
        let vc = self.getStoryboardView(RectangleVisionViewController.self)
        vc.delegate = self
        self.cardSide = side
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
    }
    
    private func checkViewFieldsErrors() -> Bool {
        self.showHideDateOfExpiryError(self.isCompleteDateOfExpiry)
        self.showHideDateOfBirthError(self.isCompleteDateOfBirth)
        self.showHideNationalityError(self.isCompleteNationality)
        self.showHideQIDNumberError(self.isCompleteQIDNumber)
        
        return self.checkRequiredFields()
    }
    
    private func checkRequiredFields() -> Bool {
        return self.isCompleteDateOfExpiry &&
            self.isCompleteDateOfBirth &&
            self.isCompleteNationality &&
            self.isCompleteQIDNumber
    }
    
    private func updateQIDDetails(_ qid: QID) {
        self.requestProxy.requestService()?.uploadQIDDetails(qid, ( self.weakify { strong, object in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                if let qidVC = strong.navigationController?.getPreviousView() as? QIDViewController {
                    qidVC.setQIDNumberToField(qid._number)
                }
                
                strong.showSuccessMessage(object?.message ?? "QID Details updated successfully")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                    strong.navigationController?.popViewController(animated: true)
                }
            }
        }))
    }
    
    private func uploadQIDImages(frontImage: UIImage, backImage: UIImage) {
        
        guard let user = self.userProfile.getUser(),
              let frontImageData = frontImage.jpegData(compressionQuality: imagesCompressionQuality),
              let backImageData = backImage.jpegData(compressionQuality: imagesCompressionQuality) else {
            return
        }
        
        var headers: HTTPHeaders = [:]
        let requestController = RequestsController.shared
        headers = requestController.getAuthorizationAcceptHeaders(user._access_token)
        
        self.dispatchGroup.enter()
        DispatchQueue.global(qos: .background).async {
            
            AF.upload(multipartFormData: { multiPart in
                
                multiPart.append(frontImageData,
                                 withName: "front",
                                 fileName: "\(CardSide.front.rawValue).jpg",
                                 mimeType: "image/jpg")
                multiPart.append(backImageData,
                                 withName: "back",
                                 fileName: "\(CardSide.back.rawValue).jpg",
                                 mimeType: "image/jpg")
                
                DispatchQueue.main.async {
                    self.customUploadView.show()
                }
                
            }, to: UPLOAD_QID_IMAGE, method: .post, headers: headers).uploadProgress(queue: .main, closure: { progress in
                let value = Float(progress.fractionCompleted)
                self.customUploadView.progressValue = value
                
            }).responseObject { (response: DataResponse<UploadQIDResponse, AFError>) in
                
                DispatchQueue.main.async {
                    self.customUploadView.hide()
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                    switch response.result {
                    case .success(let qidResponse):
                        guard qidResponse.success == true else {
                            if showUserExceptions {
                                self.showErrorMessage(qidResponse.message)
                            }
                            return
                        }
                        
                        if let expiry = qidResponse._expiryDate.formatToDate(self.cardDateFormat) {
                            self.setDateOfExpiryTextField(expiry)
                        }
                        
                        if let dob = qidResponse._dob.formatToDate(self.cardDateFormat) {
                            self.setDateOfBirthTextField(dob)
                        }
                        
                        if let nationality = qidResponse._countryList.first?._name {
                            self.setNationalityTextField(nationality)
                        }
                        
                        if qidResponse._number.isNumeric {
                            self.setQIDNumberToField(qidResponse._number)
                        }
                        
                        self.isUserHasData(qidResponse._expiryDate.isNotEmpty &&
                                           qidResponse._dob.isNotEmpty &&
                                           qidResponse._countryList.isNotEmpty &&
                                           qidResponse._number.isNotEmpty)
                        
                        self.dispatchGroup.leave()
                        
                    case .failure(let err):
                        if showAlamofireErrors {
                            self.showSnackMessage(err.localizedDescription)
                        }
                    }
                }
            }
        }
        
        self.dispatchGroup.notify(queue: .main) {
        }
    }
    
    private func didCaptureCardImage(_ image: UIImage, to side: CardSide) {
        self.cardImages[side] = image
        
        switch side {
        case .back:
            self.backSideImageView.image = image
            break
        case .front:
            self.frontSideImageView.image = image
            break
        }
        
        guard let frontImage = self.cardImages[.front] else {
            self.showSnackMessage("Please, Capture the front image")
            return
        }
        guard let backImage = self.cardImages[.back] else {
            self.showSnackMessage("Please, Capture the back image")
            return
        }
        
        self.uploadQIDImages(frontImage: frontImage, backImage: backImage)
    }
    
    private func createDateOfExpiryPicker() {
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let centerSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                          target: nil,
                                          action: nil)
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done,
                                      target: self,
                                      action: #selector(self.dateOfExpiryDonePressed))
        let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel,
                                        target: self,
                                        action: #selector(self.dateCancelPressed))
        
        toolbar.setItems([cancelBtn, centerSpace,doneBtn], animated: true)
        
        self.dateOfExpiryTextField.inputAccessoryView = toolbar
        self.dateOfExpiryTextField.inputView = self.dateOfExpiryPicker
        
        self.dateOfExpiryPicker.datePickerMode = .date
    }
    
    @objc private func dateOfExpiryDonePressed() {
        self.setDateOfExpiryTextField(self.dateOfExpiryPicker.date)
    }
    
    private func setDateOfExpiryTextField(_ date: Date) {
        let formattedDate = date.formatDate(self.dateFormat)
        self.dateOfExpiryTextField.text = formattedDate
        self.dateOfExpiryPicker.date = date
        self.isCompleteDateOfExpiry = true
        self.dateCancelPressed()
    }
    
    private func createDateOfBirthPicker() {
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let centerSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                          target: nil,
                                          action: nil)
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done,
                                      target: self,
                                      action: #selector(self.dateOfBirthDonePressed))
        let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel,
                                        target: self,
                                        action: #selector(self.dateCancelPressed))
        
        toolbar.setItems([cancelBtn, centerSpace,doneBtn], animated: true)
        
        self.dateOfBirthTextField.inputAccessoryView = toolbar
        self.dateOfBirthTextField.inputView = self.dateOfBirthPicker
        
        self.dateOfBirthPicker.datePickerMode = .date
    }
    
    @objc private func dateOfBirthDonePressed() {
        self.setDateOfBirthTextField(self.dateOfBirthPicker.date)
    }
    
    private func setDateOfBirthTextField(_ date: Date) {
        let formattedDate = date.formatDate(self.dateFormat)
        self.dateOfBirthTextField.text = formattedDate
        self.dateOfBirthPicker.date = date
        self.isCompleteDateOfBirth = true
        self.dateCancelPressed()
    }
    
    @objc private func dateCancelPressed() {
        self.view.endEditing(true)
    }
    
    private func setupDropDownAppearance() {
        let appearance = DropDown.appearance()
        
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
    }
    
    private func setupNationalityDropDown() {
        
        self.nationalityDropDown.anchorView = self.nationalityButton
        
        self.nationalityDropDown.topOffset = CGPoint(x: 0, y: self.nationalityButton.bounds.height)
        self.nationalityDropDown.direction = .any
        self.nationalityDropDown.dismissMode = .automatic
        
        self.requestProxy.requestService()?.countriesList(completion: { (status, countries) in
            guard status else { return }
            
            let list = countries ?? []
            self.countries = list
            
            list.forEach { (country) in
                if let name = country.name {
                    self.nationalityDropDown.dataSource.append(name)
                }
            }
        })
        
        self.nationalityDropDown.selectionAction = { [weak self] (index, item) in
            self?.selectNationality(index, name: item)
        }
    }
    
    private func checkNationality(_ nationality: String) -> (index: Int, country: Country)? {
        for (index, country) in self.countries.enumerated() {
            if country._name.lowercased().contains(nationality.lowercased()) {
                return (index, country)
            }
        }
        return nil
    }
    
    private func setNationalityTextField(_ name: String) {
        self.isCompleteNationality = true
        self.nationalityLabel.text = name
    }
    
    private func selectNationality(_ index: Int, name: String) {
        self.nationalityDropDown.selectRow(index)
        self.nationalityLabel.text = name
        self.nationalityIndexSelected = index
        self.isCompleteNationality = true
    }
    
    private func setQIDNumberToField(_ number: String) {
        self.qidNumberTextField.text = number
        self.isCompleteQIDNumber = true
    }
    
    private func setNotAvailableTextToFields() {
        let text = "Not Available"
        
        self.qidNumberTextField.text = text
        self.nationalityLabel.text = text
        self.dateOfExpiryTextField.text = text
        self.dateOfBirthTextField.text = text
    }
    
    private func showHideDateOfExpiryError(_ isNotEmpty: Bool) {
        self.dateOfExpiryErrorImageView.image = isNotEmpty ? .none : .errorCircle
    }
    
    private func showHideDateOfBirthError(_ isNotEmpty: Bool) {
        self.dateOfBirthErrorImageView.image = isNotEmpty ? .none : .errorCircle
    }
    
    private func showHideNationalityError(_ isNotEmpty: Bool) {
        self.nationalityErrorImageView.image = isNotEmpty ? .none : .errorCircle
    }
    
    private func showHideQIDNumberError(_ isNotEmpty: Bool) {
        self.qidNumberErrorImageView.image = isNotEmpty ? .none : .errorCircle
    }
    
    private func isQIDParent(_ status: Bool) {
        self.titleLabel.text = status ? "Upload Qatar ID" : "Qatar ID"
        self.actionButton.setTitle(status ? "SAVE" : "Update QID", for: .normal)
    }
    
    private func isUserHasData(_ status: Bool) {
        self.fieldsViewDesign.isHidden = !status
    }
    
    private func onUserCanUpdateChanged(to canUpdate: Bool) {
        self.actionButton.isEnabled = canUpdate
        self.actionButton.backgroundColor = canUpdate ? .mLight_Red : .mLight_Gray
        self.actionButton.shadowColor = canUpdate ? .mDark_Red : .mDark_Gray
    }
}
