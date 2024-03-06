//
//  InvoiceCreateViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 15/02/2022.
//  Copyright © 2022 Dev. Mohmd. All rights reserved.
//

import UIKit

class InvoiceCreateViewController: InvoiceViewController {
    
    @IBOutlet weak var invoiceNumberTextField: UITextField!
    
    @IBOutlet weak var invoiceDateTextField: UITextField!
    
    @IBOutlet weak var invoiceDueDateTextField: UITextField!
    
    @IBOutlet weak var recipitantNameTextField: UITextField!
    
    @IBOutlet weak var recipitantCompanyTextField: UITextField!
    
    @IBOutlet weak var recipitantEmailTextField: UITextField!
    
    @IBOutlet weak var recipitantAddressTextField: UITextField!
    
    @IBOutlet weak var recipitantMobileTextField: UITextField!
    
    @IBOutlet weak var discountTextField: UITextField!
    
    @IBOutlet weak var totalTextField: UITextField!
    
    @IBOutlet weak var itemsTableView: UITableView!
    
    @IBOutlet weak var itemsTableViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var deliveryChargesTextField: UITextField!
    
    @IBOutlet weak var addClientDetailsCheckBoxViewDesign: ViewDesign!
    
    @IBOutlet weak var addClientDetailsCheckBox: CheckBox!
    
    @IBOutlet weak var deliveryCheckBoxViewDesign: ViewDesign!
    
    @IBOutlet weak var deliveryCheckBox: CheckBox!
    
    @IBOutlet weak var taxTextField: UITextField!
    
    @IBOutlet weak var taxCheckBoxViewDesign: ViewDesign!
    
    @IBOutlet weak var taxCheckBox: CheckBox!
    
    @IBOutlet weak var onlineFeesTextField: UITextField!
    
    @IBOutlet weak var onlineFeesCheckBoxViewDesign: ViewDesign!
    
    @IBOutlet weak var onlineFeesCheckBox: CheckBox!
    
    @IBOutlet weak var grandTotalTextField: UITextField!
    
    @IBOutlet weak var reoccuringCheckBoxViewDesign: ViewDesign!
    
    @IBOutlet weak var reoccuringCheckBox: CheckBox!

    @IBOutlet weak var weeklyCheckBoxViewDesign: ViewDesign!
    
    @IBOutlet weak var weeklyCheckBox: CheckBox!
    
    @IBOutlet weak var startDateTextField: UITextField!
    
    @IBOutlet weak var endDateTextField: UITextField!
    
    private var items = [CreateInvoiceModel.Item]()
    
    private let background: UIColor = .systemGray4
    private let cornerRadius: CGFloat = 4
    
    private let itemHeight: CGFloat = 38
    
    private var datePicker = UIDatePicker()
    private var dueDatePicker = UIDatePicker()
    private var startDatePicker = UIDatePicker()
    private var endDatePicker = UIDatePicker()
    
    private let dateFormat: String = "dd/MM/yyyy"
    
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

extension InvoiceCreateViewController {
    
    func setupView() {
        self.itemsTableView.delegate = self
        self.itemsTableView.dataSource = self
        
        self.setupCheckBoxesViews()
        self.addCheckBoxesGestures()
        self.setupFieldViews()
        
        [
            self.datePicker,
            self.dueDatePicker,
            self.startDatePicker,
            self.endDatePicker,
        ].forEach({
            $0.datePickerMode = .date
            if #available(iOS 13.4, *) {
                $0.preferredDatePickerStyle = .wheels
            } else {
                // Fallback on earlier versions
            }
        })
        
        [
            self.invoiceDateTextField,
            self.invoiceDueDateTextField,
            self.startDateTextField,
            self.endDateTextField,
        ].forEach({
            self.createDatePicker(for: $0)
        })
        
        [
            self.discountTextField,
            self.deliveryChargesTextField,
            self.taxTextField,
            self.onlineFeesTextField,
        ].forEach({
            $0?.delegate = self
        })
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
        self.items = [
            CreateInvoiceModel.Item(description: "prod 1", quantity: 10, rate: 20),
        ]
        
        if isForDeveloping {
            self.recipitantEmailTextField.text = "email@user.com"
            self.recipitantCompanyTextField.text = "company"
            self.recipitantNameTextField.text = "name"
            self.recipitantAddressTextField.text = "address"
            self.recipitantMobileTextField.text = "mobile"
            self.invoiceNumberTextField.text = "inv 1"
            self.discountTextField.text = "5"
            self.invoiceDateTextField.text = "04/04/2022"
            self.invoiceDueDateTextField.text = "05/05/2022"
//            self.startDateTextField.text = "04/04/2023"
//            self.endDateTextField.text = "05/05/2023"
        }
    }
}

// MARK: - ACTIONS

extension InvoiceCreateViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
        guard let number = self.invoiceNumberTextField.text, number.isNotEmpty,
              let date = self.invoiceDateTextField.text, date.isNotEmpty,
              let dueDate = self.invoiceDueDateTextField.text, dueDate.isNotEmpty,
              let recipitantName = self.recipitantNameTextField.text, recipitantName.isNotEmpty,
              let recipitantCompany = self.recipitantCompanyTextField.text, recipitantCompany.isNotEmpty,
              let recipitantEmail = self.recipitantEmailTextField.text, recipitantEmail.isNotEmpty,
              let recipitantAddress = self.recipitantAddressTextField.text, recipitantAddress.isNotEmpty,
              let recipitantMobile = self.recipitantMobileTextField.text, recipitantMobile.isNotEmpty else {
            self.showSnackMessage("All fields is required")
            return
        }
        
        let serverDateFormat: String = ServerDateFormat.Server2.rawValue
        
        var createInvoice = CreateInvoiceModel()
        createInvoice.number = number
        
        if let dateObject = date.formatToDate(self.dateFormat) {
            createInvoice.date = dateObject.formatDate(serverDateFormat)
        }
        
        if let dueDateObject = dueDate.formatToDate(self.dateFormat) {
            createInvoice.dueDate = dueDateObject.formatDate(serverDateFormat)
        }
        
        createInvoice.recipitantName = recipitantName
        createInvoice.recipitantCompany = recipitantCompany
        createInvoice.recipitantEmail = recipitantEmail
        createInvoice.recipitantAddress = recipitantAddress
        createInvoice.recipitantMobile = recipitantMobile
        
        createInvoice.isScheduled = self.reoccuringCheckBox.isChecked
        
        if self.reoccuringCheckBox.isChecked {
            guard let startDate = self.startDateTextField.text, startDate.isNotEmpty,
                  let endDate = self.endDateTextField.text, endDate.isNotEmpty else {
                self.showSnackMessage("Please, enter start date & end date")
                return
            }
            
            if let startDateObject = startDate.formatToDate(self.dateFormat) {
                createInvoice.schduledTime = startDateObject.formatDate(serverDateFormat)
            }
            
            if let endDateObject = endDate.formatToDate(self.dateFormat) {
                let time = endDateObject.formatDate(serverDateFormat)
                createInvoice.endTime = time
                createInvoice.scheduleEndTime = time
            }
            
        } else {
            let date = Date().formatDate(serverDateFormat)
            createInvoice.schduledTime = date
            createInvoice.scheduleEndTime = date
            createInvoice.endTime = date
        }
        
        if self.weeklyCheckBox.isChecked {
            createInvoice.scheduleType = 3
        }
        
        createInvoice.detail = self.items
        
        if let discountString = self.discountTextField.text,
           discountString.isNotEmpty,
           let discount = Double(discountString) {
            createInvoice.discount = discount
        }
        
        if self.deliveryCheckBox.isChecked {
            guard let deliveryString = self.deliveryChargesTextField.text,
                  deliveryString.isNotEmpty else {
                self.showSnackMessage("Please, enter delivery charges")
                return
            }
            guard let delivery = Double(deliveryString) else {
                return
            }
            
            createInvoice.deliveryCharges = delivery
        }
        
        if self.taxCheckBox.isChecked {
            guard let taxString = self.taxTextField.text,
                  taxString.isNotEmpty else {
                self.showSnackMessage("Please, enter tax")
                return
            }
            guard let tax = Double(taxString) else {
                return
            }
            createInvoice.taxCharges = tax
        }
        
        if self.onlineFeesCheckBox.isChecked {
            guard let onlineFeesString = self.onlineFeesTextField.text,
                  onlineFeesString.isNotEmpty else {
                self.showSnackMessage("Please, enter online fees")
                return
            }
            
            guard let onlineFees = Double(onlineFeesString) else {
                return
            }
            createInvoice.onlineFee = onlineFees
        }
        
        let vc = self.getStoryboardView(InvoiceSendViewController.self)
        vc.createInvoice = createInvoice
        vc.invoiceType = .normal
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - TABLE VIEW DELEGATE

extension InvoiceCreateViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(InvoiceCreateItemTableCellTableViewCell.self, for: indexPath)
        cell.delegate = self
        cell.object = self.items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let object = self.items[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.itemHeight
    }
}

// MARK: - INVOICE ITEM CELL DELEGATE

extension InvoiceCreateViewController: InvoiceCreateItemTableCellTableViewCellDelegate {
    
    func didTapAdd(_ cell: InvoiceCreateItemTableCellTableViewCell, after index: Int) {
        self.items.insert(CreateInvoiceModel.Item(), at: index + 1)
        self.itemsTableView.performBatchUpdates({
            self.itemsTableView.insertRows(at: [IndexPath(row: index + 1, section: 0)],
                                           with: .fade)
        }, completion: nil)
        self.itemsTableViewConstraint.constant = CGFloat(self.items.count) * self.itemHeight
    }
    
    func didEndEditing(_ cell: InvoiceCreateItemTableCellTableViewCell, for item: CreateInvoiceModel.Item, at indexPath: IndexPath) {
        self.items[indexPath.row] = item
        self.setTotalsToFields()
    }
}

// MARK: - TEXT FIELD DELEGATE

extension InvoiceCreateViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.setTotalsToFields()
    }
}

// MARK: - CUSTOM FUNCTIONS

extension InvoiceCreateViewController {
    
    private func setTotalsToFields() {
        self.setTotalToField()
        self.setGrandTotalToField()
    }
    
    private func setTotalToField() {
        self.totalTextField.text = "\(self.calcTotal().formatNumber())"
    }
    
    private func calcTotal() -> Double {
        var total = self.items.reduce(0, { $0 + $1.amount })
        
        if let discountString = self.discountTextField.text,
           let discount = Double(discountString) {
            total -= discount
        }
        
        return total
    }
    
    private func calcGrandTotal() -> Double {
        var grandTotal: Double = self.calcTotal()
        
        if let deliveryString = self.deliveryChargesTextField.text,
           deliveryString.isNotEmpty,
           let delivery = Double(deliveryString) {
            grandTotal += self.calcPercentage(total: grandTotal, amount: delivery)
        }
        
        if let taxString = self.taxTextField.text,
           taxString.isNotEmpty,
           let tax = Double(taxString) {
            grandTotal += tax
        }
        
        if let onlineFeesString = self.onlineFeesTextField.text,
           onlineFeesString.isNotEmpty,
           let onlineFees = Double(onlineFeesString) {
            grandTotal += self.calcPercentage(total: grandTotal, amount: onlineFees)
        }
        
        return grandTotal
    }
    
    private func calcPercentage(total: Double, amount: Double) -> Double {
        return (total * (amount / 100))
    }
    
    private func setGrandTotalToField() {
        self.grandTotalTextField.text = "\(self.calcGrandTotal().formatNumber())"
    }
    
    private func addCheckBoxesGestures() {
        self.deliveryCheckBox.addTarget(self, action: #selector(self.didTapDeliveryCheckBox(_:)), for: .valueChanged)
        self.taxCheckBox.addTarget(self, action: #selector(self.didTapTaxCheckBox(_:)), for: .valueChanged)
        self.onlineFeesCheckBox.addTarget(self, action: #selector(self.didTapOnlineFeesCheckBox(_:)), for: .valueChanged)
    }
    
    @objc
    private func didTapDeliveryCheckBox(_ checkBox: CheckBox) {
        self.deliveryChargesTextField.isEnabled = checkBox.isChecked
        if !checkBox.isChecked {
            self.deliveryChargesTextField.text?.removeAll()
        }
    }
    
    @objc
    private func didTapTaxCheckBox(_ checkBox: CheckBox) {
        self.taxTextField.isEnabled = checkBox.isChecked
        if !checkBox.isChecked {
            self.taxTextField.text?.removeAll()
        }
    }
    
    @objc
    private func didTapOnlineFeesCheckBox(_ checkBox: CheckBox) {
        self.onlineFeesTextField.isEnabled = checkBox.isChecked
        if !checkBox.isChecked {
            self.onlineFeesTextField.text?.removeAll()
        }
    }
    
    /// Date Pickers ...
    
    private func createDatePicker(for textField: UITextField) {
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        var selector: Selector
        var finalDatePicker: UIDatePicker
        
        if textField == self.invoiceDateTextField {
            selector = #selector(self.dateDonePressed(_:))
            finalDatePicker = self.datePicker
            
        } else if textField == self.invoiceDueDateTextField {
            selector = #selector(self.dueDateDonePressed(_:))
            finalDatePicker = self.dueDatePicker
            
        } else if textField == self.startDateTextField {
            selector = #selector(self.startDateDonePressed(_:))
            finalDatePicker = self.startDatePicker
            
        } else {
            selector = #selector(self.endDateDonePressed(_:))
            finalDatePicker = self.endDatePicker
        }
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: selector)
        let centerSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelDatePicker))
        
        toolbar.setItems([cancelBtn, centerSpace, doneBtn], animated: true)
        
        textField.inputAccessoryView = toolbar
        textField.inputView = finalDatePicker
    }
    
    @objc private func dateDonePressed(_ buttonItem: UIBarButtonItem) {
        self.onSelectDate(datePicker: self.datePicker, at: self.invoiceDateTextField)
    }
    
    @objc private func dueDateDonePressed(_ buttonItem: UIBarButtonItem) {
        self.onSelectDate(datePicker: self.dueDatePicker, at: self.invoiceDueDateTextField)
    }
    
    @objc private func startDateDonePressed(_ buttonItem: UIBarButtonItem) {
        self.onSelectDate(datePicker: self.startDatePicker, at: self.startDateTextField)
    }
    
    @objc private func endDateDonePressed(_ buttonItem: UIBarButtonItem) {
        self.onSelectDate(datePicker: self.endDatePicker, at: self.endDateTextField)
    }
    
    private func onSelectDate(datePicker: UIDatePicker, at textField: UITextField) {
        let formattedDate = datePicker.date.formatDate(self.dateFormat)
        textField.text = formattedDate
        self.cancelDatePicker()
    }
    
    @objc private func cancelDatePicker() {
        self.view.endEditing(true)
    }
    
    private func setupCheckBoxesViews() {
        [
            self.deliveryCheckBox,
            self.taxCheckBox,
            self.onlineFeesCheckBox,
            self.addClientDetailsCheckBox,
            self.reoccuringCheckBox,
            self.weeklyCheckBox,
        ].forEach({
            $0?.style = .tick
            $0?.borderWidth = 0
            $0?.checkedBorderColor = .clear
            $0?.checkmarkColor = .mBrown
        })
        
        [
            self.deliveryCheckBoxViewDesign,
            self.taxCheckBoxViewDesign,
            self.onlineFeesCheckBoxViewDesign,
            self.addClientDetailsCheckBoxViewDesign,
        ].forEach({
            $0?.cornerRadius = self.cornerRadius
            $0?.backgroundColor = self.background
            $0?.layer.masksToBounds = true
        })
        
        [
            self.reoccuringCheckBoxViewDesign,
            self.weeklyCheckBoxViewDesign,
        ].forEach({
            $0?.cornerRadius = self.cornerRadius
            $0?.backgroundColor = .white
        })
    }
    
    private func setupFieldViews() {
        [
            self.deliveryChargesTextField,
            self.taxTextField,
            self.onlineFeesTextField,
            self.discountTextField,
            self.totalTextField,
            self.grandTotalTextField,
        ].forEach({
            $0?.backgroundColor = self.background
        })
    }
}
