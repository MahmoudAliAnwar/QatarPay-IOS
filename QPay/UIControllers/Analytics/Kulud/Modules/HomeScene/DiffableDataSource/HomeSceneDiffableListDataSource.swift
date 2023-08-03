//
//  HomeSceneDiffableListDataSource.swift
//  kulud
//
//  Created by Hussam Elsadany on 16/05/2021.
//  Copyright © 2021 Qmobile-IT. All rights reserved.
//

import UIKit

protocol HomeSceneDiffableListDataSource {
    func cellForRaw(at indexPath: IndexPath, tableView: UITableView) -> UITableViewCell
    func numberOfRows(at section: Int) -> Int
    func heightForRaw(at indexPath: IndexPath, tableView: UITableView) -> CGFloat
}
