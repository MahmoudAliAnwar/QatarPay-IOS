//
//  FSPagerViewExtension.swift
//  QPay
//
//  Created by Mohammed Hamad on 25/04/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit
import FSPagerView

extension FSPagerView {
    
    func registerCell<T: UICollectionViewCell>(_ cell: T.Type) {
        self.register(cell, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func registerNib<T: UICollectionViewCell>(_ cell: T.Type) {
        self.register(UINib(nibName: T.reuseIdentifier, bundle: .main), forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueCell<T: UICollectionViewCell>(_ cell: T.Type, for index: Int) -> T {
        return self.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, at: index) as! T
    }
}

