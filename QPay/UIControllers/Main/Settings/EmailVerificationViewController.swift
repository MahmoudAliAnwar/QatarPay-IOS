//
//  EmailVerificationViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 17/10/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit

class EmailVerificationViewController: ViewController {
    
    var updateViewElementDelegate: UpdateViewElement?
    
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

extension EmailVerificationViewController {
    
    func setupView() {
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension EmailVerificationViewController {
    
    @IBAction func closeAction(_ sender: UIButton) {
        self.dismiss(animated: true) {
//            self.updateViewElementDelegate?.elementUpdated(fromSourceView: self,
//                                                           status: false,
//                                                           data: nil)
        }
    }
    
    @IBAction func verifyAction(_ sender: UIButton) {
        self.requestProxy.requestService()?.sendVerificationEmail( weakify { strong, response in
            guard let resp = response else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                strong.dismiss(animated: true) {
                    strong.updateViewElementDelegate?.elementUpdated(fromSourceView: strong,
                                                                   status: true,
                                                                   data: resp.message ?? "")
                }
            }
        })
    }
}

// MARK: - REQUESTS DELEGATE

extension EmailVerificationViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .sendVerificationEmail {
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

extension EmailVerificationViewController {
    
}
