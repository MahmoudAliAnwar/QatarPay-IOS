//
//  CollectionTableViewCell.swift
//  kulud
//
//  Created by Hussam Elsadany on 16/05/2021.
//  Copyright © 2021 Qmobile-IT. All rights reserved.
//

import UIKit

protocol CollectionTableViewCellDelegate: AnyObject {
    func didSelectProductAt(_ indexPath: IndexPath)
    func didTapAddToCart(_ indexPath: IndexPath)
    func didChangeQuantity(_ indexPath: IndexPath, quantity: Int)
}

class CollectionTableViewCell: UITableViewCell {

    static let identifier = String(describing: CollectionTableViewCell.self)
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var collection: HomeScene.Collections.Collection! {
        didSet {
            self.isShimmering = false
        }
    }
    private var isShimmering: Bool = true
    private var tableIndex: Int = 0
    public weak var delegate: CollectionTableViewCellDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.collectionView.registerCell(KuludProductCollectionViewCell.identifier)
    }
    
    func configureCell(_ data: HomeScene.Collections.Collection, index: Int) {
        self.collection = data
        self.tableIndex = index
        self.titleLabel.text = data.name
        self.collectionView.reloadData()
    }
}

extension CollectionTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.isShimmering ? 3 : self.collection.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KuludProductCollectionViewCell.identifier, for: indexPath) as! KuludProductCollectionViewCell
        self.isShimmering ? cell.startAnimation() : cell.configureCell(self.collection.products[indexPath.row], indexPath: indexPath)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2.2 , height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !self.isShimmering else {
            return
        }
        let indexPath = IndexPath(row: indexPath.row, section: tableIndex)
        self.delegate?.didSelectProductAt(indexPath)
    }
}

extension CollectionTableViewCell: KuludProductCollectionViewCellDelegate {
    func product(cell: KuludProductCollectionViewCell, didTapAddToCart item: IndexPath) {
        let indexPath = IndexPath(row: item.row, section: tableIndex)
        self.delegate?.didTapAddToCart(indexPath)
    }
    
    func product(cell: KuludProductCollectionViewCell, didChangeQuantityFor item: IndexPath, quantity: Int) {
        let indexPath = IndexPath(row: item.row, section: tableIndex)
        self.delegate?.didChangeQuantity(indexPath, quantity: quantity)
    }
}
