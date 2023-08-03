//
//  AddBeneficiaryViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 13/02/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit

class AddBeneficiaryViewController: MainController {

    @IBOutlet weak var containerViewDesign: ViewDesign!
    
    @IBOutlet weak var qpanTextField: UITextField!
    @IBOutlet weak var qpanErrorLabel: UILabel!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!

    var beneficiary: Beneficiary?
    var qpan: String?
    
    private let qpanMaxDigit = 19
    private let spacingChar: Character = " "
    
    private var isCompleteQPAN = false {
        didSet {
            UIView.animate(withDuration: 0.3) {
//                self.qpanErrorLabel.isHidden = self.isCompleteQPAN
            }
        }
    }
    
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
        
        guard let qpan = self.qpan else { return }
        self.qpanTextField.text = qpan.chunkFormatted(withSeparator: self.spacingChar)
        
        self.requestProxy.requestService()?.getBeneficiaryByQPAN(qpan, completion: { status, beneficiary in
            guard status,
                  let ben = beneficiary else {
                return
            }
            self.setBeneficiaryToFields(ben, fromScanView: false)
        })
    }
}

extension AddBeneficiaryViewController {
    
    func setupView() {
        self.containerViewDesign.setViewCorners([.topLeft, .topRight])
        
        self.qpanTextField.delegate = self
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension AddBeneficiaryViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func scanAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(QRScannerViewController.self)
        vc.updateElementDelegate = self
        vc.isVendexView = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        guard let ben = self.beneficiary, let id = ben.userID else { return }
        
        self.requestProxy.requestService()?.addBeneficiary(id: id, completion: { (status, response) in
            guard status else { return }
            
            self.navigationController?.popViewController(animated: true)
            self.showSuccessMessage(response?.message ?? "Beneficiary added successfully!")
        })
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - UPDATE VIEW DELEGATE

extension AddBeneficiaryViewController: UpdateViewElement {
    
    func elementUpdated(fromSourceView view: UIViewController, status: Bool, data: Any?) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
            guard view is QRScannerViewController,
                  let code = data as? String else {
                return
            }
            
            self.requestProxy.requestService()?.getBeneficiaryByQRCode(code, completion: { (status, resBeneficiary) in
                guard status else { return }
                guard let ben = resBeneficiary else { return }
                self.setBeneficiaryToFields(ben, fromScanView: true)
            })
        }
    }
}

// MARK: - REQUESTS DELEGATE

extension AddBeneficiaryViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .getBeneficiaryByQPAN ||
           request == .getBeneficiaryByQRCode ||
            request == .addBeneficiary {
            showLoadingView(self)
        }
    }
    
    func requestFinished(request: RequestType, result: ResponseResult) {
        self.hideLoadingView()
        
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

// MARK: - TEXT FIELD DELEGATE

extension AddBeneficiaryViewController: UITextFieldDelegate {
    
    // Niji QPAN number =>> 1456 4567 8902 0006
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard string.compactMap({ Int(String($0)) }).count ==
                string.count else { return false }
        
        let text = textField.text ?? ""
        
        if string.count == 0 {
            textField.text = String(text.dropLast()).chunkFormatted(withSeparator: self.spacingChar)
            
        } else {
            let newText = String((text + string)
                                    .filter({ $0.isNumber }).prefix(self.qpanMaxDigit))
            var finalText = newText.chunkFormatted(withSeparator: self.spacingChar)
            
            if finalText.count <= self.qpanMaxDigit {
                textField.text = finalText
                
                if finalText.count == self.qpanMaxDigit {
                    self.view.endEditing(true)
                    finalText.removeAll(where: { $0.isWhitespace })
                    self.requestProxy.requestService()?.getBeneficiaryByQPAN(finalText, completion: { (status, beneficiary) in
                        guard status,
                              let ben = beneficiary else {
                            return
                        }
                        self.setBeneficiaryToFields(ben, fromScanView: false)
                    })
                }
            }
        }
        return false
    }
}

// MARK: - CUSTOM FUNCTIONS

extension AddBeneficiaryViewController {
    
    private func setBeneficiaryToFields(_ ben: Beneficiary, fromScanView status: Bool) {
        self.beneficiary = ben
        if status {
            self.qpanTextField.text = ben.qpan ?? ""
        }
        self.firstNameTextField.text = ben.firstName ?? ""
        self.lastNameTextField.text = ben.lastName ?? ""
        self.mobileTextField.text = ben._mobileNumber
        self.emailTextField.text = ben._emailAddress
    }
}
