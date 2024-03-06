//
//  InsurancesTabBaseInfoAdapter.swift
//  QPay
//
//  Created by Mohammed Hamad on 10/06/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation

class InsurancesTabBaseInfoAdapter : BaseInfoTabAdapter {
    
    private let array: [InsurancesTab]
    
    init(array: [InsurancesTab]) {
        self.array = array
    }
    
    func convert() -> [BaseInfoTabModel] {
        var tempArr = [BaseInfoTabModel]()
        for model in self.array {
            tempArr.append(BaseInfoTabModel(id    : model._insuranceID,
                                            title : model._insuranceName)
            )
        }
        return tempArr
    }
}
