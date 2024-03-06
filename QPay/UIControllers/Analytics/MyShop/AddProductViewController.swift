//
//  AddProductViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/6/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit
import Alamofire

class AddProductViewController: ShopController {

    @IBOutlet weak var viewTitleLabel: UILabel!
    @IBOutlet weak var addActionButton: UIButton!
    @IBOutlet weak var updateActionButton: UIButton!
    
    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameErrorImageView: UIImageView!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var descriptionErrorImageView: UIImageView!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var priceErrorImageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    var productImageID: Int?
    var product: Product?
    var selectedShop: Shop!
    
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
}

extension AddProductViewController {
    
    func setupView() {
        self.imagePicker.delegate = self
        self.requestProxy.requestService()?.delegate = self
    }
    
    func localized() {
    }
    
    func setupData() {
        if let prod = self.product {
            self.setupUpdateView()
            
            self.nameTextField.text = prod._name
            self.descriptionTextField.text = prod._description
            
            if let price = prod.price {
                self.priceTextField.text = price.formatNumber()
            }
            
            if let imgURL = self.product?.image {
                imgURL.getImageFromURLString { (status, image) in
                    guard status else { return }
                    self.productImageView.image = image
                }
            }
        }
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension AddProductViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
        
        guard let imageID = self.productImageID else {
            self.showErrorMessage("Please add image for product")
            return
        }
        guard self.checkViewFieldsErrors() else { return }
        
        guard let name = self.nameTextField.text, name.isNotEmpty,
              let desc = self.descriptionTextField.text, desc.isNotEmpty,
              let priceString = self.priceTextField.text, priceString.isNotEmpty,
              let shopID = self.selectedShop.id else {
            return
        }
        
        if let price = Double(priceString.convertedDigitsToLocale()) {
            
            var product = Product()
            product.name = name
            product.description = desc
            product.price = price
            
            self.requestProxy.requestService()?.addProduct(shopID: shopID, product: product, imageID: imageID) { (status, response) in
                guard status else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                    self.showSuccessMessage(response?.message ?? "Product Added Successfully")
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    @IBAction func updateProductAction(_ sender: UIButton) {
        
        guard self.checkViewFieldsErrors() else { return }
        
        guard let name = self.nameTextField.text, name.isNotEmpty,
              let desc = self.descriptionTextField.text, desc.isNotEmpty,
              let priceString = self.priceTextField.text, priceString.isNotEmpty,
              let shopID = self.selectedShop.id,
              let productID = self.product?.id else {
            return
        }
        
        if let price = Double(priceString.convertedDigitsToLocale()) {
            
            var product = Product()
            product.id = productID
            product.name = name
            product.description = desc
            product.price = price
            
            self.requestProxy.requestService()?.updateProduct(shopID: shopID, product: product) { (status, response) in
                guard status else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                    self.showSuccessMessage(response?.message ?? "Product Updated Successfully")
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}

// MARK: - IMAGE PICKER DELEGATE

extension AddProductViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.originalImage] as? UIImage,
              let user = self.userProfile.getUser() else {
            return
        }
        guard let imageData = image.jpegData(compressionQuality: imagesCompressionQuality) else { return }
        
        // print out the image size as a test
//        print(image.size)
        
        let url = self.product == nil ? UPLOAD_ESTORE_IMAGE : UPDATE_PRODUCT_IMAGE
        
        var headers: HTTPHeaders = [:]
        let requestController = RequestsController.shared
        headers = requestController.getAuthorizationAcceptHeaders(user._access_token)
        
        DispatchQueue.global(qos: .background).async {
            AF.upload(multipartFormData: { multiPart in
                
                if let prod = self.product,
                   let shopID = self.selectedShop.id,
                   let pID = prod.id {
                    
                    multiPart.append("\(shopID)".data(using: .utf8)!, withName: "ShopID")
                    multiPart.append("\(pID)".data(using: .utf8)!, withName: "ProductID")
                }
                
                multiPart.append(imageData,
                                 withName: "Image",
                                 fileName: "Product.jpg",
                                 mimeType: "image/jpg")
                
                DispatchQueue.main.async {
                    self.customUploadView.show()
                }
                
            }, to: url, method: .post, headers: headers) .uploadProgress(queue: .main, closure: { progress in
                
                let value = Float(progress.fractionCompleted)
                self.customUploadView.progressValue = value
                
            }).responseObject { (response: DataResponse<BaseResponse, AFError>) in
                
                DispatchQueue.main.async {
                    self.customUploadView.hide()
                    
                    switch response.result {
                    case .success(let response):
                        DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                            guard response.success == true else {
                                if showUserExceptions {
                                    self.showErrorMessage(response.message)
                                }
                                return
                            }
                            
                            self.productImageView.image = image
                            
                            if self.product == nil {
                                guard let id = response.imageID else { return }
                                self.productImageID = id
                                self.showSuccessMessage("Image Uploaded Successfully")
                                
                            }else{
                                self.showSuccessMessage("Image Updated Successfully")
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

// MARK: - REQUESTS DELEGATE

extension AddProductViewController: RequestsDelegate {

    func requestStarted(request: RequestType) {
        if request == .addProduct ||
            request == .updateProduct {
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

// MARK: - PRIVATE FUNCTIONS

extension AddProductViewController {
    
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
    
    private func setupUpdateView() {
        self.viewTitleLabel.text = "Update Product"
        self.addActionButton.isHidden = true
        self.updateActionButton.isHidden = false
    }
}
