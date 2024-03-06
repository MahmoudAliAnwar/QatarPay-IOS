//
//  SubscriptionFeeViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 16/03/2022.
//  Copyright © 2022 Dev. Mohmd. All rights reserved.
//

import UIKit

class SubscriptionFeeViewController: ViewController {
    
    @IBOutlet weak var label: UILabel!
    
    var onCompleteClousre: ((Bool) -> Void)?
    
    var shopID: Int?
    var response: BaseResponse?
    
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

extension SubscriptionFeeViewController {
    
    func setupView() {
    }
    
    func localized() {
    }
    
    func setupData() {
        guard let resp = self.response else { return }
        
        let attributedText = NSMutableAttributedString(string: "Your Monthly Subscription Fee ", attributes: [
            .foregroundColor : UIColor.mBrown,
        ])
        attributedText.append(NSAttributedString(string: "(\(resp._subscriptionFee) QR)", attributes: [
            .foregroundColor : UIColor.mYellow,
        ]))
        attributedText.append(NSAttributedString(string: " is Due on ", attributes: [
            .foregroundColor : UIColor.mBrown,
        ]))
        
        if let date = resp._dueDate.formatToDate(.Server3) {
            attributedText.append(NSAttributedString(string: "(\(date.formatDate("dd MMMM")))", attributes: [
                .foregroundColor : UIColor.mYellow,
            ]))
        }
        self.label.attributedText = attributedText
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension SubscriptionFeeViewController {
    
    @IBAction func closeAction(_ sender: UIButton) {
        guard let parent = self.presentingViewController?.children.last as? PreviewOrderViewController else {
            return
        }
        self.dismiss(animated: true) {
            parent.viewWillAppear(true)
        }
    }
    
    @IBAction func payNowAction(_ sender: UIButton) {
        guard let id = self.shopID else { return }
        self.requestProxy.requestService()?.subscriptionCharges(shopID: id, completion: { status, response in
            DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                self.dismiss(animated: true) {
                    self.onCompleteClousre?(status)
                }
            }
        })
    }
}

// MARK: - REQUESTS DELEGATE

extension SubscriptionFeeViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .subscriptionCharges {
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

// MARK: - CUSTOM FUNCTIONS

extension SubscriptionFeeViewController {
    
}
