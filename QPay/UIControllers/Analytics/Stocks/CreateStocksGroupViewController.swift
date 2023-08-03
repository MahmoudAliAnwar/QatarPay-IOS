//
//  CreateStocksGroupViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 20/06/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import UIKit


class CreateStocksGroupViewController: PhoneBillsController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var errorImage: UIImageView!
    

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

extension CreateStocksGroupViewController {
    
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

extension CreateStocksGroupViewController {
    
    @IBAction func dismissAction(_ sender: UIButton) {
        self.closeView(isSuccess: false)
    }
    
    @IBAction func createGroupAction(_ sender: UIButton) {
        
        guard let name = self.nameTextField.text, name.isNotEmpty else {
            self.showHideNotEmptyError(self.nameTextField.text!.isNotEmpty)
            return
        }
        
        self.requestProxy.requestService()?.saveStocksGroup(groupName: name) { (status, response) in
            guard status == true else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                self.closeView(isSuccess: true)
                
                guard let presenting = self.presentingViewController?.children.last as? AddStockViewController else {
                    return
                }
                presenting.showSuccessMessage(response?.message)
            }
        }
    }
}

// MARK: - REQUESTS DELEGATE

extension CreateStocksGroupViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .saveStocksGroup {
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

extension CreateStocksGroupViewController {
    
    private func closeView(isSuccess: Bool) {
        self.updateViewDelegate?.elementUpdated(fromSourceView: self, status: isSuccess, data: nil)
        self.dismiss(animated: true)
    }
    
    private func showHideNotEmptyError(_ isNotEmpty: Bool) {
        self.errorImage.image = isNotEmpty ? .none : .errorCircle
    }
}
