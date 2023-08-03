//
//  CategoriesDataSource.swift
//  kulud
//
//  Created by Hussam Elsadany on 16/05/2021.
//  Copyright © 2021 Qmobile-IT. All rights reserved.
//

import UIKit

protocol CategoriesDataSourceDelegate: AnyObject {
    func didSelectCategoryAt(_ index: Int)
}

class CategoriesDataSource: HomeSceneDiffableListDataSource {
    
    public var categories: [HomeScene.Categories.Category] = [] {
        didSet {
            self.isShimmering = false
        }
    }
    private var isShimmering: Bool = true
    public var delegate: CategoriesDataSourceDelegate? = nil
    
    func numberOfRows(at section: Int) -> Int {
        return 1
    }
    
    func cellForRaw(at indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier) as! CategoryTableViewCell
        cell.delegate = self
        cell.configureCell(self.categories, self.isShimmering)
        return cell
    }
    
    func heightForRaw(at indexPath: IndexPath, tableView: UITableView) -> CGFloat {
        return 120.0
    }
}

extension CategoriesDataSource: CategoryTableViewCellDelegate {
    func didSelectCategoryAt(_ index: Int) {
        self.delegate?.didSelectCategoryAt(index)
    }
}
