//
//  RefillWalletViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/6/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

// api/NoqoodyUser/NoqsTransferTopupRequest
// Mahmoud ALi

class RefillWalletViewController: MainController {

    @IBOutlet weak var amountCollectionView: UICollectionView!
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var balanceLabel: UILabel!
    
    var amounts = [Amount]()
    
    var selectedIndex: IndexPath!
    var profile: Profile?

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

        self.requestProxy.requestService()?.getUserBalance { (status, balance) in
            if status,
               let blnc = balance {
                self.balanceLabel.text = blnc.formatNumber()
            }
        }
        
        self.requestProxy.requestService()?.getUserProfile ( weakify { strong, myProfile in
            guard let prof = myProfile else { return }
            self.profile = prof
        })
    }
}

extension RefillWalletViewController {
    
    func setupView() {
        self.amountTextField.delegate = self
        
        self.amountCollectionView.dataSource = self
        self.amountCollectionView.delegate = self
        
        self.amountCollectionView.registerNib(AmmountCollectionViewCell.self)
        
        self.amountTextField.addTarget(self, action: #selector(self.textFieldChanged(textField:)), for: .editingChanged)
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
        self.amounts = [50,100,200,300].compactMap({ return Amount(payment: $0) })
        selectedIndex = IndexPath(row: 0, section: 0)
    }
}

// MARK: - ACTIONS

extension RefillWalletViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func topAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(TopUpAccountSettingsViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func bottomAction(_ sender: UIButton) {
        
        guard let prof = profile else {
            self.showErrorMessage("Something went wrong, please try again later")
            return
        }
        guard prof.emailVerified == true else {
            self.showErrorMessage("Please, confirm your email")
            return
        }
        
        var amount: Double = -1
        
        if self.amountTextField.text!.isEmpty {
            amount = self.amounts[self.selectedIndex.row].payment
        }else {
            if let amm = Double(self.amountTextField.text!) {
                amount = amm
            }
        }
        
        guard amount >= 10 && amount <= 300 else {
            self.showErrorMessage("The min wallet top up allowed would be 10 and max would be 300")
            return
        }
        
        let vc = self.getStoryboardView(CheckoutViewController.self)
        vc.amount = amount
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - COLLECTION VIEW DELEGATE

extension RefillWalletViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return amounts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.AmmountCollectionViewCell.rawValue, for: indexPath) as! AmmountCollectionViewCell
        
        let ammount = amounts[indexPath.row]
        cell.setupData(ammount: ammount)
        
        cell.radioButton.isChecked = selectedIndex == indexPath
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath
        self.amountTextField.text?.removeAll()
        collectionView.reloadData()
    }
}

// MARK: - REQUESTS DELEGATE

extension RefillWalletViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .refillWallet {
            showLoadingView(self)
        }
    }
    
    func requestFinished(request: RequestType, result: ResponseResult) {
        hideLoadingView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
            if request == .refillWallet {
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
}

// MARK: - TEXT FIELD DELEGATE

extension RefillWalletViewController: UITextFieldDelegate {
    
    @objc func textFieldChanged(textField: UITextField) {
        
        if let text = textField.text, text.isNotEmpty {
            selectedIndex = IndexPath(row: -1, section: 0)
        }else {
            selectedIndex = IndexPath(row: 0, section: 0)
        }
        self.amountCollectionView.reloadData()
    }

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

// MARK: - CUSTOM FUNCTIONS

extension RefillWalletViewController {
    
}
