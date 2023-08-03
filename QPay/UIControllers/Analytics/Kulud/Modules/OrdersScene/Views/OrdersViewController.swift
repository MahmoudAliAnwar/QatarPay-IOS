//
//  OrdersViewController.swift
//  kulud
//
//  Created by Hussam Elsadany on 09/06/2021.
//  Copyright (c) 2021 Qmobile-IT. All rights reserved.
//

import UIKit

private enum PageState {
    case all
    case pending
    case completed
}

protocol OrdersSceneDisplayView: AnyObject {

}

class OrdersViewController: KuludViewController {

    @IBOutlet private weak var allButton: UIButton!
    @IBOutlet private weak var pendignButton: UIButton!
    @IBOutlet private weak var completedButton: UIButton!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var allMiddleConstraint: NSLayoutConstraint!
    @IBOutlet private weak var pendingMiddleConstraint: NSLayoutConstraint!
    @IBOutlet private weak var completeMidlleConstraint: NSLayoutConstraint!
    @IBOutlet private weak var cartCountLabel: UILabel!
    
    var interactor: OrdersSceneBusinessLogic!
    var dataStore: OrdersSceneDataStore!
    var viewStore: OrdersSceneViewStore!
    var router: OrdersSceneRoutingLogic!

    private var pageState: PageState = .all
    
    private var orders = [KuludOrder]()
    private var ordersAll = [KuludOrder]()
    
    private var isShimmering: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        Network.shared.request(request: OrderBuilder.getAllOrders) { (result: KuludResult<ApiResponse<[KuludOrder]>>) in
            switch result {
            case .success(let response):
                let list = response.responseObject ?? []
                self.orders = list
                self.ordersAll = list
                self.isShimmering = false
                self.tableView.reloadData()
                break
            case .failure(let error):
                AlertView.show(message: error.localizedDescription, state: .error, sender: self)
                break
            }
        }
        let cartManager = CartManager.shated
        cartManager.updateCartCount()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.updateNotificationCount(notification:)),
                                               name: Notification.Name(cartManager.cartCountNotificationkey),
                                               object: nil)

    }
    
    private func setupView() {
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.registerCell(KuludOrderTableViewCell.identifier)
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
    
    @IBAction func allAction(_ sender: Any) {
        self.pageState = .all
        self.orders = self.ordersAll
        self.tableView.reloadData()
        self.resetSelection()
        self.allButton.setTitleColor(.white.withAlphaComponent(1.0), for: .normal)
        self.allMiddleConstraint.priority = .defaultHigh
        self.animateView()
    }
    
    @IBAction func pendingAction(_ sender: Any) {
        self.pageState = .pending
        self.orders = self.ordersAll.filter({ $0.statusObject == .PendingOnDeleviry })
        self.tableView.reloadData()
        self.resetSelection()
        self.pendignButton.setTitleColor(.white.withAlphaComponent(1.0), for: .normal)
        self.pendingMiddleConstraint.priority = .defaultHigh
        self.animateView()
    }
    
    @IBAction func completeAction(_ sender: Any) {
        self.pageState = .completed
        self.orders = self.ordersAll.filter({ $0.statusObject == .Completed })
        self.tableView.reloadData()
        self.resetSelection()
        self.completedButton.setTitleColor(.white.withAlphaComponent(1.0), for: .normal)
        self.completeMidlleConstraint.priority = .defaultHigh
        self.animateView()
    }
    
    private func resetSelection() {
        self.allButton.setTitleColor(.white.withAlphaComponent(0.5), for: .normal)
        self.pendignButton.setTitleColor(.white.withAlphaComponent(0.5), for: .normal)
        self.completedButton.setTitleColor(.white.withAlphaComponent(0.5), for: .normal)
        self.allMiddleConstraint.priority = .defaultLow
        self.pendingMiddleConstraint.priority = .defaultLow
        self.completeMidlleConstraint.priority = .defaultLow
    }
    
    private func animateView() {
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 20, options: .curveEaseOut) {
            self.view.layoutIfNeeded()
        } completion: { finished in }
    }
}

extension OrdersViewController: OrdersSceneDisplayView {

}

extension OrdersViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isShimmering ? 6 : self.orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: KuludOrderTableViewCell.identifier) as! KuludOrderTableViewCell
        
        if self.isShimmering {
            cell.startAnimation()
        } else {
            cell.object = self.orders[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = self.orders[indexPath.row]
        let vc = KuludOrderDetailsViewController()
        vc.order = object
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
