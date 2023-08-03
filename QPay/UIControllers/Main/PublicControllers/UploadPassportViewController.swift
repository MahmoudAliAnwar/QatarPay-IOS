//
//  UploadPassportViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/3/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit
import Alamofire

class UploadPassportViewController: ViewController {
    
    var passNumber: String?
    var updateViewElement: UpdateViewElement?
    
    private let imagePicker = UIImagePickerController()
    
    private var image: UIImage?
    
    private lazy var customUploadView: CustomUploadView = {
        let custom = CustomUploadView(self.view)
        return custom
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        localized()
        setupData()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.statusBarView?.isHidden = true
    }
}

extension UploadPassportViewController {
    
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

extension UploadPassportViewController {
    
    @IBAction func dismissAction(_ sender: UIButton) {
        self.closeView(false)
    }
    
    @IBAction func takePictureAction(_ sender: UIButton) {
        
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        imagePicker.cameraCaptureMode = .photo
        imagePicker.cameraFlashMode = .auto
        imagePicker.showsCameraControls = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func galleryAction(_ sender: UIButton) {
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }

    @IBAction func uploadAction(_ sender: UIButton) {
        
        guard let image = self.image,
              let user = self.userProfile.getUser() else {
            return
        }
        guard let imageData = image.jpegData(compressionQuality: imagesCompressionQuality) else { return }
        
        // MARK: - Send Passport Image
        
        var headers: HTTPHeaders = [:]
        let requestController = RequestsController.shared
        headers = requestController.getAuthorizationAcceptHeaders(user._access_token)
        
        DispatchQueue.global(qos: .background).async {
            AF.upload(multipartFormData: { multiPart in
                
                multiPart.append(imageData,
                                 withName: "file",
                                 fileName: "passport.jpg",
                                 mimeType: "image/jpg")
                
                DispatchQueue.main.async {
                    self.customUploadView.show()
                }
                
            }, to: UPLOAD_PASSPORT_IMAGE, method: .post, headers: headers) .uploadProgress(queue: .main, closure: { progress in
                
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
                        
                        self.closeView(true)
                        
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

extension UploadPassportViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else { return }
        // print out the image size as a test
//        print(image.size)
        
        self.image = image
        self.showSuccessMessage("Image selected ready to upload")
    }
}

// MARK: - PRIVATE FUNCTIONS

extension UploadPassportViewController {
    
    private func closeView(_ status: Bool) {
        self.dismiss(animated: true)
        self.updateViewElement?.elementUpdated(fromSourceView: self, status: status, data: nil)
    }
}
