//
//  HotelConfig.swift
//  QPay
//
//  Created by Mohammed Hamad on 10/06/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation

struct HotelConfig : BaseInfoConfig {
    var navigationBGImage: UIImage = .bg_hotel_navigation
    
    var title: String              = "Qatar Stay In"
    
    var commonColor: UIColor       = .mHotel
    
    var tabsBGImage: UIImage       = .bg_hotel_tab
    
    var bottomBGImage: UIImage     = .bg_hotel_qatar
    
    var tabsConfig: BaseInfoTabsConfig
    
    var cellConfig: BaseInfoCellConfig
    
    init() {
        self.tabsConfig = HotelTabsConfig(selectedColor: .white,
                                              unSelectedColor: .gray)
        
        self.cellConfig = HotelCellConfig(nameColor: self.commonColor,
                                     favoriteImage: .ic_save_limousine,
                                     notFavoriteImage: .ic_save_limousine)
    }
}

struct HotelTabsConfig : BaseInfoTabsConfig {
    var selectedColor   : UIColor
    var unSelectedColor : UIColor
}

struct HotelCellConfig : BaseInfoCellConfig {
    
    var nameColor        : UIColor
    var favoriteImage    : UIImage
    var notFavoriteImage : UIImage
    
    
}
