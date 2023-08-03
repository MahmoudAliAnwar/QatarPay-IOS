//
//  BaseInfoViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 06/06/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import UIKit

class BaseInfoViewController: ViewController {
    
    @IBOutlet weak var imageNavigationBG: UIImageView!
    
    @IBOutlet weak var imageBack: UIImageView!
    
    @IBOutlet weak var titleName: UILabel!
    
    @IBOutlet weak var imageFavorite: UIImageView!
    
    @IBOutlet weak var imageQatarBG: UIImageView!
    
    @IBOutlet weak var imageTabBG: UIImageView!
    
    @IBOutlet weak var tabsCollectionView  : UICollectionView!
    
    @IBOutlet weak var itmesCollectionView : UICollectionView!
    
    private var tabs  = [BaseInfoTabModel]()
    private var items = [BaseInfoDataModel]()
    
    var coordinator   : BaseInfoCoordinator!
    
    private var selectedTab: BaseInfoTabModel? {
        willSet {
            guard let obj = newValue else { return }
            self.showLoadingView(self)
            self.getItems(by: obj.id)
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
    }
}

extension BaseInfoViewController {
    
    func setupView() {
        
        self.tabsCollectionView.delegate    = self
        self.tabsCollectionView.dataSource  = self
        
        self.itmesCollectionView.delegate   = self
        self.itmesCollectionView.dataSource = self
        
        self.itmesCollectionView.registerNib(BaseInfoCollectionViewCell.self)
        
        self.titleName.text          = self.coordinator.configuration.config.title
        self.titleName.textColor     = self.coordinator.configuration.config.commonColor
        self.imageNavigationBG.image = self.coordinator.configuration.config.navigationBGImage
        self.imageTabBG.image        = self.coordinator.configuration.config.tabsBGImage
        self.imageQatarBG.image      = self.coordinator.configuration.config.bottomBGImage
        self.imageBack.tintColor     = self.coordinator.configuration.config.commonColor
        self.imageFavorite.tintColor = self.coordinator.configuration.config.commonColor
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
        self.coordinator.configuration.requests.getTabs( weakify { strongSelf, result in
            switch result {
            case .success(let array):
                strongSelf.tabs = array
                strongSelf.selectedTab = strongSelf.tabs.first
                strongSelf.tabsCollectionView.reloadData()
                break
            case .failure(let failure):
                self.showErrorMessage(failure.localizedDescription)
                break
            }
        })
    }
}

// MARK: - Action

extension BaseInfoViewController {
    
    @IBAction func backAction (_ sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func myListAction(_ sender: UIButton) {
        self.coordinator.start()
    }
}

// MARK: - COLLECTION VIEW DELEGATE

extension BaseInfoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
        case tabsCollectionView :
            return self.tabs.count
            
        case itmesCollectionView :
            return self.items.count
            
        default:
            break
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case tabsCollectionView :
            let cell    = collectionView.dequeueCell(BaseInfoTabCollectionViewCell.self, for: indexPath)
            let object  = self.tabs[indexPath.row]
            cell.config = self.coordinator.configuration.config.tabsConfig
            cell.object = object
            cell.isCellSelected = object == self.selectedTab
            return cell
            
        case itmesCollectionView :
            let cell      = collectionView.dequeueCell(BaseInfoCollectionViewCell.self, for: indexPath)
            let object    = self.items[indexPath.row]
            cell.config = self.coordinator.configuration.config.cellConfig
            cell.object   = object
            cell.delegate = self
            return cell
            
        default:
            break
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case tabsCollectionView :
            let object = self.tabs[indexPath.row]
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
            let text = self.tabs[indexPath.row].title
            let string = NSAttributedString(string: text, attributes: [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)
            ])
            let cellWidth = string.size().width
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

// MARK: - BaseInfoCollectionViewCellDelegate

extension BaseInfoViewController : BaseInfoCollectionViewCellDelegate {
    
    func didTapAddToFavorite(_ cell: BaseInfoCollectionViewCell, for object: BaseInfoDataModel) {
        let id = object.id
        self.showLoadingView(self)
        self.coordinator.configuration.requests.addToFavorite(itemId: id, weakify { strongSelf  , result in
            switch result {
            case .success(_):
                self.getItems(by: self.selectedTab?.id ?? 0)
                strongSelf.itmesCollectionView.reloadData()
                break
            case .failure(let failure):
                self.showErrorMessage(failure.localizedDescription)
                break
            }
        })
    }
    
    func didTapRemoveFromFavorite(_ cell: BaseInfoCollectionViewCell, for object: BaseInfoDataModel) {
        let id = object.id
        self.showLoadingView(self)
        self.coordinator.configuration.requests.removeFromFavorite(itemId: id, weakify { strongSelf  , result in
            switch result {
            case .success(_):
                self.getItems(by: self.selectedTab?.id ?? 0)
                strongSelf.itmesCollectionView.reloadData()
                break
            case .failure(let failure):
                self.showErrorMessage(failure.localizedDescription)
                break
            }
        })
    }
}

// MARK: - CUSTOME FUNCTIONS

extension BaseInfoViewController {
    
    private func getItems(by tabId: Int) {
        self.coordinator.configuration.requests.getData(tabId: tabId, { result in
            self.hideLoadingView()
            switch result {
            case .success(let success):
                self.items = success
                self.itmesCollectionView.reloadData()
                break
            case .failure(let failure):
                self.showErrorMessage(failure.localizedDescription)
                break
            }
        })
    }
}
