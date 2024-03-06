//
//  ConfirmPaymentRequestViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/15/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

protocol ConfirmPaymentRequestDelegate: AnyObject {
    func didTapPayButton(notification: NotificationModel)
    func didTapCancelButton(notification: NotificationModel)
}

class ConfirmPaymentRequestViewController: ViewController {
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var confirmImageView: UIImageView!
    @IBOutlet weak var confirmTextLabel: UILabel!
    
    var notification: NotificationModel?
    var updateViewElementDelegate: UpdateViewElement?
    var delegate: ConfirmPaymentRequestDelegate?

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
        
        self.requestProxy.requestService()?.delegate = self
    }
}

extension ConfirmPaymentRequestViewController {
    
    func setupView() {
        self.topView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.closeViewGest(_:))))
    }
    
    func localized() {
    }
    
    func setupData() {
        if let notif = self.notification {
            if let message = notif.message, let imageURL = notif.sendByUserImageLocation {
                
                imageURL.getImageFromURLString { (status, image) in
                    if status, let img = image {
                        self.confirmImageView.image = img
                    }
                }
                self.confirmTextLabel.text = message
            }
        }
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension ConfirmPaymentRequestViewController {
    
    @IBAction func closeAction(_ sender: UIButton) {
        self.closeView(false)
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        
        if let notif = self.notification {
            self.showConfirmation(message: "you want to cancel this notification?") {
                
                self.delegate?.didTapCancelButton(notification: notif)
                self.dismiss(animated: true)
                
//                self.requestProxy.requestService()?.cancelPaymentRequests(id: refID) { (status, response) in
//                    if status {
//                        DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
//                            self.requestProxy.requestService()?.removeNotification(id: id, completion: { (status, response) in
//                                if status {
//                                    DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
//                                        self.closeView(true, data: response?.message ?? "Payment request Canceled successfully")
//                                    }
//                                }
//                            })
//                        }
//                    }
//                }
            }
        }
    }

    @IBAction func payAction(_ sender: UIButton) {
        
        if let notif = self.notification {
            self.delegate?.didTapPayButton(notification: notif)
            self.dismiss(animated: true)
            
//            if let presentingView = self.presentingViewController?.children.last as? NotificationsViewController {
//
//                self.closeView(false)
//
//                let vc = Views.ConfirmPinCodeViewController.storyboardView as! ConfirmPinCodeViewController
//                vc.notification = notif
//                vc.parentView = self
//                vc.updateViewElementDelegate = presentingView
//                presentingView.present(vc, animated: true)
//            }
        }
    }
}

// MARK: - REQUESTS DELEGATE

extension ConfirmPaymentRequestViewController: RequestsDelegate {

    func requestStarted(request: RequestType) {
        if request == .cancelPaymentRequests || request == .confirmPaymentRequests || request == .removeNotification {
            showLoadingView(self)
        }
    }

    func requestFinished(request: RequestType, result: ResponseResult) {
        hideLoadingView()
        
        switch result {
        case .Success(_):
            
            break
        case .Failure(let errorType):
            DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                if let presentingView = self.presentingViewController?.children.last as? NotificationsViewController {
                    
                    self.closeView(false)
                    
                    switch errorType {
                    case .Exception(let exc):
                        if showUserExceptions {
                            presentingView.showErrorMessage(exc)
                        }
                        break
                    case .AlamofireError(let err):
                        if showAlamofireErrors {
                            presentingView.showSnackMessage(err.localizedDescription)
                        }
                        break
                    case .Runtime(_):
                        break
                    }
                }
            }
        }
    }
}

// MARK: - UPDATE VIEW ELEMENTS DELEGATE

extension ConfirmPaymentRequestViewController: UpdateViewElement {
    
    func elementUpdated(fromSourceView view: UIViewController, status: Bool, data: Any?) {
        
        if view is ConfirmPinCodeViewController {
            self.closeView(true)
        }
    }
}

// MARK: - PRIVATE FUNCTIONS

extension ConfirmPaymentRequestViewController {

    @objc private func closeViewGest(_ gesture: UIGestureRecognizer) {
        self.closeView(false)
    }
    
    private func closeView(_ status: Bool, data: Any? = nil) {
        self.dismiss(animated: true)
        self.updateViewElementDelegate?.elementUpdated(fromSourceView: self, status: status, data: data)
    }
}
