//
//  AddTravelCardViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/5/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class AddTravelCardViewController: MetroRailController {
    
    @IBOutlet weak var firstTextField: UITextField!
    
    @IBOutlet weak var secondTextField: UITextField!
    
    @IBOutlet weak var thirdTextField: UITextField!
    
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

extension AddTravelCardViewController {
    
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

extension AddTravelCardViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        guard let firstText = self.firstTextField.text,
              firstText.isNotEmpty,
              let secondText = self.secondTextField.text,
              secondText.isNotEmpty,
              let thirdText = self.thirdTextField.text,
              thirdText.isNotEmpty else {
            self.showSnackMessage("Please, enter card numebr")
            return
        }
        
        let number = "\(firstText)\(secondText)\(thirdText)"
        
        self.requestProxy.requestService()?.addMetroCard(cardNumber: number, completion: { status, response in
            guard status else { return }
            guard let parent = self.navigationController?.getPreviousView() as? MetroRailCardsViewController else {
                return
            }
            parent.updateClosure = (true, response?._message ?? "Card added successfully")
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        self.backAction(sender)
    }
}

// MARK: - REQUESTS DELEGATE

extension AddTravelCardViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .addMetroCard {
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

extension AddTravelCardViewController {
    
}

