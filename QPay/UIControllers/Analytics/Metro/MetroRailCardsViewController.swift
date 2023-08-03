//
//  MetroRailCardsViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/5/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit
import FSPagerView
import DropDown

class MetroRailCardsViewController: MetroRailController {
    
    @IBOutlet weak var dropDownImageView: UIImageView!
    
    @IBOutlet weak var dropDownButton: UIButton!
    
    @IBOutlet weak var dataStackView: UIStackView!
    
    @IBOutlet weak var placeholderStackView: UIStackView!
    
    @IBOutlet weak var cardsFSPagerView: FSPagerView!
    
    @IBOutlet weak var cardNumberTextField: UITextField!
    
    @IBOutlet weak var cardTypeTextField: UITextField!
    
    @IBOutlet weak var cardBalanceTextField: UITextField!
    
    var updateClosure: (success: Bool, message: String)?
    
    private var cards = [MetroCard]()
    
    private var selectedCard: MetroCard?
    
    private lazy var actionsDropDown = {
        return DropDown()
    }()
    
    enum DropDownActions: String, CaseIterable {
        case delete = "Delete"
        case fare = "Fare"
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
        
        self.requestProxy.requestService()?.delegate = self
        self.getCardsRequest()
    }
}

extension MetroRailCardsViewController {
    
    func setupView() {
        self.cardsFSPagerView.registerNib(MetroCardFSPagerViewCell.self)
        self.cardsFSPagerView.delegate = self
        self.cardsFSPagerView.dataSource = self
        
        self.cardsFSPagerView.transformer = FSPagerViewTransformer(type: .linear)
        
        let pagerViewHeight = self.cardsFSPagerView.height
        self.cardsFSPagerView.itemSize = CGSize(width: (self.view.width * 0.8), height: pagerViewHeight)
        self.setupActionsDropDown()
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension MetroRailCardsViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func dropDownAction(_ sender: UIButton) {
        self.actionsDropDown.show()
    }
    
    @IBAction func addCardAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(AddTravelCardViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func refillCardAction(_ sender: UIButton) {
        guard let card = self.selectedCard else { return }
        let vc = self.getStoryboardView(RefillMetroCardViewController.self)
        vc.card = card
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func faresCardAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(FaresAndTravelCardsViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - FSPAGER VIEW DELEGATE

extension MetroRailCardsViewController: FSPagerViewDelegate, FSPagerViewDataSource {
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.cards.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueCell(MetroCardFSPagerViewCell.self, for: index)
        
        let object = self.cards[index]
        cell.card = object
        
        return cell
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        self.setCardDetailsToFields(self.cards[targetIndex])
    }
}

// MARK: - REQUESTS DELEGATE

extension MetroRailCardsViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .getMetroCards ||
            request == .removeMetroCard {
            showLoadingView(self)
        }
    }
    
    func requestFinished(request: RequestType, result: ResponseResult) {
        hideLoadingView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
            switch result {
            case .Success(_):
                if self.updateClosure?.success == true {
                    self.showSuccessMessage(self.updateClosure?.message ?? "")
                    self.updateClosure = nil
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

extension MetroRailCardsViewController {
    
    private func setCardDetailsToFields(_ card: MetroCard) {
        self.selectedCard = card
        self.removeFieldsData()
        
        self.cardNumberTextField.text = card._number
        self.cardTypeTextField.text = card._metroCardType
        self.setBalanceToField(card._balance)
    }
    
    private func removeFieldsData() {
        self.cardNumberTextField.text?.removeAll()
        self.cardTypeTextField.text?.removeAll()
        self.setBalanceToField(0.0)
    }
    
    private func setBalanceToField(_ balance: Double) {
        self.cardBalanceTextField.text = "QAR \(balance.formatNumber())"
    }
    
    private func getCardsRequest() {
        
        self.dispatchGroup.enter()
        self.requestProxy.requestService()?.getMetroCards(completion: { (status, cardList) in
            guard status else { return }
            let list = cardList ?? []
            
            self.cards = list
            self.isUserHasCards(list.isNotEmpty)
            
            self.dispatchGroup.leave()
        })
        
        self.dispatchGroup.notify(queue: .main) {
            self.cardsFSPagerView.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                guard self.cards.isNotEmpty else { return }
                if self.updateClosure?.success == true {
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
    
    private func isUserHasCards(_ status: Bool) {
        self.dataStackView.isHidden = !status
        self.placeholderStackView.isHidden = status
    }
    
    private func setupActionsDropDown() {
        self.actionsDropDown.anchorView = self.dropDownImageView
        
        let width = UIScreen.main.bounds.width * 0.6
        self.actionsDropDown.width = width
        
        // Top of drop down will be below the anchorView
        self.actionsDropDown.bottomOffset = CGPoint(x: 0, y: (self.actionsDropDown.anchorView?.plainView.bounds.height)!)
        
        self.actionsDropDown.direction = .bottom
        self.actionsDropDown.dismissMode = .automatic
        
        self.actionsDropDown.dataSource = DropDownActions.allCases.compactMap({ return $0.rawValue })
        
        self.actionsDropDown.selectionAction = { [weak self] (index, item) in
            guard let self = self else { return }
            
            switch DropDownActions.allCases[index] {
            case .delete:
                guard let id = self.selectedCard?.id else { return }
                self.deleteCardRequest(id: id)
                break
            case .fare:
                let vc = self.getStoryboardView(FaresAndTravelCardsViewController.self)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    private func deleteCardRequest(id: Int) {
        self.requestProxy.requestService()?.removeMetroCard(cardID: id, completion: { status, response in
            guard status else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                self.selectedCard = nil
                self.updateClosure = (true, response?._message ?? "Card removed successfully")
                self.viewWillAppear(true)
            }
        })
    }
}
