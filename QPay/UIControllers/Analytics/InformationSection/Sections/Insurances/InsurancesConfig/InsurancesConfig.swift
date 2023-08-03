//
//  InsurancesConfig.swift
//  QPay
//
//  Created by Mohammed Hamad on 10/06/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation

struct InsurancesConfig : BaseInfoConfig {
    //FIXME:  config
    var navigationBGImage: UIImage  = .bg_insurance_navigation
    var title            : String   = "Insurances"
    var commonColor      : UIColor  = .mInsurance
    var tabsBGImage      : UIImage  = .bg_insurance_tab
    var bottomBGImage    : UIImage  = .bg_insurance_qater
    
    var tabsConfig: BaseInfoTabsConfig
    
    var cellConfig: BaseInfoCellConfig
    
    init() {
        self.tabsConfig = InsurancesTabsConfig(selectedColor: .white,
                                         unSelectedColor: .gray)
        
        self.cellConfig = InsurancesCellConfig(nameColor: self.commonColor,
                                         favoriteImage: .ic_save_limousine,
                                         notFavoriteImage: .ic_save_limousine)
    }
}

struct InsurancesTabsConfig : BaseInfoTabsConfig {
    var selectedColor   : UIColor
    var unSelectedColor : UIColor
}

struct InsurancesCellConfig : BaseInfoCellConfig {
    
    var nameColor        : UIColor
    var favoriteImage    : UIImage
    var notFavoriteImage : UIImage
    
    
}
