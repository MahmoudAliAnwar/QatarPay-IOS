//
//  DineTabBaseInfoAdapter.swift
//  QPay
//
//  Created by Mohammed Hamad on 10/06/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation

class DineTabBaseInfoAdapter : BaseInfoTabAdapter {
    
    private let array: [DineTab]
    
    init(array: [DineTab]) {
        self.array = array
    }
    
    func convert() -> [BaseInfoTabModel] {
        var tempArr = [BaseInfoTabModel]()
        for model in self.array {
            tempArr.append(BaseInfoTabModel(id    : model._dineID,
                                            title : model._dineName)
            )
        }
        return tempArr
    }
}
