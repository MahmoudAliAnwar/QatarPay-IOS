//
//  AddInvoiceViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/6/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class MyOrdersViewController: ShopController {
    
    @IBOutlet weak var emptyOrdersStackView: UIStackView!
    @IBOutlet weak var ordersCollectionView: UICollectionView!
    
    @IBOutlet weak var pendingView: UIView!
    @IBOutlet weak var completedView: UIView!
    
    var orders = [Order]()
    var ordersAll = [Order]()
    var selectedShop: Shop!
    
    private var updateClosure: UpdateClosure?
    
    var colors: [UIColor] = [
        .magenta,
        .systemOrange,
        .systemBlue,
        .systemPurple,
        .systemGreen,
        .systemRed
    ]
    
    private enum TabButton: String {
        case Pending
        case Completed
    }
    
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
        
        guard let shopID = self.selectedShop.id else { return }
        
        self.dispatchGroup.enter()
        self.requestProxy.requestService()?.getOrderListByShopID(shopID: shopID) { (status, myOrders) in
            guard let orders = myOrders else { return }
            self.orders = orders
            self.ordersAll = orders
            self.dispatchGroup.leave()
        }
        
        self.dispatchGroup.notify(queue: .main) {
            self.setTabButton(.Pending)
            self.ordersCollectionView.reloadData()
            self.isUserHasOrders(self.orders.isEmpty)
        }
    }
}

extension MyOrdersViewController {
    
    func setupView() {
        self.ordersCollectionView.delegate = self
        self.ordersCollectionView.dataSource = self
        
        self.setTabButton(.Pending)
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension MyOrdersViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func pendingAction(_ sender: UIButton) {
        self.setTabButton(.Pending)
    }

    @IBAction func completedAction(_ sender: UIButton) {
        self.setTabButton(.Completed)
    }
}

// MARK: - COLLECTION VIEW DELEGATE

extension MyOrdersViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.orders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueCell(MyOrderCollectionViewCell.self, for: indexPath)
        
        let randomInt = Int.random(in: 0..<self.colors.count)
        let color = self.colors[randomInt]
        cell.color = color
        
        let order = self.orders[indexPath.row]
        cell.order = order
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let viewWidth = self.view.width
        return .init(width: viewWidth, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = self.getStoryboardView(OrderDetailsViewController.self)
        let order = self.orders[indexPath.row]
        vc.order = order
        vc.updateElementDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UPDATE VIEW ELEMENTS DELEGATE

extension MyOrdersViewController: UpdateViewElement {
    
    func elementUpdated(fromSourceView view: UIViewController, status: Bool, data: Any?) {
        guard status,
              view is OrderDetailsViewController else {
            return
        }
        guard let message = data as? String else { return }
        self.updateClosure = (status, message)
    }
}

// MARK: - REQUESTS DELEGATE

extension MyOrdersViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .getOrderListByShopID {
            showLoadingView(self)
        }
    }
    
    func requestFinished(request: RequestType, result: ResponseResult) {
        hideLoadingView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
            switch result {
            case .Success(_):
                guard let closure = self.updateClosure,
                      closure.isSuccess else {
                    return
                }
                self.showSuccessMessage(closure.message)
                self.updateClosure = nil
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
                        self.showErrorMessage(err.localizedDescription)
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

extension MyOrdersViewController {
    
    private func setTabButton(_ btn: TabButton) {
        
        UIView.animate(withDuration: 0.3) {
            switch btn {
            case .Pending:
                self.setPendingView(btn)
                self.setCompletedView(btn)
                
                self.orders = self.ordersAll.filter({ ($0._paymentStatus) == btn.rawValue })
                
            case .Completed:
                self.setPendingView(btn)
                self.setCompletedView(btn)

                self.orders = self.ordersAll.filter({ ($0._paymentStatus) != TabButton.Pending.rawValue })
            }
            self.isUserHasOrders(self.orders.isEmpty)
            self.ordersCollectionView.reloadData()
        }
    }
    
    private func setPendingView(_ btn: TabButton) {
        self.pendingView.backgroundColor = btn == .Pending ? .orange : .clear
    }
    
    private func setCompletedView(_ btn: TabButton) {
        self.completedView.backgroundColor = btn == .Completed ? .orange : .clear
    }
    
    private func isUserHasOrders(_ status: Bool) {
        self.ordersCollectionView.isHidden = status
        self.emptyOrdersStackView.isHidden = !status
    }
}
