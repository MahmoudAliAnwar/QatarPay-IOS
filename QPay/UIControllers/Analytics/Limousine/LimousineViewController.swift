//
//  LimousineViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/4/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class LimousineViewController: ViewController {
    
    @IBOutlet weak var tabsCollectionView  : UICollectionView!
    
    @IBOutlet weak var itmesCollectionView : UICollectionView!
    
    private var limousineTabs  = [LimousineTab]()
    private var limousineItmes = [OjraDetails]()
    
    private var selectedTab: LimousineTab? {
        willSet {
            guard let obj = newValue else { return }
            self.showLoadingView(self)
            self.getLimousineItems(by: obj._id)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        localized()
        setupData()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.requestProxy.requestService()?.delegate = self
    }
}

extension LimousineViewController {
    
    func setupView() {
        self.tabsCollectionView.delegate   = self
        self.tabsCollectionView.dataSource = self
        
        self.itmesCollectionView.delegate   = self
        self.itmesCollectionView.dataSource = self
        
        self.itmesCollectionView.registerNib(LimousineCollectionViewCell.self)
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
        self.requestProxy.requestService()?.getLimousineTab ({ (response) in
            guard let resp = response  else { return }
            self.limousineTabs = resp._list
            self.selectedTab = self.limousineTabs.first
            self.tabsCollectionView.reloadData()
            self.getLimousineItems(by: self.limousineTabs.first?._id ?? 0)
        })
    }
}

// MARK: - Action

extension LimousineViewController {
    @IBAction func backAction (_ sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func myListAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(MyListLimousineViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - COLLECTION VIEW DELEGATE

extension LimousineViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case tabsCollectionView :
            return self.limousineTabs.count
            
        case itmesCollectionView :
            return self.limousineItmes.count
            
        default:
            break
        }
        return 0
    }
    
    ///FIXME limousineTabs
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case tabsCollectionView :
            let cell    = collectionView.dequeueCell(LimousineTabCollectionViewCell.self, for: indexPath)
            let object  = self.limousineTabs[indexPath.row]
            cell.object = object
            cell.isCellSelected = object == self.selectedTab
            return cell
            
        case itmesCollectionView :
            let cell      = collectionView.dequeueCell(LimousineCollectionViewCell.self, for: indexPath)
            let object    = self.limousineItmes[indexPath.row]
            cell.object   = object
            cell.delegate = self
            cell.cellConfiguration(.black)
             return cell
            
        default:
            break
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case tabsCollectionView :
            let object = self.limousineTabs[indexPath.row]
            self.selectedTab = object
            collectionView.reloadData()
            break
        default :
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch collectionView {
        case tabsCollectionView :
            
            let cellsInRow: CGFloat = CGFloat(limousineTabs.count)
            let flowLayout: UICollectionViewFlowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            let leftRightPadding: CGFloat = flowLayout.sectionInset.left + flowLayout.sectionInset.right
            let spaceBetweenCells: CGFloat = flowLayout.minimumInteritemSpacing
            
            let cellWidth = (collectionView.width - leftRightPadding - spaceBetweenCells) / cellsInRow
            return CGSize(width: cellWidth, height: collectionView.height)
            
        case itmesCollectionView :
            
            let cellsInRow: CGFloat = 1
            let flowLayout: UICollectionViewFlowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            let leftRightPadding: CGFloat = flowLayout.sectionInset.left + flowLayout.sectionInset.right
            let spaceBetweenCells: CGFloat = flowLayout.minimumInteritemSpacing
            
            let cellWidth = (collectionView.width - leftRightPadding - spaceBetweenCells) / cellsInRow
            return CGSize(width: cellWidth, height: 150)
            
        default:
            break
        }
        return CGSize(width: 0, height: 0 )
    }
}

// MARK: - LimousineCollectionViewCellDelegate

extension LimousineViewController : LimousineCollectionViewCellDelegate {
    
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
        guard let id = limousine.ojra_ID else {return}
        
        self.requestProxy.requestService()?.addLimousineToMyList(id: id, { respone in
            guard let resp = respone else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                self.showSuccessMessage(resp._message)
                self.getLimousineItems(by: self.selectedTab?._id ?? 0)
            }
        })
    }
    
    func didTapRemoveToMyLimousine(_ cell: LimousineCollectionViewCell, for limousine: OjraDetails) {
        guard let id = limousine.ojra_ID else { return }
        
        self.requestProxy.requestService()?.deleteLimousineFromMyList(id: id,{ respone in
            guard let resp = respone else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                self.showSuccessMessage(resp._message)
                self.getLimousineItems(by: self.selectedTab?._id ?? 0)
            }
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
        guard let map = limousine._ojraWorkingSetUpList.first?._locationGPS else { return }
        self.openGoogleMaps(map)        
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

extension LimousineViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .getLimousineTabs ||
            request == .addLimousineToMyList ||
            request == .deleteLimousineFromMyList {
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

// MARK: - CUSTOME FUNCTIONS

extension LimousineViewController {
    
    private func getLimousineItems(by tabId: Int) {
        self.requestProxy.requestService()?.getLimousineItmes(BuisCategID: tabId, { (response) in
            guard let resp = response else { return }
            self.limousineItmes = resp._list
            self.itmesCollectionView.reloadData()
        })
    }
    
    private func openGoogleMaps(_ map :String) {
        guard let url = URL(string: "comgooglemaps://\(map)") else { return }
        
        guard UIApplication.shared.canOpenURL(url) else {
            guard let websiteURL = URL(string: "\(map)") else { return }
            UIApplication.shared.open(websiteURL, options: [:], completionHandler: nil)
            return
        }
        
        UIApplication.shared.open(url)
    }
}
