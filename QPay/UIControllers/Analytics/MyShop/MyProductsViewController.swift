//
//  MyProductsViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/7/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class MyProductsViewController: ShopController {
    
    @IBOutlet weak var shopImageViewDesign: ImageViewDesign!
    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var shopDescriptionLabel: UILabel!
    @IBOutlet weak var productsCountLabel: UILabel!
    @IBOutlet weak var productsCountViewDesign: ViewDesign!
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
        
        self.statusBarView?.isHidden = true
        
        self.requestProxy.requestService()?.delegate = self
        
        if let shopID = self.selectedShop.id {
            self.dispatchGroup.enter()
            self.requestProxy.requestService()?.getProductListByShopID(shopID: shopID) { (status, myShops) in
                guard status,
                      let shops = myShops else {
                    return
                }
                let prods = shops[0].products ?? []
                
                let fileCartitems = self.cart.getCartItems()
                self.cartItems.removeAll()
                
                prods.forEach { (prod) in
                    if let item = fileCartitems.filter({ $0.product == prod }).first {
                        self.cartItems.append(.init(product: prod, quantity: item.quantity))
                        
                    }else {
                        self.cartItems.append(.init(product: prod, quantity: 0))
                    }
                }
                
                self.updateBagdeNumber()
                self.dispatchGroup.leave()
            }
        }
        
        self.dispatchGroup.notify(queue: .main) {
            self.productsCollectionView.reloadData()
            self.isUserHasProducts(self.cartItems.isEmpty)
        }
    }
}

extension MyProductsViewController {
    
    func setupView() {
        self.productsCollectionView.registerNib(ProductCollectionViewCell.self)
        
        self.productsCollectionView.delegate = self
        self.productsCollectionView.dataSource = self
    }
    
    func localized() {
    }
    
    func setupData() {
        guard let shopName = self.selectedShop.name,
              let shopDescription = self.selectedShop.description else {
            return
        }
        self.shopNameLabel.text = shopName
        self.shopDescriptionLabel.text = shopDescription
        
        guard let shopBanner = self.selectedShop.banner else { return }
        
        shopBanner.getImageFromURLString { status, image in
            guard status,
                  let img = image else {
                return
            }
            self.shopImageViewDesign.image = img
        }
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension MyProductsViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.cart.removeCartItems()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func invoiceAction(_ sender: UIButton) {
        
        if self.cart.getCartItems().isEmpty {
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

extension MyProductsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cartItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(ProductCollectionViewCell.self, for: indexPath)
        
        let item = self.cartItems[indexPath.row]
        cell.cartItem = item
        cell.selectedShop = self.selectedShop
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.view.width
        return .init(width: width, height: 120)
    }
}

// MARK: - PRODUCT COLLECTION CELL DELEGATE

extension MyProductsViewController: ProductsCollectionCellDelegate {
    
    func didAddProductQuantity(for cell: ProductCollectionViewCell, item: CartItem) {
        self.cart.addItem(item.product)
        self.updateBagdeNumber()
    }
    
    func didRemoveProductQuantity(for cell: ProductCollectionViewCell, item: CartItem) {
        self.cart.removeItem(item.product)
        self.updateBagdeNumber()
    }
    
    func didTapEditProduct(for cell: ProductCollectionViewCell, item: CartItem) {
        
        let vc = self.getStoryboardView(AddProductViewController.self)
        vc.product = item.product
        vc.selectedShop = self.selectedShop
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapShowHideProduct(for cell: ProductCollectionViewCell, item: CartItem) {
        
        guard let sId = self.selectedShop.id,
              let pId = item.product.id else {
            return
        }
        
        self.requestProxy.requestService()?.updateProductStatus(pId, shopID: sId, completion: { (status, response) in
            guard status else { return }
        })
    }
    
    func didTapDeleteProduct(for cell: ProductCollectionViewCell, item: CartItem) {
        
        self.showConfirmation(message: "Do you want to Delete ?") {
            
            guard let sId = self.selectedShop.id,
                  let pId = item.product.id else {
                return
            }
            self.requestProxy.requestService()?.removeProduct(shopID: sId, productID: pId) { (status, response) in
                guard status else { return }
                self.showSuccessMessage(response?.message ?? "Product removed Successfully")
                self.viewWillAppear(true)
            }
        }
    }
}

// MARK: - REQUESTS DELEGATE

extension MyProductsViewController: RequestsDelegate {
    
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

extension MyProductsViewController {
    
    public func updateBagdeNumber() {
        self.setProductsCount(self.cart.getCartItemsQuantites())
    }
    
    private func setProductsCount(_ count: Int) {
        if count > 99 {
            self.productsCountLabel.text = "99+"
        } else {
            self.productsCountLabel.text = count.description
        }
    }
    
    private func isUserHasProducts(_ status: Bool) {
        self.productsCollectionView.isHidden = status
        self.emptyProductsStackView.isHidden = !status
    }
}
