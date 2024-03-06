//
//  GiftStoresViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 28/03/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit
import FSPagerView

class GiftStoresViewController: GiftController {
    
    @IBOutlet weak var imagesPagerView: FSPagerView!
    @IBOutlet weak var storesCollectionView: UICollectionView!
    @IBOutlet weak var brandsCollectionView: UICollectionView!
    
    private var stores = [GiftStore]()
    private var banners = [String]()
    private var brands = [GiftBrand]()
    
    private var selectedStoreID: Int = 1 {
        didSet {
            self.brandsRequest(storeID: self.selectedStoreID)
        }
    }
    
    private var selectedIndexPath: IndexPath! {
        didSet {
            self.selectedStoreID = self.selectedIndexPath.row+1
            if oldValue != nil {
                self.storesCollectionView.reloadItems(at: [oldValue])
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
        
        self.statusBarView?.isHidden = true
    }
}

extension GiftStoresViewController {
    
    func setupView() {
        self.requestProxy.requestService()?.delegate = self
        
        self.imagesPagerView.delegate = self
        self.imagesPagerView.dataSource = self

        self.storesCollectionView.delegate = self
        self.storesCollectionView.dataSource = self

        self.brandsCollectionView.delegate = self
        self.brandsCollectionView.dataSource = self
        
        self.imagesPagerView.register(UINib(nibName: ImageFSPagerCell.identifier, bundle: .main),
                                      forCellWithReuseIdentifier: ImageFSPagerCell.identifier)
        
        self.imagesPagerView.transformer = FSPagerViewTransformer(type: .linear)
//        let newScale = 0.5+CGFloat(0.5)*0.5
//        self.imagesPagerView.itemSize = self.imagesPagerView.frame.size.applying(CGAffineTransform(scaleX: newScale, y: 0.9))
        self.imagesPagerView.itemSize = CGSize(width: (self.view.width*0.8), height: (self.imagesPagerView.height*0.9))
        self.imagesPagerView.automaticSlidingInterval = 5
        self.imagesPagerView.interitemSpacing = 6
        self.imagesPagerView.isInfinite = true
    }
    
    func localized() {
    }
    
    func setupData() {
        self.storesRequest()
    }
    
    func fetchData() {
        self.selectedIndexPath = .init(row: 0, section: 0)
    }
}

// MARK: - ACTIONS

extension GiftStoresViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - COLLECTION VIEW DELEGATE

extension GiftStoresViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == self.storesCollectionView ? self.stores.count : self.brands.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        /// Store cell ...
        if collectionView == self.storesCollectionView {
            let cell = collectionView.dequeueCell(GiftStoreCollectionViewCell.self, for: indexPath)

            let object = self.stores[indexPath.row]
            cell.object = object
            cell.isSelectedCell = indexPath.row == self.selectedIndexPath.row

            return cell
        }
        
        /// Brand cell ...
        let cell = collectionView.dequeueCell(GiftBrandCollectionViewCell.self, for: indexPath)
        
        let object = self.brands[indexPath.row]
        cell.object = object
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.storesCollectionView {
            self.selectedIndexPath = indexPath
            collectionView.reloadItems(at: [indexPath])
            
        } else {
            let object = self.brands[indexPath.row]
            
            let vc = self.getStoryboardView(GiftDenominationsViewController.self)
            vc.brand = object
            vc.storeID = self.selectedStoreID
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        /// Store cell size ...
        
        let flowLayout: UICollectionViewFlowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let leftRightPadding: CGFloat = flowLayout.sectionInset.left + flowLayout.sectionInset.right

        if collectionView == self.storesCollectionView {
            let cellsInRow: CGFloat = 4.5
            let spaceBetweenCells: CGFloat = flowLayout.minimumInteritemSpacing * cellsInRow
            
            let cellWidth = (collectionView.width - leftRightPadding - spaceBetweenCells) / cellsInRow
            return CGSize(width: cellWidth, height: collectionView.height)
        }
        
        /// Brand cell size ...
        let cellsInRow: CGFloat = 3
        let spaceBetweenCells: CGFloat = flowLayout.minimumInteritemSpacing * cellsInRow
        
        let cellWidth = (collectionView.width - leftRightPadding - spaceBetweenCells) / cellsInRow
        return CGSize(width: cellWidth, height: 100)
    }
}

// MARK: - FS PAGER DELEGATE

extension GiftStoresViewController: FSPagerViewDelegate, FSPagerViewDataSource {
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.banners.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: ImageFSPagerCell.identifier, at: index) as! ImageFSPagerCell
        
        let urlString = self.banners[index]
//        cell.cellImageView.kf.setImage(with: URL(string: urlString.correctUrlString()))
        
        urlString.getImageFromURLString { (status, image) in
            if status, let img = image {
                cell.cellImageView.image = img
            }
        }
        
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
//        print("\(index)")
    }
}

// MARK: - REQUESTS DELEGATE

extension GiftStoresViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .getGiftStoreList {
            showLoadingView(self)
        }
    }
    
    func requestFinished(request: RequestType, result: ResponseResult) {
        hideLoadingView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
            switch result {
            case .Success(_):
                break
            case .Failure(let errorType):
                switch errorType {
                case .Exception(let exc):
                    if showUserExceptions {
                        self.showErrorMessage(exc)
                    }
                    break
                case .AlamofireError(let err):
                    if showAlamofireErrors {
                        self.showSnackMessage(err.localizedDescription)
                    }
                    break
                case .Runtime(_):
                    break
                }
            }
        }
    }
}

// MARK: - CUSTOM FUNCTIONS

extension GiftStoresViewController {
    
    private func storesRequest() {
        self.dispatchGroup.enter()
        self.requestProxy.requestService()?.getGiftStoreList { (status, response) in
            guard status else { return }
            
            self.stores = response?.stores ?? []
            self.banners = response?.banners ?? []
            self.dispatchGroup.leave()
        }
        
        self.dispatchGroup.notify(queue: .main) {
            self.storesCollectionView.reloadData()
            self.imagesPagerView.reloadData()
            self.brandsRequest(storeID: self.selectedStoreID)
        }
    }
    
    private func brandsRequest(storeID: Int) {
        self.dispatchGroup.enter()
        self.requestProxy.requestService()?.getGiftBrandList(storeID: storeID) { (status, brandList) in
            guard status else { return }
            
            self.brands = brandList ?? []
            self.dispatchGroup.leave()
        }
        self.dispatchGroup.notify(queue: .main) {
            self.brandsCollectionView.reloadData()
        }
    }
}
