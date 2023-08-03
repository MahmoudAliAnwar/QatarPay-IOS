//
//  CartViewController.swift
//  kulud
//
//  Created by Hussam Elsadany on 10/03/2021.
//  Copyright (c) 2021 Qmobile-IT. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

protocol CartSceneDisplayView: AnyObject {
    func displayProducts(viewModel: CartScene.Product.ViewModel)
    func displayCart(viewModel: CartScene.Cart.ViewModel, cartModel: CartModel)
    func displayError(message: String)
}

class CartViewController: KuludViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var checkoutView: UIView!
    @IBOutlet private weak var subTotalLabel: UILabel!
    @IBOutlet private weak var deliveryFeeLabel: UILabel!
    @IBOutlet private weak var discountLabel: UILabel!
    @IBOutlet private weak var totalLabel: UILabel!
    @IBOutlet private weak var taxLabel: UILabel!
    @IBOutlet weak var emptyDataView: UIView!
    
    var interactor: CartSceneBusinessLogic!
    var dataStore: CartSceneDataStore!
    var viewStore: CartSceneViewDataStore!
    var router: CartSceneRoutingLogic!
    private var isShimmering = true
    
    private var cartModel: CartModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.interactor.getCartDetails()
    }
    
    private func setupView() {
        self.checkoutView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        self.tableView.registerCell(CartTableViewCell.identifier)
        self.checkoutView.transform = CGAffineTransform(translationX: 0, y: self.checkoutView.frame.height + 50)
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func goToWishList(_ sender: Any) {
        self.router.routeToWishList()
    }
    
    @IBAction func goToOrders(_ sender: Any) {
        self.router.routeToOrders()
    }
    
    @IBAction func checkout(_ sender: Any) {
        guard let cart = self.cartModel else { return }
        self.router.routeToShippingAddressPage(cartModel: cart)
    }
}

extension CartViewController: CartSceneDisplayView {
    
    func displayProducts(viewModel: CartScene.Product.ViewModel) {
        self.isShimmering = false
        self.tableView.reloadData()
        
        if viewModel.products.count == 0 {
            self.emptyDataView.isHidden = viewModel.products.count != 0
            UIView.animate(withDuration: 0.7, delay: 0.3, usingSpringWithDamping: 0.9, initialSpringVelocity: 10, options: .curveEaseIn) {
                self.checkoutView.transform = CGAffineTransform(translationX: 0, y: self.checkoutView.frame.height + 50)
            } completion: { finished in }
        }
    }
    
    func displayCart(viewModel: CartScene.Cart.ViewModel, cartModel: CartModel) {
        self.cartModel = cartModel
        self.subTotalLabel.text = viewModel.cart.subTotal
        self.deliveryFeeLabel.text = viewModel.cart.shipment
        self.taxLabel.text = viewModel.cart.tax
        self.discountLabel.text = viewModel.cart.discount
        self.totalLabel.text = viewModel.cart.total
        guard self.viewStore.products?.products.count != 0 else {
            return
        }
        UIView.animate(withDuration: 0.7, delay: 0.3, usingSpringWithDamping: 0.9, initialSpringVelocity: 10, options: .curveEaseIn) {
            self.checkoutView.transform = .identity
        } completion: { finished in }
    }
    
    func displayError(message: String) {
        AlertView.show(message: message, state: .error, sender: self)
    }
}

extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isShimmering ? 5 : self.viewStore.products?.products.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.identifier) as! CartTableViewCell
        self.isShimmering ? cell.startAnimation() : cell.configureCell((self.viewStore.products?.products[indexPath.row])!, indexPath: indexPath)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

extension CartViewController: CartTableViewCellDelegate {
    func cartTableView(cell: CartTableViewCell, didTapChangeQuantityFor item: IndexPath) {
        guard let product = self.dataStore.cartDetails?.shoppings?[item.row].product else {
            return
        }
        self.changeQuantity(product)
    }
    
    func cartTableView(cell: CartTableViewCell, didTapRemoveFor item: IndexPath) {
        guard let product = self.dataStore.cartDetails?.shoppings?[item.row].product else {
            return
        }
        self.interactor.updateProduct(productId: product.id!, quantity: 0)
        NotificationCenter.default.post(name: .updateHomeData, object: nil)
    }
}

extension CartViewController {
    
    private  func changeQuantity(_ product: ProductModel) {
        
        let maxQuantity = product.count ?? 1
        let quantities = 1..<maxQuantity
        let rows = quantities.map { String($0) }

        ActionSheetStringPicker.show(withTitle: "Quantity", rows: rows, initialSelection: 0, doneBlock: { picker, indexes, values in
            let value = Int(rows[indexes]) ?? 1
            self.interactor.updateProduct(productId: product.id!, quantity: value)
        }, cancel: { ActionMultipleStringCancelBlock in return }, origin: self.view)
    }
}
