//
//  LimousineImageBaseInfoAdapter.swift
//  QPay
//
//  Created by Mohammed Hamad on 07/06/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit

class LimousineImageBaseInfoAdapter : BaseInfoImageAdapter {
    private let array : [CarTypeDetails]
    init(array : [CarTypeDetails]){
        self.array = array
    }
    func convert() -> [BaseInfoImageModel] {
        var tempArr = [BaseInfoImageModel]()
        for model in self.array {
            tempArr.append(BaseInfoImageModel(
                imageURL: model._carImageLocation)
            )
        }
        return tempArr
    }
    
}
