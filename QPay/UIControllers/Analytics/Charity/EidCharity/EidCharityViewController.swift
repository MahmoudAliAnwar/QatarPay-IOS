//
//  EidCharityViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 18/01/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit
import DropDown

class EidCharityViewController: CharityController {
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
        
        self.setupDropDownAppearance(textColor: .mCart_Eid_Red)
    }
}

extension EidCharityViewController {
    
    func setupView() {
        self.amountsCollectionView.delegate = self
        self.amountsCollectionView.dataSource = self
        self.amountsCollectionView.registerNib(CharityAmountCollectionViewCell.self)
        
        self.setupDonationTypeDropDown()
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension EidCharityViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cartAction(_ sender: UIButton) {
    }
    
    @IBAction func donateTypeDropDownAction(_ sender: UIButton) {
        self.donationTypeDropDown.show()
    }
    
    @IBAction func donateAction(_ sender: UIButton) {
        self.sendTransferRequest()
    }
}

// MARK: - COLLECTION VIEW DELEGATE

extension EidCharityViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.amounts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharityAmountCollectionViewCell.identifier, for: indexPath) as! CharityAmountCollectionViewCell
        
        let object = self.amounts[indexPath.row]
        cell.numberLabel.textColor = .mAmount_Eid
        cell.number = object
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.amountTextField.text = self.amounts[indexPath.row]
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = collectionView.height
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let itemsCount = CGFloat(self.amounts.count)
        let padding: CGFloat = (collectionView.width-(itemsCount*collectionView.height))/itemsCount
        
        let totalCellWidth = collectionView.height * itemsCount
        let totalSpacingWidth = padding * (itemsCount - 1)
        
        let leftInset = (collectionView.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        
        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: leftInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        let itemsCount = CGFloat(self.amounts.count)
        let padding: CGFloat = (collectionView.width-(itemsCount*collectionView.height))/itemsCount
        return padding
    }
}

// MARK: - CUSTOM FUNCTIONS

extension EidCharityViewController {

}
