//
//  VodafoneAccountViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/10/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class VodafoneAccountViewController: MainController {
    
    @IBOutlet weak var accountNameTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var isDefaultAccountCheckBox: CheckBox!
    
    var isDefaultAccount = false
    
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

extension VodafoneAccountViewController {
    
    func setupView() {
        self.isDefaultAccountCheckBox.style = .tick
        self.isDefaultAccountCheckBox.borderStyle = .square
        self.isDefaultAccountCheckBox.borderWidth = 1
        
        self.isDefaultAccountCheckBox.addTarget(self,
                                                action: #selector(onCheckBoxValueChange(_:)),
                                                for: .valueChanged)
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension VodafoneAccountViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func saveAccountAction(_ sender: UIButton) {
        
    }
    
    @IBAction func setDefaultAccountAction(_ sender: UIButton) {
        self.isDefaultAccountCheckBox.isChecked.toggle()
        self.changeCheckBoxStatus(self.isDefaultAccountCheckBox.isChecked)
    }
    
    @objc func onCheckBoxValueChange(_ sender: CheckBox) {
        self.changeCheckBoxStatus(sender.isChecked)
    }
    
    private func changeCheckBoxStatus(_ status: Bool) {
        self.isDefaultAccount = status
    }
}

// MARK: - REQUESTS DELEGATE

extension VodafoneAccountViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .paymentRequests {
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

extension VodafoneAccountViewController {
    
}
