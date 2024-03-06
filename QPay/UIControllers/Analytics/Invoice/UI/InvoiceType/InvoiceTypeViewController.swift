//
//  InvoiceTypeViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 09/02/2022.
//  Copyright © 2022 Dev. Mohmd. All rights reserved.
//

import UIKit

class InvoiceTypeViewController: InvoiceViewController {
    
    @IBOutlet weak var navGradientView: NavGradientView!
    
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

extension InvoiceTypeViewController {
    
    func setupView() {
        self.navGradientView.delegate = self
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension InvoiceTypeViewController {
    
    @IBAction func expressInvoiceAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(InvoiceCreateExpressViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func invoiceAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(InvoiceCreateViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - NAV GRADIENT DELEGATE

extension InvoiceTypeViewController: NavGradientViewDelegate {
    
    func didTapLeftButton(_ nav: NavGradientView) {
        nav.goBack()
    }
}

// MARK: - CUSTOM FUNCTIONS

extension InvoiceTypeViewController {
    
}
