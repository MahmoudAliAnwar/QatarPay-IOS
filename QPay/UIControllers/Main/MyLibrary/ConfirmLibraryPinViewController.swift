//
//  ConfirmLibraryPinViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 10/25/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class ConfirmLibraryPinViewController: ViewController {

    @IBOutlet weak var code1TextField: UITextField!
    @IBOutlet weak var code2TextField: UITextField!
    @IBOutlet weak var code3TextField: UITextField!
    @IBOutlet weak var code4TextField: UITextField!
    @IBOutlet weak var codeErrorLabel: UILabel!
    
    var updateViewElementDelegate: UpdateViewElement?
    
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
        
    }
}

extension ConfirmLibraryPinViewController {
    
    func setupView() {
        
        self.code1TextField.addTarget(self, action: #selector(self.textFieldDidBegin(_:)), for: .editingDidBegin)
        self.code2TextField.addTarget(self, action: #selector(self.textFieldDidBegin(_:)), for: .editingDidBegin)
        self.code3TextField.addTarget(self, action: #selector(self.textFieldDidBegin(_:)), for: .editingDidBegin)
        self.code4TextField.addTarget(self, action: #selector(self.textFieldDidBegin(_:)), for: .editingDidBegin)
        
        self.code1TextField.addTarget(self, action: #selector(self.textField1DidChange(_:)), for: .editingChanged)
        self.code2TextField.addTarget(self, action: #selector(self.textField2DidChange(_:)), for: .editingChanged)
        self.code3TextField.addTarget(self, action: #selector(self.textField3DidChange(_:)), for: .editingChanged)
        self.code4TextField.addTarget(self, action: #selector(self.textField4DidChange(_:)), for: .editingChanged)
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension ConfirmLibraryPinViewController {

    @IBAction func closeAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func proceedAction(_ sender: UIButton) {
        
        if let cd1 = self.code1TextField.text, cd1.isNotEmpty,
           let cd2 = self.code2TextField.text, cd2.isNotEmpty,
           let cd3 = self.code3TextField.text, cd3.isNotEmpty,
           let cd4 = self.code4TextField.text, cd4.isNotEmpty {
            
            let fullCode = "\(cd1)\(cd2)\(cd3)\(cd4)"
            
            self.requestProxy.requestService()?.verifyPin(pin: fullCode, completion: { (status, response) in
                if status {
                    DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                        self.updateViewElementDelegate?.elementUpdated(fromSourceView: self, status: true, data: nil)
                        self.dismiss(animated: true)
                    }
                }
            })
        }
    }
}

// MARK: - TEXT FIELD DELEGATE

extension ConfirmLibraryPinViewController {

    @objc func textFieldDidBegin(_ textField : UITextField) {
        textField.text?.removeAll()
    }
    
    @objc func textField1DidChange(_ textField : UITextField) {
        
        if textField == self.code1TextField {
            if let code1 = self.code1TextField.text, code1.isNotEmpty {
                
                if code1.count == 1 {
                    self.code2TextField.becomeFirstResponder()
                }
            }
        }
    }
    
    @objc func textField2DidChange(_ textField : UITextField) {
        
        if textField == self.code2TextField {
            if let code2 = self.code2TextField.text, code2.isNotEmpty {
                
                if code2.count == 1 {
                    self.code3TextField.becomeFirstResponder()
                }
            }
        }
    }
    
    @objc func textField3DidChange(_ textField : UITextField) {
        
        if textField == self.code3TextField {
            if let code3 = self.code3TextField.text, code3.isNotEmpty {
                
                if code3.count == 1 {
                    self.code4TextField.becomeFirstResponder()
                }
            }
        }
    }
    
    @objc func textField4DidChange(_ textField : UITextField) {
        
        if textField == self.code4TextField {
            if let code4 = self.code4TextField.text, code4.isNotEmpty {
                
                if code4.count == 1 {
                    self.view.endEditing(true)
//                    if let parent = self.parentView {
//                        if parent is MyCardsViewController {
                    
//                        }
//                    }
                }
            }
        }
    }
}

// MARK: - PRIVATE FUNCTIONS

extension ConfirmLibraryPinViewController {
    
}
