//
//  ShippingAddressViewController.swift
//  kulud
//
//  Created by Hussam Elsadany on 06/06/2021.
//  Copyright (c) 2021 Qmobile-IT. All rights reserved.
//

import UIKit

protocol ShippingAddressSceneDisplayView: AnyObject {

}

class ShippingAddressViewController: KuludViewController {

    @IBOutlet weak var addressesTableView: UITableView!
    
    var interactor: ShippingAddressSceneBusinessLogic!
    var dataStore: ShippingAddressSceneDataStore!
    var viewStore: ShippingAddressSceneViewStore!
    var router: ShippingAddressSceneRoutingLogic!

    var cartModel: CartModel?
    
    var createOrderCompletion: ((ApiResponse<CreateOrderResponse>) -> Void)?
    
    private var addresses = [Address]()
    
    private var selectedAddress: Address?
    private var selectedIndexPath: IndexPath?
    private var isShrimming: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addressesTableView.registerNib(KuludAddressTableViewCell.self)
        self.addressesTableView.delegate = self
        self.addressesTableView.dataSource = self
        self.addressesTableView.tableFooterView = UIView()
        
        self.requestProxy.requestService()?.getAddressList(completion: { status, list in
            guard status else { return }
            self.addresses = list ?? []
            self.addressesTableView.reloadData()
        })
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func continueToPayment(_ sender: Any) {
//        self.router.routeToPayment()
        guard let address = self.selectedAddress,
              let cart = self.cartModel,
              let total = cart.total else {
            return
        }
        let vc = self.getStoryboardView(ConfirmPinCodeViewController.self)
        vc.handler = { code in
            self.sendConfirmPayment(pinCode: code, amount: total) {
                self.sendCreateOrder(address: address)
            }
        }
        self.present(vc, animated: true)
    }
}

// MARK: - TABLE VIEW DELEGATE

extension ShippingAddressViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.addresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(KuludAddressTableViewCell.self, for: indexPath)
        let object = self.addresses[indexPath.row]
        cell.isChecked = self.selectedIndexPath == indexPath
        cell.object = object
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedAddress = self.addresses[indexPath.row]
        self.selectedIndexPath = indexPath
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension ShippingAddressViewController: ShippingAddressSceneDisplayView {
    
    private func sendConfirmPayment(pinCode: String, amount: Double, _ completion: @escaping voidCompletion) {
        self.showLoadingView(self)
        self.requestProxy.requestService()?.kuludConfirmPayment(pinCode: pinCode, amount: amount, { response in
            guard response?._success == true else {
                self.hideLoadingView(response?._message)
                return
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                completion()
            }
        })
    }
    
    private func sendCreateOrder(address: Address) {
        Network.shared.request(request: OrderBuilder.createOrder(address)) { (result: KuludResult<ApiResponse<CreateOrderResponse>>) in
            switch result {
            case .success(let response):
                self.hideLoadingView()
                guard response.success == true else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                    self.navigationController?.popViewController(animated: true)
                    self.createOrderCompletion?(response)
                }
                break
            case .failure(let error):
                self.hideLoadingView(error.localizedDescription)
                break
            }
        }
    }
}
