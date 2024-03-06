//
//  InvoiceCreateExpressViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 12/02/2022.
//  Copyright © 2022 Dev. Mohmd. All rights reserved.
//

import UIKit

class InvoiceCreateExpressViewController: InvoiceViewController {
    
    @IBOutlet weak var amountTextField: UITextField!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var deliveryChargesTextField: UITextField!
    
    @IBOutlet weak var deliveryChargesCheckBoxViewDesign: ViewDesign!
    
    @IBOutlet weak var deliveryChargesCheckBox: CheckBox!
    
    @IBOutlet weak var taxTextField: UITextField!
    
    @IBOutlet weak var taxCheckBoxViewDesign: ViewDesign!
    
    @IBOutlet weak var taxCheckBox: CheckBox!
    
    @IBOutlet weak var onlineFeesTextField: UITextField!
    
    @IBOutlet weak var onlineFeesCheckBoxViewDesign: ViewDesign!
    
    @IBOutlet weak var onlineFeesCheckBox: CheckBox!
    
    private let background: UIColor = .systemGray4
    
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

extension InvoiceCreateExpressViewController {
    
    func setupView() {
        self.setupFieldViews()
        self.setupCheckBoxesViews()
        self.addCheckBoxesGestures()
        
        self.amountTextField.attributedPlaceholder = NSAttributedString(string: "0.00", attributes: [
            .foregroundColor : UIColor.white,
        ])
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension InvoiceCreateExpressViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
        guard let amountString = self.amountTextField.text, amountString.isNotEmpty,
              let description = self.descriptionTextView.text, description.isNotEmpty else {
            self.showSnackMessage("All fields is required")
            return
        }
        
        guard let amount = Double(amountString) else { return }
        
        var createInvoice = CreateInvoiceModel()
        createInvoice.description = description
        createInvoice.amount = amount
        createInvoice.number = "\((1...10000).randomElement() ?? 0)"
        
        if let deliveryString = self.deliveryChargesTextField.text,
           deliveryString.isNotEmpty,
           let delivery = Double(deliveryString) {
            
            createInvoice.deliveryCharges = delivery
        }
        
        if let taxString = self.taxTextField.text,
           taxString.isNotEmpty,
           let tax = Double(taxString) {
            
            createInvoice.taxCharges = tax
        }
        
        if let onlineFeesString = self.onlineFeesTextField.text,
           onlineFeesString.isNotEmpty,
           let onlineFees = Double(onlineFeesString) {
            
            createInvoice.onlineFee = onlineFees
        }
        
        let vc = self.getStoryboardView(InvoiceSendViewController.self)
        vc.createInvoice = createInvoice
        vc.invoiceType = .express
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - CUSTOM FUNCTIONS

extension InvoiceCreateExpressViewController {
    
    private func addCheckBoxesGestures() {
        self.deliveryChargesCheckBox.addTarget(self, action: #selector(self.didTapDeliveryCheckBox(_:)), for: .valueChanged)
        self.taxCheckBox.addTarget(self, action: #selector(self.didTapTaxCheckBox(_:)), for: .valueChanged)
        self.onlineFeesCheckBox.addTarget(self, action: #selector(self.didTapOnlineFeesCheckBox(_:)), for: .valueChanged)
    }
    
    @objc
    private func didTapDeliveryCheckBox(_ checkBox: CheckBox) {
        self.deliveryChargesTextField.isEnabled = checkBox.isChecked
    }
    
    @objc
    private func didTapTaxCheckBox(_ checkBox: CheckBox) {
        self.taxTextField.isEnabled = checkBox.isChecked
    }
    
    @objc
    private func didTapOnlineFeesCheckBox(_ checkBox: CheckBox) {
        self.onlineFeesTextField.isEnabled = checkBox.isChecked
    }
    
    private func setupCheckBoxesViews() {
        [
            self.deliveryChargesCheckBox,
            self.taxCheckBox,
            self.onlineFeesCheckBox,
        ].forEach({
            $0?.style = .tick
            $0?.borderWidth = 0
            $0?.checkedBorderColor = .clear
            $0?.checkmarkColor = .mBrown
        })
        
        [
            self.deliveryChargesCheckBoxViewDesign,
            self.taxCheckBoxViewDesign,
            self.onlineFeesCheckBoxViewDesign,
        ].forEach({
            $0?.cornerRadius = 4
            $0?.backgroundColor = self.background
        })
    }
    
    private func setupFieldViews() {
        
        [
            self.deliveryChargesTextField,
            self.taxTextField,
            self.onlineFeesTextField,
        ].forEach({
            $0?.backgroundColor = self.background
        })
    }
}
