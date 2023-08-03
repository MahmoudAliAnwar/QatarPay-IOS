//
//  InvoiceDetailsViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 02/02/2022.
//  Copyright © 2022 Dev. Mohmd. All rights reserved.
//

import UIKit

class InvoiceDetailsViewController: InvoiceViewController {
    
    @IBOutlet weak var navGradientView: NavGradientView!
    
    @IBOutlet weak var numberLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var dueDateLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var itemsTableView: UITableView!
    
    @IBOutlet weak var recipitantNameLabel: UILabel!
    
    @IBOutlet weak var recipitantCompanyLabel: UILabel!
    
    @IBOutlet weak var recipitantAddressLabel: UILabel!
    
    @IBOutlet weak var statusViewDesign: ViewDesign!
    
    @IBOutlet weak var subTotalLabel: UILabel!
    
    @IBOutlet weak var discountLabel: UILabel!
    
    @IBOutlet weak var taxLabel: UILabel!
    
    @IBOutlet weak var deliveryChargesLabel: UILabel!
    
    @IBOutlet weak var totalAmountLabel: UILabel!
    
    var invoiceID: Int?
    
    private var items = [InvoiceAppItem]() {
        didSet {
            self.itemsTableView.reloadData()
        }
    }
    
    private var invoiceDetails: InvoiceAppDetails? {
        willSet {
            guard let inv = newValue else { return }
            self.numberLabel.text = inv.number
            self.recipitantNameLabel.text = inv._recipitantName
            self.recipitantCompanyLabel.text = inv._recipitantCompany
            self.recipitantAddressLabel.text = inv._recipitantAddress
            self.totalAmountLabel.text = "QAR \(inv._invoiceTotal.formatNumber())"
            
            self.items = inv._invoiceDetails
            
            if let date = inv._date.formatToDate(.Server2) {
                self.dateLabel.text = date.formatDate("dd/MM/yyyyy")
            }
            if let date = inv._dueDate.formatToDate(.Server2) {
                self.dueDateLabel.text = date.formatDate("dd/MM/yyyyy")
            }
            
            self.subTotalLabel.text = "QAR \(inv._invoiceAmount)"
            self.discountLabel.text = "QAR \(inv._discount)"
            let tax: Double = inv._taxCharges + inv._onlineFee
            self.taxLabel.text = "QAR \(tax)"
            self.deliveryChargesLabel.text = "QAR \(inv._deliveryCharges)"
            self.totalAmountLabel.text = "QAR \(inv._invoiceTotal)"
            
            guard let status = inv._statusObject else { return }
            self.statusLabel.text = inv._status
            self.statusViewDesign.backgroundColor = status.color
            
            switch status {
            case .success:
                break
            case .pending:
                break
            case .failed:
                break
            case .void:
                break
            }
        }
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

extension InvoiceDetailsViewController {
    
    func setupView() {
        self.navGradientView.delegate = self
        
        self.itemsTableView.delegate = self
        self.itemsTableView.dataSource = self
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
        guard let id = self.invoiceID else { return }
        
        self.showLoadingView(self)
        
        InvoiceRequestsService.shared.send(InvoiceEndPoints.invoiceDetails(id: id)) { (result: Result<BaseObjectResponse<InvoiceAppDetails>, InvoiceRequestErrors>) in
            switch result {
            case .success(let response):
                self.invoiceDetails = response.object
                self.hideLoadingView()
                break
            case .failure(let error):
                self.hideLoadingView(error.localizedDescription)
                break
            }
        }
    }
}

// MARK: - ACTIONS

extension InvoiceDetailsViewController {
    
}

// MARK: - TABLE VIEW DELEGATE

extension InvoiceDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(InvoiceAppItemTableViewCell.self, for: indexPath)
        
        let object = self.items[indexPath.row]
        cell.object = object
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let object = self.items[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

// MARK: - NAV GRADIENT DELEGATE

extension InvoiceDetailsViewController: NavGradientViewDelegate {
    
    func didTapLeftButton(_ nav: NavGradientView) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /// Add button
    func didTapRightButton(_ nav: NavGradientView) {
        let vc = self.getStoryboardView(InvoiceTypeViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

final class InvoiceAppItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var amountLabel: UILabel!
    
    var object: InvoiceAppItem! {
        willSet {
            self.nameLabel.text = newValue._description
            self.amountLabel.text = "QAR \(newValue._amount.formatNumber())"
        }
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
