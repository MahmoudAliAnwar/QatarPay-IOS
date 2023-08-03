//
//  QaterSchoolsTabBaseInfoAdapter.swift
//  QPay
//
//  Created by Mohammed Hamad on 12/06/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation

class QaterSchoolsTabBaseInfoAdapter : BaseInfoTabAdapter {
    
    private let array: [QaterSchoolTab]
    
    init(array: [QaterSchoolTab]) {
        self.array = array
    }
    
    func convert() -> [BaseInfoTabModel] {
        var tempArr = [BaseInfoTabModel]()
        for model in self.array {
            tempArr.append(BaseInfoTabModel(id    : model._schoolID,
                                            title : model._schoolName)
            )
        }
        return tempArr
    }
}
