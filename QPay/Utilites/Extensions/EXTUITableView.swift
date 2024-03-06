//
//  EXTUITableView.swift
//  QPay
//
//  Created by Mahmoud on 19/02/2024.
//  Copyright © 2024 Dev. Mohmd. All rights reserved.
//


import UIKit

class IntrinsicTableView: UITableView {

    override var contentSize: CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return contentSize
    }

    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
    }

}


