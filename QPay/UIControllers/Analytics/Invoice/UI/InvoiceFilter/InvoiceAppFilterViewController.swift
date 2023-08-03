//
//  InvoiceFilterViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 03/02/2022.
//  Copyright © 2022 Dev. Mohmd. All rights reserved.
//

import UIKit

class InvoiceAppFilterViewController: InvoiceViewController {
    
    @IBOutlet weak var navGradientView: NavGradientView!
    
    @IBOutlet weak var invoicesCollectionView: UICollectionView!
    
    private var invoices = [InvoiceApp]()
    
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

extension InvoiceAppFilterViewController {
    
    func setupView() {
        self.navGradientView.delegate = self
        
        self.invoicesCollectionView.registerNib(InvoiceAppCollectionViewCell.self)
        self.invoicesCollectionView.delegate = self
        self.invoicesCollectionView.dataSource = self
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension InvoiceAppFilterViewController {
    
}

// MARK: - COLLECTION VIEW DELEGATE

extension InvoiceAppFilterViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.invoices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(InvoiceAppCollectionViewCell.self, for: indexPath)
        
        let object = self.invoices[indexPath.row]
        cell.object = object
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let object = self.invoices[indexPath.row]
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let flowLayout: UICollectionViewFlowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let leftRightPadding: CGFloat = flowLayout.sectionInset.left + flowLayout.sectionInset.right
        
        let cellWidth = (collectionView.width - leftRightPadding)
        return CGSize(width: cellWidth, height: 100)
    }
}

// MARK: - NAV GRADIENT DELEGATE

extension InvoiceAppFilterViewController: NavGradientViewDelegate {
    
    func didTapLeftButton(_ nav: NavGradientView) {
//        self.navigationController?.popViewController(animated: true)
        nav.goBack()
    }
    
    /// Add button
    func didTapRightButton(_ nav: NavGradientView) {
        
    }
}

// MARK: - CUSTOM FUNCTIONS

extension InvoiceAppFilterViewController {
    
}
