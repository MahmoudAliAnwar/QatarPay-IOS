//
//  ChildCareTabBaseInfoAdapter.swift
//  QPay
//
//  Created by Mohammed Hamad on 08/06/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation
 
class ChildCareTabBaseInfoAdapter : BaseInfoTabAdapter {
    
    private let array: [ChildCareTab]
    
    init(array: [ChildCareTab]) {
        self.array = array
    }
    
    func convert() -> [BaseInfoTabModel] {
        var tempArr = [BaseInfoTabModel]()
        for model in self.array {
            tempArr.append(BaseInfoTabModel(id    : model._childCareID,
                                            title : model._childCareName)
            )
        }
        return tempArr
    }
}
