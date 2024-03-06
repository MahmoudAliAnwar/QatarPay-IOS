//
//  NoqoodyCodeViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/10/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class NoqoodyCodeViewController: MainController {
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var verifiedUserLabel: UILabel!
    
    @IBOutlet weak var qrCodeImageView: UIImageView!
    
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
        
        self.requestProxy.requestService()?.getUserProfile ( weakify { strong, myProfile in
            guard let profile = myProfile else { return }
            
            self.nameLabel.text = "\(profile.fullName ?? "") \(profile.lastName ?? "")"
            
            if let imgUrl = profile.imageURL {
                imgUrl.getImageFromURLString { (status, image) in
                    guard status,
                          let img = image else {
                        return
                    }
                    self.userImageView.image = img
                }
            }
        })
    }
}

extension NoqoodyCodeViewController {
    
    func setupView() {
        self.verifiedUserLabel.isHidden = true
        
        self.requestProxy.requestService()?.getQRCode ( weakify { strong, qrCodeString in
            guard let string = qrCodeString else { return }
            let image = string.convertBase64StringToImage()
            self.qrCodeImageView.image = image
        })
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension NoqoodyCodeViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func scanQRAction(_ sender: UIButton) {
//        let vc = Views.QRScannerViewController.storyboardView
//        self.present(vc, animated: true)
    }
    
    @IBAction func shareAction(_ sender: UIButton) {
        
        guard self.qrCodeImageView.image != nil else { return }
        
        let image = self.containerView.takeScreenShot()
        let string = "I accept payments using Qatar Pay. Please scan this QR Code with your Qatar Pay App to pay me"
        
        openShareDialog(sender: self.view, data: [image, string])
    }
}

// MARK: - REQUESTS DELEGATE

extension NoqoodyCodeViewController: RequestsDelegate {

    func requestStarted(request: RequestType) {
        if request == .getQRCode {
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

extension NoqoodyCodeViewController {
    
}
