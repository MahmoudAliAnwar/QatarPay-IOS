//
//  LimousineTabBaseInfoAdapter.swift
//  QPay
//
//  Created by Mohammed Hamad on 07/06/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit

class LimousineTabBaseInfoAdapter: BaseInfoTabAdapter {
    
    private let array: [LimousineTab]
    
    init(array: [LimousineTab]) {
        self.array = array
    }
    
    func convert() -> [BaseInfoTabModel] {
        var tempArr = [BaseInfoTabModel]()
        for model in self.array {
            tempArr.append(BaseInfoTabModel(id    : model._id,
                                            title : model._ojraBuisnessCategory)
            )
        }
        return tempArr
    }
}
