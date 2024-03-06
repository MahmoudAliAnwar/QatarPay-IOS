//
//  CouponsViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 15/12/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit

class CouponsViewController: ViewController {
    
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    
    @IBOutlet weak var couponsCollectionView: UICollectionView!
    
    private var coupons = [Coupon]()
    private var couponsAll = [Coupon]()
    private var categories = [CouponCategory]()
    
    private var selectedCategory: CouponCategory? {
        willSet {
            self.filterCoupons(by: newValue!._id)
        }
        didSet {
            self.categoriesCollectionView.reloadData()
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
        
        self.requestProxy.requestService()?.delegate = self
        
        self.dispatchGroup.enter()
        
        self.requestProxy.requestService()?.getCouponCategories(weakify { strong, list in
            strong.categories = list ?? []
            strong.categoriesCollectionView.reloadData()
            self.dispatchGroup.leave()
        })
        
        self.dispatchGroup.enter()
        
        self.requestProxy.requestService()?.getCouponList(weakify { strong, list in
            let couponList = list ?? []
            strong.couponsAll = couponList
            self.dispatchGroup.leave()
        })
        
        self.dispatchGroup.notify(queue: .main) {
            guard self.categories.isNotEmpty else { return }
            let firstCateg = self.categories[0]
            self.selectedCategory = firstCateg
            self.filterCoupons(by: firstCateg._id)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension CouponsViewController {
    
    func setupView() {
        self.categoriesCollectionView.delegate = self
        self.categoriesCollectionView.dataSource = self
        
        self.couponsCollectionView.registerNib(CouponCollectionViewCell.self)
        self.couponsCollectionView.delegate = self
        self.couponsCollectionView.dataSource = self
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension CouponsViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func couponAction(_ sender: UIButton) {
    }
}

// MARK: - COLLECTION VIEW DELEGATE

extension CouponsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.categoriesCollectionView {
            return self.categories.count
        }
        return self.coupons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.categoriesCollectionView {
            let cell = collectionView.dequeueCell(CouponCategoryCollectionViewCell.self, for: indexPath)
            let object = self.categories[indexPath.row]
            cell.isCategorySelected = self.selectedCategory == object
            cell.object = object
            return cell
        }
        let cell = collectionView.dequeueCell(CouponCollectionViewCell.self, for: indexPath)
        let object = self.coupons[indexPath.row]
        cell.object = object
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.categoriesCollectionView {
            self.selectedCategory = self.categories[indexPath.row]
            
        } else {
            let vc = self.getStoryboardView(CouponDetailsViewController.self)
            vc.couponID = self.coupons[indexPath.row]._couponID
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout: UICollectionViewFlowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let leftRightPadding: CGFloat = flowLayout.sectionInset.left + flowLayout.sectionInset.right
        
        if collectionView == self.categoriesCollectionView {
            let cellsInRow: CGFloat = 4
            let spaceBetweenCells: CGFloat = flowLayout.minimumInteritemSpacing * cellsInRow
            let cellWidth = (collectionView.width - leftRightPadding - spaceBetweenCells) / cellsInRow
            return CGSize(width: cellWidth, height: collectionView.height)
        }
        
        let cellWidth = (collectionView.width - leftRightPadding)
        return CGSize(width: cellWidth, height: (cellWidth * 0.36))
    }
}

// MARK: - REQUESTS DELEGATE

extension CouponsViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .getCouponList {
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

extension CouponsViewController {
    
    private func filterCoupons(by categoryID: Int) {
        self.coupons = self.couponsAll.filter({ $0._categoryID == categoryID })
        self.couponsCollectionView.reloadData()
    }
}

final class CouponCategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var bottomView: UIView!
    
    var object: CouponCategory! {
        willSet {
            self.iconImageView.kf.setImage(with: URL(string: newValue._icon.correctUrlString()))
            self.titleLabel.text = newValue._name
        }
    }
    
    var isCategorySelected: Bool = false {
        willSet {
            self.bottomView.backgroundColor = newValue ? R.color.orange() : .clear
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
}
