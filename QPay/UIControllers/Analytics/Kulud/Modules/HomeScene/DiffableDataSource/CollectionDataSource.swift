//
//  CollectionDataSource.swift
//  kulud
//
//  Created by Hussam Elsadany on 16/05/2021.
//  Copyright © 2021 Qmobile-IT. All rights reserved.
//

import UIKit

protocol CollectionDataSourceDelegate: AnyObject {
    func didSelectProductAt(_ indexPath: IndexPath)
    func didTapAddToCartForProductAt(_ indexPath: IndexPath)
    func didChangeQuantity(_ indexPath: IndexPath, quantity: Int)
}

class CollectionDataSource: HomeSceneDiffableListDataSource {
    
    public var collections: [HomeScene.Collections.Collection] = [] {
        didSet {
            self.isShimmering = false
        }
    }
    private var isShimmering: Bool = true
    public var delegate: CollectionDataSourceDelegate? = nil
    
    func numberOfRows(at section: Int) -> Int {
        return self.isShimmering ? 1 : self.collections.count
    }
    
    func cellForRaw(at indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CollectionTableViewCell.identifier) as! CollectionTableViewCell
        cell.delegate = self
        if !self.isShimmering { cell.configureCell(self.collections[indexPath.row], index: indexPath.row) }
        return cell
    }
    
    func heightForRaw(at indexPath: IndexPath, tableView: UITableView) -> CGFloat {
        return 320
    }
}

extension CollectionDataSource: CollectionTableViewCellDelegate {
    func didSelectProductAt(_ indexPath: IndexPath) {
        self.delegate?.didSelectProductAt(indexPath)
    }
    
    func didTapAddToCart(_ indexPath: IndexPath) {
        self.delegate?.didTapAddToCartForProductAt(indexPath)
    }
    
    func didChangeQuantity(_ indexPath: IndexPath, quantity: Int) {
        self.delegate?.didChangeQuantity(indexPath, quantity: quantity)
    }
}
