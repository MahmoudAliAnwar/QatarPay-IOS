//
//  MyBookViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 08/02/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit

class MyBookViewController: MyBookController {

    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var categoriesCollectionViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var collectionsCollectionView: UICollectionView!
    @IBOutlet weak var collectionsCollectionViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var offersCollectionView: UICollectionView!
    @IBOutlet weak var offersCollectionViewHeightConstraint: NSLayoutConstraint!

    var categories = [[MyBookCategory]]()
    var collections = [[MyBookCollection]]()
    var offers = [MyBookOffer]()
    
    private var categoriesDataSource: UICollectionViewDiffableDataSource<Int, MyBookCategory>!
    private var collectionsDataSource: UICollectionViewDiffableDataSource<Int, MyBookCollection>!
    
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

extension MyBookViewController {
    
    func setupView() {
        categoriesCollectionView.delegate = self
        collectionsCollectionView.delegate = self
        offersCollectionView.delegate = self
//        categoriesCollectionView.dataSource = self
//        collectionsCollectionView.dataSource = self
        offersCollectionView.dataSource = self
        
        self.categoriesCollectionView.collectionViewLayout = self.categoriesCollectionLayout()
        self.collectionsCollectionView.collectionViewLayout = self.collectionsCollectionLayout()
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
        self.categories = [
            [1,2,3,4,5].compactMap({ return MyBookCategory(image: nil, name: "Food & Drinks \($0)") }),
            [6,7,8,9,10,11].compactMap({ return MyBookCategory(image: nil, name: "Room Nights \($0)") })
        ]
        
        self.collections = [
            [1,2,3,4,5].compactMap({ return MyBookCollection(background: nil, icon: nil, color: .mBook_Red, name: "Best Ice Cream Offers \($0)") }),
            [6,7,8,9,10].compactMap({ return MyBookCollection(background: nil, icon: nil, color: .mBook_Blue, name: "Best Ice Cream Offers \($0)") })
        ]
        
        self.offers = [1,2,3,4].compactMap({ return MyBookOffer(logo: nil, title: "Special High Tea \($0)", description: "Caramel - City Centre \($0)", expires: "31/12/2021") })
        
        self.configureCategoriesDataSource()
        self.configureCollectionsDataSource()
        self.updateOffersCollectionHeightConstraint()
    }
}

// MARK: - ACTIONS

extension MyBookViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - COLLECTION VIEW DELEGATE

extension MyBookViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.offers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(MyBookOfferCollectionViewCell.self, for: indexPath)
        
        let object = self.offers[indexPath.row]
        cell.offer = object
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.categoriesCollectionView {
            let object = self.categories[indexPath.section][indexPath.row]
//            print("Category \(object)")
            
            var categs: [MyBookCategory] = []
            
            for value in self.categories {
                for categ in value {
                    categs.append(categ)
                }
            }
            
            let vc = self.getStoryboardView(MyBookStoresViewController.self)
            vc.categories = categs
            vc.viewTitle = object.name
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if collectionView == self.collectionsCollectionView {
            let object = self.collections[indexPath.section][indexPath.row]
            print("Collection \(object)")
            
        } else {
            let object = self.offers[indexPath.row]
            print("Offer \(object)")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth: CGFloat = (collectionView.width - 60) / 1.3
        return CGSize(width: cellWidth, height: cellWidth * 0.50)
    }
}

// MARK: - CUSTOM FUNCTIONS

extension MyBookViewController {
    
    private func configureCategoriesDataSource() {
        
        self.categoriesDataSource = UICollectionViewDiffableDataSource
        <Int, MyBookCategory>(collectionView: self.categoriesCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, category: MyBookCategory) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueCell(MyBookCategoryCollectionViewCell.self, for: indexPath)
            
            cell.category = self.categories[indexPath.section][indexPath.row]
            
            return cell
        }
        
        let snapshot = snapshotForCategoriesState()
        self.categoriesDataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func configureCollectionsDataSource() {
        
        self.collectionsDataSource = UICollectionViewDiffableDataSource
        <Int, MyBookCollection>(collectionView: self.collectionsCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, category: MyBookCollection) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueCell(MyBookCollectionCollectionViewCell.self, for: indexPath)
            
            cell.collection = self.collections[indexPath.section][indexPath.row]
            
            return cell
        }
        
        let snapshot = snapshotForCollectionsState()
        self.collectionsDataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func categoriesCollectionLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
                                                            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            return self.categoriesSectionLayout()
        }
        return layout
    }
    
    private func collectionsCollectionLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
                                                            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            return self.collectionsSectionLayout()
        }
        return layout
    }
    
    private func categoriesSectionLayout() -> NSCollectionLayoutSection {
        
        let viewWidth = self.view.width
        let cellWidth: CGFloat = (viewWidth-36)/3
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(cellWidth), heightDimension: .absolute(cellWidth))
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20)
        
        self.categoriesCollectionViewHeightConstraint.constant = (cellWidth*2)+20
        
        return section
    }
    
    private func collectionsSectionLayout() -> NSCollectionLayoutSection {
        
        let viewWidth = self.view.width
        let cellWidth: CGFloat = (viewWidth-40)/2.4
        let cellHeight: CGFloat = cellWidth*0.35
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(cellWidth), heightDimension: .absolute(cellHeight))
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 5, trailing: 0)
        
        self.collectionsCollectionViewHeightConstraint.constant = (cellHeight*2)+10
        
        return section
    }
    
    private func snapshotForCategoriesState() -> NSDiffableDataSourceSnapshot<Int, MyBookCategory> {
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, MyBookCategory>()
        
        for (i, value) in self.categories.enumerated() {
            snapshot.appendSections([i])
            snapshot.appendItems(value)
        }
        
        return snapshot
    }
    
    private func snapshotForCollectionsState() -> NSDiffableDataSourceSnapshot<Int, MyBookCollection> {
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, MyBookCollection>()
        
        for (i, value) in self.collections.enumerated() {
            snapshot.appendSections([i])
            snapshot.appendItems(value)
        }
        
        return snapshot
    }

    private func updateCategoriesCollectionHeightConstraint() {
        self.categoriesCollectionViewHeightConstraint.constant = self.categoriesCollectionView.collectionViewLayout.collectionViewContentSize.height
        self.categoriesCollectionView.reloadData()
    }
    
    private func updateCollectionsCollectionHeightConstraint() {
        self.collectionsCollectionViewHeightConstraint.constant = self.collectionsCollectionView.collectionViewLayout.collectionViewContentSize.height
        self.collectionsCollectionView.reloadData()
    }
    
    private func updateOffersCollectionHeightConstraint() {
        self.offersCollectionViewHeightConstraint.constant = self.offersCollectionView.collectionViewLayout.collectionViewContentSize.height+20
        self.offersCollectionView.reloadData()
    }
}
