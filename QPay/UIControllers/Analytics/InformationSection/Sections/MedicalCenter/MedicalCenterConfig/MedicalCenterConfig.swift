//
//  MedicalCenterConfig.swift
//  QPay
//
//  Created by Mohammed Hamad on 10/06/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation

struct MedicalCenterConfig : BaseInfoConfig {
    //FIXME:  config
    var navigationBGImage: UIImage = .bg_medical_center_navigation
    
    var title: String = "Medical Center"
    
    var commonColor: UIColor = .mMedicalCenter
    
    var tabsBGImage: UIImage = .bg_medical_center_tab
    
    var bottomBGImage: UIImage = .bg_medical_center_qatar
    
    var tabsConfig: BaseInfoTabsConfig
    
    var cellConfig: BaseInfoCellConfig
    
    init() {
        self.tabsConfig = MedicalCenterTabsConfig(selectedColor: .white,
                                               unSelectedColor: .gray)
        
        self.cellConfig = MedicalCenterCellConfig(nameColor: self.commonColor,
                                               favoriteImage: .ic_save_limousine,
                                               notFavoriteImage: .ic_save_limousine)
    }
}

struct MedicalCenterTabsConfig : BaseInfoTabsConfig {
    var selectedColor   : UIColor
    var unSelectedColor : UIColor
}

struct MedicalCenterCellConfig : BaseInfoCellConfig {
    
    var nameColor        : UIColor
    var favoriteImage    : UIImage
    var notFavoriteImage : UIImage
    
    
}
