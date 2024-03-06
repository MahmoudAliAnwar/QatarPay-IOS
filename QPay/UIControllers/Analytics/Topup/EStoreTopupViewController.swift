//
//  EStoreTopupViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 28/01/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit

class EStoreTopupViewController: EStoreTopupController {

    @IBOutlet weak var topupPhotosCollectionView: UICollectionView!
    @IBOutlet weak var customPageControl: CustomPageControl!
    @IBOutlet weak var topupTypesCollectionView: UICollectionView!

    var photos = [TopupType]()
    var data = [TopupType]()
    
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

extension EStoreTopupViewController {
    
    func setupView() {
        self.topupTypesCollectionView.delegate = self
        self.topupTypesCollectionView.dataSource = self

        self.topupPhotosCollectionView.delegate = self
        self.topupPhotosCollectionView.dataSource = self
        
        self.customPageControl.currentPageIndicatorTintColor = .clear
        self.customPageControl.pageIndicatorTintColor = .clear
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
        self.data = [
            .init(image: #imageLiteral(resourceName: "ic_international_topup_estore.png"), name: "International Top-Up", completion: {
                let vc = self.getStoryboardView(InternationalTopupViewController.self)
                self.navigationController?.pushViewController(vc, animated: true)
            }),
            .init(image: #imageLiteral(resourceName: "ic_ooredoo_topup_estore.png"), name: "Ooredoo Top-Up", completion: {
                
            }),
            .init(image: #imageLiteral(resourceName: "ic_vodafone_topup_estore.png"), name: "Vodafone Top-Up", completion: {
                
            })
        ]
        
        self.photos = [
            .init(image: #imageLiteral(resourceName: "ic_international_photo_topup_estore"), name: "International".uppercased(), completion: {
                
            }),
            .init(image: #imageLiteral(resourceName: "ic_international_photo_topup_estore"), name: "Ooredoo".uppercased(), completion: {
                
            }),
            .init(image: #imageLiteral(resourceName: "ic_international_photo_topup_estore"), name: "Vodafone".uppercased(), completion: {
                
            }),
        ]
        
        self.customPageControl.numberOfPages = self.photos.count
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.customPageControl.currentPage = 0
        }
    }
}

// MARK: - ACTIONS

extension EStoreTopupViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - COLLECTION VIEW DELEGATE

extension EStoreTopupViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == self.topupPhotosCollectionView ? self.photos.count : self.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.topupPhotosCollectionView {
            let cell = collectionView.dequeueCell(TopupPhotoCollectionViewCell.self, for: indexPath)
            
            let object = self.photos[indexPath.row]
            cell.object = object
            
            return cell
        }
        
        let cell = collectionView.dequeueCell(TopupTypeCollectionViewCell.self, for: indexPath)
        
        let object = self.data[indexPath.row]
        cell.object = object
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.topupTypesCollectionView {
            self.data[indexPath.row].completion()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentIndex = floorf(Float(scrollView.contentOffset.x) / Float(scrollView.width))
        self.customPageControl.currentPage = Int(currentIndex)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.topupPhotosCollectionView {
            return .init(width: collectionView.width, height: collectionView.height)
        }
        
        let cellWidth = (self.view.width-70)/3
        return .init(width: cellWidth, height: cellWidth)
    }
}

// MARK: - CUSTOM FUNCTIONS

extension EStoreTopupViewController {
    
}
