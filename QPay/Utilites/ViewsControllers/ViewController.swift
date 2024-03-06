//
//  ViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/3/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit
import TTGSnackbar
import DropDown

class ViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    
    var userProfile: UserProfile = UserProfile.shared
    var requestProxy = RequestServiceProxy.shared
    let dispatchGroup = DispatchGroup()
    
    let appDelegate = AppDelegate.shared
    var statusBarView: UIView?
    
    private var loadingView: LoadingViewController!
    private var navigationViewsDropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        self.statusBarView = UIView(frame: UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect(x: 0, y: 0, width: 0, height: 0))
        self.view.addSubview(self.statusBarView!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

extension ViewController {
    
    func setupBackViewsDropDown() {
        /// Navigation stack views in drop down
        if self.backButton != nil {
            self.backButton.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.backLongPressed(_:))))
            
            self.navigationViewsDropDown.anchorView = self.backButton
            
            self.navigationViewsDropDown.topOffset = CGPoint(x: 0, y: self.backButton.bottom)
            self.navigationViewsDropDown.direction = .any
            self.navigationViewsDropDown.dismissMode = .automatic
            
            let views = self.navigationController?.viewControllers ?? []
            for (i, value) in views.enumerated()  {
                if i < views.count-1 {
                    self.navigationViewsDropDown.dataSource.append(String(describing: type(of: value)))
                }
            }
            
            self.navigationViewsDropDown.selectionAction = { [weak self] (index, item) in
                self?.navigationController?.popTo((self?.navigationController?.viewControllers[index].classForCoder)!)
            }
        }
    }
    
    @objc private func backLongPressed(_ gesture: UILongPressGestureRecognizer) {
        self.navigationViewsDropDown.show()
    }
    
    func showLoadingView(_ viewController: UIViewController) {
        self.loadingView = LoadingViewController.loadingView
        guard !self.loadingView.isLoadingViewPresenting else { return }
        
        self.present(self.loadingView, animated: true) {
        }
    }
    
    func hideLoadingView(_ error: String? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
            guard self.loadingView != nil,
                  self.loadingView.isLoadingViewPresenting else {
                return
            }
            self.loadingView.dismiss(animated: true) {
                guard let err = error else { return }
                self.showErrorMessage(err)
            }
        }
    }
    
    func showConfirmation(message: String, _ okCompletion: @escaping voidCompletion) {
        
        let alert = UIAlertController(title: "Are you sure", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            okCompletion()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            
        }))
        self.present(alert, animated: true)
    }
    
    func showSuccessMessage(_ message: String?, closure: (()->())? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
            let vc = self.getStoryboardView(SuccessMessageViewController.self)
            vc.message = message
            vc.closure = closure
            self.present(vc, animated: true)
        }
    }
    
    func showErrorMessage(_ message: String? = nil, buttonTitle: String? = "Try Again",closure: (()->())? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
            let vc = self.getStoryboardView(ErrorMessageViewController.self)
            vc.closure = closure
            vc.tryAgainTitle = buttonTitle
            if let msg = message {
                vc.message = msg
            }
            self.present(vc, animated: true)
        }
    }
    
    func showPaymentPopup(_ remingAmount: Double?, serviceAmount: Double?, bankAmount: Double? ,closure: (()->())? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
            let vc = self.getStoryboardView(PaymentPopup.self)
            vc.closure = closure
            vc.remingAmount = remingAmount
            vc.serviceAmount = serviceAmount
            vc.bankAmount = bankAmount
            self.present(vc, animated: true)
        }
    }
    
    func showSnackMessage(_ message: String, duration: TTGSnackbarDuration = .middle, background: UIColor = .systemRed, textColor: UIColor = .white) {
        let snack = TTGSnackbar(message: message, duration: duration)
        snack.backgroundColor = background
        snack.messageTextColor = textColor
        snack.cornerRadius = 6
        snack.show()
    }
    
    func showSnackMessage(_ message: String, messageStatus: MessageStatus = .Error) {

        let snack: TTGSnackbar

        switch messageStatus {
        case .Warning:
            snack = TTGSnackbar(message: message, duration: .middle)
            snack.backgroundColor = .systemYellow
        case .Error:
            snack = TTGSnackbar(message: message, duration: .middle)
            snack.backgroundColor = .systemRed
        case .Success:
            snack = TTGSnackbar(message: message, duration: .middle)
            snack.backgroundColor = .systemGreen
        }

        snack.cornerRadius = 6
        snack.show()
    }
    
    func changeStatusBarBG(color: UIColor = appBackgroundColor) {
        self.statusBarView!.backgroundColor = color
    }
    
    // MARK: - Unused Function...
    
    func showAlertMessage(message: String,_ okCompletion: voidCompletion? = nil) {

        let alert = UIAlertController.init(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (action) in
            if let comp = okCompletion {
                comp()
            }
        }))
        self.present(alert, animated: true)
    }
}
