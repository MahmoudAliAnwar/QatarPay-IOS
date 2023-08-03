//
//  SelectTopupAmountViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 28/01/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit

protocol SelectTopupAmountViewControllerDelegate: AnyObject {
    func didSelectAmount(product: MSISDNProduct)
}

class SelectTopupAmountViewController: EStoreTopupController {

    @IBOutlet weak var operatorNameLabel: UILabel!
    @IBOutlet weak var amountsCollectionView: UICollectionView!

    var object: MSISDN?
    weak var delegate: SelectTopupAmountViewControllerDelegate?
    
    private var selectedIndexPath: IndexPath?
    
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

extension SelectTopupAmountViewController {
    
    func setupView() {
        self.amountsCollectionView.delegate = self
        self.amountsCollectionView.dataSource = self
        
        self.operatorNameLabel.text = self.object?._operatorName
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension SelectTopupAmountViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func continueAction(_ sender: UIButton) {
        guard let selectedRow = self.selectedIndexPath?.row,
              let selectedProduct = self.object?._products[selectedRow] else {
            self.showErrorMessage("Please, select amount from list")
            return
        }
        
        self.navigationController?.popViewController(animated: true)
        self.delegate?.didSelectAmount(product: selectedProduct)
    }
}

// MARK: - COLLECTION VIEW DELEGATE

extension SelectTopupAmountViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.object?._products.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(EstoreTopupAmountCollectionViewCell.self, for: indexPath)
        guard let obj = self.object else { return cell }
        
        if !obj._products.isEmpty {
            let product = obj._products[indexPath.row]
            cell.object = product
            cell.destinationCurrency = obj._destinationCurrency
        }
        cell.cellBorderWidth = indexPath == self.selectedIndexPath ? 2 : 0
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
        self.amountsCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (self.view.width-70)/4
        return .init(width: cellWidth, height: cellWidth)
    }
}

// MARK: - CUSTOM FUNCTIONS

extension SelectTopupAmountViewController {
    
}
