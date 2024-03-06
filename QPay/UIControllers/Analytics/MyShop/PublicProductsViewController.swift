//
//  PublicProductsViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 10/13/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class PublicProductsViewController: ShopController {
    
    @IBOutlet weak var emptyProductsStackView: UIStackView!
    @IBOutlet weak var productsCollectionView: UICollectionView!
    
    var selectedShop: Shop!
    var cartItems = [CartItem]()
    
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
        
        self.dispatchGroup.enter()
        
        if let shopID = self.selectedShop.id {
            
            self.requestProxy.requestService()?.getProductListByShopID(shopID: shopID) { (status, myShops) in
                if status {
                    if let shops = myShops {
                        let prods = shops[0].products ?? []
                        
                        let fileCartitems = super.cart.getCartItems()
                        self.cartItems.removeAll()
                        
                        prods.forEach { (prod) in
                            if let item = fileCartitems.filter({ $0.product == prod }).first {
                                self.cartItems.append(.init(product: prod, quantity: item.quantity))
                                
                            }else {
                                self.cartItems.append(.init(product: prod, quantity: 0))
                            }
                        }
                        self.dispatchGroup.leave()
                    }
                }
            }
        }
        
        self.dispatchGroup.notify(queue: .main) {
            self.productsCollectionView.reloadData()
            self.isUserHasProducts(self.cartItems.isEmpty)
        }
    }
}

extension PublicProductsViewController {
    
    func setupView() {
        self.productsCollectionView.register(UINib.init(nibName: Cells.ProductCollectionViewCell.rawValue, bundle: nil), forCellWithReuseIdentifier: Cells.ProductCollectionViewCell.rawValue)
        
        self.productsCollectionView.delegate = self
        self.productsCollectionView.dataSource = self
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension PublicProductsViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func shareAction(_ sender: UIButton) {
        
    }
    
    @IBAction func invoiceAction(_ sender: UIButton) {
        
        if super.cart.getCartItems().isEmpty {
            self.showErrorMessage("Please, select product to continue!\nincrease quantity to select")
            
        }else {
            let vc = self.getStoryboardView(CreateInvoiceViewController.self)
            vc.selectedShop = self.selectedShop
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func addProductAction(_ sender: UIButton) {
        
        let vc = self.getStoryboardView(AddProductViewController.self)
        vc.selectedShop = self.selectedShop
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - COLLECTION VIEW DELEGATE

extension PublicProductsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cartItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(ProductCollectionViewCell.self, for: indexPath)
        
        let item = self.cartItems[indexPath.row]
        cell.cartItem = item
        
        return cell
    }
}

// MARK: - REQUESTS DELEGATE

extension PublicProductsViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .getProductListByShopID {
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

extension PublicProductsViewController {
    
    private func isUserHasProducts(_ status: Bool) {
        self.productsCollectionView.isHidden = status
        self.emptyProductsStackView.isHidden = !status
    }
}
