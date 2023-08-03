//
//  AdvertisementDataSource.swift
//  kulud
//
//  Created by Hussam Elsadany on 16/05/2021.
//  Copyright © 2021 Qmobile-IT. All rights reserved.
//

import UIKit

class AdvertisementDataSource: HomeSceneDiffableListDataSource {
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: AdvertiseTableViewCell.identifier) as! AdvertiseTableViewCell
        cell.configureCell(self.advertisements, self.isShimmering)
        return cell
    }
    
    func heightForRaw(at indexPath: IndexPath, tableView: UITableView) -> CGFloat {
        return UIScreen.main.bounds.height * 0.2
    }
}
