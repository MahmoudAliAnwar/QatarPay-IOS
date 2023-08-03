//
//  DineImagesBaseInfoAdapter.swift
//  QPay
//
//  Created by Mohammed Hamad on 10/06/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation

class DineImagesBaseInfoAdapter : BaseInfoImageAdapter {
    
    private let array : [ServiceTypeDetails]
    init(array : [ServiceTypeDetails]){
        self.array = array
    }
    func convert() -> [BaseInfoImageModel] {
        var tempArr = [BaseInfoImageModel]()
        for model in self.array {
            tempArr.append(BaseInfoImageModel(
                imageURL: model._serviceImageLocation)
            )
        }
        return tempArr
    }
    
}
