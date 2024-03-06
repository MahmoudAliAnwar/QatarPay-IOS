//
//  ProductDetailsViewController.swift
//  kulud
//
//  Created by Hussam Elsadany on 10/03/2021.
//  Copyright (c) 2021 Qmobile-IT. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

protocol ProductDetailsSceneDisplayView: AnyObject {
    func displayProduct(viewModel: ProductDetailsScene.Product.ViewModel)
    func displayAddedToCart()
    func displayError(message: String)
}

class ProductDetailsViewController: KuludViewController {

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var cartView: UIView!
    @IBOutlet private weak var pageControl: UIPageControl!
    @IBOutlet private weak var productTitleLabel: UILabel!
    @IBOutlet private weak var productDescLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var wishListButton: UIButton!
    @IBOutlet private weak var quanitityLabel: UILabel!
    @IBOutlet private weak var addToCartButton: UIButton!
    @IBOutlet private weak var addToCartView: UIStackView!
    @IBOutlet private weak var cartCountLabel: UILabel!
    @IBOutlet private weak var cartQuatityLabel: UILabel!
    @IBOutlet private weak var quatityView: UIView!
    @IBOutlet private weak var addToCartButtonView: UIView!
    
    var interactor: ProductDetailsSceneBusinessLogic!
    var dataStore: ProductDetailsSceneDataStore!
    var viewStore: ProductDetailsSceneViewDataStore!
    var router: ProductDetailsSceneRoutingLogic!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.interactor.getProductDetails()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.updateNotificationCount(notification:)),
                                               name: Notification.Name("CartCountNotificationkey"),
                                               object: nil)
    }
    
    private func setupView() {
        self.cartView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.collectionView.registerCell(KuludProductDetailsImageCell.identifier)
    }
    
    @objc func updateNotificationCount(notification: Notification) {
        if let count = notification.object as? Int {
            self.cartCountLabel.isHidden = count == 0
            self.cartCountLabel.text = "\(count)"
        }
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func goToCart(_ sender: Any) {
        self.router.routeToCart()
    }
    
    @IBAction func goToWishList(_ sender: Any) {
        self.router.routeToWishList()
    }

    @IBAction func goToOrders(_ sender: Any) {
        self.router.routeToOrders()
    }

    @IBAction func addToWishList(_ sender: Any) {
        self.interactor.addRemoveProductToWithList()
    }
    
    @IBAction func addToCart(_ sender: Any) {
        self.interactor.addToCart()
        self.addToCartButton.startLoading()
        self.addToCartView.isHidden = true
    }
    
    @IBAction func shareProduct(_ sender: Any) {
        
    }
    
    @IBAction func changeQuantity(_ sender: Any) {
        
        let maxQuantity = self.dataStore.productDetails?.count ?? 1
        let quantities = 1..<maxQuantity
        let rows = quantities.map { String($0) }

        ActionSheetStringPicker.show(withTitle: "Quantity", rows: rows, initialSelection: 0, doneBlock: { picker, indexes, values in
            self.quanitityLabel.text = rows[indexes]
            let value = Int(rows[indexes]) ?? 1
            self.dataStore.productQuantoty = value
        }, cancel: { ActionMultipleStringCancelBlock in return }, origin: sender)
    }
    
    @IBAction func increaseCount(_ sender: Any) {
        let quantity: Int = ((self.dataStore.productDetails?.quantity ?? 0) + 1)
        self.interactor.updateProductQuantity(quantity: quantity)
    }
    
    @IBAction func decreaseCount(_ sender: Any) {
        let quantity = ((self.dataStore.productDetails?.quantity ?? 0) - 1)
        self.interactor.updateProductQuantity(quantity: quantity)
    }
}

extension ProductDetailsViewController: ProductDetailsSceneDisplayView {
    
    func displayProduct(viewModel: ProductDetailsScene.Product.ViewModel) {
        self.productTitleLabel.text = viewModel.product.name
        self.productDescLabel.text = viewModel.product.desc
        self.priceLabel.text = "QAR" + " " + viewModel.product.price
        if viewModel.product.isWishList {
            let image = self.wishListButton.imageView?.image?.imageWithColor(color: #colorLiteral(red: 0.6274509804, green: 0.1176470588, blue: 0.1568627451, alpha: 1))
            self.wishListButton.setImage(image, for: .normal)
        } else {
            self.wishListButton.setImage(#imageLiteral(resourceName: "WishListProduct"), for: .normal)
        }
        self.pageControl.numberOfPages = viewModel.product.images.count
        self.collectionView.reloadData()
        
        
        self.quatityView.isHidden = !viewModel.product.isCart
        self.addToCartButtonView.isHidden = viewModel.product.isCart
        self.cartQuatityLabel.text = "\(viewModel.product.quantity)"
    }
    
    func displayAddedToCart() {
        self.addToCartButton.stopLoading()
        self.addToCartView.isHidden = false
    }
    
    func displayError(message: String) {
        self.addToCartButton.stopLoading()
        self.addToCartView.isHidden = false
        AlertView.show(message: message, state: .error, sender: self)
    }
}

extension ProductDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewStore.product?.product.images.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KuludProductDetailsImageCell.identifier, for: indexPath) as! KuludProductDetailsImageCell
        cell.configureCell((self.viewStore.product?.product.images[indexPath.row])!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

extension ProductDetailsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page: Int = Int(scrollView.contentOffset.x / scrollView.frame.width)
        self.pageControl.currentPage = page
    }
}
