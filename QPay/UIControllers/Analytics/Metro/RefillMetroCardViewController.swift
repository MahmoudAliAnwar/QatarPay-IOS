//
//  RefillMetroCardViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/5/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class RefillMetroCardViewController: MetroRailController {
    
    @IBOutlet weak var cardBalanceLabel: UILabel!
    
    @IBOutlet weak var cardNumberLabel: UILabel!
    
    @IBOutlet weak var cardImageViewDesign: ImageViewDesign!
    
    @IBOutlet weak var amountCollectionView: UICollectionView!
    
    @IBOutlet weak var amountTextField: UITextField!
    
    var card: MetroCard?
    var amounts = [Amount]()
    
    private var selectedIndex: IndexPath!

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

extension RefillMetroCardViewController {
    
    func setupView() {
        self.amountCollectionView.delegate = self
        self.amountTextField.delegate = self
        self.amountCollectionView.registerNib(AmmountCollectionViewCell.self)
        
        self.amountTextField.addTarget(self, action: #selector(self.textFieldChanged(textField:)), for: .editingChanged)
    }
    
    func localized() {
    }
    
    func setupData() {
        self.amounts = [10,15,20,25,30,35,40,45,50].compactMap({ return Amount(payment: $0) })
        selectedIndex = IndexPath(row: 0, section: 0)
    }
    
    func fetchData() {
        guard let card = self.card else { return }
        self.cardImageViewDesign.kf.setImage(with: URL(string: card._thumbnail))
        
        self.cardBalanceLabel.text = "QAR \(card._balance.formatNumber())"
        self.cardNumberLabel.text = card._number
    }
}

// MARK: - ACTIONS

extension RefillMetroCardViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func proceedAction(_ sender: UIButton) {
        
        guard let number = self.card?._number else { return }
        
        var amount: Double = -1
        
        if self.amountTextField.text!.isEmpty {
            amount = self.amounts[self.selectedIndex.row].payment
        }else {
            guard let amm = Double(self.amountTextField.text!) else { return }
            amount = amm
        }
        
        guard amount > 0 else { return }
        
        self.sendRefillMetro(amount, cardNumber: number)
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        self.navigationController?.popTo(MetroRailViewController.self)
    }
}

// MARK: - COLLECTION VIEW DELEGATE

extension RefillMetroCardViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return amounts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(AmmountCollectionViewCell.self, for: indexPath)
        
        let amount = amounts[indexPath.row]
        cell.setupData(ammount: amount)
        
        cell.radioButton.isChecked = selectedIndex == indexPath
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath
        self.amountTextField.text?.removeAll()
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.height*1.2, height: collectionView.height)
    }
}

// MARK: - REQUESTS DELEGATE

extension RefillMetroCardViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .refillMetroCard ||
            request == .confirmTransfer {
            showLoadingView(self)
        }
    }
    
    func requestFinished(request: RequestType, result: ResponseResult) {
        hideLoadingView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
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
}

// MARK: - TEXT FIELD DELEGATE

extension RefillMetroCardViewController: UITextFieldDelegate {
    
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

extension RefillMetroCardViewController {
    
    private func sendRefillMetro(_ amount: Double, cardNumber: String) {
        self.requestProxy.requestService()?.refillMetroCard(cardNumber: cardNumber, amount: amount, completion: { status, transfer in
            guard status,
                  let trans = transfer else {
                return
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                let vc = self.getStoryboardView(ConfirmPinCodeViewController.self)
                vc.data = trans
                vc.handler = { code in
                    self.sendConfirmTransfer(trans, code: code)
                }
                self.present(vc, animated: true)
            }
        })
    }
    
    private func sendConfirmTransfer(_ transfer: Transfer, code: String) {
        self.requestProxy.requestService()?.delegate = self
        
        self.requestProxy.requestService()?.confirmTransfer(transfer, pinCode: code, completion: { status, response in
            guard status else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                self.showSuccessMessage(response?._message ?? "Success")
            }
        })
    }
}
