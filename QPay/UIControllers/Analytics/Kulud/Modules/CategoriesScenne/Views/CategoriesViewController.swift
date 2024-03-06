//
//  CategoriesViewController.swift
//  kulud
//
//  Created by Hussam Elsadany on 27/03/2021.
//  Copyright © 2021 Qmobile-IT. All rights reserved.
//

import UIKit

protocol CategoriesSceneDisplayView: AnyObject {
    func displayTitle(viewModel: CategoriesScene.Category.ViewModel)
    func displayProducts(viewModel: CategoriesScene.Products.ViewModel)
    func displayError(message: String)
}

class CategoriesViewController: KuludViewController {

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var categoryTitleLabel: UILabel!
    @IBOutlet private weak var cartCountLabel: UILabel!

    var interactor: CategoriesSceneBusinessLogic!
    var dataStore: CategoriesSceneDataStore!
    var viewStore: CategoriesSceneViewDataStore!
    var router: CategoriesSceneRoutingLogic!
    
    private var isShimmering: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.interactor.getCategoryName()
        self.interactor.getCategoryProducts()
        CartManager.shated.updateCartCount()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.updateNotificationCount(notification:)),
                                               name: Notification.Name("CartCountNotificationkey"),
                                               object: nil)
    }
    
    private func setupView() {
        self.collectionView.registerCell(CategoryItemCell.identifier)
        if let textField = self.searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = .white
        }
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
    
    @IBAction func openFilters(_ sender: Any) {
        self.router.routeToFilters(subCategories: self.dataStore.selectedCategory?.subCategories ?? [])
    }
}

extension CategoriesViewController: CategoriesSceneDisplayView {
    
    func displayTitle(viewModel: CategoriesScene.Category.ViewModel) {
        self.categoryTitleLabel.text = viewModel.Category.name
    }
    
    func displayProducts(viewModel: CategoriesScene.Products.ViewModel) {
        self.isShimmering = false
        self.collectionView.reloadData()
    }
    
    func displayError(message: String) {
        AlertView.show(message: message, state: .error, sender: self)
    }
}

extension CategoriesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.isShimmering ? 20 : self.viewStore.products?.products.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryItemCell.identifier, for: indexPath) as! CategoryItemCell
        self.isShimmering ? cell.startAnimation() : cell.configureCell((self.viewStore.products?.products[indexPath.row])!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 3, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !isShimmering else {
            return
        }
        self.router.routeToProductDetails(self.dataStore.selectedCategory!.products![indexPath.row])
    }
}

extension CategoriesViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.interactor.search(keyword: searchBar.text!)
    }
}

extension CategoriesViewController: FilterViewControllerDelegate {
    func filterSceneDidTapFilter(subCategory: CategoryModel?, minimumPrice: Double?, maximumPrice: Double?) {
        if let category = subCategory {
            self.dataStore.selectedCategory = category
        }
        self.dataStore.minmumPrice = minimumPrice
        self.dataStore.maximumPrice = maximumPrice
        self.interactor.applyFilter()
    }
}
