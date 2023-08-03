//
//  OrderDetailsViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 12/28/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class OrderDetailsViewController: ShopController {

    @IBOutlet weak var totalDueTopLabel: UILabel!
    @IBOutlet weak var customerNameLabel: UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var mobileLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var orderDateLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var deliveryLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var totalDueBottomLabel: UILabel!
    
    @IBOutlet weak var sendOrderButton: UIButton!
    @IBOutlet weak var completeOrderEnabledButton: UIButton!
    @IBOutlet weak var completeOrderDisabledButton: UIButton!
    
    @IBOutlet weak var orderItemContainerView: ViewDesign!
    @IBOutlet weak var tableHeaderView: UIView!
    @IBOutlet weak var tableFooterView: UIView!
    
    @IBOutlet weak var orderItemsTableView: UITableView!
    
    var orderItems = [OrderDetails]()
    
    var order: Order!
    var updateElementDelegate: UpdateViewElement?
    
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
        
    }
}

extension OrderDetailsViewController {
    
    func setupView() {
        let radius = self.orderItemContainerView.cornerRadius
        self.tableHeaderView.roundCorners([.topLeft, .topRight], radius: radius)
        self.tableFooterView.roundCorners([.bottomLeft, .bottomRight], radius: radius)
        
        self.orderItemsTableView.delegate = self
        self.orderItemsTableView.dataSource = self
        self.requestProxy.requestService()?.delegate = self
    }
    
    func localized() {
    }
    
    func setupData() {
        var total = "QAR \(0.0)"
        if let orderTotal = self.order.orderTotal {
            let invTotalString = orderTotal.formatNumber()
            total = "QAR \(invTotalString)"
        }
        self.totalDueTopLabel.text = total
        self.companyNameLabel.text = self.order._companyName
        self.customerNameLabel.text = self.order._customerName
        self.mobileLabel.text = self.order._customerMobile
        self.emailLabel.text = self.order._customerEmail
        
        let viewDateFormat = "dd/MM/yyyy"
        
        if var orderDate = self.order.orderDate {
            var dateString = ""
            if let tRange = orderDate.range(of: "T") {
                orderDate.removeSubrange(tRange.lowerBound..<orderDate.endIndex)
                if let date = orderDate.convertFormatStringToDate(ServerDateFormat.DateWithoutTime.rawValue) {
                    dateString = date.formatDate(viewDateFormat)
                }
            }else {
                if let date = orderDate.formatToDate(viewDateFormat) {
                    dateString = date.formatDate(viewDateFormat)
                }
            }
            self.orderDateLabel.text = dateString
        }
        
        if var orderDueDate = self.order.orderDueDate {
            var dateString = ""
            if let tRange = orderDueDate.range(of: "T") {
                orderDueDate.removeSubrange(tRange.lowerBound..<orderDueDate.endIndex)
                if let date = orderDueDate.convertFormatStringToDate(ServerDateFormat.DateWithoutTime.rawValue) {
                    dateString = date.formatDate(viewDateFormat)
                }
            }else {
                if let date = orderDueDate.formatToDate(viewDateFormat) {
                    dateString = date.formatDate(viewDateFormat)
                }
            }
            self.dueDateLabel.text = dateString
        }
        self.numberLabel.text = self.order._orderNumber
        self.statusLabel.text = self.order._paymentStatus
        
        self.subTotalLabel.text = "QAR \(self.order._orderSubTotal)"
        self.discountLabel.text = "QAR \(self.order._discount)"
        self.deliveryLabel.text = "QAR \(self.order._deliveryCharges)"
        self.totalLabel.text = total
        self.totalDueBottomLabel.text = total
        
        guard let orderID = self.order.id else { return }
        self.dispatchGroup.enter()
        
        self.requestProxy.requestService()?.getOrderDetails(orderID) { (status, orderDetails) in
            guard let details = orderDetails else { return }
            
            if let paymentStatus = details.paymentStatus,
               let status = OrderStatus(rawValue: paymentStatus) {
                self.isCompleteOrder(status)
            }
            
            if let items = details.orderDetails {
                self.orderItems = items
                self.dispatchGroup.leave()
            }
        }
        
        self.dispatchGroup.notify(queue: .main) {
            self.orderItemsTableView.reloadData()
        }
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension OrderDetailsViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteOrderAction(_ sender: UIButton) {
        
        guard let orderID = self.order.id,
              let shopID = self.order.shopID else {
            return
        }
        
        self.showConfirmation(message: "you want to delete this order") {
            self.requestProxy.requestService()?.deleteOrder(orderID, shopID: shopID, ( self.weakify { strong, response in
                guard response?.success == true else { return }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                    strong.closeView(true, data: response?.message ?? "Deleted Successfully")
                }
            }))
        }
    }
    
    @IBAction func sendInvoiceAction(_ sender: UIButton) {
        
        guard let paymentURL = self.order.paymentURL,
              let shopID = self.order.shopID else {
            return
        }
        
        let vc = self.getStoryboardView(SendOrderViewController.self)
        vc.link = paymentURL
        vc.shopID = shopID
        vc.order = self.order
        self.present(vc, animated: true)
    }
    
    @IBAction func markAsCompletedAction(_ sender: UIButton) {
        
        guard let orderID = self.order.id,
              let shopID = self.order.shopID else {
            return
        }
        self.requestProxy.requestService()?.markOrderAsRead(orderID: orderID, shopID: shopID) { (status, response) in
            guard status else { return }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                self.closeView(true, data: response?.message ?? "Success")
            }
        }
    }
}

// MARK: - TABLE VIEW DELEGATE

extension OrderDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orderItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(InvoiceItemTableViewCell.self, for: indexPath)
        
        let item = self.orderItems[indexPath.row]
        cell.orderItem = item
        
        return cell
    }
}

// MARK: - REQUESTS DELEGATE

extension OrderDetailsViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .deleteOrder ||
            request == .markOrderAsRead ||
            request == .getOrderDetails {
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

// MARK: - CUSTOM FUNCTIONS

extension OrderDetailsViewController {
    
    private func closeView(_ status: Bool, data: Any? = nil) {
        self.updateElementDelegate?.elementUpdated(fromSourceView: self,
                                                   status: status,
                                                   data: data)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func isCompleteOrder(_ status: OrderStatus) {
        let isNotPending = status != .Pending
        self.completeOrderEnabledButton.isHidden = isNotPending
        self.completeOrderDisabledButton.isHidden = !isNotPending
        self.sendOrderButton.isHidden = status != .Pending
    }
}
