//
//  CreateInvoice2ViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/7/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class CreateInvoice2ViewController: ShopController {
    
    @IBOutlet weak var customerNameTextField: UITextField!
    @IBOutlet weak var customerNameErrorImageView: UIImageView!
    @IBOutlet weak var customerMobileTextField: UITextField!
    @IBOutlet weak var customerMobileErrorImageView: UIImageView!
    @IBOutlet weak var customerEmailTextField: UITextField!
    @IBOutlet weak var customerEmailErrorImageView: UIImageView!
    @IBOutlet weak var companyNameTextField: UITextField!
    @IBOutlet weak var companyNameErrorImageView: UIImageView!
    
    @IBOutlet weak var invoiceNumberTextField: UITextField!
    @IBOutlet weak var invoiceNumberErrorImageView: UIImageView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var dateErrorImageView: UIImageView!
    @IBOutlet weak var dueDateTextField: UITextField!
    @IBOutlet weak var dueDateErrorImageView: UIImageView!
    
    @IBOutlet weak var dateImageView: UIImageView!
    @IBOutlet weak var dueDateImageView: UIImageView!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var descriptionErrorImageView: UIImageView!
    
    private let descPlaceholder = "Invoice Description"
    
    private let datePicker = UIDatePicker()
    private let dueDatePicker = UIDatePicker()
    
    var order: Order!
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
        
    }
}

extension CreateInvoice2ViewController {
    
    func setupView() {
        self.descriptionTextView.text = self.descPlaceholder
        self.descriptionTextView.textColor = .lightGray

        self.descriptionTextView.delegate = self
        self.createDatePicker()
        self.createDueDatePicker()
        
        self.dateImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showDatePicker(tapGestureRecognizer:))))
        self.dueDateImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showDueDatePicker(tapGestureRecognizer:))))
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension CreateInvoice2ViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func previewInvoiceAction(_ sender: UIButton) {
        
        guard self.checkViewFieldsErrors() else { return }
        
        guard let orderNumber = self.invoiceNumberTextField.text, orderNumber.isNotEmpty,
              let customerName = self.customerNameTextField.text, customerName.isNotEmpty,
              let customerMobile = self.customerMobileTextField.text, customerMobile.isNotEmpty,
              let companyName = self.companyNameTextField.text, companyName.isNotEmpty,
              let customerEmail = self.customerEmailTextField.text, customerEmail.isNotEmpty,
              let date = self.dateTextField.text, date.isNotEmpty,
              let dueDate = self.dueDateTextField.text, dueDate.isNotEmpty,
              let note = self.descriptionTextView.text, note != self.descPlaceholder else {
            return
        }
        
        self.order.orderStatus = ""
        self.order.orderNumber = orderNumber
        self.order.customerName = customerName
        self.order.customerMobile = customerMobile
        self.order.customerEmail = customerEmail
        self.order.companyName = companyName
        self.order.orderDate = date
        self.order.orderDueDate = dueDate
        self.order.orderNote = note
        
        let vc = self.getStoryboardView(PreviewOrderViewController.self)
        vc.order = self.order
        vc.selectedShop = self.selectedShop
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - TEXT VIEW DELEGATE

extension CreateInvoice2ViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = self.descPlaceholder
            textView.textColor = .lightGray
        }
    }
}

// MARK: - PRIVATE FUNCTIONS

extension CreateInvoice2ViewController {
    
    private func checkViewFieldsErrors() -> Bool {
        let isCustomerNameNotEmpty = self.customerNameTextField.text!.isNotEmpty
        self.showHideCustomerNameError(isCustomerNameNotEmpty)

        let isCustomerMobileNotEmpty = self.customerMobileTextField.text!.isNotEmpty
        self.showHideCustomerMobileError(isCustomerMobileNotEmpty)

        let isCustomerEmailNotEmpty = self.customerEmailTextField.text!.isNotEmpty
        self.showHideCustomerEmailError(isCustomerEmailNotEmpty)
        
        let isCompanyNameNotEmpty = self.companyNameTextField.text!.isNotEmpty
        self.showHideCompanyNameError(isCompanyNameNotEmpty)
        
        let isInvoiceNumberNotEmpty = self.invoiceNumberTextField.text!.isNotEmpty
        self.showHideInvoiceNumberError(isInvoiceNumberNotEmpty)
        
        let isDateNotEmpty = self.dateTextField.text!.isNotEmpty
        self.showHideDateError(isDateNotEmpty)
        
        let isDueDateNotEmpty = self.dueDateTextField.text!.isNotEmpty
        self.showHideDueDateError(isDueDateNotEmpty)
        
        let isDescriptionNotEmpty = self.descriptionTextView.text! != self.descPlaceholder
        self.showHideInvoiceDescriptionError(isDescriptionNotEmpty)
        
        return isCustomerNameNotEmpty && isCustomerMobileNotEmpty &&  isCustomerEmailNotEmpty && isCompanyNameNotEmpty && isInvoiceNumberNotEmpty && isDateNotEmpty && isDueDateNotEmpty && isDescriptionNotEmpty
    }
    
    private func showHideCustomerNameError(_ isNotEmpty: Bool) {
        self.customerNameErrorImageView.image = isNotEmpty ? .none : Images.ic_error_circle.image
    }
    
    private func showHideCustomerMobileError(_ isNotEmpty: Bool) {
        self.customerMobileErrorImageView.image = isNotEmpty ? .none : Images.ic_error_circle.image
    }
    
    private func showHideCustomerEmailError(_ isNotEmpty: Bool) {
        self.customerEmailErrorImageView.image = isNotEmpty ? .none : Images.ic_error_circle.image
    }
    
    private func showHideCompanyNameError(_ isNotEmpty: Bool) {
        self.companyNameErrorImageView.image = isNotEmpty ? .none : Images.ic_error_circle.image
    }
    
    private func showHideInvoiceNumberError(_ isNotEmpty: Bool) {
        self.invoiceNumberErrorImageView.image = isNotEmpty ? .none : Images.ic_error_circle.image
    }
    
    private func showHideDateError(_ isNotEmpty: Bool) {
        self.dateErrorImageView.image = isNotEmpty ? .none : Images.ic_error_circle.image
    }
    
    private func showHideDueDateError(_ isNotEmpty: Bool) {
        self.dueDateErrorImageView.image = isNotEmpty ? .none : Images.ic_error_circle.image
    }
    
    private func showHideInvoiceDescriptionError(_ isNotEmpty: Bool) {
        self.descriptionErrorImageView.image = isNotEmpty ? .none : Images.ic_error_circle.image
    }
    
    @objc private func showDatePicker(tapGestureRecognizer: UITapGestureRecognizer) {
        self.dateTextField.becomeFirstResponder()
    }
    
    private func createDatePicker() {
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let centerSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dateDonePressed))
        let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.dateCancelPressed))
        
        toolbar.setItems([cancelBtn, centerSpace,doneBtn], animated: true)

        self.dateTextField.inputAccessoryView = toolbar
        self.dateTextField.inputView = self.datePicker
        
        self.datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            self.datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc private func dateDonePressed() {
        
        let date = self.formatDate(self.datePicker.date)
        self.dateTextField.text = date
        self.showHideDateError(self.dateTextField.text!.isNotEmpty)
        self.dateCancelPressed()
    }
    
    @objc private func showDueDatePicker(tapGestureRecognizer: UITapGestureRecognizer) {
        self.dueDateTextField.becomeFirstResponder()
    }
    
    private func createDueDatePicker() {
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let centerSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dueDateDonePressed))
        let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.dateCancelPressed))
        
        toolbar.setItems([cancelBtn, centerSpace,doneBtn], animated: true)

        self.dueDateTextField.inputAccessoryView = toolbar
        self.dueDateTextField.inputView = self.dueDatePicker
        
        self.dueDatePicker.datePickerMode = .date
        self.dueDatePicker.minimumDate = Date()
        if #available(iOS 13.4, *) {
            self.dueDatePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc private func dueDateDonePressed() {
        
        let date = self.formatDate(self.dueDatePicker.date)
        self.dueDateTextField.text = date
        self.showHideDueDateError(self.dueDateTextField.text!.isNotEmpty)
        self.dateCancelPressed()
    }
    
    @objc private func dateCancelPressed() {
        self.view.endEditing(true)
    }
    
    private func formatDate(_ date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }
}
