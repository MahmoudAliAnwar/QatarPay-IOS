//
//  BaseInfoConfig.swift
//  QPay
//
//  Created by Mohammed Hamad on 06/06/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit

protocol BaseInfoConfig {
    
    var navigationBGImage: UIImage { get }
    var title            : String  { get }
    var commonColor      : UIColor { get }
    var tabsBGImage      : UIImage { get }
    var bottomBGImage    : UIImage { get }
    var tabsConfig       : BaseInfoTabsConfig { get }
    var cellConfig       : BaseInfoCellConfig { get }
}

protocol BaseInfoTabsConfig {
    
    var selectedColor   : UIColor { get }
    var unSelectedColor : UIColor { get }
}

protocol BaseInfoCellConfig {
    
    var nameColor        : UIColor { get }
    var favoriteImage    : UIImage { get }
    var notFavoriteImage : UIImage { get }
}

