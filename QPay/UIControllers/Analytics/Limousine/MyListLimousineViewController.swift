//
//  MyListLimousineViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 26/05/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import UIKit

class MyListLimousineViewController: ViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var myLimousines = [OjraDetails]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        localized()
        setupData()
        fetchData()
    }
}

extension MyListLimousineViewController {
    
    func setupView() {
        self.requestProxy.requestService()?.delegate = self
        
        self.collectionView.delegate   = self
        self.collectionView.dataSource = self
        
        self.collectionView.registerNib(LimousineCollectionViewCell.self)
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
        self.getMyLimousineItems()
    }
}

// MARK: - Action

extension MyListLimousineViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - COLLECTION VIEW DELEGATE

extension MyListLimousineViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.myLimousines.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(LimousineCollectionViewCell.self, for: indexPath)
        
        let object  = self.myLimousines[indexPath.row]
        cell.object = object
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellsInRow: CGFloat = 1
        let flowLayout: UICollectionViewFlowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let leftRightPadding: CGFloat  = flowLayout.sectionInset.left + flowLayout.sectionInset.right
        let spaceBetweenCells: CGFloat = flowLayout.minimumInteritemSpacing
        
        let cellWidth = (collectionView.width - leftRightPadding - spaceBetweenCells) / cellsInRow
        return CGSize(width: cellWidth, height: 150)
    }
}

// MARK: - Cell Delegate
extension MyListLimousineViewController : LimousineCollectionViewCellDelegate {
    
    func didTapOpenWebsiteLimousine(_ cell: LimousineCollectionViewCell, for limousine: OjraDetails) {
        
        guard let web = limousine._ojraWorkingSetUpList.first?._web else {
            return
        }
        
        guard let url = URL(string: web) else {
            return
        }
        
        guard UIApplication.shared.canOpenURL(url) else {
            return
        }
        
        UIApplication.shared.open(url)
    }
    
    func didTapAddToMyLimousine(_ cell: LimousineCollectionViewCell, for limousine: OjraDetails) {
        
    }
    
    func didTapRemoveToMyLimousine(_ cell: LimousineCollectionViewCell, for limousine: OjraDetails) {
        guard let id = limousine.ojra_ID else {return}
        self.requestProxy.requestService()?.deleteLimousineFromMyList(id: id,{ respone in
            guard let resp = respone , resp._success == true else {
                return
            }
            self.showSuccessMessage(resp._message)
            self.getMyLimousineItems()
        })
    }
    
    func didTapCallLimousine(_ cell: LimousineCollectionViewCell, for limousine: OjraDetails) {
        guard let numberPhone = limousine._ojraAccountInfoList.first?._managerMobile else { return }
        var mobile: String = numberPhone
        
        if mobile.contains("/") {
            let mobiles = mobile.split(separator: "/")
            guard let phone = mobiles.first else { return }
            mobile = String(phone)
        }
        
        guard let callURL = URL(string: "\(mobile)") else { return }
        guard UIApplication.shared.canOpenURL(callURL) else { return }
        UIApplication.shared.open(callURL, options: [:])
    }
    
    func didTapOpenMapLimousine(_ cell: LimousineCollectionViewCell, for limousine: OjraDetails) {
        
    }
    
    func didTapOpenEmailLimousine(_ cell: LimousineCollectionViewCell, for limousine: OjraDetails) {
        let email = limousine._ojra_Email
        guard let url = URL(string: "mailto:\(email)") else {
            return
        }
        
        guard UIApplication.shared.canOpenURL(url) else {
            return
        }
        
        UIApplication.shared.open(url)
    }
}

// MARK: - Requests Delegate

extension MyListLimousineViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .getMyLimousineList ||
            request == .deleteLimousineFromMyList {
            showLoadingView(self)
        }
    }
    
    func requestFinished(request: RequestType, result: ResponseResult) {
        self.hideLoadingView()
        
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


// MARK: - CUSTOME FUNCTIONS

extension MyListLimousineViewController {
    
    private func getMyLimousineItems() {
        
        self.requestProxy.requestService()?.getMyLimousineList({ (response) in
            guard let resp    = response else { return }
            self.myLimousines = resp._list
            self.collectionView.reloadData()
        })
    }
}
