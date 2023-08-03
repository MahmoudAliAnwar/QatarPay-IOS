//
//  QaterSchoolsConfig.swift
//  QPay
//
//  Created by Mohammed Hamad on 12/06/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation

struct QaterSchoolsConfig : BaseInfoConfig {
    //FIXME:  config
    var navigationBGImage: UIImage = .bg_qater_school_navigation
    
    var title: String = "Qater Schools"
    
    var commonColor: UIColor = .mSchool
    
    var tabsBGImage: UIImage = .bg_qater_School_tab
    
    var bottomBGImage: UIImage = .bg_school_qater
    
    var tabsConfig: BaseInfoTabsConfig
    
    var cellConfig: BaseInfoCellConfig
    
    init() {
        self.tabsConfig = QaterSchoolsTabsConfig(selectedColor: .white,
                                                  unSelectedColor: .gray)
        
        self.cellConfig = QaterSchoolsCellConfig(nameColor: self.commonColor,
                                                  favoriteImage: .ic_save_limousine,
                                                  notFavoriteImage: .ic_save_limousine)
    }
}

struct QaterSchoolsTabsConfig : BaseInfoTabsConfig {
    var selectedColor   : UIColor
    var unSelectedColor : UIColor
}

struct QaterSchoolsCellConfig : BaseInfoCellConfig {
    
    var nameColor        : UIColor
    var favoriteImage    : UIImage
    var notFavoriteImage : UIImage
    
    
}
