//
//  EmailRegisterErrorViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 24/08/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit
import MessageUI

class DataRegisterErrorViewController: ViewController {
    
    @IBOutlet weak var messageLabel: UILabel!
    
    var errorType: ErrorType = .Email
    var amount: String = ""
    
    enum ErrorType: String {
        case Email = "email address"
        case Mobile = "mobile number"
    }
    
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
        self.setErrorMessage(to: self.errorType)
    }
}

extension DataRegisterErrorViewController {
    
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

extension DataRegisterErrorViewController {
    
    @IBAction func noAction(_ sender: UIButton) {
        guard let parent = self.presentingViewController?.children.last as? RequestMoneyViewController else { return }
        self.dismiss(animated: true) {
            parent.viewWillAppear(true)
        }
    }
    
    @IBAction func yesAction(_ sender: UIButton) {
        
        guard let parent = self.presentingViewController?.children.last as? RequestMoneyViewController else { return }
        guard let amount = Double(self.amount) else {
            self.showSnackMessage("Please, Enter valid amount", background: .systemRed, textColor: .white)
            return
        }
        
        switch self.errorType {
        case .Email:
           guard let email = parent.emailTextField.text,
               email.isNotEmpty else {
                return
            }
            
            self.requestProxy.requestService()?.externalPaymentEmail(email, amount: amount, { status, response in
                guard status else { return }
                
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    self.showSuccessMessage(response?.message ?? "")
                }
            })
            break
            
        case .Mobile:
            guard let mobile = parent.mobileTextField.text,
               mobile.isNotEmpty else {
                return
            }
            
            guard let user = self.userProfile.getUser() else { return }
            
            self.requestProxy.requestService()?.externalPaymentMobile(mobile, amount: amount, { status, response in
                guard status else { return }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                    let body = "Dear ,\nA request from \(user._fullName) to transfer amount of QAR \(amount).\nPlease press link to proceed\n\(response?.paymentLink ?? "")"
                    
                    if MFMessageComposeViewController.canSendText() == true {
                        let messageController = MFMessageComposeViewController()
                        messageController.messageComposeDelegate = self
                        messageController.recipients = [mobile]
                        messageController.body = body
                        self.present(messageController, animated: true, completion: nil)
                    } else {
                        //handle text messaging not available
                    }
                }
            })
            break
        }
    }
}

// MARK: - MESSAGE COMPOSE DEELGATE

extension DataRegisterErrorViewController: MFMessageComposeViewControllerDelegate {
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true)
        switch result {
        case .cancelled:
            break
        case .sent:
            break
        case .failed:
            break
        @unknown default:
            break
        }
    }
}

// MARK: - REQUESTS DELEGATE

extension DataRegisterErrorViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .externalPaymentEmail ||
            request == .externalPaymentMobile {
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

extension DataRegisterErrorViewController {
    
    private func setErrorMessage(to type: ErrorType) {
        let typeVar: String = type == .Email ? "an email" : "a message"
        self.messageLabel.text = "This \(type.rawValue) is not registered with Qatar Pay. Do you wish to send \(typeVar) to request money (\(self.amount)) QAR."
    }
}
