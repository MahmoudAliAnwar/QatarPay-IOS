//
//  CreatePhoneBillsGroupViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/6/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class CreatePhoneBillsGroupViewController: PhoneBillsController {
    
    @IBOutlet weak var nameTextField: UITextField!
    
    var operatorType: AddPhoneBillsCardViewController.OperatorTypes?
    
    var updateViewDelegate: UpdateViewElement?
    
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

extension CreatePhoneBillsGroupViewController {
    
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

extension CreatePhoneBillsGroupViewController {
    
    @IBAction func dismissAction(_ sender: UIButton) {
        self.closeView(isSuccess: false)
    }

    @IBAction func createGroupAction(_ sender: UIButton) {
        
        guard let name = self.nameTextField.text, name.isNotEmpty,
              let type = self.operatorType else {
            return
        }
        
        self.requestProxy.requestService()?.savePhoneUserGroups(groupName: name, operatorID: type.rawValue) { (status, response) in
            guard status == true else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                self.closeView(isSuccess: true)
                
                guard let presenting = self.presentingViewController?.children.last as? AddPhoneBillsCardViewController else {
                    return
                }
                presenting.showSuccessMessage(response?.message)
            }
        }
    }
}

// MARK: - REQUESTS DELEGATE

extension CreatePhoneBillsGroupViewController: RequestsDelegate {

    func requestStarted(request: RequestType) {
        if request == .savePhoneUserGroups {
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

extension CreatePhoneBillsGroupViewController {

    private func closeView(isSuccess: Bool) {
        self.updateViewDelegate?.elementUpdated(fromSourceView: self, status: isSuccess, data: nil)
        self.dismiss(animated: true)
    }
}
