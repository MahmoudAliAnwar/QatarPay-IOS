//
//  AddInvoiceViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/6/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit
import Alamofire

class ShopProfileViewController: ShopController {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBOutlet weak var uploadView: UIView!
    @IBOutlet weak var uploadProgressView: UIProgressView!
    @IBOutlet weak var uploadProgressLabel: UILabel!
    
    var selectedShop: Shop!
    
    let imagePicker = UIImagePickerController()
    
    private enum ImageType: String {
        case logo = "Logo"
        case banner = "Banner"
    }
    
    private var imageType: ImageType?
    
    private lazy var customUploadView: CustomUploadView = {
        let uploadView = CustomUploadView(self.view)
        return uploadView
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

extension ShopProfileViewController {
    
    func setupView() {
        self.imagePicker.delegate = self
    }
    
    func localized() {
    }
    
    func setupData() {
        
        if let name = self.selectedShop.name,
           let desc = self.selectedShop.description,
           let logo = self.selectedShop.logo,
           let banner = self.selectedShop.banner {
            
            self.titleLabel.text = name
            self.nameTextField.text = name
            self.descriptionTextField.text = desc
            
            logo.getImageFromURLString { (status, image) in
                if status, let img = image {
                    self.logoImageView.image = img
                }
            }
            
            banner.getImageFromURLString { (status, image) in
                if status, let img = image {
                    self.bannerImageView.image = img
                }
            }
        }
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension ShopProfileViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func uploadLogoImageAction(_ sender: UIButton) {
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.allowsEditing = false
        self.imageType = .logo
        
        self.present(self.imagePicker, animated: true)
    }
    
    @IBAction func uploadBannerImageAction(_ sender: UIButton) {
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.allowsEditing = false
        self.imageType = .banner
        
        self.present(self.imagePicker, animated: true)
    }
    
    @IBAction func saveChangesAction(_ sender: UIButton) {
        
        guard let id = self.selectedShop.id,
              let name = self.nameTextField.text, name.isNotEmpty,
              let desc = self.descriptionTextField.text, desc.isNotEmpty else {
            return
        }
        
        self.requestProxy.requestService()?.updateShopDetails(id, shopName: name, shopDescription: desc, ( weakify { strong, object in
            DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                strong.navigationController?.popViewController(animated: true)
                strong.showSuccessMessage(object?.message ?? "Saved Successfully")
            }
        }))
    }
}

// MARK: - REQUESTS DELEGATE

extension ShopProfileViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .updateShopDetails {
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

// MARK: - IMAGE PICKER DELEGATE

extension ShopProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage,
              let type = self.imageType else {
            return
        }
        // print out the image size as a test
//            print(image.size)
        
        DispatchQueue.global(qos: .background).async {
            self.uploadImageToTheServer(image, type: type)
        }
    }
}

// MARK: - PRIVATE FUNCTIONS

extension ShopProfileViewController {
    
    private func uploadImageToTheServer(_ image: UIImage, type: ImageType) {
        
        guard let user = self.userProfile.getUser(),
              let shopID = self.selectedShop.id,
              let imageData = image.jpegData(compressionQuality: imagesCompressionQuality) else {
            return
        }
        
        var headers: HTTPHeaders = [:]
        let requestController = RequestsController.shared
        headers = requestController.getAuthorizationAcceptHeaders(user._access_token)
        
        AF.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(shopID.description.data(using: .utf8)!, withName: "ShopID")
            
            multipartFormData.append(imageData,
                                     withName: type.rawValue,
                                     fileName: "\(type.rawValue).jpg",
                                     mimeType: "image/jpg")
            
            DispatchQueue.main.async {
                self.customUploadView.show()
            }
            
        }, to: UPDATE_SHOP_IMAGE, method: .post, headers: headers).uploadProgress(closure: { (progress) in
            
            let value = Float(progress.fractionCompleted)
            self.customUploadView.progressValue = value
            
        }).responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
            
            DispatchQueue.main.async {
                self.customUploadView.hide()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                switch response.result {
                case .success(let response):
                    guard response.success == true else {
                        if showUserExceptions {
                            self.showErrorMessage(response.message)
                        }
                        return
                    }
                    
                    switch type {
                    case .logo:
                        self.logoImageView.image = .none
                        self.logoImageView.image = UIImage(data: imageData) ?? .none
                    case .banner:
                        self.bannerImageView.image = .none
                        self.bannerImageView.image = UIImage(data: imageData) ?? .none
                    }
                    self.showSuccessMessage("Shop \(type.rawValue) updated successfully")
                    
                case .failure(let err):
                    if showAlamofireErrors {
                        self.showSnackMessage(err.localizedDescription)
                    }
                }
            }
        }
    }
    
    private func showHideUploadView(to status: Bool) {
        self.uploadView.isHidden = !status
    }
}
