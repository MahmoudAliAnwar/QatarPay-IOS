//
//  EditBalanceViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/10/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class EditBalanceViewController: MainController {
    
    @IBOutlet weak var maxPerDayTextField: UITextField!
    @IBOutlet weak var maxPerDayErrorImageView: UIImageView!
    @IBOutlet weak var maxPerMonthTextField: UITextField!
    @IBOutlet weak var maxPerMonthErrorImageView: UIImageView!
    @IBOutlet weak var notLessThanTextField: UITextField!
    @IBOutlet weak var notLessThanErrorImageView: UIImageView!
    
    var updateViewDelegate: UpdateViewElement?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

extension EditBalanceViewController {
    
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

extension EditBalanceViewController {
    
    @IBAction func dismissAction(_ sender: UIButton) {
        self.closeView(false)
    }

    @IBAction func saveChangesAction(_ sender: UIButton) {
        
        guard self.checkViewFieldsErrors() else { return }
        
        guard let maxDayString = self.maxPerDayTextField.text, maxDayString.isNotEmpty,
              let maxMonthString = self.maxPerMonthTextField.text, maxMonthString.isNotEmpty,
              let lessThanString = self.notLessThanTextField.text, lessThanString.isNotEmpty else {
            return
        }
        
        guard let maxDay = Double(maxDayString.convertedDigitsToLocale()),
              let maxMonth = Double(maxMonthString.convertedDigitsToLocale()),
              let lessThan = Double(lessThanString.convertedDigitsToLocale()) else {
            return
        }
        
        self.requestProxy.requestService()?.updateTopupSettings(maxPerDay: maxDay,
                                                 maxPerMonth: maxMonth,
                                                 defaultTopup: lessThan) { (status, response) in
            guard status else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                guard let parent = self.presentingViewController?.children.last as? TopUpAccountSettingsViewController else {
                    return
                }
                self.closeView(true)
                parent.showSuccessMessage(response?.message ?? "")
            }
        }
    }
}

// MARK: - REQUESTS DELEGATE

extension EditBalanceViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .updateTopupSettings {
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

extension EditBalanceViewController {
    
    private func checkViewFieldsErrors() -> Bool {
        
        let isMaxPerDayNotEmpty = self.maxPerDayTextField.text!.isNotEmpty
        self.showHideMaxPerDayError(isMaxPerDayNotEmpty)
        
        let isMaxPerMonthNotEmpty = self.maxPerMonthTextField.text!.isNotEmpty
        self.showHideMaxPerMonthError(isMaxPerMonthNotEmpty)
        
        let isNotLessThanNotEmpty = self.notLessThanTextField.text!.isNotEmpty
        self.showHideNotLessThanError(isNotLessThanNotEmpty)
        
        return isMaxPerDayNotEmpty && isMaxPerMonthNotEmpty && isNotLessThanNotEmpty
    }
    
    private func showHideMaxPerDayError(_ isNotEmpty: Bool) {
        self.maxPerDayErrorImageView.image = isNotEmpty ? .none : .errorCircle
    }
    
    private func showHideMaxPerMonthError(_ isNotEmpty: Bool) {
        self.maxPerMonthErrorImageView.image = isNotEmpty ? .none : .errorCircle
    }
    
    private func showHideNotLessThanError(_ isNotEmpty: Bool) {
        self.notLessThanErrorImageView.image = isNotEmpty ? .none : .errorCircle
    }
    
    private func closeView(_ status: Bool) {
        self.dismiss(animated: true)
        self.updateViewDelegate?.elementUpdated(fromSourceView: self, status: status, data: nil)
    }
}
