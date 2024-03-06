//
//  MyShopViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/7/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit
import Alamofire

class UploadShopBannerViewController: ShopController {
    
    @IBOutlet weak var bannerImageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    var logoImage: UIImage?
    var bannerImage: UIImage?
    
    var shopName: String?
    var shopDesc: String?
    
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
        
    }
}

extension UploadShopBannerViewController {
    
    func setupView() {
        self.imagePicker.delegate = self
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension UploadShopBannerViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func uploadImageAction(_ sender: UIButton) {
        self.imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        
        self.present(self.imagePicker, animated: true)
    }
    
    @IBAction func createShopAction(_ sender: UIButton) {
        
        guard let banner = self.bannerImage,
              let logo = self.logoImage,
              let name = self.shopName,
              let desc = self.shopDesc else {
            self.showErrorMessage("Please upload banner to your shop")
            return
        }
        guard let user = self.userProfile.getUser(),
              let logoData = logo.jpegData(compressionQuality: imagesCompressionQuality),
              let bannerData = banner.jpegData(compressionQuality: imagesCompressionQuality) else {
            return
        }
        
        var headers: HTTPHeaders = [:]
        let requestController = RequestsController.shared
        headers = requestController.getAuthorizationAcceptHeaders(user._access_token)
        
        var params: Parameters = [:]
        params["ShopName"] = name
        params["ShopNameArabic"] = "NA"
        params["ShopDescription"] = desc
        params["ShopDescriptionArabic"] = "NA"
        params["CategoryID"] = "0"
        
        DispatchQueue.global(qos: .background).async {
            
            AF.upload(multipartFormData: { (multipartFormData) in
                for (key,value) in params {
                    multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
                }
                multipartFormData.append(logoData,
                                         withName: "Logo",
                                         fileName: "Logo.jpg",
                                         mimeType: "image/jpg")
                multipartFormData.append(bannerData,
                                         withName: "Banner",
                                         fileName: "Banner.jpg",
                                         mimeType: "image/jpg")
                
                DispatchQueue.main.async {
                    self.customUploadView.show()
                }
                
            }, to: CREATE_SHOP, method: .post, headers: headers).uploadProgress(closure: { (progress) in
                
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
                        
                        self.navigationController?.popTo(MyShopsViewController.self, onFailure: {
                            self.navigationController?.popTo(DashboardViewController.self)
                        })
                        self.showSuccessMessage(response.message ?? "Shop created Successfully")
                        
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

// MARK: - IMAGE PICKER DELEGATE

extension UploadShopBannerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.imagePicker.dismiss(animated: true)
        
        if let image = info[.originalImage] as? UIImage {
//            print("Image \(image.size)")
            self.bannerImageView.image = image
            
            self.bannerImage = image
            DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                self.showSuccessMessage("You are ready now to create shop")
            }
        }
    }
}

// MARK: - PRIVATE FUNCTIONS

extension UploadShopBannerViewController {
    
}
