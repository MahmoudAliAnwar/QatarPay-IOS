//
//  ConfirmPaymentRequestViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/15/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class RemovePaymentRequestViewController: ViewController {
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var confirmImageView: UIImageView!
    @IBOutlet weak var confirmTextLabel: UILabel!
    
    var notification: NotificationModel?
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
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension RemovePaymentRequestViewController {
    
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

extension RemovePaymentRequestViewController {
    
    @IBAction func removeNotificationAction(_ sender: UIButton) {
        
        if let notif = self.notification, let id = notif.id {
            self.requestProxy.requestService()?.removeNotification(id: id) { (status, response) in
                if status {
                    DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                        if let presentingView = self.presentingViewController?.children.last as? NotificationsViewController {
                            self.closeView(true)
                            presentingView.showSuccessMessage(response?.message ?? "Notification removed successfully")
                        }
                    }
                }
            }
        }
    }
}

// MARK: - REQUESTS DELEGATE

extension RemovePaymentRequestViewController: RequestsDelegate {

    func requestStarted(request: RequestType) {
        if request == .removeNotification {
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
                    self.dismiss(animated: true)
                    
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

extension RemovePaymentRequestViewController: UpdateViewElement {
    
    func elementUpdated(fromSourceView view: UIViewController, status: Bool, data: Any?) {
        if view is ConfirmPinCodeViewController {
            self.closeView(true)
        }
    }
}

// MARK: - PRIVATE FUNCTIONS

extension RemovePaymentRequestViewController {

    @objc private func closeViewGest(_ gesture: UIGestureRecognizer) {
        self.closeView(false)
    }
    
    private func closeView(_ status: Bool) {
        self.dismiss(animated: true)
        self.updateViewElementDelegate?.elementUpdated(fromSourceView: self, status: status, data: nil)
    }
}

