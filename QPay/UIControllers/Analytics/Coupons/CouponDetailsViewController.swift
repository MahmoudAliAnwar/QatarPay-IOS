//
//  CouponDetailsViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 15/12/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit

class CouponDetailsViewController: ViewController {
    
    @IBOutlet weak var ticketView: TicketView!
    
    var couponID: Int?
    
    private lazy var ticketDetailsView: TicketDetailsView = {
        return TicketDetailsView()
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
        
        self.changeStatusBarBG(color: .clear)
        
        self.requestProxy.requestService()?.delegate = self
        
        guard let id = self.couponID else { return }
        
        self.requestProxy.requestService()?.getCouponDetails(id, (weakify { strong, list in
            guard let details = list?.first else { return }
            strong.ticketDetailsView.object = details
        }))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.ticketDetailsView.frame = self.ticketView.bounds
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension CouponDetailsViewController {
    
    func setupView() {
        self.ticketView.includedView = ticketDetailsView
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension CouponDetailsViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - REQUESTS DELEGATE

extension CouponDetailsViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .getCouponDetails {
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

extension CouponDetailsViewController {
    
}
