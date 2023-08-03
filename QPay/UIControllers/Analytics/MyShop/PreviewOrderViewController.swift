//
//  PreviewOrderViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/7/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit
import DropDown

class PreviewOrderViewController: ShopController {
    
    @IBOutlet weak var archiveView: UIView!
    
    @IBOutlet weak var totalDueTopLabel: UILabel!
    @IBOutlet weak var customerNameLabel: UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var mobileLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var invoiceDateLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var deliveryLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var totalDueBottomLabel: UILabel!
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var reSendButton: UIButton!
    
    @IBOutlet weak var invoiceItemContainerView: ViewDesign!
    @IBOutlet weak var tableHeaderView: UIView!
    @IBOutlet weak var tableFooterView: UIView!
    
    @IBOutlet weak var invoiceItemsTableView: UITableView!
    
    var order: Order!
    var selectedShop: Shop?
    
    var isArchiveOrder: Bool = false
    
    var orderItems = [OrderDetails]()
    
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
    }
}

extension PreviewOrderViewController {
    
    func setupView() {
        let rad = self.invoiceItemContainerView.cornerRadius
        self.tableHeaderView.roundCorners([.topLeft, .topRight], radius: rad)
        self.tableFooterView.roundCorners([.bottomLeft, .bottomRight], radius: rad)
        
        self.archiveView.isHidden = true
        
        self.invoiceItemsTableView.delegate = self
        self.invoiceItemsTableView.dataSource = self
        
        let isPendingOrder = self.order.paymentStatusID == InvoicePaidStatus.Pending.rawValue ||
            self.order.paymentStatusID == InvoicePaidStatus.Failed.rawValue
        
        self.isHideArchiveButton((self.order.paymentStatusID != nil && isPendingOrder) || self.isArchiveOrder)
        self.isHideSendButton(self.selectedShop == nil)
        self.isShowResendButton(isPendingOrder)
    }
    
    func localized() {
    }
    
    func setupData() {
        var total = "QAR \(0.0)"
        if let invoiceTotal = self.order.orderTotal {
            let invTotalString = invoiceTotal.formatNumber()
            total = "QAR \(invTotalString)"
        }
        self.totalDueTopLabel.text = total
        self.companyNameLabel.text = self.order.companyName ?? ""
        self.customerNameLabel.text = self.order.customerName ?? ""
        self.mobileLabel.text = self.order.customerMobile ?? ""
        self.emailLabel.text = self.order.customerEmail ?? ""
        
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
            self.invoiceDateLabel.text = dateString
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
        self.numberLabel.text = self.order.orderNumber ?? ""
        self.statusLabel.text = self.order.paymentStatus ?? ""
        
        self.subTotalLabel.text = "QAR \(self.order.orderSubTotal ?? 0.00)"
        self.discountLabel.text = "QAR \(self.order.discount ?? 0)"
        self.deliveryLabel.text = "QAR \(self.order.deliveryCharges ?? 0.00)"
        self.totalLabel.text = total
        self.totalDueBottomLabel.text = total
        
        self.orderItems = self.order.orderDetails ?? []
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension PreviewOrderViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteAction(_ sender: UIButton) {
        guard let parentVC = self.navigationController?.getPreviousView() else { return }
        
        guard parentVC is InvoicesViewController else {
            self.cart.removeCartItems()
            self.navigationController?.popTo(MyProductsViewController.self)
            return
        }
        
        showConfirmation(message: "You want to delete this order") {
            self.requestProxy.requestService()?.deleteOrder(self.order._id, shopID: self.order._shopID, ( self.weakify { strong, response in
                guard response?.success == true else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                    strong.showSuccessMessage(response?.message ?? "Order deleted successfully")
                    strong.navigationController?.popViewController(animated: true)
                }
            }))
        }
    }
    
    @IBAction func archiveAction(_ sender: UIButton) {
        
        showConfirmation(message: "You want to archive this order") {
            self.requestProxy.requestService()?.archiveOrder(self.order._id, shopID: self.order._shopID, ( self.weakify { strong, response in
                guard response?.success == true else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                    strong.showSuccessMessage(response?.message ?? "Order archived successfully")
                    strong.navigationController?.popViewController(animated: true)
                }
            }))
        }
    }
    
    @IBAction func sendInvoiceAction(_ sender: UIButton) {
        
        guard let shopID = self.selectedShop?.id else {
            return
        }
        
        var items = [OrderItem]()
        self.orderItems.forEach { (orderDetail) in
            items.append(OrderItem(ShopID: shopID, ProductID: orderDetail.productID ?? 0,Quantity: orderDetail.quantity ?? 0.0))
        }
        self.requestProxy.requestService()?.createShopOrder(shopID: shopID, order: self.order, items: items) { (status, response) in
            guard status else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                self.cart.removeCartItems()
                
                guard let link = response?.orderPaymentLink,
                      let orderID = response?.orderID else {
                    return
                }
                let vc = self.getStoryboardView(SendOrderViewController.self)
                vc.link = link
                vc.shopID = shopID
                vc.order = self.order
                vc.orderID = orderID
                self.present(vc, animated: true)
            }
        }
    }

    @IBAction func resendInvoiceAction(_ sender: UIButton) {
        
        guard let link = self.order.paymentURL,
              let shopID = self.order.shopID else {
            return
        }
        
        self.requestProxy.requestService()?.getSubscriptionStatus(shopID: shopID, completion: { status, response in
            guard status,
                  let resp = response else {
                return
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                if resp._isSubscribed {
                    self.showSendOrderView(link: link, shopID: shopID)
                    
                } else {
                    let vc = self.getStoryboardView(SubscriptionFeeViewController.self)
                    vc.shopID = shopID
                    vc.response = resp
                    vc.onCompleteClousre = { status in
                        guard status else { return }
                        self.showSendOrderView(link: link, shopID: shopID)
                    }
                    self.present(vc, animated: true)
                }
            }
        })
    }
}

// MARK: - TABLE VIEW DELEGATE

extension PreviewOrderViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orderItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.InvoiceItemTableViewCell.rawValue, for: indexPath) as! InvoiceItemTableViewCell
        
        let item = self.orderItems[indexPath.row]
        cell.orderItem = item
        
        return cell
    }
}

// MARK: - REQUESTS DELEGATE

extension PreviewOrderViewController: RequestsDelegate {

    func requestStarted(request: RequestType) {
        if request == .createShopOrder ||
           request == .getSubscriptionStatus {
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

// MARK: - UPDATE VIEW ELEMENTS DELEGATE

extension PreviewOrderViewController: UpdateViewElement {
    
    func elementUpdated(fromSourceView view: UIViewController, status: Bool, data: Any?) {
        self.viewWillAppear(true)
        
        if view is SendOrderViewController,
           status {
            self.isHideSendButton(status)
            self.isShowResendButton(status)
        }
    }
}

// MARK: - PRIVATE FUNCTIONS

extension PreviewOrderViewController {
    
    private func showSendOrderView(link: String, shopID: Int) {
        let vc = self.getStoryboardView(SendOrderViewController.self)
        vc.link = link
        vc.order = self.order
        vc.shopID = shopID
        vc.updateViewElement = self
        self.present(vc, animated: true)
    }
    
    private func isHideSendButton(_ status: Bool) {
        self.sendButton.isHidden = status
    }
    
    private func isShowResendButton(_ status: Bool) {
        self.reSendButton.isHidden = !status
    }
    
    private func isHideArchiveButton(_ status: Bool) {
        self.archiveView.isHidden = status
    }
}
