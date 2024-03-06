//
//  DineConfig.swift
//  QPay
//
//  Created by Mohammed Hamad on 10/06/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation

struct DineConfig : BaseInfoConfig {
    var navigationBGImage: UIImage = .bg_dine_navigation
    
    var title: String = "DINE IN and OUT"
    
    var commonColor: UIColor = .mDine
    
    var tabsBGImage: UIImage = .bg_dine_tab
    
    var bottomBGImage: UIImage = .bg_dine_qater
    
    var tabsConfig: BaseInfoTabsConfig
    
    var cellConfig: BaseInfoCellConfig
    
    init() {
        self.tabsConfig = DineTabsConfig(selectedColor: .white,
                                          unSelectedColor: .gray)
        
        self.cellConfig = DineCellConfig(nameColor: self.commonColor,
                                          favoriteImage: .ic_save_limousine,
                                          notFavoriteImage: .ic_save_limousine)
    }
}

struct DineTabsConfig : BaseInfoTabsConfig {
    var selectedColor   : UIColor
    var unSelectedColor : UIColor
}

struct DineCellConfig : BaseInfoCellConfig {
    
    var nameColor        : UIColor
    var favoriteImage    : UIImage
    var notFavoriteImage : UIImage
}
