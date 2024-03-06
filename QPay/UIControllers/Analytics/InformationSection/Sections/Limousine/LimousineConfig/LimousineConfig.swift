//
//  LimousineConfig.swift
//  QPay
//
//  Created by Mohammed Hamad on 07/06/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation

struct LimousineConfig : BaseInfoConfig {
    
    var navigationBGImage: UIImage = .bg_limousine_navigation
    
    var title: String = "Limousine"
     
    var commonColor: UIColor = .black
    
    var tabsBGImage: UIImage = .bg_limousine_tab
    
    var bottomBGImage: UIImage = .bg_limousine_qatar
    
    var tabsConfig: BaseInfoTabsConfig
    
    var cellConfig: BaseInfoCellConfig
    
    init() {
        self.tabsConfig = LimousineTabsConfig(selectedColor: .white,
                                                                 unSelectedColor: .gray)
        
        self.cellConfig = LimousineCellConfig(nameColor: self.commonColor,
                                                                 favoriteImage: .ic_save_limousine,
                                                                 notFavoriteImage: .ic_save_limousine)
    }
}

struct LimousineTabsConfig : BaseInfoTabsConfig {
    var selectedColor   : UIColor
    var unSelectedColor : UIColor
}

struct LimousineCellConfig : BaseInfoCellConfig {
    
    var nameColor        : UIColor
    var favoriteImage    : UIImage
    var notFavoriteImage : UIImage
    
    
}
