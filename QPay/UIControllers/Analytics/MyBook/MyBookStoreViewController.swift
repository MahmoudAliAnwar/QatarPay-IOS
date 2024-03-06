//
//  MyBookStoreViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 10/02/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit

class MyBookStoreViewController: MyBookController {

    @IBOutlet weak var viewTitleLabel: UILabel!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var storeDescriptionLabel: UILabel!
    
    @IBOutlet weak var headerBackgroundView: UIView!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var membershipStackView: UIStackView!
    
    @IBOutlet weak var productsCollectionView: UICollectionView!
    @IBOutlet weak var productsCollectionHeightConstraint: NSLayoutConstraint!
    
    var store: MyBookStore!
    
    private var membershipStatus: MembershipStatus = .Hide {
        didSet {
            self.showHideMembershipStackView()
        }
    }
    
    private enum MembershipStatus: CaseIterable {
        case Show
        case Hide
        
        mutating func toggle() -> Self {
            switch self {
            case .Show:
                return .Hide
            case .Hide:
                return .Show
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension MyBookStoreViewController {
    
    func setupView() {
        self.productsCollectionView.delegate = self
        self.productsCollectionView.dataSource = self
        
        self.membershipStatus = .Show
        self.updateProductsCollectionHight()
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
        self.storeNameLabel.text = self.store.name ?? ""
        self.viewTitleLabel.text = self.store.name ?? ""
    }
}

// MARK: - ACTIONS

extension MyBookStoreViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func loveAction(_ sender: UIButton) {
        
    }
    
    @IBAction func shareAction(_ sender: UIButton) {
        
    }
    
    @IBAction func showHideMembershipAction(_ sender: UIButton) {
        self.membershipStatus = self.membershipStatus.toggle()
    }
}

// MARK: - COLLECTION VIEW DELEGATE

extension MyBookStoreViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.store.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyBookStoreProductCollectionViewCell.identifier, for: indexPath) as! MyBookStoreProductCollectionViewCell
        
        let object = self.store.products[indexPath.row]
        cell.product = object
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let object = self.store.products[indexPath.row]
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let viewWidth = self.view.width
        return .init(width: viewWidth-40, height: 100)
    }
}

// MARK: - CUSTOM FUNCTIONS

extension MyBookStoreViewController {
    
    private func showHideMembershipStackView() {
        UIView.animate(withDuration: 0.3) {
            self.membershipStackView.isHidden = self.membershipStatus == .Hide
            self.arrowImageView.image = self.membershipStatus == .Hide ? .ic_arrow_down_my_book_product : .ic_arrow_up_my_book_product
            self.headerBackgroundView.backgroundColor = self.membershipStatus == .Hide ? .white : .clear
        }
    }
    
    private func updateProductsCollectionHight() {
        self.productsCollectionHeightConstraint.constant = self.productsCollectionView.collectionViewLayout.collectionViewContentSize.height
        self.productsCollectionView.reloadData()
    }
}
