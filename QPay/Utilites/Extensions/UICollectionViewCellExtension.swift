//
//  UICollectionViewExtension.swift
//  QPay
//
//  Created by Mohammed Hamad on 03/02/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionViewCell {
    
    var collectionView: UICollectionView? {
        return self.next(of: UICollectionView.self)
    }
    
    var indexPath: IndexPath? {
        return self.collectionView?.indexPath(for: self)
    }
}
