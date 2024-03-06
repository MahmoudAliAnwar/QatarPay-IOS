//
//  QatarCharityViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 18/01/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit
import DropDown

class QatarCharityViewController: CharityController {
    
    @IBOutlet weak var singleTabLabel: UILabel!
    @IBOutlet weak var singleTabView: UIView!

    @IBOutlet weak var periodicTabLabel: UILabel!
    @IBOutlet weak var periodicTabView: UIView!
    
    @IBOutlet weak var periodicTypeStackView: UIStackView!
    @IBOutlet weak var periodicTypeLabel: UILabel!
    @IBOutlet weak var periodicTypeErrorImageView: UIImageView!
    @IBOutlet weak var periodicTypeButton: UIButton!
    
    private var periodicTypeDropDown = DropDown()
    private var periodicTypeSelected: PeriodicType = .Periodic1 {
        didSet {
            for (index, value) in PeriodicType.allCases.enumerated() {
                guard periodicTypeSelected == value else { continue }
                self.periodicTypeErrorImageView.image = .none
                self.periodicTypeDropDown.selectRow(index)
                self.periodicTypeLabel.text = value.rawValue
                break
            }
        }
    }
    
    private var tabSelected: Tab = .Single {
        didSet {
            self.setViewTab(to: tabSelected)
        }
    }
    
    private enum PeriodicType: String, CaseIterable {
        case Periodic1 = "Daily"
        case Periodic2 = "Daily2"
    }
    
    private enum Tab: String, CaseIterable {
        case Single
        case Periodic
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

extension QatarCharityViewController {
    
    func setupView() {
        self.tabSelected = .Single
        
        self.requestProxy.requestService()?.delegate = self
        
        self.amountsCollectionView.delegate = self
        self.amountsCollectionView.dataSource = self
        self.amountsCollectionView.registerNib(CharityAmountCollectionViewCell.self)
        
        self.setupDropDownAppearance(textColor: .mAmount_Qatar)
        self.setupDonationTypeDropDown()
        self.setupPeriodicTypeDropDown()
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension QatarCharityViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func singleTabAction(_ sender: UIButton) {
        self.tabSelected = .Single
    }
    
    @IBAction func periodicTabAction(_ sender: UIButton) {
        self.tabSelected = .Periodic
    }
    
    @IBAction func cartAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(QatarCharityCartViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func donationTypeDropDownAction(_ sender: UIButton) {
        self.donationTypeDropDown.show()
    }
    
    @IBAction func periodicTypeDropDownAction(_ sender: UIButton) {
        self.periodicTypeDropDown.show()
    }
    
    @IBAction func donateAction(_ sender: UIButton) {
        self.sendTransferRequest()
    }
}

// MARK: - COLLECTION VIEW DELEGATE

extension QatarCharityViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.amounts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(CharityAmountCollectionViewCell.self, for: indexPath)
        
        let object = self.amounts[indexPath.row]
        cell.numberLabel.textColor = .mAmount_Qatar
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

extension QatarCharityViewController {
    
    private func setViewTab(to tab: Tab) {
        
        let alpha: CGFloat = 0.5
        
        self.singleTabLabel.textColor = tab == .Single ? .white : UIColor.white.withAlphaComponent(alpha)
        self.singleTabView.backgroundColor = tab == .Single ? .white : .clear
        
        self.periodicTabLabel.textColor = tab == .Periodic ? .white : UIColor.white.withAlphaComponent(alpha)
        self.periodicTabView.backgroundColor = tab == .Periodic ? .white : .clear
        
        self.periodicTypeStackView.isHidden = tab == .Single
    }
    
    private func setupPeriodicTypeDropDown() {
        
        self.periodicTypeDropDown.anchorView = self.periodicTypeButton
        
        self.periodicTypeDropDown.topOffset = CGPoint(x: 0, y: self.periodicTypeButton.bottom)
        self.periodicTypeDropDown.direction = .any
        self.periodicTypeDropDown.dismissMode = .automatic
        
        for type in PeriodicType.allCases {
            self.periodicTypeDropDown.dataSource.append(type.rawValue)
        }
        
//        self.selectPeriodicType(.Periodic1)
        self.periodicTypeSelected = .Periodic1
        
        self.periodicTypeDropDown.selectionAction = { [weak self] (index, item) in
            self?.periodicTypeLabel.text = item
            
            let selectedType = PeriodicType(rawValue: item)
            if let type = selectedType {
//                self?.selectPeriodicType(type)
                self?.periodicTypeSelected = type
            }
        }
    }
}
