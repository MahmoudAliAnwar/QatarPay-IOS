//
//  AddItemMyShopViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/6/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit
import Alamofire

class AddItemMyShopViewController: ShopController {

    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameErrorImageView: UIImageView!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var descriptionErrorImageView: UIImageView!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var priceErrorImageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    var productImageID: Int?
    var selectedShop: Shop!
    
    private lazy var customUploadView: CustomUploadView = {
        let custom = CustomUploadView(self.view)
        return custom
    }()
    
    override func viewDidLoad() {
        super.currentView = self
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupView()
        localized()
        setupData()
        fetchData()
    }
}

extension AddItemMyShopViewController {
    
    func setupView() {
        self.imagePicker.delegate = self
        super.requestService?.delegate = self
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension AddItemMyShopViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
    }

    @IBAction func takePhotoAction(_ sender: UIButton) {
        
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        imagePicker.showsCameraControls = true
        self.present(imagePicker, animated: true, completion: nil)
    }

    @IBAction func browseGelleryAction(_ sender: UIButton) {
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }

    @IBAction func addProductAction(_ sender: UIButton) {
        
        if let imageID = self.productImageID {
            if self.checkViewFieldsErrors() {
                
                if let name = self.nameTextField.text, name.isNotEmpty,
                   let desc = self.descriptionTextField.text, desc.isNotEmpty,
                   let priceString = self.priceTextField.text, priceString.isNotEmpty,
                   let shopID = self.selectedShop.id {
                    
                    if let price = Double(priceString.convertedDigitsToLocale()) {
                        
                        var product = Product()
                        product.name = name
                        product.description = desc
                        product.price = price
                        
                        super.requestService?.addProduct(shopID: shopID, product: product, imageID: imageID) { (status, response) in
                            if status {
                                DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                                    self.navigationController?.popViewController(animated: true)
                                    self.showSuccessMessage(response?.message ?? "Product Added Successfully")
                                }
                            }
                        }
                    }
                }
            }
            
        }else {
            super.showErrorMessage("Please add image for product")
        }
    }
}

// MARK: - IMAGE PICKER DELEGATE

extension AddItemMyShopViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        if let image = info[.originalImage] as? UIImage {
            // print out the image size as a test
//            print(image.size)
            
            // MARK: - Send Product Image

            if let user = self.userProfile.getUser() {
                var headers: HTTPHeaders = [:]
                headers["Authorization"] = "bearer \(user.access_token ?? "")"
                headers["Accept"] = "application/json"
                
                DispatchQueue.global(qos: .background).async {
                    AF.upload(multipartFormData: { multiPart in
                        
                        multiPart.append(image.jpegData(compressionQuality: imagesCompressionQuality)!, withName: "file", fileName: "Product.jpg", mimeType: "image/jpg")

                        DispatchQueue.main.async {
                            self.customUploadView.show()
                        }
                        
                    }, to: UPLOAD_ESTORE_IMAGE, method: .post, headers: headers) .uploadProgress(queue: .main, closure: { progress in
                        let value = Float.init(progress.fractionCompleted)
                        self.customUploadView.progressValue = value
                        
                    }).responseJSON(completionHandler: { data in
//                        print("upload finished JSON: \(data)")
//                        if let json = data.value as? [String : Any] {
//                            if let imageLocation = json["ProfileImageLocation"] as? String {
//                                self.userProfile.updateImageLocation(location: imageLocation)
//                            }
//                        }
                    
                    }).responseObject { (response: DataResponse<BaseResponse, AFError>) in
                        
                        DispatchQueue.main.async {
                            self.customUploadView.hide()
                            
                            switch response.result {
                            case .success(let response):
                                if response.success == true {
                                    if let id = response.imageID {
                                        self.productImageID = id
                                        self.productImageView.image = image
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                                            super.showSuccessMessage("Image Uploaded Successfully")
                                        }
                                    }
                                }else {
                                    if let message = response.message {
                                        self.showErrorMessage(message)
                                    }else {
                                        self.showErrorMessage()
                                    }
                                }
                            case .failure(let err):
                                self.showSnackMessage(err.localizedDescription)
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: - REQUESTS DELEGATE

extension AddItemMyShopViewController: RequestsDelegate {

    func requestStarted(request: RequestType) {
        if request == .addProduct {
            showLoadingView(self)
        }
    }

    func requestFinished(request: RequestType, result: ResponseResult) {
        hideLoadingView()
        
        switch result {
        case .Success(_):
            
            break
        case .Failure(let errorType):
            switch errorType {
            case .Exception(let exc):
                if showUserExceptions {
//                    showMessage(exc, messageStatus: .Warning)
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

// MARK: - PRIVATE FUNCTIONS

extension AddItemMyShopViewController {
    
    private func checkViewFieldsErrors() -> Bool {
        let isNameNotEmpty = self.nameTextField.text!.isNotEmpty
        self.showHideNameError(isNameNotEmpty)

        let isDescriptionNotEmpty = self.descriptionTextField.text!.isNotEmpty
        self.showHideDescriptionError(isDescriptionNotEmpty)

        let isPriceNotEmpty = self.priceTextField.text!.isNotEmpty
        self.showHidePriceError(isPriceNotEmpty)
        
        return isNameNotEmpty && isDescriptionNotEmpty &&  isPriceNotEmpty
    }
    
    private func showHideNameError(_ isNotEmpty: Bool) {
        self.nameErrorImageView.image = isNotEmpty ? .none : Images.ic_error_circle.image
    }
    
    private func showHideDescriptionError(_ isNotEmpty: Bool) {
        self.descriptionErrorImageView.image = isNotEmpty ? .none : Images.ic_error_circle.image
    }
    
    private func showHidePriceError(_ isNotEmpty: Bool) {
        self.priceErrorImageView.image = isNotEmpty ? .none : Images.ic_error_circle.image
    }
    
}
