//
//  NotificationsViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/10/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class NotificationsViewController: MainController {
    
    @IBOutlet weak var notificationsTable: UITableView!
    
    var notifications = [NotificationModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        localized()
        setupData()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
}

extension NotificationsViewController {
    
    func setupView() {
        
        self.changeStatusBarBG(color: .clear)
        self.notificationsTable.delegate = self
        self.notificationsTable.dataSource = self
        
        self.requestProxy.requestService()?.delegate = self
    }
    
    func localized() {
    }
    
    func setupData() {
        self.notificationsRequest()
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension NotificationsViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - TABLE VIEW DELEGATE

extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(NotificationTableViewCell.self, for: indexPath)
        
        let not = self.notifications[indexPath.row]
        cell.notification = not
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let notification = self.notifications[indexPath.row]
        
        if let id = notification.id {
            self.requestProxy.requestService()?.updateNotificationStatus(id, completion: { (status, response) in
            })
        }
        
        if notification.typeID == 10 {
            guard let ref = notification.referenceID else { return }
            
            self.requestProxy.requestService()?.validateTransfer(referenceID: ref, completion: { (status, response) in
                DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                    if status {
                        let vc = self.getStoryboardView(ConfirmPaymentRequestViewController.self)
                        vc.notification = notification
                        vc.updateViewElementDelegate = self
                        vc.delegate = self
                        self.present(vc, animated: true)
                        
                    }else {
                        self.openRemoveNotificationView(notification)
                    }
                }
            })
            
        }else if notification.typeID == 7 {
            guard let orderID = notification.referenceID else { return }
            
            self.requestProxy.requestService()?.getOrderDetails(orderID, completion: { (status, order) in
                if status {
                    if let ord = order {
                        let vc = self.getStoryboardView(OrderDetailsViewController.self)
                        vc.order = ord
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            })
            
        }else {
            self.openRemoveNotificationView(notification)
        }
    }
}

// MARK: - REQUESTS DELEGATE

extension NotificationsViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .getNotificationList ||
            request == .validateTransfer {
            showLoadingView(self)
        }
    }
    
    func requestFinished(request: RequestType, result: ResponseResult) {
        hideLoadingView()
        
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

// MARK: - UPDATE VIEW ELEMENTS DELEGATE

extension NotificationsViewController: UpdateViewElement {
    
    func elementUpdated(fromSourceView view: UIViewController, status: Bool, data: Any?) {
        
        if view is ConfirmPaymentRequestViewController ||
            view is ConfirmPinCodeViewController ||
            view is RemovePaymentRequestViewController {
            DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                self.viewWillAppear(true)
                if status,
                   let data = data as? String {
                    self.showSuccessMessage(data)
                }
                self.setupData()
            }
        }
    }
}

// MARK: - CONFIRM PAYMENT DELEGATE

extension NotificationsViewController: ConfirmPaymentRequestDelegate {
    
    func didTapPayButton(notification: NotificationModel) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
            let vc = self.getStoryboardView(ConfirmPinCodeViewController.self)
            vc.notification = notification
            vc.updateViewElementDelegate = self
            self.present(vc, animated: true)
        }
    }
    
    func didTapCancelButton(notification: NotificationModel) {
        
        self.viewWillAppear(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
            if let notID = notification.id, let refID = notification.referenceID {
                self.requestProxy.requestService()?.cancelPaymentRequests(id: refID) { (status, response) in
                    guard status == true else { return }
                    
                    self.requestProxy.requestService()?.removeNotification(id: notID, completion: { (status, response) in
                        guard status == true else { return }
                    
                        self.showSuccessMessage(response?.message ?? "Payment request Canceled successfully")
                        self.setupData()
                    })
                }
            }
        }
    }
}

// MARK: - CUSTOM FUNCTIONS

extension NotificationsViewController {
    
    public func openRemoveNotificationView(_ notification: NotificationModel) {
        let vc = self.getStoryboardView(RemovePaymentRequestViewController.self)
        vc.notification = notification
        vc.updateViewElementDelegate = self
        self.present(vc, animated: true)
    }
    
    private func notificationsRequest() {
        
        self.dispatchGroup.enter()
        
        self.requestProxy.requestService()?.getNotificationList { (notifications) in
                // "2020-07-02T14:34:57.83"
                
                let arr = notifications ?? []
                
                self.notifications.removeAll()
                self.notifications = arr.reversed()
                
                self.dispatchGroup.leave()
            }
        
        self.dispatchGroup.notify(queue: .main) {
            self.notificationsTable.reloadData()
        }
    }
    
    private func updateNotificationsStatusRequest() {
        
//        let unReadNotifications = self.notifications.filter({ $0.isReadByUser == false })
//        let ids = unReadNotifications.map({ $0.id ?? 0 })
//
//        self.requestProxy.requestService()?.updateNotificationsStatus(ids, completion: { (status, response) in
//            if status {
//            }
//        })
    }
}
