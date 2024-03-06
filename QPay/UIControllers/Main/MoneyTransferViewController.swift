//
//  MoneyTransferViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/10/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//
// Mahmoud ali
import UIKit

class MoneyTransferViewController: MainController {
    
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var actionsCollectionView: UICollectionView!
    
    var actions = [MoneyTransferAction]()
    var refillClousure: (status: Bool, message: String)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        localized()
        setupData()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.requestProxy.requestService()?.getUserBalance { (status, balance) in
            if status,
               let blnc = balance {
                self.balanceLabel.text = blnc.formatNumber()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let clousure = self.refillClousure else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.viewWillAppear(true)
        }
        if clousure.status {
            self.showSuccessMessage(clousure.message)
        }else {
            self.showErrorMessage(clousure.message)
        }
    }
}

extension MoneyTransferViewController {
    
    func setupView() {
        self.actionsCollectionView.delegate = self
        self.actionsCollectionView.dataSource = self
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
        let topupAction = MoneyTransferAction(image: #imageLiteral(resourceName: "ic_topup_money_transfer.png"), title: "Top-up Wallet", description: "Refill your wallet balance.", buttonTitle: "TOP-UP Now!".uppercased()) {
            
            let vc = self.getStoryboardView(RefillWalletViewController.self)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        let transferAction = MoneyTransferAction(image: #imageLiteral(resourceName: "ic_transfer_money_transfer.png"), title: "Transfer Money", description: "Fast, simple and secured.", buttonTitle: "Send Money".uppercased()) {
            
            let vc = self.getStoryboardView(TransferViewController.self)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        let requestAction = MoneyTransferAction(image: #imageLiteral(resourceName: "ic_request_money_transfer.png"), title: "Request Money", description: "Any day, anytime, anywhere.", buttonTitle: "Request Money".uppercased()) {
            
            let vc = self.getStoryboardView(RequestMoneyViewController.self)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        let beneficiariesAction = MoneyTransferAction(image: #imageLiteral(resourceName: "ic_beneficiaries_money_transfer.png"), title: "Beneficiaries", description: "Add your beneficiaries.", buttonTitle: "add beneficiary".uppercased()) {
            
            let vc = self.getStoryboardView(BeneficiariesViewController.self)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        let topupSettingsAction = MoneyTransferAction(image: #imageLiteral(resourceName: "ic_topup_settings_money_transfer"), title: "Top-up Account Settings", description: "Edit account settings", buttonTitle: "Edit Accounts") {
            
            let vc = self.getStoryboardView(TopUpAccountSettingsViewController.self)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        self.actions = [
            topupAction,
            transferAction,
            requestAction,
            beneficiariesAction,
            topupSettingsAction
        ]
    }
}

// MARK: - ACTIONS

extension MoneyTransferViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - COLLECTION VIEW DELEGATE

extension MoneyTransferViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.actions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.MoneyTransferActionCollectionViewCell.rawValue, for: indexPath) as! MoneyTransferActionCollectionViewCell
        
        let object = self.actions[indexPath.row]
        cell.action = object
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.actions[indexPath.row].actionClosure()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let viewWidth = self.view.width
        return .init(width: viewWidth, height: 140)
    }
}

// MARK: - CUSTOM FUNCTIONS

extension MoneyTransferViewController {
    
}
