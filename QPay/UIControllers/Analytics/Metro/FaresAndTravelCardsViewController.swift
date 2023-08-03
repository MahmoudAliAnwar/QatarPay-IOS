//
//  FaresAndTravelCardsViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/5/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit
import FSPagerView

class FaresAndTravelCardsViewController: MetroRailController {
    
    @IBOutlet weak var standardViewDesign: ViewDesign!
    
    @IBOutlet weak var standardLabel: UILabel!
    
    @IBOutlet weak var goldViewDesign: ViewDesign!
    
    @IBOutlet weak var goldLabel: UILabel!
    
    @IBOutlet weak var limitedViewDesign: ViewDesign!
    
    @IBOutlet weak var limitedLabel: UILabel!
    
    @IBOutlet weak var cardsCollectionView: UICollectionView!
    
    private var cards = [MetroFareCard]()
    
    private var cardType: MetroFareCard.Types = .standard {
        willSet {
            self.setViewType(to: newValue)
        }
    }
    
    private var selectedCardDetails = [MetroFareDetails]()
    
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
        self.sendCardsRequest()
    }
}

extension FaresAndTravelCardsViewController {
    
    func setupView() {
        self.cardsCollectionView.delegate = self
        self.cardsCollectionView.dataSource = self
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension FaresAndTravelCardsViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func standardAction(_ sender: UIButton) {
        self.cardType = .standard
    }
    
    @IBAction func goldAction(_ sender: UIButton) {
        self.cardType = .gold
    }
    
    @IBAction func limitedAction(_ sender: UIButton) {
        self.cardType = .limited
    }
}

// MARK: - COLLECTION VIEW DELEGATE

extension FaresAndTravelCardsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.selectedCardDetails.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(MetroFareCardCollectionViewCell.self, for: indexPath)
        cell.type = self.cardType
        
        let object = self.selectedCardDetails[indexPath.row]
        cell.details = object
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let flowLayout: UICollectionViewFlowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let leftRightPadding: CGFloat = flowLayout.sectionInset.left + flowLayout.sectionInset.right
        
        let cellWidth = (collectionView.width - leftRightPadding)
        return CGSize(width: cellWidth, height: collectionView.height)
    }
}

// MARK: - REQUESTS DELEGATE

extension FaresAndTravelCardsViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .getMetroFareCards {
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

// MARK: - CUSTOM FUNCTIONS

extension FaresAndTravelCardsViewController {
    
    private func sendCardsRequest() {
        self.requestProxy.requestService()?.getMetroFareCards(completion: { status, cardList in
            guard status else { return }
            self.cards = cardList ?? []
            self.cardType = .standard
        })
    }
    
    private func setViewType(to type: MetroFareCard.Types) {
        self.filterCards(by: type)
        
        self.standardLabel.textColor = type == .standard ? .white : .mDark_Gray
        self.goldLabel.textColor = type == .gold ? .white : .mDark_Gray
        self.limitedLabel.textColor = type == .limited ? .white : .mDark_Gray
        
        self.standardViewDesign.backgroundColor = type == .standard ? .mOrange : .clear
        self.goldViewDesign.backgroundColor = type == .gold ? .mOrange : .clear
        self.limitedViewDesign.backgroundColor = type == .limited ? .mOrange : .clear
    }
    
    private func filterCards(by type: MetroFareCard.Types) {
        let list = self.cards.filter({ $0.typeObject == type }).first?._cardsDetails ?? []
        self.selectedCardDetails.removeAll()
        self.selectedCardDetails = list
        self.cardsCollectionView.reloadData()
    }
}

