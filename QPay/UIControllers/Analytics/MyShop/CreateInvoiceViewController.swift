//
//  AddInvoiceViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/6/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class CreateInvoiceViewController: ShopController {
    
    @IBOutlet weak var productsTableView: UITableView!
    
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var discountTextField: UITextField!
    @IBOutlet weak var dileveryTextField: UITextField!
    @IBOutlet weak var totalLabel: UILabel!
    
    var cartItems = [CartItem]()
    var selectedShop: Shop!
    
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
        
        let subTotal = self.cart.getCartSubTotal()
        self.setSubTotalToLabel(subTotal)
        self.setTotalToLabel(subTotal)
    }
}

extension CreateInvoiceViewController {
    
    func setupView() {
        self.productsTableView.registerNib(ProductTableViewCell.self)
        
        self.productsTableView.delegate = self
        self.productsTableView.dataSource = self
        
        self.discountTextField.addTarget(self, action: #selector(self.discountFieldDidChanged(_:)), for: .editingChanged)
        self.dileveryTextField.addTarget(self, action: #selector(self.dileveryFieldDidChanged(_:)), for: .editingChanged)
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
        self.cartItems = self.cart.getCartItems()
        self.productsTableView.reloadData()
    }
}

// MARK: - ACTIONS

extension CreateInvoiceViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func proceedAction(_ sender: UIButton) {
        
        let order = super.shopConcrete.casher.createOrder(self.cart,
                                                          discount: self.getDiscountFromField(),
                                                          delivery: self.getDeliveryFromField())
        
        let vc = self.getStoryboardView(CreateInvoice2ViewController.self)
        vc.order = order
        vc.selectedShop = self.selectedShop
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func deleteAction(_ sender: UIButton) {
        super.cart.removeCartItems()
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - TEXT FIELD DELEGATE

extension CreateInvoiceViewController: UITextFieldDelegate {
    
    @objc private func discountFieldDidChanged(_ textField: UITextField) {
        self.calcAndSetTotalToLabel()
    }
    
    @objc private func dileveryFieldDidChanged(_ textField: UITextField) {
        self.calcAndSetTotalToLabel()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        
        if textField == self.discountTextField {
            return count <= 2
        }
        return true
    }
}

// MARK: - TABLE VIEW DELEGATE

extension CreateInvoiceViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(ProductTableViewCell.self, for: indexPath)
        
        let item = self.cartItems[indexPath.row]
        cell.cartItem = item
        
        return cell
    }
}

// MARK: - PRIVATE FUNCTIONS

extension CreateInvoiceViewController {
    
    private func calcAndSetTotalToLabel() {
        self.setTotalToLabel(self.getInvoiceTotal())
    }
    
    private func setSubTotalToLabel(_ subTotal: Double) {
        self.subTotalLabel.text = subTotal.formatNumber()
    }
    
    private func setTotalToLabel(_ total: Double) {
        self.totalLabel.text = total.formatNumber()
    }
    
    private func getDiscountFromField() -> Double {
        if let discountString = self.discountTextField.text, discountString.isNotEmpty {
            guard let discount = Double(discountString) else { return 0.0 }
            return discount
        }
        return 0.0
    }
    
    private func getDeliveryFromField() -> Double {
        if let deliveryString = self.dileveryTextField.text, deliveryString.isNotEmpty {
            guard let delivery = Double(deliveryString) else { return 0.0 }
            return delivery
        }
        return 0.0
    }
    
    private func getInvoiceTotal() -> Double {
        return Casher.shared.calcTotal(self.cart.getCartSubTotal(),
                                       discount: self.getDiscountFromField(),
                                       delivery: self.getDeliveryFromField())
    }
}
