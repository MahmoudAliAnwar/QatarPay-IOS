//
//  InvoiceAccountViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 02/02/2022.
//  Copyright © 2022 Dev. Mohmd. All rights reserved.
//

import UIKit

class InvoiceAccountViewController: InvoiceViewController {
    
    @IBOutlet weak var imageViewDesign: ImageViewDesign!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var companyLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var mobileLabel: UILabel!
    
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

extension InvoiceAccountViewController {
    
    func setupView() {
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
        guard let user = self.userProfile.invoiceUser else { return }
        self.nameLabel.text = user._name
        self.emailLabel.text = user._email
        
        guard user._ImageLocation.isNotEmpty else { return }
        self.imageViewDesign.kf.setImage(with: URL(string: user._ImageLocation), placeholder: UIImage.ic_transaction_person)
    }
}

// MARK: - ACTIONS

extension InvoiceAccountViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - CUSTOM FUNCTIONS

extension InvoiceAccountViewController {
    
}
