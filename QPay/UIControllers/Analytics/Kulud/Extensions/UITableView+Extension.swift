//
//  UITableView+Extension.swift
//  kulud
//
//  Created by Hussam Elsadany on 10/03/2021.
//  Copyright © 2021 Qmobile-IT. All rights reserved.
//

import UIKit

extension UITableView {
    
    func registerCell(_ identifierName: String) {
        self.register(UINib(nibName: identifierName, bundle: nil), forCellReuseIdentifier: identifierName)
    }
}
