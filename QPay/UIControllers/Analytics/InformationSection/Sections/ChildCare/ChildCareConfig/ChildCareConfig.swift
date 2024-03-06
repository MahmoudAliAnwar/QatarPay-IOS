//
//  ChildCareConfig.swift
//  QPay
//
//  Created by Mohammed Hamad on 10/06/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation

struct ChildCareConfig : BaseInfoConfig {
    
    var navigationBGImage: UIImage = .bg_child_Care_navigation
    
    var title: String = "Child Care"
    
    var commonColor: UIColor = .mChildCare
    
    var tabsBGImage: UIImage = .bg_child_Care_tab
    
    var bottomBGImage: UIImage = .bg_limousine_qatar
    
    var tabsConfig: BaseInfoTabsConfig
    
    var cellConfig: BaseInfoCellConfig
    
    init() {
        self.tabsConfig = ChildCareTabsConfig(selectedColor: .white,
                                              unSelectedColor: .gray)
        
        self.cellConfig = ChildCareCellConfig(nameColor: self.commonColor,
                                              favoriteImage: .ic_save_limousine,
                                              notFavoriteImage: .ic_save_limousine)
    }
}

struct ChildCareTabsConfig : BaseInfoTabsConfig {
    var selectedColor   : UIColor
    var unSelectedColor : UIColor
}

struct ChildCareCellConfig : BaseInfoCellConfig {
    
    var nameColor        : UIColor
    var favoriteImage    : UIImage
    var notFavoriteImage : UIImage
    
    
}
