//
//  PayViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/10/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class PayViewController: MainController {
    
    @IBOutlet weak var ammountTextField: UITextField!
    @IBOutlet weak var balanceLabel: UILabel!
    
    private let imagePicker = UIImagePickerController()
    
    var qrCode: String?
    
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

        self.requestProxy.requestService()?.getUserBalance { (status, balance) in
            guard status,
                  let blnc = balance else {
                      return
                  }
            self.balanceLabel.text = blnc.formatNumber()
        }
    }
}

extension PayViewController {
    
    func setupView() {
        self.ammountTextField.delegate = self
        self.imagePicker.delegate = self
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension PayViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func scanQRCodeAction(_ sender: UIButton) {
        
        guard let amount = self.ammountTextField.text,
              amount.isNotEmpty else {
                  self.showErrorMessage("Please Enter Noqs")
                  return
              }
        
        if let _ = Double(amount) {
            let vc = self.getStoryboardView(QRScannerViewController.self)
            vc.updateElementDelegate = self
            self.present(vc, animated: true)
        }
    }
    
    @IBAction func uploadAction(_ sender: UIButton) {
        guard let amount = self.ammountTextField.text,
              amount.isNotEmpty else {
                  self.showErrorMessage("Please Enter Noqs")
                  return
              }
        
        if let _ = Double(amount) {
            
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }

    @IBAction func confirmAction(_ sender: UIButton) {
        
        guard let qr = self.qrCode else { return }
        guard let amount = self.ammountTextField.text,
              amount.isNotEmpty else {
                  self.showErrorMessage("Please Enter Noqs")
                  return
              }
        
        guard let amm = Double(amount) else { return }
        
        self.requestProxy.requestService()?.payFromQRCode(amount: amm, QRCode: qr) { (status, transfer) in
            guard status,
                  let trans = transfer else {
                      return
                  }
            DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                let vc = self.getStoryboardView(ConfirmTransferViewController.self)
                vc.transfer = trans
                vc.parentView = self
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

// MARK: - IMAGE PICKER DELEGATE

extension PayViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage else { return }
        // print out the image size as a test
//        print(image.size)
        
        guard let features = image.detectQRCode(),
              !features.isEmpty else {
                  return
              }
        
        for case let row as CIQRCodeFeature in features {
            if let code = row.messageString {
                self.qrCode = code
                self.showSuccessMessage("QRCode is ready to pay")
            }
        }
    }
}

// MARK: - UPDATE PROFILE IMAGE DELEGATE

extension PayViewController: UpdateViewElement {
    
    func elementUpdated(fromSourceView view: UIViewController, status: Bool, data: Any?) {

        self.viewWillAppear(true)
        
        if view is QRScannerViewController {
            if let code = data as? String {
                self.qrCode = code
                self.showSuccessMessage("QRCode is ready to pay")
            }
        }
    }
}

// MARK: - REQUESTS DELEGATE

extension PayViewController: RequestsDelegate {

    func requestStarted(request: RequestType) {
        if request == .payFromQRCode {
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

// MARK: - TEXT FIELD DELEGATE

extension PayViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= ammountFieldsMaxLength
    }
}
