//
//  InvoiceSendViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 13/02/2022.
//  Copyright © 2022 Dev. Mohmd. All rights reserved.
//

import UIKit

class InvoiceSendViewController: InvoiceViewController {
    
    @IBOutlet weak var navGradientView: NavGradientView!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var sendMeCopySwitch: UISwitch!
    
    @IBOutlet weak var subjectTextField: UITextField!
    
    @IBOutlet weak var invoiceNumberLabel: UILabel!
    
    @IBOutlet weak var emailTextTextView: UITextView!
    
    var createInvoice: CreateInvoiceModel?
    
    var invoiceType: InvoiceType?
    
    public enum InvoiceType: Int, CaseIterable {
        case express = 0
        case normal
    }
    
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

extension InvoiceSendViewController {
    
    func setupView() {
        self.navGradientView.delegate = self
        
        guard let type = self.invoiceType else { return }
        self.emailTextField.isEnabled = type == .express
    }
    
    func localized() {
    }
    
    func setupData() {
        if isForDeveloping {
            self.subjectTextField.text = "subject"
            self.emailTextTextView.text = "Email Text"
        }
    }
    
    func fetchData() {
        guard let invoice = self.createInvoice else { return }
        self.emailTextField.text = invoice.recipitantEmail
        self.invoiceNumberLabel.text = invoice.number
    }
}

// MARK: - ACTIONS

extension InvoiceSendViewController {
    
    @IBAction func createInvoiceAction(_ sender: UIButton) {
        guard var invoice = self.createInvoice else { return }
        
        guard let subject = self.subjectTextField.text, subject.isNotEmpty else {
            return
        }
        
        invoice.subject = subject
        invoice.sendMeCopy = self.sendMeCopySwitch.isOn
        invoice.emailText = self.emailTextTextView.text ?? ""
        
        self.sendCreateInvoiceRequest(invoice)
    }
}

// MARK: - CUSTOM FUNCTIONS

extension InvoiceSendViewController: NavGradientViewDelegate {
    
    func didTapLeftButton(_ nav: NavGradientView) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - CUSTOM FUNCTIONS

extension InvoiceSendViewController {
    
    private func sendCreateInvoiceRequest(_ invoice: CreateInvoiceModel) {
        
        var builder: InvoiceURLRequestBuilder
        
        if invoice.isScheduled {
            builder = InvoiceEndPoints.createInvoiceTemplate(invoice: invoice)
            
        } else {
            builder = InvoiceEndPoints.createInvoice(invoice: invoice)
        }
        
        self.showLoadingView(self)
        
        InvoiceRequestsService.shared.send(builder) { (result: Result<BaseArrayResponse<InvoiceApp>, InvoiceRequestErrors>) in
            switch result {
            case .success(let response):
                self.hideLoadingView()
                guard response._success == true else {
                    self.showErrorMessage(response._message)
                    return
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                    self.showSuccessMessage(response._message)
                }
                break
                
            case .failure(let error):
                self.hideLoadingView(error.localizedDescription)
                break
            }
        }
    }
}
