//
//  KuludHomeViewController.swift
//  kulud
//
//  Created by Hussam Elsadany on 10/03/2021.
//  Copyright (c) 2021 Qmobile-IT. All rights reserved.
//

import UIKit

protocol HomeSceneDisplayView: AnyObject {
    func displayError(message: String)
    func displayCategories(viewModel: HomeScene.Categories.ViewModel)
    func displayAdvertisements1(viewModel: HomeScene.Advertisements.ViewModel)
    func displayAdvertisements2(viewModel: HomeScene.Advertisements.ViewModel)
    func displayCollections(viewModel: HomeScene.Collections.ViewModel)
}

class KuludHomeViewController: KuludViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var cartCountLabel: UILabel!

    var interactor: HomeSceneBusinessLogic!
    var dataStore: HomeSceneDataStore!
    var viewStore: HomeSceneViewDataStore!
    var router: HomeSceneRoutingLogic!
    
    private var advertisementsDataSource = AdvertisementDataSource()
    private var advertisements2DataSource = Advertisement2DataSource()
    private var categoriesDataSource = CategoriesDataSource()
    private var collectionsDataSource = CollectionDataSource()
    private var homeListDataSource = [HomeSceneDiffableListDataSource]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.interactor.getStoreDetails()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.updateHomeData(_:)),
                                               name: .updateHomeData,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.updateNotificationCount(_:)),
                                               name: Notification.Name(CartManager.shated.cartCountNotificationkey),
                                               object: nil)
    }
    
    private func setupView() {
        self.navigationController?.navigationBar.isHidden = true
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.registerCell(AdvertiseTableViewCell.identifier)
        self.tableView.registerCell(Advertisment2TableViewCell.identifier)
        self.tableView.registerCell(CategoryTableViewCell.identifier)
        self.tableView.registerCell(CollectionTableViewCell.identifier)
        
        self.homeListDataSource = [
            self.advertisementsDataSource,
            self.advertisements2DataSource,
            self.categoriesDataSource,
            self.collectionsDataSource
        ]
        
        self.categoriesDataSource.delegate  = self
        self.collectionsDataSource.delegate = self
    }
    
    @objc func updateHomeData(_ notification: Notification) {
        self.interactor.getStoreDetails()
    }
    
    @objc func updateNotificationCount(_ notification: Notification) {
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
}

extension KuludHomeViewController: HomeSceneDisplayView {
    
    func displayError(message: String) {
        AlertView.show(message: message, state: .error, sender: self)
    }
    
    func displayCategories(viewModel: HomeScene.Categories.ViewModel) {
        self.categoriesDataSource.categories = viewModel.categories
        self.tableView.reloadData()
    }
    
    func displayAdvertisements1(viewModel: HomeScene.Advertisements.ViewModel) {
        self.advertisementsDataSource.advertisements = viewModel.advertisements
        self.tableView.reloadData()
    }
    
    func displayAdvertisements2(viewModel: HomeScene.Advertisements.ViewModel) {
        self.advertisements2DataSource.advertisements = viewModel.advertisements
        self.tableView.reloadData()
    }
    
    func displayCollections(viewModel: HomeScene.Collections.ViewModel) {
        self.collectionsDataSource.collections = viewModel.collections
        self.tableView.reloadData()
    }
}

extension KuludHomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.homeListDataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.homeListDataSource[section].numberOfRows(at: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.homeListDataSource[indexPath.section].cellForRaw(at: indexPath, tableView: tableView)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.homeListDataSource[indexPath.section].heightForRaw(at: indexPath, tableView: tableView)
    }
}

extension KuludHomeViewController: CategoriesDataSourceDelegate, CollectionDataSourceDelegate {
    
    func didTapAddToCartForProductAt(_ indexPath: IndexPath) {
        self.interactor.addProductToCart(indexPath: indexPath)
    }
    
    func didSelectCategoryAt(_ index: Int) {
        if let category = self.dataStore.storeDetails?.categories?[index] {
            self.router.routeToCategory(category)
        }
    }
    
    func didSelectProductAt(_ indexPath: IndexPath) {
        if let product = self.dataStore.storeDetails?.collections?[indexPath.section].products?[indexPath.row] {
            self.router.routeToProductDetails(product)
        }
    }
    
    func didChangeQuantity(_ indexPath: IndexPath, quantity: Int) {
        self.interactor.updateProductQuantity(indexPath: indexPath, quantity: quantity)
    }
}

extension Notification.Name {
    static let updateHomeData = Notification.Name("UPDATE_HOME_DATA")
}
