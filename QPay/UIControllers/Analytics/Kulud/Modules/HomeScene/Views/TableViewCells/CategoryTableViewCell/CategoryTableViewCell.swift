//
//  CategoryTableViewCell.swift
//  kulud
//
//  Created by Hussam Elsadany on 16/05/2021.
//  Copyright © 2021 Qmobile-IT. All rights reserved.
//

import UIKit

protocol CategoryTableViewCellDelegate: AnyObject {
    func didSelectCategoryAt(_ index: Int)
}

class CategoryTableViewCell: UITableViewCell {

    static let identifier = String(describing: CategoryTableViewCell.self)
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var categories: [HomeScene.Categories.Category] = []
    private var isShimmering: Bool = true
    public var delegate: CategoryTableViewCellDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.collectionView.registerCell(CategoryCollectionViewCell.identifier)
    }
    
    func configureCell(_ data: [HomeScene.Categories.Category], _ isShimmering: Bool) {
        self.isShimmering = isShimmering
        self.categories = data
        self.collectionView.reloadData()
    }
}

extension CategoryTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isShimmering ? 10 : self.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
        self.isShimmering ? cell.startAnimation() : cell.updateCell(self.categories[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !self.isShimmering else {
            return
        }
        self.delegate?.didSelectCategoryAt(indexPath.row)
    }
}
