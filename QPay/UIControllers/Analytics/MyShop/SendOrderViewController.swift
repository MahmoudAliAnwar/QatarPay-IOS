//
//  SendOrderViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/6/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit
import MessageUI

class SendOrderViewController: ShopController {
    
    @IBOutlet weak var emailBackgroundImageView: UIImageView!
    @IBOutlet weak var emailBackgroundView: UIView!
    @IBOutlet weak var emailIconImageView: UIImageView!
    @IBOutlet weak var emailTitleLabel: UILabel!
    
    @IBOutlet weak var linkBackgroundImageView: UIImageView!
    @IBOutlet weak var linkBackgroundView: UIView!
    @IBOutlet weak var linkIconImageView: UIImageView!
    @IBOutlet weak var linkTitleLabel: UILabel!
    
    @IBOutlet weak var redSendButton: UIButton!
    @IBOutlet weak var graySendButton: UIButton!
    
    var updateViewElement: UpdateViewElement?
    
    var link: String?
    var customerEmail: String?
    var order: Order?
    var shopID: Int?
    var orderID: Int?
    
    var emailToggleVar = false {
        willSet {
            self.emailToggleBtn(newValue)
        }
    }
    
    var linkToggleVar = false {
        willSet {
            self.linkToggleBtn(newValue)
        }
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
        
        self.statusBarView?.isHidden = true
        
        self.requestProxy.requestService()?.delegate = self
    }
}

extension SendOrderViewController {
    
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

extension SendOrderViewController {
    
    @IBAction func dismissAction(_ sender: UIButton) {
        self.closeView(false)
    }
    
    @IBAction func emailAction(_ sender: UIButton) {
        self.emailToggleVar.toggle()
        self.linkToggleVar = false
    }
    
    @IBAction func linkAction(_ sender: UIButton) {
        self.linkToggleVar.toggle()
        self.emailToggleVar = false
    }
    
    @IBAction func sendAction(_ sender: UIButton) {
        
        guard let link = self.link else { return }
        if self.emailToggleVar {
            
            let orderId: Int = self.orderID ?? self.order?.id ?? -1
            
            guard orderId > 0,
                  let orderNumber = self.order?.orderNumber,
                  let shopId = self.shopID else {
                self.showErrorMessage("Something went wrong!")
                return
            }
            
            self.requestProxy.requestService()?.resendOrder(orderId, shopID: shopId, orderNumber: orderNumber, completion: { (status, response) in
                guard status else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                    if let parentView = self.presentingViewController?.children.last as? ShopController {
                        self.closeView(true)
                        parentView.navigationController?.popTo(MyProductsViewController.self, onFailure: {
                            parentView.navigationController?.popViewController(animated: true)
                        })
                        
                        parentView.showSuccessMessage(response?.message ?? "Order sent successfully")
                    }
                }
            })
            
        }else if self.linkToggleVar {
            openShareDialog(sender: self.view, data: [link]) { isCompleted in
                guard isCompleted else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                    if let parentView = self.presentingViewController?.children.last as? ShopController {
                        self.closeView(true)
                        parentView.navigationController?.popTo(MyProductsViewController.self, onFailure: {
                            parentView.navigationController?.popViewController(animated: true)
                        })
                    }
                }
            }
        }
    }
}

// MARK: - REQUESTS DELEGATE

extension SendOrderViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .resendOrder {
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

// MARK: - PRIVATE FUNCTIONS

extension SendOrderViewController {
    
    private func closeView(_ status: Bool) {
        self.updateViewElement?.elementUpdated(fromSourceView: self, status: status, data: nil)
        self.dismiss(animated: true)
    }

    private func emailToggleBtn(_ status: Bool) {
        
        UIView.animate(withDuration: 0.3) {
            
            let whiteImage = Images.ic_email_white_send_invoice.image
            let redImage = Images.ic_email_red_send_invoice.image
            
            self.emailBackgroundImageView.isHidden = status
            self.emailBackgroundView.isHidden = !status
            
            self.emailTitleLabel.textColor = status ? .white : .mLight_Gray
            self.emailIconImageView.image = status ? whiteImage : redImage
        }
        self.setButtonsToggle()
    }
    
    private func linkToggleBtn(_ status: Bool) {
        
        UIView.animate(withDuration: 0.3) {
            
            let whiteImage = Images.ic_link_white_send_invoice.image
            let redImage = Images.ic_link_red_send_invoice.image
            
            self.linkBackgroundImageView.isHidden = status
            self.linkBackgroundView.isHidden = !status
            
            self.linkTitleLabel.textColor = status ? .white : .mLight_Gray
            self.linkIconImageView.image = status ? whiteImage : redImage
        }
        self.setButtonsToggle()
    }
    
    private func setButtonsToggle() {
        
        let condition = self.emailToggleVar == true || self.linkToggleVar == true
        
        self.redSendButton.isHidden = !condition
        self.graySendButton.isHidden = condition
    }
    
    private func createEmailUrl(to: String, subject: String, body: String) -> URL? {
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!

        let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
        let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")

        if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
            return gmailUrl
        } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
            return outlookUrl
        } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
            return yahooMail
        } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
            return sparkUrl
        }

        return defaultUrl
    }
}
