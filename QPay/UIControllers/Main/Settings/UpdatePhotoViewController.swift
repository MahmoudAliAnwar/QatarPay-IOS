//
//  UpdatePhotoViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/3/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit
import Alamofire

class UpdatePhotoViewController: ViewController {
    
    let imagePicker = UIImagePickerController()
    
    var updateViewElementDelegate: UpdateViewElement?
    
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
        
        self.statusBarView?.isHidden = true
    }
}

extension UpdatePhotoViewController {
    
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

extension UpdatePhotoViewController {
    
    @IBAction func dismissAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func galleryAction(_ sender: UIButton) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func takePhotoAction(_ sender: UIButton) {
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        imagePicker.cameraCaptureMode = .photo
        imagePicker.cameraFlashMode = .auto
        imagePicker.showsCameraControls = true
        self.present(imagePicker, animated: true, completion: nil)
    }
}

// MARK: - IMAGE PICKER DELEGATE

extension UpdatePhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage,
              let user = self.userProfile.getUser() else {
            return
        }
        guard let imageData = image.jpegData(compressionQuality: imagesCompressionQuality) else { return }
        
            // print out the image size as a test
//            print(image.size)
            
        // MARK: - Send Profile Image
        
        var headers: HTTPHeaders = [:]
        let requestController = RequestsController.shared
        headers = requestController.getAuthorizationAcceptHeaders(user._access_token)
        
        DispatchQueue.global(qos: .background).async {
            
            AF.upload(multipartFormData: { multiPart in
                
                multiPart.append(imageData,
                                 withName: "file",
                                 fileName: "file.jpg",
                                 mimeType: "image/jpg")
                DispatchQueue.main.async {
                    self.customUploadView.show()
                }
                
            }, to: UPLOAD_PROFILE_IMAGE, method: .post, headers: headers) .uploadProgress(queue: .main, closure: { progress in
                let value = Float(progress.fractionCompleted)
                self.customUploadView.progressValue = value
                
            }).responseJSON(completionHandler: { data in
                
                if let json = data.value as? [String : Any],
                   let imageLocation = json["ProfileImageLocation"] as? String {
                    
                    self.userProfile.updateImageLocation(location: imageLocation)
                }
                
            }).responseObject { (response: DataResponse<BaseResponse, AFError>) in
                
                DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                    self.customUploadView.hide()
                    
                    switch response.result {
                    case .success(let response):
                        if response.success == true {
                            self.closeView(true, data: response.message ?? "")
                        }else {
                            if showUserExceptions {
                                self.showErrorMessage(response.message)
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

// MARK: - PRIVATE FUNCTIONS

extension UpdatePhotoViewController {
    
    private func closeView(_ status: Bool, data: Any?) {
        self.dismiss(animated: true)
        self.updateViewElementDelegate?.elementUpdated(fromSourceView: self, status: status, data: data)
    }
}
