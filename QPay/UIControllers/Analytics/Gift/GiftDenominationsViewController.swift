//
//  GiftDenominationsViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 29/03/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit

class GiftDenominationsViewController: GiftController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var denominationsCollectionView: UICollectionView!

    var denominations = [GiftDenomination]()
    
    var storeID: Int!
    var brand: GiftBrand!
    
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
        
    }
}

extension GiftDenominationsViewController {
    
    func setupView() {
        self.requestProxy.requestService()?.delegate = self

        self.denominationsCollectionView.delegate = self
        self.denominationsCollectionView.dataSource = self
        
        self.denominationsCollectionView.registerHeaderNib(GiftDenominationHeaderReusableView.self)
        
        self.denominationsCollectionView.registerNib(GiftDenominationCollectionViewCell.self)
        
        self.titleLabel.text = self.brand._name
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
        if let brandID = self.brand.id {
            self.denominationsRequest(storeID: self.storeID, brandID: brandID)
        }
    }
}

// MARK: - ACTIONS

extension GiftDenominationsViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - COLLECTION VIEW DELEGATE

extension GiftDenominationsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.denominations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(GiftDenominationCollectionViewCell.self, for: indexPath)
        
        let object = self.denominations[indexPath.row]
        cell.object = object
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let object = self.denominations[indexPath.row]
        
        let vc = self.getStoryboardView(GiftCardPurchaseViewController.self)
        vc.denomination = object
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//
//        let view = collectionView.dequeueHeader(GiftDenominationHeaderReusableView.self, for: indexPath)
//
//        return view
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return .init(width: collectionView.width, height: 40)
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let viewWidth = (self.view.width-60)/2
        return .init(width: viewWidth, height: (viewWidth*0.9))
    }
}

// MARK: - REQUESTS DELEGATE

extension GiftDenominationsViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .getGiftDenominationList {
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

// MARK: - CUSTOM FUNCTIONS

extension GiftDenominationsViewController {
    
    private func denominationsRequest(storeID: Int, brandID: Int) {
        self.dispatchGroup.enter()
        
        self.requestProxy.requestService()?.getGiftDenominationList(storeID: storeID, brandID: brandID, completion: { (status, denominationList) in
            if status {
                self.denominations = denominationList ?? []
                self.dispatchGroup.leave()
            }
        })
        
        self.dispatchGroup.notify(queue: .main) {
            self.denominationsCollectionView.reloadData()
        }
    }
}
