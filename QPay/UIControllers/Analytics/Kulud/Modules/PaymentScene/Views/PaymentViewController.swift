//
//  PaymentViewController.swift
//  kulud
//
//  Created by Hussam Elsadany on 07/06/2021.
//  Copyright (c) 2021 Qmobile-IT. All rights reserved.
//

import UIKit

protocol PaymentSceneDisplayView: AnyObject {

}

class PaymentViewController: KuludViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var checkoutView: UIView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    var interactor: PaymentSceneBusinessLogic!
    var dataStore: PaymentSceneDataStore!
    var viewStore: PaymentSceneViewStore!
    var router: PaymentSceneRoutingLogic!

    private var rowHeight: CGFloat = 80.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    private func setupView() {
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.registerCell(PaymentMethodTableViewCell.identifier)
        self.tableViewHeightConstraint.constant = self.rowHeight * 4 // TODO: ToBeChanged
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension PaymentViewController: PaymentSceneDisplayView {

}

extension PaymentViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PaymentMethodTableViewCell.identifier) as! PaymentMethodTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.rowHeight
    }
}

