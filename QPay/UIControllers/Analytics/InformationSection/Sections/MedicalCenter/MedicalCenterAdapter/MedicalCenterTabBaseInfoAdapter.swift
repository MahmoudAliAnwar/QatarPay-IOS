//
//  MedicalCenterTabBaseInfoAdapter.swift
//  QPay
//
//  Created by Mohammed Hamad on 10/06/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation

class MedicalCenterTabBaseInfoAdapter : BaseInfoTabAdapter {
    
    private let array: [MedicalCenterTab]
    
    init(array: [MedicalCenterTab]) {
        self.array = array
    }
    
    func convert() -> [BaseInfoTabModel] {
        var tempArr = [BaseInfoTabModel]()
        for model in self.array {
            tempArr.append(BaseInfoTabModel(id    : model._clinicsID,
                                            title : model._clinicsName)
            )
        }
        return tempArr
    }
}
