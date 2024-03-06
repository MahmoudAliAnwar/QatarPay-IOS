//
//  MyCardsViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/15/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

// api/NoqoodyUser/GetPaymentCard

class MyCardsViewController: MainController {
    
    @IBOutlet weak var transactionsTable: UITableView!

    @IBOutlet weak var cardsCollection: UICollectionView!
    
    var transactions = [Transaction]()
//    var cards = [Card]()
    
    var indexPath: IndexPath?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupView()
        localized()
        setupData()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewDidLoad()
        
        self.requestProxy.requestService()?.delegate = self
        
        self.cardsRequest()
//        self.transactionsRequest()
    }
}

extension MyCardsViewController {
    
    func setupView() {
        self.cardsCollection.delegate = self
        self.cardsCollection.dataSource = self
        
        self.transactionsTable.delegate = self
        self.transactionsTable.dataSource = self
        
        self.transactionsTable.register(UINib.init(nibName: Cells.TransactionTableViewCell.rawValue, bundle: nil), forCellReuseIdentifier: Cells.TransactionTableViewCell.rawValue)
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension MyCardsViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addCardAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(MyCardsAndBanksViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - COLLECTION DELEGATE

extension MyCardsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return cards.count
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueCell(CardCollectionViewCell.self, for: indexPath)
        
//        cell.setupData(card: cards[indexPath.row])
        
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        let width = self.view.frame.width
//        return CGSize.init(width: width, height: (width * 0.63))
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.indexPath = indexPath
        let vc = self.getStoryboardView(ConfirmPinCodeViewController.self)
        vc.updateViewElementDelegate = self
        self.present(vc, animated: true)
    }
}

// MARK: - TABLE DELEGATE

extension MyCardsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueCell(TransactionTableViewCell.self, for: indexPath)
        
        let trans = transactions[indexPath.row]
        cell.setupData(transaction: trans)
        
        return cell
    }
}

// MARK: - UPDATE VIEW ELEMENTS DELEGATE

extension MyCardsViewController: UpdateViewElement {
    
    func elementUpdated(fromSourceView view: UIViewController, status: Bool, data: Any?) {
        
        guard status else { return }
        
        if view is ConfirmPinCodeViewController {
            if let _ = self.indexPath {
                DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
//                    let _ = self.cards[index.row]
                    let vc = self.getStoryboardView(CardDetailsViewController.self)
//                    vc.card = card
                    vc.updateElementDelegate = self
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
        }else if view is CardDetailsViewController {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.showSuccessMessage("Deleted successfully")
            }
        }
    }
}

// MARK: - REQUESTS DELEGATE

extension MyCardsViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
//        if request == .accountsDetails {
//            showLoadingView(self)
//        }
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
                        //                    showMessage(exc, messageStatus: .Warning)
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

extension MyCardsViewController {
    
    private func cardsRequest() {
        self.dispatchGroup.enter()
        
//        self.requestProxy.requestService()?.accountsDetails { (status, accountDetails) in
//            
//            if status {
//                if let accounts = accountDetails {
//                    let cards = accounts.cards ?? []
//                    let banks = accounts.banks ?? []
//
//                    self.cards.removeAll()
//                    cards.forEach { (card) in
//                        self.cards.append(card)
//                    }
//                    banks.forEach { (bank) in
//                        self.cards.append(bank)
//                    }
//                    
//                    self.dispatchGroup.leave()
//                }
//            }
//        }
//        self.dispatchGroup.notify(queue: DispatchQueue.main) {
//            self.cardsCollection.reloadData()
//        }
    }
    
    private func transactionsRequest() {
//        dispatchGroup.enter()
//        self.requestProxy.requestService()?.transactionsList { (status, list) in
//            if status {
//               
//                let arr = list ?? []
//                if arr.count > recentTransactionsLength {
//                    
//                    var maxArray: Int = arr.count - 1
//                    self.transactions.removeAll()
//                    
//                    for _ in 0..<recentTransactionsLength {
//                        let trans = arr[maxArray]
//                        self.transactions.append(trans)
//                        maxArray -= 1
//                    }
//                    
//                }else {
//                    self.transactions.removeAll()
//                    self.transactions = arr
//                }
//                self.dispatchGroup.leave()
//            }
//        }
//        dispatchGroup.notify(queue: DispatchQueue.main) {
//            self.transactionsTable.reloadData()
//        }
    }
}
