//
//  KuludOrderDetailsViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 18/01/2022.
//  Copyright © 2022 Dev. Mohmd. All rights reserved.
//

import UIKit

class KuludOrderDetailsViewController: KuludViewController {
    
    @IBOutlet weak var orderStatusLabel: UILabel!
    
    @IBOutlet weak var orderIDLabel: UILabel!
    
    @IBOutlet weak var orderTimeLabel: UILabel!
    
    @IBOutlet weak var shopNameLabel: UILabel!
    
    @IBOutlet weak var productsTableView: UITableView!
    
    @IBOutlet weak var subTotalLabel: UILabel!
    
    @IBOutlet weak var deliveryChargesLabel: UILabel!
    
    @IBOutlet weak var orderTotalLabel: UILabel!
    
    var order: KuludOrder!
    var orderDetails = [KuludOrderDetails]()
    
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

extension KuludOrderDetailsViewController {
    
    func setupView() {
        self.productsTableView.registerNib(KuludOrderDetailsTableViewCell.self)
        self.productsTableView.delegate = self
        self.productsTableView.dataSource = self
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
        Network.shared.request(request: OrderBuilder.getOrderDetails(self.order._id)) { (result: KuludResult<ApiResponse<OrderDetailsResponse>>) in
            switch result {
            case .success(let response):
                let orderDetailsResponse = response.responseObject
                
                /// Order section labels...
                self.orderStatusLabel.text = orderDetailsResponse?.orderStatus?.statusObject?.title
                self.orderIDLabel.text = orderDetailsResponse?.orderStatus?.orderId
                if let dateString = orderDetailsResponse?.orderStatus?.createDateTime,
                   let date = dateString.formatToDate(ServerDateFormat.Server1.rawValue) {
                    self.orderTimeLabel.text = date.formatDate("dd-MM-yyyy HH:mm")
                }
                
                /// Products section labels...
                self.shopNameLabel.text = "Kulud Pharamcy"
                self.orderDetails = orderDetailsResponse?._orderDetails ?? []
                self.productsTableView.reloadData()
                
                /// Summary section labels...
                let subTotal = (orderDetailsResponse?.cart?.subTotal ?? 0.0).formatNumber()
                self.subTotalLabel.text = "QAR \(subTotal)"
                let shipment = (orderDetailsResponse?.cart?.shipment ?? 0.0).formatNumber()
                self.deliveryChargesLabel.text = "QAR \(shipment)"
                let orderTotal = (orderDetailsResponse?.cart?.total ?? 0.0).formatNumber()
                self.orderTotalLabel.text = "QAR \(orderTotal)"
                break
                
            case .failure(let error):
                AlertView.show(message: error.localizedDescription, state: .error, sender: self)
                break
            }
        }
    }
}


// MARK: - ACTIONS

extension KuludOrderDetailsViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - TABLE VIEW DELEGATE

extension KuludOrderDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orderDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(KuludOrderDetailsTableViewCell.self, for: indexPath)
        
        let object = self.orderDetails[indexPath.row]
        cell.object = object
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let object = self.orderDetails[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

// MARK: - CUSTOM FUNCTIONS

extension KuludOrderDetailsViewController {
    
}

