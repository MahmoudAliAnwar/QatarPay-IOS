//
//  PhoneBillsViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/6/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class PhoneBillsViewController: PhoneBillsController {
    
    @IBOutlet weak var containerViewDesign: ViewDesign!
    
    var numbers = [String]()
    
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
    }
}

extension PhoneBillsViewController {
    
    func setupView() {
        self.containerViewDesign.setViewCorners([.topLeft, .topRight])
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension PhoneBillsViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func ooredooAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(PhoneOoredooViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func vodafoneAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(PhoneVodafoneViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - REQUESTS DELEGATE

extension PhoneBillsViewController: RequestsDelegate {

    func requestStarted(request: RequestType) {
        if request == .getGroupListWithPhoneNumbers {
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

// MARK: - CUSTOM FUNCTION

extension PhoneBillsViewController {
    
}
