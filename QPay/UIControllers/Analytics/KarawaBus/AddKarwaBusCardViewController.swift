//
//  AddKarwaBusCardViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/4/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class AddKarwaBusCardViewController: KarwaBusController {
    
    @IBOutlet weak var oneTextField: UITextField!
    @IBOutlet weak var twoTextField: UITextField!
    @IBOutlet weak var threeTextField: UITextField!

    weak var delegate: UpdateViewElement?
    
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

extension AddKarwaBusCardViewController {
    
    func setupView() {
        self.oneTextField.delegate = self
        self.twoTextField.delegate = self
        self.threeTextField.delegate = self
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension AddKarwaBusCardViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        guard let one = self.oneTextField.text, one.isNotEmpty,
              let two = self.twoTextField.text, two.isNotEmpty,
              let three = self.threeTextField.text, three.isNotEmpty else {
            return
        }
        
        let number = "\(one)\(two)\(three)"
        
        self.requestProxy.requestService()?.addKarwaBusCard(cardNumber: number, completion: { (status, response) in
            guard status else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                self.closeView(status, data: response?.message ?? "")
            }
        })
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        self.backAction(sender)
    }
}

// MARK: - TEXT FIELD DELEGATE

extension AddKarwaBusCardViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let textFieldText = textField.text,
              let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count

        if textField == self.oneTextField ||
            textField == self.twoTextField {
          
            if count == 5 {
                textField.text! += string
                
                if textField == self.oneTextField {
                    self.twoTextField.becomeFirstResponder()
                } else if textField == self.twoTextField {
                    self.threeTextField.becomeFirstResponder()
                }
            }
            return count <= 5
            
        } else if textField == self.threeTextField {
            if count == 1 {
                textField.text! += string
                self.view.endEditing(true)
            }
            return count <= 1
        }
        return false
        
    }
}

// MARK: - REQUESTS DELEGATE

extension AddKarwaBusCardViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .addKarwaBusCard {
            showLoadingView(self)
        }
    }
    
    func requestFinished(request: RequestType, result: ResponseResult) {
        hideLoadingView()
        
        switch result {
        case .Success(_):
            break
        case .Failure(let error):
            switch error {
            case .Exception(let message):
                if showUserExceptions {
                    self.showErrorMessage(message)
                }
                break
            case .AlamofireError(let error):
                if showAlamofireErrors {
                    self.showErrorMessage(error.localizedDescription)
                }
                break
            case .Runtime(_):
                break
            }
        }
    }
}

// MARK: - CUSTOM FUNCTIONS

extension AddKarwaBusCardViewController {
    private func closeView(_ status: Bool, data: Any? = nil) {
        self.delegate?.elementUpdated(fromSourceView: self, status: status, data: data)
        self.navigationController?.popViewController(animated: true)
    }
}
