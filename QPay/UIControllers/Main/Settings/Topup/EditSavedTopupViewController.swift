//
//  EditSavedTopupViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/10/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class EditSavedTopupViewController: MainController {
    
    @IBOutlet weak var accountsCollectionView: UICollectionView!
    
    var accounts = [Topup]()
    
    var selectedCards: [LibraryCard]?
    
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
        
        self.topupCardListRequest()
    }
}

extension EditSavedTopupViewController {
    
    func setupView() {
        self.accountsCollectionView.delegate = self
        self.accountsCollectionView.dataSource = self
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension EditSavedTopupViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addAccountAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(SelectTopupAccountViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func saveChangesAction(_ sender: UIButton) {
        
        if self.accounts.isEmpty {
            self.saveAccountsRequest()
            
        }else {
            let accs = self.accounts.filter({ $0.isDefault == true })
            if accs.isEmpty {
                self.showErrorMessage("Please select one card as a default")
                
            }else {
                self.saveAccountsRequest()
            }
        }
    }
}

// MARK: - COLLECTION VIEW DELEGATE

extension EditSavedTopupViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.accounts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(TopUpAccountCollectionViewCell.self, for: indexPath)
        
        let account = self.accounts[indexPath.row]
        cell.accountCellDelegate = self
        cell.account = account
        cell.setDefaultCellButton(account.isDefault ?? false)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = self.view.width
        return .init(width: width, height: 130)
    }
}

// MARK: - ACCOUNT CELL DELEGATE

extension EditSavedTopupViewController: TopupAccountCellDelegate {
    
    func onCellSelected(_ selectedCell: UICollectionViewCell, object: Any) {
        guard let topup = object as? Topup,
              let id = topup.id else {
            return
        }
        for (index, acc) in self.accounts.enumerated() {
            self.accounts[index].isDefault = acc.id == id
        }
        self.accountsCollectionView.reloadData()
    }
    
    func onCellDeleted(_ deletedCell: UICollectionViewCell, id: Int) {
        
        let topup = self.accounts.first(where: { $0.id == id })
        self.accounts.removeAll(where: { $0.id == id })
        
        if topup?.isDefault == true,
           !self.accounts.isEmpty {
            self.accounts[0].isDefault = true
        }
        
        self.accountsCollectionView.reloadData()
    }
}

// MARK: - REQUESTS DELEGATE

extension EditSavedTopupViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .topupPaymentSetting ||
            request == .getTopupCardList {
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

extension EditSavedTopupViewController {
    
    private func saveAccountsRequest() {
        self.requestProxy.requestService()?.topupPaymentSetting(topupPaymentList: self.accounts, completion: { (status, response) in
            guard status else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                self.navigationController?.popTo(TopUpAccountSettingsViewController.self)
                self.showSuccessMessage(response?.message ?? "")
            }
        })
    }
    
    private func topupCardListRequest() {
        
        self.dispatchGroup.enter()
        self.requestProxy.requestService()?.getTopupCardList { (status, topupList) in
            guard status else { return }
            
            self.accounts = topupList ?? []
            
            if let cards = self.selectedCards {
                cards.forEach({ (card) in
                    var topup = Topup()
                    topup.id = card.id
                    topup.cardID = card.id
                    topup.cardName = card.name
                    topup.isDefault = false
                    topup.ownerName = card.ownerName
                    topup.cardNumber = card.number
                    
                    self.accounts.append(topup)
                })
            }
            self.dispatchGroup.leave()
        }
        
        self.dispatchGroup.notify(queue: .main) {
            self.accountsCollectionView.reloadData()
        }
    }
}
