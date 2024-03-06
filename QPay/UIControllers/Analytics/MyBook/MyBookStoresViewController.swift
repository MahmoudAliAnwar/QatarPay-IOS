//
//  MyBookStoresViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 10/02/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit

class MyBookStoresViewController: MyBookController {

    @IBOutlet weak var viewTitleLabel: UILabel!
    
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var categoriesCollectionHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var storesCollectionView: UICollectionView!

    var categories = [MyBookCategory]()
    var stores = [MyBookStore]()
    var viewTitle: String?
    
    private var selectedIndexPath:IndexPath = IndexPath(row: 0, section: 0)
    
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
        
        self.changeStatusBarBG(color: .mKarwa_Dark_Red)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension MyBookStoresViewController {
    
    func setupView() {
        self.categoriesCollectionView.delegate = self
        self.storesCollectionView.delegate = self
        self.categoriesCollectionView.dataSource = self
        self.storesCollectionView.dataSource = self
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
        self.viewTitleLabel.text = self.viewTitle ?? ""
        self.stores = [1,2,3,4,5,6].compactMap({ return MyBookStore(name: "Store \($0)",
                        products: [1,2,3,4,5,6,7,8].compactMap({ return MyBookProduct(name: "Product \($0)") }))
        })
    }
}

// MARK: - ACTIONS

extension MyBookStoresViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - COLLECTION VIEW DELEGATE

extension MyBookStoresViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.categoriesCollectionView {
            return self.categories.count
        }
        return self.stores.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.categoriesCollectionView {
            let cell = collectionView.dequeueCell(MyBookStoresCategoryCollectionViewCell.self, for: indexPath)
            
            let object = self.categories[indexPath.row]
            cell.category = object
            
            if self.selectedIndexPath == indexPath {
                cell.whiteForegroudViewDesign.backgroundColor = UIColor.white.withAlphaComponent(0)
                
            } else {
                cell.whiteForegroudViewDesign.backgroundColor = UIColor.white.withAlphaComponent(0.7)
            }
            
            return cell
        }
        
        let cell = collectionView.dequeueCell(MyBookStoreCollectionViewCell.self, for: indexPath)
        
        let object = self.stores[indexPath.row]
        cell.store = object
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.categoriesCollectionView {
            self.selectedIndexPath = indexPath
            collectionView.reloadData()
            
        } else {
            let object = self.stores[indexPath.row]
            let vc = self.getStoryboardView(MyBookStoreViewController.self)
            vc.store = object
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionWidth = collectionView.width
        
        if collectionView == self.categoriesCollectionView {
            let cellWidth = (collectionWidth-50)/2.8
            return CGSize(width: cellWidth, height: cellWidth*0.40)
        }
        
        return CGSize(width: collectionWidth-50, height: 110)
    }
}

// MARK: - CUSTOM FUNCTIONS

extension MyBookStoresViewController {
    
    private func updateCategoriesCollectionHight() {
        self.categoriesCollectionHeightConstraint.constant = self.categoriesCollectionView.collectionViewLayout.collectionViewContentSize.height
        self.categoriesCollectionView.reloadData()
    }
}
