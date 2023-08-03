//
//  AddPaymentCardViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 10/18/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit
import Alamofire
import DropDown

class AddPaymentCardViewController: MainController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var viewTypeLabel: UILabel!
    
    @IBOutlet weak var deleteImageView: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var paymentCardStackView: UIStackView!
    @IBOutlet weak var loyaltyCardStackView: UIStackView!
    @IBOutlet weak var loyaltyCardImageOptionView: UIView!
    
    @IBOutlet weak var creditCardCheckBox: CheckBox!
    @IBOutlet weak var creditCardSelectionButton: UIButton!
    @IBOutlet weak var debitCardCheckBox: CheckBox!
    @IBOutlet weak var debitCardSelectionButton: UIButton!
    @IBOutlet weak var loyaltyCardCheckBox: CheckBox!
    @IBOutlet weak var loyaltyCardSelectionButton: UIButton!
    
    /// Credit, Debit Outlets ...
    @IBOutlet weak var cardTypeLabel: UILabel!
    @IBOutlet weak var cardTypeErrorImageView: UIImageView!
    @IBOutlet weak var cardTypeButton: UIButton!
    
    @IBOutlet weak var cardSwiftCodeTextField: UITextField!
    
    @IBOutlet weak var code1TextField: UITextField!
    @IBOutlet weak var code2TextField: UITextField!
    @IBOutlet weak var code3TextField: UITextField!
    @IBOutlet weak var code4TextField: UITextField!
    @IBOutlet weak var codeNumberContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var codeNumberErrorLabel: UILabel!
    
    @IBOutlet weak var dateMonthField: UITextField!
    @IBOutlet weak var dateYearTextField: UITextField!
    @IBOutlet weak var expiryContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var expiryErrorLabel: UILabel!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var nameErrorLabel: UILabel!
    
    @IBOutlet weak var cvvTextField: UITextField!
    @IBOutlet weak var cvvContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var cvvErrorLabel: UILabel!
    
    @IBOutlet weak var cardImageContainerStackView: UIStackView!
    @IBOutlet weak var cardImageStackView: UIStackView!
    @IBOutlet weak var cardImageView: UIImageView!
    
    /// Loyalty Outlets ...
    @IBOutlet weak var loyaltyCardNameTextField: UITextField!
    @IBOutlet weak var loyaltyCardNameErrorImageView: UIImageView!
    
    @IBOutlet weak var loyaltyNameOnCardTextField: UITextField!
    @IBOutlet weak var loyaltyNameOnCardErrorImageView: UIImageView!
    
    @IBOutlet weak var loyaltyCardBrandLabel: UILabel!
    @IBOutlet weak var loyaltyCardBrandErrorImageView: UIImageView!
    @IBOutlet weak var loyaltyCardBrandButton: UIButton!
    
    @IBOutlet weak var loyaltyCardNumberTextField: UITextField!
    @IBOutlet weak var loyaltyCardNumberErrorImageView: UIImageView!
    
    @IBOutlet weak var loyaltySwiftCodeTextField: UITextField!
    
    @IBOutlet weak var loyaltyCardValidityTextField: UITextField!
    @IBOutlet weak var loyaltyCardValidityErrorImageView: UIImageView!
    
    @IBOutlet weak var reminderExpiryLabel: UILabel!
    @IBOutlet weak var reminderExpiryButton: UIButton!
    
    var viewType: String?
    var libraryCard: LibraryCard?
    var loyaltyCard: Loyalty?
    
    private var code1Complete = false
    private var code2Complete = false
    private var code3Complete = false
    private var code4Complete = false
    
    private var monthComplete = false
    private var yearComplete = false
    
    private var viewCardTypeSelected: ViewCardType = .Credit
    private var galleryActionSelected: GalleryActions = .visa
    private var visaImageSideSelected: VisaImageSides = .front
    private var visaImages = [VisaImageSides : UIImage]()
    private var datePicker = UIDatePicker()
    private var imagePicker = UIImagePickerController()
    private var reminderDropDown = DropDown()
    private var cardTypeDropDown = DropDown()
    private var brandDropDown = DropDown()
    private var frontImageID: Int?
    //    private var cardFrontImage: UIImage?
    private var backImageID: Int?
    private var expiryReminderSelected: ExpiryReminder = .Before1Month
    private var cardTypeSelected: CardType = .Visa
    private var loyaltyBrandSelected: String?
    
    private var isFrontImageUploaded: Bool = false
    
    private lazy var customUploadView: CustomUploadView = {
        let custom = CustomUploadView(self.view)
        return custom
    }()
    
    private enum ViewCardType: String, CaseIterable {
        case Credit, Debit, Loyalty
    }
    
    private enum GalleryActions: Int, CaseIterable {
        case visa = 0
        case loyality
    }
    
    private enum VisaImageSides: Int, CaseIterable {
        case front = 0
        case back
        
        mutating func toggle() {
            switch self {
            case .front: self = .back
            case .back: self = .front
            }
        }
    }
    
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

extension AddPaymentCardViewController {
    
    func setupView() {
        self.setupCreditCardCheckBox()
        self.setupDebitCardCheckBox()
        self.setupLoyaltyCardCheckBox()
        
        self.setupDropDownAppearance()
        self.setupReminderDropDown()
        self.setupCardTypeDropDown()
        self.setupLoyaltyBrandDropDown()
        
        self.createLoyaltyValidityDatePicker()
        
        self.cardImageView.layer.cornerRadius = (self.cardImageView.height/11)
        self.imagePicker.delegate = self
        
        self.code1TextField.delegate = self
        self.code2TextField.delegate = self
        self.code3TextField.delegate = self
        self.code4TextField.delegate = self
        self.nameTextField.delegate = self
        self.cvvTextField.delegate = self
        self.dateMonthField.delegate = self
        self.dateYearTextField.delegate = self
        
        self.code1TextField.addTarget(self, action: #selector(self.code1FieldDidChange(_:)), for: .editingChanged)
        self.code2TextField.addTarget(self, action: #selector(self.code2FieldDidChange(_:)), for: .editingChanged)
        self.code3TextField.addTarget(self, action: #selector(self.code3FieldDidChange(_:)), for: .editingChanged)
        self.code4TextField.addTarget(self, action: #selector(self.code4FieldDidChange(_:)), for: .editingChanged)
        self.nameTextField.addTarget(self, action: #selector(self.nameFieldDidChange(_:)), for: .editingChanged)
        self.cvvTextField.addTarget(self, action: #selector(self.cvvFieldDidChange(_:)), for: .editingChanged)
        self.dateMonthField.addTarget(self, action: #selector(self.dateMonthFieldDidChange(_:)), for: .editingChanged)
        self.dateYearTextField.addTarget(self, action: #selector(self.dateYearFieldDidChange(_:)), for: .editingChanged)
        
        if isForDeveloping {
            self.nameTextField.text = "Test text"
            
            self.code1TextField.text = "123"
            self.code2TextField.text = "567"
            self.code3TextField.text = "909"
            self.code4TextField.text = "765"
            
            self.dateMonthField.text = "01"
            self.dateYearTextField.text = "23"
            self.cvvTextField.text = "111"
            
            self.changeStatusBarBG()
        }
    }
    
    func localized() {
    }
    
    func setupData() {
        
        if let type = self.viewType {
            self.viewTypeLabel.text = type
        }
        
        self.setIsUpdateView(self.libraryCard != nil || self.loyaltyCard != nil)
        
        if let card = self.libraryCard {
            
            if let typeString = card.paymentCardType, typeString.isNotEmpty,
               let type = PaymentCardType(rawValue: typeString) {
                switch type {
                case .Credit:
                    self.setViewCardType(to: .Credit)
                    self.setUpdateView(to: .Credit)
                case .Debit:
                    self.setViewCardType(to: .Debit)
                    self.setUpdateView(to: .Debit)
                }
            }
            
            if let typeString = card.cardType, typeString.isNotEmpty,
               let type = CardType(rawValue: typeString) {
                self.selectCardType(type)
            }
            
            if let code = card.number, code.isNotEmpty {
                let codeArr = trimCode(code)
                if codeArr.count >= 4 {
                    self.code1TextField.text = codeArr[0]
                    self.code2TextField.text = codeArr[1]
                    self.code3TextField.text = codeArr[2]
                    self.code4TextField.text = codeArr[3]
                    
                    self.code1Complete = self.code1TextField.text!.count == 4
                    self.code2Complete = self.code2TextField.text!.count == 4
                    self.code3Complete = self.code3TextField.text!.count == 4
                    self.code4Complete = self.code4TextField.text!.count == 4
                }
            }
            
            self.nameTextField.text = card._name
            self.cvvTextField.text = card._cvv
            
            if let expiry = card.expiryDate {
                let dateArr = expiry.components(separatedBy: "/")
                if dateArr.count >= 2 {
                    self.dateMonthField.text = dateArr[0]
                    self.dateYearTextField.text = dateArr[1]
                    
                    self.monthComplete = self.dateMonthField.text!.count == 2
                    self.yearComplete = self.dateYearTextField.text!.count == 2
                }
            }
            //            print(card.expiryDate ?? "") // 11/22
            //            print(card.entryTime ?? "") // 2020-11-05T19:49:35.347
            
            if let reminderString = card.reminderType,
               let reminder = ExpiryReminder.getObjectByNumber(reminderString) {
                self.selectExpiryReminder(reminder)
            }
            
            if let frontUrl = card.frontImagePath {
                frontUrl.getImageFromURLString { (status, image) in
                    guard status else { return }
                    self.setCardImageToView(image!)
                }
            }
            
        }else if let loyalty = self.loyaltyCard {
            self.setUpdateView(to: .Loyalty)
            self.setViewCardType(to: .Loyalty)
            
            self.loyaltyCardNameTextField.text = loyalty._name
            self.loyaltyNameOnCardTextField.text = loyalty._cardName
            self.loyaltyCardNumberTextField.text = loyalty._number
            
            if !self.brandDropDown.dataSource.isEmpty,
               let brand = loyalty.brand {
                self.selectLoyaltyBrand(brand)
            }
            
            if let loyValidty = loyalty.expiryDate,
               let date = loyValidty.server2StringToDate() {
                self.setLoyaltyValidityTextField(date)
            }
            
            if let loyReminder = loyalty.reminderType,
               let reminder = ExpiryReminder.getObjectByNumber(loyReminder) {
                self.selectExpiryReminder(reminder)
            }
            
        } else {
            self.setViewCardType(to: self.viewCardTypeSelected)
        }
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension AddPaymentCardViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addAnotherLanguageAction(_ sender: UIButton) {
    }
    
    @IBAction func scanCardAction(_ sender: UIButton) {
        
        guard let vc = CreditCardScannerViewController.createViewController(withDelegate: self) else {
            //            print("This device is incompatible with CardScan")
            self.showErrorMessage("This device is incompatible with CardScan")
            return
        }
        self.present(vc, animated: true)
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        
        switch self.viewCardTypeSelected {
        case .Credit, .Debit:
            if !self.isCardNumberFull() {
                self.showHideCodeNumberError()
                
            }else if !self.isDateFull() {
                self.showHideCodeNumberError(action: .hide)
                self.showHideExpiryError()
                
            }else if self.nameTextField.text!.isEmpty {
                self.showHideCodeNumberError(action: .hide)
                self.showHideExpiryError(action: .hide)
                self.showHideNameError()
                
            }else if !self.isCvvFull() {
                self.showHideCodeNumberError(action: .hide)
                self.showHideExpiryError(action: .hide)
                self.showHideNameError(action: .hide)
                self.showHideCVVError()
                
            }else {
                self.showHideCodeNumberError(action: .hide)
                self.showHideExpiryError(action: .hide)
                self.showHideNameError(action: .hide)
                self.showHideCVVError(action: .hide)
                
                //                guard let frontImage = self.cardFrontImage else {
                //                    self.showErrorMessage("Please, Scan your card to save")
                //                    return
                //                }
                
                guard let code1 = self.code1TextField.text, code1.isNotEmpty,
                      let code2 = self.code2TextField.text, code2.isNotEmpty,
                      let code3 = self.code3TextField.text, code3.isNotEmpty,
                      let code4 = self.code4TextField.text, code4.isNotEmpty,
                      let month = self.dateMonthField.text, month.isNotEmpty,
                      let year = self.dateYearTextField.text, year.isNotEmpty,
                      let name = self.nameTextField.text, name.isNotEmpty,
                      let cvv = self.cvvTextField.text, cvv.isNotEmpty else {
                    return
                }
                
                guard self.isCardDataFull() else {
                    return
                }
                
                var fullCode = ""
                fullCode += code1
                fullCode += code2
                fullCode += code3
                fullCode += code4
                
                let date = "\(month)/\(year)"
                
                var paymentType: PaymentCardType = .Credit
                switch self.viewCardTypeSelected {
                case .Credit:
                    paymentType = .Credit
                case .Debit:
                    paymentType = .Debit
                case .Loyalty:
                    break
                }
                
                var finalCard = LibraryCard()
                finalCard.name = name
                finalCard.cardType = self.cardTypeSelected.rawValue
                finalCard.number = fullCode
                finalCard.ownerName = name
                finalCard.expiryDate = date
                finalCard.cvv = cvv
                finalCard.paymentCardType = paymentType.rawValue
                finalCard.reminderType = self.expiryReminderSelected.serverType
                
                let frontImage: UIImage? = self.visaImages[.front]
                let backImage: UIImage? = self.visaImages[.back]
                
                if let card = self.libraryCard {
                    guard let id = card.id else { return }
                    
                    finalCard.id = id
                    self.uploadVisaCardData(finalCard,
                                            paymentType: paymentType,
                                            frontImage: frontImage,
                                            backImage: backImage)
                    
                } else {
                    self.uploadVisaCardData(finalCard,
                                            paymentType: paymentType,
                                            frontImage: frontImage,
                                            backImage: backImage)
                }
            }
            
        case .Loyalty:
            
            guard self.checkLoyaltyViewFieldsErrors() else { return }
            guard let frontImageId = self.frontImageID else {
                self.showErrorMessage("Please, upload front side image")
                return
            }
            guard let backImageId = self.backImageID else {
                self.showErrorMessage("Please, upload back side image")
                return
            }
            guard let cardName = self.loyaltyCardNameTextField.text, cardName.isNotEmpty,
                  let nameOnCard = self.loyaltyNameOnCardTextField.text, nameOnCard.isNotEmpty,
                  let loyBrand = self.loyaltyBrandSelected,
                  let cardNumber = self.loyaltyCardNumberTextField.text, cardNumber.isNotEmpty,
                  let cardValidity = self.loyaltyCardValidityTextField.text, cardValidity.isNotEmpty else {
                return
            }
            
            var card = Loyalty()
            card.name = cardName
            card.cardName = nameOnCard
            card.number = cardNumber
            card.brand = loyBrand
            if let validity = cardValidity.formatToDate(libraryFieldsDateFormat) {
                card.expiryDate = validity.description
            }
            card.reminderType = self.expiryReminderSelected.serverType
            
            if let loyalty = self.loyaltyCard {
                guard let id = loyalty.id else { return }
                self.requestProxy.requestService()?.updateLoyalty(id, card: card, FrontSideImageID: frontImageId, BackSideImageID: backImageId) { (status, loyalty) in
                    guard status else { return }
                }
                
            }else {
                self.requestProxy.requestService()?.addLoyalty(card, FrontSideImageID: frontImageId, BackSideImageID: backImageId) { (status, loyaltyCards) in
                    guard status else { return }
                }
            }
        }
    }
    
    @IBAction func deleteAction(_ sender: UIButton) {
        
        switch self.viewCardTypeSelected {
        case .Credit, .Debit:
            guard let card = self.libraryCard,
                  let id = card.id else {
                return
            }
            self.showConfirmation(message: "you want to delete this card ?") {
                self.requestProxy.requestService()?.deleteLibraryPaymentCard(cardID: id) { (status, response) in
                    guard status else { return }
                }
            }
            break
            
        case .Loyalty:
            guard let loyalty = self.loyaltyCard,
                  let id = loyalty.id else {
                return
            }
            self.showConfirmation(message: "you want to delete this card ?") {
                self.requestProxy.requestService()?.deleteLoyalty(id: id) { (status, loyalty) in
                    guard status else { return }
                }
            }
            break
        }
    }
    
    @IBAction func creditCardAction(_ sender: UIButton) {
        self.setViewCardType(to: .Credit)
    }
    
    @IBAction func debitCardAction(_ sender: UIButton) {
        self.setViewCardType(to: .Debit)
    }
    
    @IBAction func loyaltyCardAction(_ sender: UIButton) {
        self.setViewCardType(to: .Loyalty)
    }
    
    @IBAction func visaGalleryAction(_ sender: UIButton) {
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.allowsEditing = false
        self.galleryActionSelected = .visa
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func takeLoyalityPhotoAction(_ sender: UIButton) {
        self.imagePicker.sourceType = .camera
        self.imagePicker.allowsEditing = false
        self.imagePicker.showsCameraControls = true
        self.galleryActionSelected = .loyality
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func loyalityGalleryAction(_ sender: UIButton) {
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.allowsEditing = false
        self.galleryActionSelected = .loyality
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cardTypeDropDownAction(_ sender: UIButton) {
        self.cardTypeDropDown.show()
    }
    
    @IBAction func brandDropDownAction(_ sender: UIButton) {
        self.brandDropDown.show()
    }
    
    @IBAction func reminderDropDownAAction(_ sender: UIButton) {
        self.reminderDropDown.show()
    }
}

// MARK: - Vision Controller Delegate

extension AddPaymentCardViewController: CreditCardScannerViewControllerDelegate {
    
    func creditCardScannerViewController(_ viewController: CreditCardScannerViewController, didFinishWith card: VisionCreditCard) {
        viewController.dismiss(animated: true)
        
        self.cardImageView.image = .none
        if let img = card.image {
            self.visaImages[.front] = img
            self.setCardImageToView(img)
            self.visaImageSideSelected = .back
        }
        
        let number = card.number ?? ""
        
        self.code1TextField.text?.removeAll()
        self.code2TextField.text?.removeAll()
        self.code3TextField.text?.removeAll()
        self.code4TextField.text?.removeAll()
        
        if number.isNotEmpty, number.count >= 16 {
            
            let code = trimCode(number)
            self.code1TextField.text = code[0]
            self.code2TextField.text = code[1]
            self.code3TextField.text = code[2]
            self.code4TextField.text = code[3]
            
            self.code1FieldDidChange(self.code1TextField)
            self.code2FieldDidChange(self.code2TextField)
            self.code3FieldDidChange(self.code3TextField)
            self.code4FieldDidChange(self.code4TextField)
        }
        
        self.dateMonthField.text?.removeAll()
        if let expiryMonth = card.expireDate?.month,
           expiryMonth.description.count == 2 {
            
            self.dateMonthField.text = expiryMonth.description
            self.dateMonthFieldDidChange(self.dateMonthField)
        }
        
        self.dateYearTextField.text?.removeAll()
        if let expiryYear = card.expireDate?.year,
           expiryYear.description.count == 4 {
            
            self.dateYearTextField.text = "\(expiryYear.description.suffix(2))"
            self.dateYearFieldDidChange(self.dateYearTextField)
        }
        
        self.nameTextField.text?.removeAll()
        if let name = card.name,
           name.isNotEmpty {
            self.nameTextField.text = name
        }
    }
    
    func creditCardScannerViewController(_ viewController: CreditCardScannerViewController, didErrorWith error: CreditCardScannerError) {
        viewController.dismiss(animated: true)
        print(error.localizedDescription)
    }
}

// MARK: - REQUESTS DELEGATE

extension AddPaymentCardViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .addLoyalty ||
            request == .updateLoyalty ||
            request == .deleteLoyalty ||
            request == .deleteLibraryPaymentCard {
            showLoadingView(self)
        }
    }
    
    func requestFinished(request: RequestType, result: ResponseResult) {
        hideLoadingView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
            switch result {
            case .Success(let data):
                if let response = data as? BaseResponse {
                    self.showSuccessMessage(response.message ?? "")
                    
                    if request == .deleteLibraryPaymentCard {
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                } else if let response = data as? BaseArrayResponse<Loyalty> {
                    self.showSuccessMessage(response.message ?? "")
                    
                    if request == .addLoyalty || request == .updateLoyalty || request == .deleteLoyalty {
                        self.navigationController?.popViewController(animated: true)
                    }
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

extension AddPaymentCardViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage else { return }
        
        // print out the image size as a test
//        print(image.size)
        
        switch self.viewCardTypeSelected {
        case .Credit, .Debit:
            self.visaImages[self.visaImageSideSelected] = image
            switch self.visaImageSideSelected {
            case .front:
                self.setCardImageToView(image)
                self.showSuccessMessage("Image selected successfully, please upload back side")
            case .back:
                self.showSuccessMessage("Image selected successfully")
            }
            self.visaImageSideSelected.toggle()
            break
            
        case .Loyalty:
            self.uploadLoyaltyImage(image)
            break
        }
    }
}

// MARK: - TEXT FIELDS DELEGATE

extension AddPaymentCardViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //        if textField == accountNameTextField {
        //            self.bankNameTextField.becomeFirstResponder()
        //
        //        }else if textField == bankNameTextField {
        //            self.accountNumberTextField.becomeFirstResponder()
        //        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let textFieldText = textField.text,
              let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        
        if textField == self.code1TextField || textField == self.code2TextField || textField == self.code3TextField || textField == self.code4TextField {
            return count <= 4
            
        }else if textField == self.dateYearTextField || textField == self.dateMonthField {
            return count <= 2
            
        }else if textField == self.nameTextField {
            return count <= 30
            
        }else if textField == self.cvvTextField {
            return count <= 4
        }
        return true
    }
    
    @objc func code1FieldDidChange(_ textField : UITextField) {
        guard let text = textField.text, text.isNotEmpty else {
            self.code1Complete = false
            return
        }
        
        if text.count == 4 {
            code2TextField.becomeFirstResponder()
        }
        self.code1Complete = text.count == 4
    }
    
    @objc func code2FieldDidChange(_ textField : UITextField) {
        guard let text = textField.text, text.isNotEmpty else {
            self.code2Complete = false
            return
        }
        
        if text.count == 4 {
            code3TextField.becomeFirstResponder()
        }
        self.code2Complete = text.count == 4
    }
    
    @objc func code3FieldDidChange(_ textField : UITextField) {
        guard let text = textField.text, text.isNotEmpty else {
            self.code3Complete = false
            return
        }
        
        if text.count == 4 {
            code4TextField.becomeFirstResponder()
        }
        self.code3Complete = text.count == 4
    }
    
    @objc func code4FieldDidChange(_ textField : UITextField) {
        guard let text = textField.text, text.isNotEmpty else {
            self.code4Complete = false
            return
        }
        
        if text.count == 4 {
            dateMonthField.becomeFirstResponder()
        }
        self.code4Complete = text.count == 4
    }
    
    @objc func dateMonthFieldDidChange(_ textField : UITextField) {
        guard let text = textField.text, text.isNotEmpty else {
            self.monthComplete = false
            return
        }
        
        if text.count == 2 {
            dateYearTextField.becomeFirstResponder()
        }
        self.monthComplete = text.count == 2
    }
    
    @objc func dateYearFieldDidChange(_ textField : UITextField) {
        guard let text = textField.text, text.isNotEmpty else {
            self.yearComplete = false
            return
        }
        
        if text.count == 2 {
            nameTextField.becomeFirstResponder()
        }
        self.yearComplete = text.count == 2
    }
    
    @objc func nameFieldDidChange(_ textField : UITextField) {
        guard let text = textField.text, text.isNotEmpty else {
            return
        }
        
        if text.count == 30 {
            cvvTextField.becomeFirstResponder()
        }
    }
    
    @objc func cvvFieldDidChange(_ textField : UITextField) {
        guard let text = textField.text, text.isNotEmpty else {
            return
        }
        
        if text.count == 4 {
            view.endEditing(true)
        }
    }
}

// MARK: - PRIVATE FUNCTIONS

extension AddPaymentCardViewController {
    
    private func setCardImageToView(_ image: UIImage) {
        self.cardImageView.image = image
        //        self.cardFrontImage = image
    }
    
    private func uploadVisaCardData(_ card: LibraryCard, paymentType: PaymentCardType, frontImage: UIImage? = nil, backImage: UIImage? = nil) {
        
        guard let user = self.userProfile.getUser() else { return }
        
        var headers: HTTPHeaders = [:]
        let requestController = RequestsController.shared
        headers = requestController.getAuthorizationAcceptHeaders(user._access_token)
        
        let url = card.id == nil ? ADD_PAYMENT_CARD : UPDATE_PAYMENT_CARD
        
        self.customUploadView.show()
        
        DispatchQueue.global(qos: .background).async {
            AF.upload(multipartFormData: { (multipart) in
                if let front = frontImage,
                   let imageData = front.jpegData(compressionQuality: imagesCompressionQuality) {
                    multipart.append(imageData,
                                     withName: "front",
                                     fileName: "\(paymentType.typeString)-front.jpg",
                                     mimeType: "image/jpg")
                }
                
                if let back = backImage,
                   let imageData = back.jpegData(compressionQuality: imagesCompressionQuality) {
                    multipart.append(imageData,
                                     withName: "back",
                                     fileName: "\(paymentType.typeString)-back.jpg",
                                     mimeType: "image/jpg")
                }
                
                if let id = card.id {
                    multipart.append("\(id)".data(using: .utf8)!, withName: "PaymentCardID")
                }
                multipart.append(card._name.data(using: .utf8)!, withName: "CardName")
                multipart.append(self.cardTypeSelected.rawValue.data(using: .utf8)!, withName: "CardType")
                multipart.append(card._number.data(using: .utf8)!, withName: "CardNumber")
                multipart.append(card._name.data(using: .utf8)!, withName: "OwnerName")
                multipart.append(card._expiryDate.data(using: .utf8)!, withName: "ExpiryDate")
                multipart.append(card._cvv.data(using: .utf8)!, withName: "CVV")
                multipart.append(paymentType.rawValue.data(using: .utf8)!, withName: "PaymentCardType")
                multipart.append(self.expiryReminderSelected.serverType.data(using: .utf8)!, withName: "ReminderType")
                
            }, to: url, method: .post, headers: headers).uploadProgress(queue: .main, closure: { (progress) in
                
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
                    self.showSuccessMessage(response.message ?? "")
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                case .failure(let err):
                    if showAlamofireErrors {
                        self.showSnackMessage(err.localizedDescription)
                    }
                }
            }
        }
    }
    
    private func uploadLoyaltyImage(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: imagesCompressionQuality),
              let user = self.userProfile.getUser() else {
            return
        }
        
        var headers: HTTPHeaders = [:]
        let requestController = RequestsController.shared
        headers = requestController.getAuthorizationAcceptHeaders(user._access_token)
        
        self.customUploadView.show()
        
        DispatchQueue.global(qos: .background).async {
            AF.upload(multipartFormData: { multiPart in
                
                multiPart.append(imageData,
                                 withName: "file",
                                 fileName: "Loyalty.jpg",
                                 mimeType: "image/jpg")
                
            }, to: UPLOAD_LIBRARY_IMAGE, method: .post, headers: headers).uploadProgress(queue: .main, closure: { progress in
                
                let value = Float(progress.fractionCompleted)
                self.customUploadView.progressValue = value
                
            }).responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                self.customUploadView.hide()
                
                switch response.result {
                case .success(let response):
                    guard response.success == true else {
                        self.showErrorMessage(response.message)
                        return
                    }
                    
                    guard let id = response.imageID else { return }
                    
                    if self.isFrontImageUploaded {
                        self.backImageID = id
                        self.showSuccessMessage("Back side image Uploaded Successfully")
                    } else {
                        self.frontImageID = id
                        self.isFrontImageUploaded = true
                        self.showSuccessMessage("Front side image Uploaded Successfully\nplease upload back side image")
                    }
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
    
    private func isCardDataFull() -> Bool {
        return self.isCode1Full() && self.isCode2Full() && self.isCode3Full() && self.isCode4Full() && self.isMonthFull() && self.isYearFull() && self.isCvvFull()
    }
    
    private func isCardNumberFull() -> Bool {
        return self.isCode1Full() && self.isCode2Full() && self.isCode3Full() && self.isCode4Full()
    }
    
    private func isCode1Full() -> Bool {
        return self.code1Complete && self.code1TextField.text!.count == 4
    }
    private func isCode2Full() -> Bool {
        return self.code2Complete && self.code2TextField.text!.count == 4
    }
    
    private func isCode3Full() -> Bool {
        return self.code3Complete && self.code3TextField.text!.count == 4
    }
    
    private func isCode4Full() -> Bool {
        return self.code4Complete && self.code4TextField.text!.count == 4
    }
    
    private func isDateFull() -> Bool {
        return self.isMonthFull() && self.isYearFull()
    }
    
    private func isMonthFull() -> Bool {
        return self.monthComplete && self.dateMonthField.text!.count == 2
    }
    
    private func isYearFull() -> Bool {
        return self.yearComplete && self.dateYearTextField.text!.count == 2
    }
    
    private func isCvvFull() -> Bool {
        return self.cvvTextField.text!.count == 3 || self.cvvTextField.text!.count == 4
    }
    
    private func showHideCodeNumberError(action: ViewErrorsAction = .show) {
        
        switch action {
        case .hide:
            if !self.codeNumberErrorLabel.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.codeNumberErrorLabel.isHidden = true
                    self.codeNumberContainerHeight.constant -= self.codeNumberErrorLabel.height
                }
            }
        case .show:
            if self.codeNumberErrorLabel.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.codeNumberErrorLabel.isHidden = false
                    self.codeNumberContainerHeight.constant += self.codeNumberErrorLabel.height
                }
            }
        }
    }
    
    private func showHideExpiryError(action: ViewErrorsAction = .show) {
        
        switch action {
        case .hide:
            if !self.expiryErrorLabel.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.expiryErrorLabel.isHidden = true
                    self.expiryContainerHeight.constant -= self.expiryErrorLabel.height
                }
            }
        case .show:
            if self.expiryErrorLabel.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.expiryErrorLabel.isHidden = false
                    self.expiryContainerHeight.constant += self.expiryErrorLabel.height
                }
            }
        }
    }
    
    private func showHideNameError(action: ViewErrorsAction = .show) {
        
        switch action {
        case .hide:
            if !self.nameErrorLabel.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.nameErrorLabel.isHidden = true
                    self.nameContainerHeight.constant -= self.nameErrorLabel.height
                    self.cvvContainerHeight.constant -= self.cvvErrorLabel.height
                }
            }
        case .show:
            if self.nameErrorLabel.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.nameErrorLabel.isHidden = false
                    self.nameContainerHeight.constant += self.nameErrorLabel.height
                    self.cvvContainerHeight.constant += self.cvvErrorLabel.height
                }
            }
        }
    }
    
    private func showHideCVVError(action: ViewErrorsAction = .show) {
        
        switch action {
        case .hide:
            if !self.cvvErrorLabel.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.cvvErrorLabel.isHidden = true
                    self.nameContainerHeight.constant -= self.nameErrorLabel.height
                    self.cvvContainerHeight.constant -= self.cvvErrorLabel.height
                }
            }
        case .show:
            if self.cvvErrorLabel.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.cvvErrorLabel.isHidden = false
                    self.nameContainerHeight.constant += self.nameErrorLabel.height
                    self.cvvContainerHeight.constant += self.cvvErrorLabel.height
                }
            }
        }
    }
    
    private func checkLoyaltyViewFieldsErrors() -> Bool {
        
        let isLoyaltyCardNameNotEmpty = self.loyaltyCardNameTextField.text!.isNotEmpty
        self.showHideLoyaltyCardNameError(isLoyaltyCardNameNotEmpty)
        
        let isLoyaltyNameOnCardNotEmpty = self.loyaltyNameOnCardTextField.text!.isNotEmpty
        self.showHideLoyaltyNameOnCardError(isLoyaltyNameOnCardNotEmpty)
        
        let isLoyaltyBrandNotEmpty = self.loyaltyBrandSelected != nil
        self.showHideLoyaltyBrandError(isLoyaltyBrandNotEmpty)
        
        let isLoyaltyCardNumberNotEmpty = self.loyaltyCardNumberTextField.text!.isNotEmpty
        self.showHideLoyaltyCardNumberError(isLoyaltyCardNumberNotEmpty)
        
        let showHideLoyaltyCardValidityError = self.loyaltyCardValidityTextField.text!.isNotEmpty
        self.showHideLoyaltyCardValidityError(showHideLoyaltyCardValidityError)
        
        return isLoyaltyCardNameNotEmpty && isLoyaltyNameOnCardNotEmpty && isLoyaltyBrandNotEmpty && isLoyaltyCardNumberNotEmpty && showHideLoyaltyCardValidityError
    }
    
    private func showHideLoyaltyCardNameError(_ isNotEmpty: Bool) {
        self.loyaltyCardNameErrorImageView.image = isNotEmpty ? .none : .errorCircle
    }
    
    private func showHideLoyaltyNameOnCardError(_ isNotEmpty: Bool) {
        self.loyaltyNameOnCardErrorImageView.image = isNotEmpty ? .none : .errorCircle
    }
    
    private func showHideLoyaltyBrandError(_ isNotEmpty: Bool) {
        self.loyaltyCardBrandErrorImageView.image = isNotEmpty ? .none : .errorCircle
    }
    
    private func showHideLoyaltyCardNumberError(_ isNotEmpty: Bool) {
        self.loyaltyCardNumberErrorImageView.image = isNotEmpty ? .none : .errorCircle
    }
    
    private func showHideLoyaltyCardValidityError(_ isNotEmpty: Bool) {
        self.loyaltyCardValidityErrorImageView.image = isNotEmpty ? .none : .errorCircle
    }
    
    @objc private func onCreditBoxValueChange(_ sender: CheckBox) {
        self.setViewCardType(to: .Credit)
    }
    
    @objc private func onDebitBoxValueChange(_ sender: CheckBox) {
        self.setViewCardType(to: .Debit)
    }
    
    @objc private func onLoyaltyBoxValueChange(_ sender: CheckBox) {
        self.setViewCardType(to: .Loyalty)
    }
    
    private func setViewCardType(to type: ViewCardType) {
        
        self.viewCardTypeSelected = type
        self.setRadioButton(type)
        
        let isLoyaltyType = type == .Loyalty
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {
            self.loyaltyCardStackView.isHidden = isLoyaltyType.toggleAndReturn()
            self.paymentCardStackView.isHidden = isLoyaltyType
            
            //            self.cardImageContainerStackView.isHidden = isLoyaltyType
            //            self.cardImageView.isHidden = isLoyaltyType
            //            self.cardImageStackView.isHidden = isLoyaltyType
            
        }, completion: { isComplete in
            guard isComplete else { return }
            self.loyaltyCardImageOptionView.isHidden = isLoyaltyType.toggleAndReturn()
        })
    }
    
    private func setRadioButton(_ type: ViewCardType) {
        self.creditCardCheckBox.isChecked = type == .Credit
        self.debitCardCheckBox.isChecked = type == .Debit
        self.loyaltyCardCheckBox.isChecked = type == .Loyalty
    }
    
    private func setUpdateView(to type: ViewCardType) {
        
        self.creditCardCheckBox.isEnabled = type == .Credit
        self.debitCardCheckBox.isEnabled = type == .Debit
        self.loyaltyCardCheckBox.isEnabled = type == .Loyalty
        
        self.creditCardSelectionButton.isEnabled = type == .Credit
        self.debitCardSelectionButton.isEnabled = type == .Debit
        self.loyaltyCardSelectionButton.isEnabled = type == .Loyalty
        
        self.creditCardSelectionButton.setTitleColor(type == .Credit ? .black : .mLight_Gray, for: .normal)
        self.debitCardSelectionButton.setTitleColor(type == .Debit ? .black : .mLight_Gray, for: .normal)
        self.loyaltyCardSelectionButton.setTitleColor(type == .Loyalty ? .black : .mLight_Gray, for: .normal)
    }
    
    private func setupCreditCardCheckBox() {
        
        self.creditCardCheckBox.style = .circle
        self.creditCardCheckBox.borderStyle = .rounded
        self.creditCardCheckBox.borderWidth = 1
        self.creditCardCheckBox.addTarget(self, action: #selector(self.onCreditBoxValueChange(_:)), for: .valueChanged)
    }
    
    private func setupDebitCardCheckBox() {
        
        self.debitCardCheckBox.style = .circle
        self.debitCardCheckBox.borderStyle = .rounded
        self.debitCardCheckBox.borderWidth = 1
        self.debitCardCheckBox.addTarget(self, action: #selector(self.onDebitBoxValueChange(_:)), for: .valueChanged)
    }
    
    private func setupLoyaltyCardCheckBox() {
        
        self.loyaltyCardCheckBox.style = .circle
        self.loyaltyCardCheckBox.borderStyle = .rounded
        self.loyaltyCardCheckBox.borderWidth = 1
        self.loyaltyCardCheckBox.addTarget(self, action: #selector(self.onLoyaltyBoxValueChange(_:)), for: .valueChanged)
    }
    
    private func createLoyaltyValidityDatePicker() {
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let centerSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.loyaltyValidityDateDonePressed))
        let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.dateCancelPressed))
        
        toolbar.setItems([cancelBtn, centerSpace,doneBtn], animated: true)
        
        self.loyaltyCardValidityTextField.inputAccessoryView = toolbar
        self.loyaltyCardValidityTextField.inputView = self.datePicker
        
        self.datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            self.datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc private func loyaltyValidityDateDonePressed() {
        self.setLoyaltyValidityTextField(self.datePicker.date)
    }
    
    @objc private func dateCancelPressed() {
        self.view.endEditing(true)
    }
    
    private func setLoyaltyValidityTextField(_ date: Date) {
        
        let formattedDate = date.formatDate(libraryFieldsDateFormat)
        self.loyaltyCardValidityTextField.text = formattedDate
        self.showHideLoyaltyCardValidityError(self.loyaltyCardValidityTextField.text!.isNotEmpty)
        self.dateCancelPressed()
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
    
    private func setupCardTypeDropDown() {
        
        self.cardTypeDropDown.anchorView = self.cardTypeButton
        
        self.cardTypeDropDown.topOffset = CGPoint(x: 0, y: self.cardTypeButton.bounds.height)
        self.cardTypeDropDown.direction = .any
        self.cardTypeDropDown.dismissMode = .automatic
        
        for type in CardType.allCases {
            self.cardTypeDropDown.dataSource.append(type.rawValue)
        }
        
        self.selectCardType(self.cardTypeSelected)
        
        self.cardTypeDropDown.selectionAction = { [weak self] (index, item) in
            
            let selectedType = CardType(rawValue: item)
            if let selected = selectedType {
                self?.selectCardType(selected)
            }
        }
    }
    
    private func selectCardType(_ type: CardType) {
        
        for (index, value) in CardType.allCases.enumerated() {
            if type == value {
                self.cardTypeDropDown.selectRow(index)
                self.cardTypeLabel.text = value.rawValue
                self.cardTypeSelected = value
                break
            }
        }
    }
    
    private func setupLoyaltyBrandDropDown() {
        
        self.brandDropDown.anchorView = self.loyaltyCardBrandButton
        
        self.brandDropDown.topOffset = CGPoint(x: 0, y: self.loyaltyCardBrandButton.bounds.height)
        self.brandDropDown.direction = .any
        self.brandDropDown.dismissMode = .automatic
        
        let group = DispatchGroup()
        group.enter()
        self.requestProxy.requestService()?.getLoyaltyBrandList(completion: { (status, brands) in
            guard status else { return }
            
            for brand in brands ?? [] {
                if let brnd = brand.text {
                    self.brandDropDown.dataSource.append(brnd)
                }
            }
            group.leave()
        })
        
        group.notify(queue: .main) {
            if let card = self.loyaltyCard, let brand = card.brand {
                self.selectLoyaltyBrand(brand)
            }
        }
        
        self.brandDropDown.selectionAction = { [weak self] (index, item) in
            self?.selectLoyaltyBrand(item)
        }
    }
    
    private func selectLoyaltyBrand(_ brand: String) {
        
        for (index, value) in self.brandDropDown.dataSource.enumerated() {
            if brand == value {
                self.brandDropDown.selectRow(index)
                self.loyaltyCardBrandLabel.text = value
                self.loyaltyBrandSelected = value
                self.showHideLoyaltyBrandError(true)
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
