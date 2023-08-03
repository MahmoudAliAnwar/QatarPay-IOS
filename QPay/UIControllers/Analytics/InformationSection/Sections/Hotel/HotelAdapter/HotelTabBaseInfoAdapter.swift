//
//  HotelTabBaseInfoAdapter.swift
//  QPay
//
//  Created by Mohammed Hamad on 10/06/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation

class HotelTabBaseInfoAdapter : BaseInfoTabAdapter {
    
    private let array: [HotelTab]
    
    init(array: [HotelTab]) {
        self.array = array
    }
    
    func convert() -> [BaseInfoTabModel] {
        var tempArr = [BaseInfoTabModel]()
        for model in self.array {
            tempArr.append(BaseInfoTabModel(id    : model._hotelID,
                                            title : model._hotelName)
            )
        }
        return tempArr
    }
}
