//
//  WishListSceneViewController.swift
//  kulud
//
//  Created by Hussam Elsadany on 05/06/2021.
//  Copyright (c) 2021 Qmobile-IT. All rights reserved.
//

import UIKit

protocol WishListSceneDisplayView: AnyObject {
    func displayProducts(viewModel: WishListSceneScene.Products.ViewModel)
    func displayError(message: String)
}

class WishListViewController: KuludViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var cartCountLabel: UILabel!
    
    var interactor: WishListSceneBusinessLogic!
    var dataStore: WishListSceneDataStore!
    var viewStore: WishListSceneViewStore!
    var router: WishListSceneRoutingLogic!
    private var isShimmering = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.interactor.getWishListData()
        CartManager.shated.updateCartCount()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.updateNotificationCount(notification:)),
                                               name: Notification.Name("CartCountNotificationkey"),
                                               object: nil)
    }
    
    private func setupView() {
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        self.tableView.registerCell(WishListTableViewCell.identifier)
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
    
    @IBAction func goToOrders(_ sender: Any) {
        self.router.routeToOrders()
    }
}

extension WishListViewController: WishListSceneDisplayView {

    func displayProducts(viewModel: WishListSceneScene.Products.ViewModel) {
        self.isShimmering = false
        self.tableView.reloadData()
    }
    
    func displayError(message: String) {
        AlertView.show(message: message, state: .error, sender: self)
    }
}

extension WishListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isShimmering ? 5 : self.viewStore.products?.products.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WishListTableViewCell.identifier) as! WishListTableViewCell
        self.isShimmering ? cell.startAnimation() : cell.configureCell((self.viewStore.products?.products[indexPath.row])!, indexPath: indexPath)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

extension WishListViewController: WishListTableViewCellDelegate {
    
    func wishList(cell: WishListTableViewCell, didTapMoveToCartFor item: IndexPath) {
        self.interactor.addItemToCart(index: item.row)
    }
    
    func wishList(cell: WishListTableViewCell, didTapDeleteFor item: IndexPath) {
        self.interactor.removeItemFromWishList(index: item.row)
    }
}
