//
//  SelectTopupAccountViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 23/11/2020.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class SelectTopupAccountViewController: MainController {

    @IBOutlet weak var accountsCollectionView: UICollectionView!

    var cards = [LibraryCard]()
    
    var selectedCards = [LibraryCard]()
    
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
    
        self.topupPaymentCardListRequest()
    }
}

extension SelectTopupAccountViewController {
    
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

extension SelectTopupAccountViewController {

    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
        
        let vc = self.getStoryboardView(EditSavedTopupViewController.self)
        vc.selectedCards = self.selectedCards
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - COLLECTION VIEW DELEGATE

extension SelectTopupAccountViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(TopupSelectCollectionViewCell.self, for: indexPath)
        
        let card = self.cards[indexPath.row]
        
        cell.delegate = self
        cell.card = card
        cell.isTopupAccountCheckBox.isChecked = self.selectedCards.contains(card)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.view.width
        return .init(width: width, height: 130)
    }
}

// MARK: - TOPUP CELL DELEGATE

extension SelectTopupAccountViewController: TopupSelectCollectionViewCellDelegate {
    
    func didSelectAccount(_ card: LibraryCard, isSelected: Bool) {
        isSelected ? self.onCardSelected(card) : self.onCardRemoved(card)
    }
}

extension SelectTopupAccountViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .getTopupPaymentCardList {
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

extension SelectTopupAccountViewController {
    
    private func topupPaymentCardListRequest() {
        
        self.dispatchGroup.enter()
        
        self.requestProxy.requestService()?.getTopupPaymentCardList(completion: { (status, cards) in
            guard status else { return }
            
            self.cards = cards?.cards ?? []
            self.dispatchGroup.leave()
        })
        
        self.dispatchGroup.notify(queue: .main) {
            self.accountsCollectionView.reloadData()
        }
    }
    
    private func onCardSelected(_ card: LibraryCard) {
        self.selectedCards.append(card)
    }
    
    private func onCardRemoved(_ card: LibraryCard) {
        self.selectedCards.removeAll(where: { $0 == card })
    }
}
