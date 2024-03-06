//
//  SignatureViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/10/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit
import SignaturePad
import Alamofire

class SignatureViewController: AuthController {
    
    @IBOutlet weak var signatureView: SignaturePad!
    @IBOutlet weak var checkBox: CheckBox!
    
    var isAcceptedTerms = false
    
    var email: String?
    var password: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

extension SignatureViewController {
    
    func setupView() {
        self.signatureView.delegate = self
        
        self.checkBox.style = .tick
        self.checkBox.borderStyle = .square
        self.checkBox.tintColor = .darkGray
        self.checkBox.borderWidth = 1
        self.checkBox.addTarget(self, action: #selector(self.onCheckBoxValueChange(_:)), for: .valueChanged)
    }
    
    func localized() {
    }
    
    func setupData() {
        let signupData = userProfile.getSignUpData()
        
        if let email = self.email, let password = self.password {
            self.sendSignInRequest(email, password)
            
        } else if signupData.email.isNotEmpty && signupData.password.isNotEmpty {
            self.sendSignInRequest(signupData.email, signupData.password)
        }
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension SignatureViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clearSignatureAction(_ sender: UIButton) {
        self.signatureView.clear()
    }
    
    @IBAction func termsAction(_ sender: UIButton) {
        guard let url = URL(string: "http://qatarpay.com/termsandconditions.html") else { return }
        UIApplication.shared.open(url, options: [:])
    }
    
    @IBAction func continueAction(_ sender: UIButton) {
        
        guard isAcceptedTerms,
              let signature = self.signatureView.getSignature(),
              let user = userProfile.getUser() else {
            return
        }
        
        guard let imageData = signature.jpegData(compressionQuality: imagesCompressionQuality) else { return }
        
        showLoadingView(self)
        
        var headers: HTTPHeaders = [:]
        let requestController = RequestsController.shared
        headers = requestController.getAuthorizationAcceptHeaders(user._access_token)
        
        DispatchQueue.global(qos: .background).async {
            AF.upload(multipartFormData: { multiPart in
                
                multiPart.append(imageData,
                                 withName: "file",
                                 fileName: "file.jpg",
                                 mimeType: "image/jpg")
                
            }, to: UPLOAD_SIGNATURE, method: .post, headers: headers) .uploadProgress(queue: .main, closure: { progress in
                
            }).responseObject { (response: DataResponse<BaseResponse, AFError>) in
                
                DispatchQueue.main.async {
                    self.hideLoadingView()
                    
                    switch response.result {
                    case .success(let response):
                        if response.success == true {
                            self.showSuccessMessage(response.message ?? "Signature uploaded successfully")
                            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                                let vc = self.getStoryboardView(QIDMobileViewController.self)
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
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
    
    @IBAction func termsAgreeAction(_ sender: UIButton) {
        self.checkBox.isChecked = !self.checkBox.isChecked
        self.changeCheckBoxStatus(self.checkBox.isChecked)
    }
    
    @objc func onCheckBoxValueChange(_ sender: CheckBox) {
        self.changeCheckBoxStatus(sender.isChecked)
    }
}

// MARK: - SIGNATURE PAD DELEGATE

extension SignatureViewController: SignaturePadDelegate {
    
    func didStart() {
        
    }
    
    func didFinish() {
        
    }
}

// MARK: - REQUEST DELEGATE

extension SignatureViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .signIn {
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
                        self.showErrorMessage(err.localizedDescription)
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

extension SignatureViewController {
    
    private func sendSignInRequest(_ email: String, _ password: String) {
        self.requestProxy.requestService()?.signIn(email, password, ( weakify { strong, object in
        }))
    }
    
    private func changeCheckBoxStatus(_ status: Bool) {
        self.isAcceptedTerms = status
    }
}

/*
  upload Response {
      code = 401;
      errors =     (
      );
      message = "Not Authorize for this request.";
      success = 0;
  }

 Upload Progress: 1.0
 upload finished JSON: success({
     ProfileDigitalSignatureLocation = "http://151.106.28.182:1124/API/Uploads\\Registeration\\imagepath/2020-08-05_13-50-17_User-file.jpg";
            http://151.106.28.182:1124/API/Uploads\\Registeration\\imagepath/2020-08-05_15-28-25_User-file.jpg
     code = OK;
     errors =     (
     );
     message = "";
     success = 1;
 })
 upload success result: BaseResponse(success: Optional(true), code: Optional("OK"), message: Optional(""), errors: Optional([]))

 */
