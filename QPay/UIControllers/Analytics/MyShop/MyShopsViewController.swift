//
//  MyShopViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/7/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class MyShopsViewController: ShopController {
    
    @IBOutlet weak var shopsSearchTextField: UITextField!
    @IBOutlet weak var shopsCollectionView: UICollectionView!
    
    var shopsAll = [Shop]()
    var shops = [Shop]()
    
    var isFromDashboard: Bool = false
    var isFromHome: Bool = false
    
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
        
        if self.isFromDashboard {
            self.isFromDashboard.toggle()
        } else if self.isFromHome {
            self.isFromHome.toggle()
        } else {
            self.shopsRequest()
        }
    }
}

extension MyShopsViewController {
    
    func setupView() {
        
        self.changeStatusBarBG(color: .clear)
        self.shopsCollectionView.delegate = self
        self.shopsCollectionView.dataSource = self
        
        self.shopsSearchTextField.addTarget(self,
                                            action: #selector(self.searchFieldDidChange(_:)),
                                            for: .editingChanged)
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension MyShopsViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func invoicesAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(InvoicesViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func invoiceAppAction(_ sender: UIButton) {
//        let vc = self.getStoryboardView(InvoiceLoginViewController.self)
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func addShopAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(CreateShopViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - REQUESTS DELEGATE

extension MyShopsViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .getShopList {
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

// MARK: - COLLECTION VIEW DELEGATE

extension MyShopsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.shops.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(ShopCollectionViewCell.self, for: indexPath)
        cell.delegate = self
        
        let shop = self.shops[indexPath.row]
        cell.shop = shop
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.view.width
        return .init(width: width, height: 130)
    }
}

// MARK: - SHOP CELL DELEGATE

extension MyShopsViewController: ShopCollectionViewCellDelegate {
    
    func didTapShowHideButton(_ cell: ShopCollectionViewCell, for shop: Shop) {
        guard let shopID = shop.id else { return }
        self.requestProxy.requestService()?.updateShopStatus(shopID: shopID) { (status, repsonse) in
            guard status else { return }
        }
    }
    
    func didTapShareButton(_ cell: ShopCollectionViewCell, for shop: Shop) {
        guard let id = shop.id, let name = shop.name else { return }
        
        let url = "http://api.qatarpay.com/shop/index.html?ShopID=\(id)"
        let string = "Take a look at my shop \(name)"
        self.openShareDialog(sender: cell, data: [url, string])
    }
    
    func didTapEditButton(_ cell: ShopCollectionViewCell, for shop: Shop) {
        let vc = self.getStoryboardView(ShopProfileViewController.self)
        vc.selectedShop = shop
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapProductsButton(_ cell: ShopCollectionViewCell, for shop: Shop) {
        let vc = self.getStoryboardView(MyProductsViewController.self)
        vc.selectedShop = shop
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapOrdersButton(_ cell: ShopCollectionViewCell, for shop: Shop) {
        let vc = self.getStoryboardView(MyOrdersViewController.self)
        vc.selectedShop = shop
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - TEXT FIELD DELEGATE

extension MyShopsViewController: UITextFieldDelegate {
    
    @objc func searchFieldDidChange(_ textField: UITextField) {
        
        guard let searchName = textField.text,
              searchName.isNotEmpty else {
            
            self.shops = self.shopsAll
            self.shopsCollectionView.reloadData()
            return
        }
        
        self.shops = self.shopsAll.filter({ (shop) -> Bool in
            if let name = shop.name?.lowercased() {
                return name.contains(searchName.lowercased())
            }
            return false
        })
        self.shopsCollectionView.reloadData()
    }
}

// MARK: - PRIVATE FUNCTIONS

extension MyShopsViewController {
    
    private func shopsRequest() {
        
        self.dispatchGroup.enter()
        
        self.requestProxy.requestService()?.getShopList ( weakify { strong, shops in
            strong.shopsAll = shops ?? []
            strong.shops = shops ?? []
            strong.dispatchGroup.leave()
        })
        
        self.dispatchGroup.notify(queue: .main) {
            self.shopsCollectionView.reloadData()
        }
    }
}
