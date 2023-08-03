//
//  BaseInfoFavoritesViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 06/06/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import UIKit

class BaseInfoFavoritesViewController: ViewController {
    
    @IBOutlet weak var imageNavigationBG: UIImageView!
    
    @IBOutlet weak var imageBack: UIButton!
    
    @IBOutlet weak var titleName: UILabel!
    
    
    @IBOutlet weak var imageBottomBg: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var configuration   : BaseInfoConfiguration!
    
    private var items = [BaseInfoDataModel]()

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

extension BaseInfoFavoritesViewController {
    
    func setupView() {
        self.collectionView.delegate   = self
        self.collectionView.dataSource = self
        self.collectionView.registerNib(BaseInfoCollectionViewCell.self)
        
        self.imageNavigationBG.image = self.configuration.config.navigationBGImage
        self.titleName.text          = self.configuration.config.title
        self.titleName.textColor     = self.configuration.config.commonColor
        self.imageBack.tintColor     = self.configuration.config.commonColor
        self.imageBottomBg.image     = self.configuration.config.bottomBGImage
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
        self.showLoadingView(self)
        
        self.configuration.requests.getMyFavoriteList { [weak self] (result) in
            guard let self = self else { return }
            self.hideLoadingView()
            switch result {
            case .success(let list):
                self.items = list
                self.collectionView.reloadData()
                break
                
            case .failure(let failure):
                print(failure.localizedDescription)
                break
            }
        }
    }
}

// MARK: - ACTIONS

extension BaseInfoFavoritesViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - COLLECTION VIEW DELEGATE

extension BaseInfoFavoritesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(BaseInfoCollectionViewCell.self, for: indexPath)
        
        let object = self.items[indexPath.row]
        cell.config = self.configuration.config.cellConfig
        cell.delegate = self
        cell.object = object
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellsInRow: CGFloat = 1
        let flowLayout: UICollectionViewFlowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let leftRightPadding: CGFloat = flowLayout.sectionInset.left + flowLayout.sectionInset.right
        let spaceBetweenCells: CGFloat = flowLayout.minimumInteritemSpacing * cellsInRow
        
        let cellWidth = (collectionView.width - leftRightPadding - spaceBetweenCells) / cellsInRow
        return CGSize(width: cellWidth, height: 150)
    }
}

// MARK: - BaseInfoCollectionViewCellDelegate

extension BaseInfoFavoritesViewController : BaseInfoCollectionViewCellDelegate {
    
    func didTapAddToFavorite(_ cell: BaseInfoCollectionViewCell, for object: BaseInfoDataModel) {
    }
    
    func didTapRemoveFromFavorite(_ cell: BaseInfoCollectionViewCell, for object: BaseInfoDataModel) {
        let id = object.id
        self.showLoadingView(self)
        self.configuration.requests.removeFromFavorite(itemId: id, weakify { strongSelf , result in
            self.hideLoadingView()
            switch result {
            case .success(_):
                strongSelf.items.removeAll(where: { $0.id == id })
                strongSelf.collectionView.reloadData()
                break
            case .failure(let failure):
                self.showErrorMessage(failure.localizedDescription)
                break
            }
        })
    }
}

// MARK: - CUSTOM FUNCTIONS

extension BaseInfoFavoritesViewController {
    
}
