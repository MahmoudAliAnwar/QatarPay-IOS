//
//  Advertisement2DataSource.swift
//  kulud
//
//  Created by Hussam Elsadany on 07/06/2021.
//  Copyright © 2021 Qmobile-IT. All rights reserved.
//

import UIKit

class Advertisement2DataSource: HomeSceneDiffableListDataSource {
    
    public var advertisements: [HomeScene.Advertisements.Advertisement] = [] {
        didSet {
            self.isShimmering = false
        }
    }
    private var isShimmering: Bool = true
    
    func numberOfRows(at section: Int) -> Int {
        return 1
    }
    
    func cellForRaw(at indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Advertisment2TableViewCell.identifier) as! Advertisment2TableViewCell
        cell.configureCell(self.advertisements, self.isShimmering)
        return cell
    }
    
    func heightForRaw(at indexPath: IndexPath, tableView: UITableView) -> CGFloat {
        return 100
    }
}
