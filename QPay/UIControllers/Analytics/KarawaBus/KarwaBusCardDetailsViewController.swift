//
//  KarwaBusCardDetailsViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/4/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit
import FSPagerView

// 01104 31619 6
class KarwaBusCardDetailsViewController: KarwaBusController {
    
    @IBOutlet weak var dataStackView: UIStackView!
    @IBOutlet weak var placeholderStackView: UIStackView!
    
    @IBOutlet weak var cardsFSPagerView: FSPagerView!
    
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var lastUsageTextField: UITextField!
    @IBOutlet weak var lastRechargeTextField: UITextField!
    @IBOutlet weak var cardBalanceTextField: UITextField!
    
    var cards = [KarwaBusCard]()
    
    private var addCardClosure: (isAfterAddCard: Bool, message: String)?
    private var selectedCard: KarwaBusCard?
    
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
        
        self.getCardsRequest()
    }
}

extension KarwaBusCardDetailsViewController {
    
    func setupView() {
        self.cardsFSPagerView.delegate = self
        self.cardsFSPagerView.dataSource = self
        
        self.cardsFSPagerView.registerNib(KarwaBusCardFSPagerViewCell.self)
        
        self.cardsFSPagerView.transformer = FSPagerViewTransformer(type: .linear)
        self.cardsFSPagerView.interitemSpacing = 10
        
        let pagerViewHeight = self.cardsFSPagerView.height
        self.cardsFSPagerView.itemSize = CGSize(width: (pagerViewHeight*1.6), height: pagerViewHeight)
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension KarwaBusCardDetailsViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addCardAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(AddKarwaBusCardViewController.self)
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func refillCardAction(_ sender: UIButton) {
        guard let card = self.selectedCard else { return }
        
        let vc = self.getStoryboardView(RefillKarwaBusCardViewController.self)
        vc.card = card
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - FSPAGER VIEW DELEGATE

extension KarwaBusCardDetailsViewController: FSPagerViewDelegate, FSPagerViewDataSource {
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.cards.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueCell(KarwaBusCardFSPagerViewCell.self, for: index)
        
        let object = self.cards[index]
        cell.card = object
        
        return cell
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        self.setCardDetailsToFields(self.cards[targetIndex])
    }
}

// MARK: - UPDATE VIEW ELEMENT DELEGATE

extension KarwaBusCardDetailsViewController: UpdateViewElement {
    
    func elementUpdated(fromSourceView view: UIViewController, status: Bool, data: Any?) {
        guard view is AddKarwaBusCardViewController,
              let message = data as? String else {
            return
        }
        
        self.addCardClosure = (status, message)
    }
}

// MARK: - REQUESTS DELEGATE

extension KarwaBusCardDetailsViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .getKarwaBusCardList {
            showLoadingView(self)
        }
    }
    
    func requestFinished(request: RequestType, result: ResponseResult) {
        hideLoadingView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
            switch result {
            case .Success(_):
                if self.addCardClosure?.isAfterAddCard == true {
                    self.showSuccessMessage(self.addCardClosure?.message ?? "")
                    self.addCardClosure = nil
                }
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

// MARK: - CUSTOM FUNCTIONS

extension KarwaBusCardDetailsViewController {
    
    private func setCardDetailsToFields(_ card: KarwaBusCard) {
        self.selectedCard = card
        self.removeFieldsData()
        
        self.cardNumberTextField.text = card._number
        
        // 2021-04-22T11:46:52.6115858+03:00
        if let date = card._lastUsageDateTime.formatToDate(ServerDateFormat.Server3.rawValue) {
            let currentDate = date.toLocalTime()
            self.lastUsageTextField.text = currentDate.formatDate("dd MMMM yyyy hh.mm a") // 30 April 2021 11.20 pm
        }
        if let date = card._lastRechargeDateTime.formatToDate(ServerDateFormat.Server3.rawValue) {
            let currentDate = date.toLocalTime()
            self.lastRechargeTextField.text = currentDate.formatDate("dd MMMM yyyy hh.mm a") // 30 April 2021 11.20 pm
        }
        
        self.requestProxy.requestService()?.getKarwaBusCardBalance(cardNumber: card._number, completion: { (status, response) in
            guard status == true else { return }
            guard let balanceString = response?.cardBalance,
                  let balance = Double(balanceString) else {
                return
            }
            self.selectedCard?.balance = balance
            self.setBalanceToField(balance)
        })
    }
    
    private func removeFieldsData() {
        self.cardNumberTextField.text?.removeAll()
        self.lastUsageTextField.text?.removeAll()
        self.lastRechargeTextField.text?.removeAll()
        self.setBalanceToField(0.0)
    }
    
    private func setBalanceToField(_ balance: Double) {
        self.cardBalanceTextField.text = "QAR \(balance.formatNumber())"
    }
    
    private func getCardsRequest() {
        
        self.dispatchGroup.enter()
        self.requestProxy.requestService()?.getKarwaBusCardList(completion: { (status, cardList) in
            guard status else { return }
            let list = cardList ?? []
            
            self.cards = list
            self.isUserHasCards(list.isNotEmpty)
            
            self.dispatchGroup.leave()
        })
        
        self.dispatchGroup.notify(queue: .main) {
            self.cardsFSPagerView.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                if !self.cards.isEmpty {
                    if self.addCardClosure?.isAfterAddCard == true {
                        let lastIndex = self.cards.count-1
                        self.setCardDetailsToFields(self.cards[lastIndex])
                        self.cardsFSPagerView.scrollToItem(at: lastIndex, animated: true)
                        
                    } else {
                        self.cardsFSPagerView.scrollToItem(at: 0, animated: true)
                        self.setCardDetailsToFields(self.cards[0])
                    }
                }
            }
        }
    }
    
    private func isUserHasCards(_ status: Bool) {
        self.dataStackView.isHidden = !status
        self.placeholderStackView.isHidden = status
    }
}
