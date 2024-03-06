//
//  AddBankAccountViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 10/17/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit
import DropDown
import Alamofire

class AddDocumentViewController: MainController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var viewTypeLabel: UILabel!
    
    @IBOutlet weak var deleteImageView: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameErrorImageView: UIImageView!
    
    @IBOutlet weak var fileTypeLabel: UILabel!
    @IBOutlet weak var fileTypeErrorImageView: UIImageView!
    @IBOutlet weak var fileTypeButton: UIButton!
    
    @IBOutlet weak var dateOfExpiryTextField: UITextField!
    @IBOutlet weak var dateOfExpiryErrorImageView: UIImageView!
    
    @IBOutlet weak var uploadImageStackView: UIStackView!
    @IBOutlet weak var uploadDocumentStackView: UIStackView!
    
    @IBOutlet weak var reminderExpiryLabel: UILabel!
    @IBOutlet weak var reminderExpiryButton: UIButton!
    
    var viewType: String?
    var document: Document?
    
    private var fileTypeDropDown = DropDown()
    private var reminderDropDown = DropDown()
    
    private var datePicker = UIDatePicker()
    private var imagePicker = UIImagePickerController()
    private var expiryReminderSelected: ExpiryReminder = .Before1Month
    private var documentID: Int?
    private var fileTypeSelected: FileType! {
        willSet {
            self.setViewType(to: newValue)
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
        
        self.requestProxy.requestService()?.delegate = self
    }
}

extension AddDocumentViewController {
    
    func setupView() {
        self.imagePicker.delegate = self
        
        self.createDateOfExpiryPicker()
        
        self.setupDropDownAppearance()
        self.setupFileTypeDropDown()
        self.setupReminderDropDown()
    }
    
    func localized() {
    }
    
    func setupData() {
        if let type = self.viewType {
            self.viewTypeLabel.text = type
        }
        
        self.setIsUpdateView(self.document != nil)
        
        guard let doc = self.document else { return }
        self.documentID = 0
        self.nameTextField.text = doc.name
        
        if let type = FileType(rawValue: doc._type) {
            self.selectFileType(type)
        }
        
        if let date = doc._expiryDate.server2StringToDate() {
            self.setDateOfExpiryTextField(date)
        }
        
        if let reminder = ExpiryReminder.getObjectByNumber(doc._reminderType) {
            self.selectExpiryReminder(reminder)
        }
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension AddDocumentViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func fileTypeDropDownAction(_ sender: UIButton) {
        self.fileTypeDropDown.show()
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
    
    @IBAction func uploadDocumentAction(_ sender: UIButton) {
        
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["com.adobe.pdf"], in: .import)
        //Call Delegate
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        self.present(documentPicker, animated: true)
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        
        guard self.checkViewFieldsErrors() else { return }
        if let docID = self.documentID {
            guard let name = self.nameTextField.text, name.isNotEmpty,
                  let dateOfExpiry = self.dateOfExpiryTextField.text, dateOfExpiry.isNotEmpty else {
                return
            }
            
            var finalDocument = Document()
            finalDocument.name = name
            if let doe = dateOfExpiry.formatToDate(libraryFieldsDateFormat) {
                finalDocument.expiryDate = doe.description
            }
            finalDocument.type = self.fileTypeSelected.rawValue
            finalDocument.reminderType = self.expiryReminderSelected.serverType
            
            if let doc = self.document {
                guard let id = doc.id else { return }
                self.requestProxy.requestService()?.updateDocument(id: id, document: finalDocument, documentLocationID: docID) { (status, documents) in
                    guard status else { return }
                }
                
            }else {
                self.requestProxy.requestService()?.addDocument(finalDocument, documentLocationID: docID) { (status, documents) in
                    guard status else { return }
                }
            }
        }else {
            self.showErrorMessage("Please, upload document to save")
        }
    }
    
    @IBAction func deleteAction(_ sender: UIButton) {
        guard let doc = self.document, let id = doc.id else { return }
        
        self.showConfirmation(message: "you want to delete document ?") {
            self.requestProxy.requestService()?.deleteDocument(id: id) { (status, documents) in
                guard status else { return }
            }
        }
    }
}

// MARK: - IMAGE PRICKER DELEGATE

extension AddDocumentViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage,
              let user = self.userProfile.getUser() else {
            return
        }
        //        print(image.size)
        
        guard let imageData = image.jpegData(compressionQuality: imagesCompressionQuality) else { return }
        
        var headers: HTTPHeaders = [:]
        let requestController = RequestsController.shared
        headers = requestController.getAuthorizationAcceptHeaders(user._access_token)
        
        DispatchQueue.global(qos: .background).async {
            AF.upload(multipartFormData: { multiPart in
                
                multiPart.append(imageData,
                                 withName: "file",
                                 fileName: "document.jpg",
                                 mimeType: "image/jpg")
                
                DispatchQueue.main.async {
                    self.customUploadView.show()
                }
                
            }, to: UPLOAD_LIBRARY_IMAGE, method: .post, headers: headers) .uploadProgress(queue: .main, closure: { progress in
                
                let value = Float(progress.fractionCompleted)
                self.customUploadView.progressValue = value
                
            }).responseObject { (response: DataResponse<BaseResponse, AFError>) in
                
                DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                    self.customUploadView.hide()
                    
                    switch response.result {
                    case .success(let response):
                        guard response.success == true else {
                            if showUserExceptions {
                                self.showErrorMessage(response.message)
                            }
                            return
                        }
                        
                        if let id = response.imageID {
                            self.documentID = id
                            self.showSuccessMessage("Upload successfully")
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
}

// MARK: - DOCUMENT PICKER DELEGATE

extension AddDocumentViewController: UIDocumentPickerDelegate, UIDocumentBrowserViewControllerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        controller.dismiss(animated: true)
        
        guard let url = urls.first else { return }
        let doc = UIDocument(fileURL: url)
//        print(doc.fileURL.lastPathComponent)
        guard let data = try? Data(contentsOf: url),
              let user = self.userProfile.getUser() else {
            return
        }
        
        var headers: HTTPHeaders = [:]
        let requestController = RequestsController.shared
        headers = requestController.getAuthorizationAcceptHeaders(user._access_token)
        
        DispatchQueue.global(qos: .background).async {
            AF.upload(multipartFormData: { multiPart in
                
                multiPart.append(data, withName: "file", fileName: doc.fileURL.lastPathComponent, mimeType: "file/pdf")
                
                DispatchQueue.main.async {
                    self.customUploadView.show()
                }
                
            }, to: UPLOAD_DOCUMENT, method: .post, headers: headers) .uploadProgress(queue: .main, closure: { progress in
                
                let value = Float(progress.fractionCompleted)
                self.customUploadView.progressValue = value
                
            }).responseObject { (response: DataResponse<BaseResponse, AFError>) in
                
                DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                    self.customUploadView.hide()
                    
                    switch response.result {
                    case .success(let response):
                        if response.success == true {
                            if let docID = response.documentID {
                                self.documentID = docID
                                self.showSuccessMessage("Upload successfully")
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
}

// MARK: - REQUESTS DELEGATE

extension AddDocumentViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .addDocument || request == .updateDocument || request == .deleteDocument {
            showLoadingView(self)
        }
    }
    
    func requestFinished(request: RequestType, result: ResponseResult) {
        hideLoadingView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
            switch result {
            case .Success(let data):
                guard let response = data as? BaseArrayResponse<Document> else { return }
                self.showSuccessMessage(response.message ?? "")
                
                if request == .addDocument ||
                    request == .updateDocument ||
                    request == .deleteDocument {
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

// MARK: - PRIVATE FUNCTIONS

extension AddDocumentViewController {
    
    private func checkViewFieldsErrors() -> Bool {
        let isNameNotEmpty = self.nameTextField.text!.isNotEmpty
        let isDateOfExpiryNotEmpty = self.dateOfExpiryTextField.text!.isNotEmpty
        
        self.showHideNameError(isNameNotEmpty)
        self.showHideDateOfExpiryError(isDateOfExpiryNotEmpty)
        
        return isNameNotEmpty && isDateOfExpiryNotEmpty
    }
    
    private func showHideNameError(_ isNotEmpty: Bool) {
        self.nameErrorImageView.image = isNotEmpty ? .none : Images.ic_error_circle.image
    }
    
    private func showHideDateOfExpiryError(_ isNotEmpty: Bool) {
        self.dateOfExpiryErrorImageView.image = isNotEmpty ? .none : .errorCircle
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
    
    private func setupFileTypeDropDown() {
        
        self.fileTypeDropDown.anchorView = self.fileTypeButton
        
        self.fileTypeDropDown.topOffset = CGPoint(x: 0, y: self.fileTypeButton.bounds.height)
        self.fileTypeDropDown.direction = .any
        self.fileTypeDropDown.dismissMode = .automatic
        
        for type in FileType.allCases {
            self.fileTypeDropDown.dataSource.append(type.rawValue)
        }
        
        self.selectFileType(.Images)
        
        self.fileTypeDropDown.selectionAction = { [weak self] (index, item) in
            self?.fileTypeLabel.text = item
            
            let selectedType = FileType(rawValue: item)
            if let type = selectedType {
                self?.selectFileType(type)
            }
        }
    }
    
    private func selectFileType(_ type: FileType) {
        
        for (index, value) in FileType.allCases.enumerated() {
            if type == value {
                self.fileTypeDropDown.selectRow(index)
                self.fileTypeLabel.text = value.rawValue
                self.fileTypeSelected = value
                self.fileTypeErrorImageView.image = .none
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
    
    private func setViewType(to type: FileType) {
        self.uploadImageStackView.isHidden = type != .Images
        self.uploadDocumentStackView.isHidden = type != .Documents
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
