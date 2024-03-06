//
//  LimousineDataBaseInfoAdapter.swift
//  QPay
//
//  Created by Mohammed Hamad on 07/06/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit

class LimousineDataBaseInfoAdapter: BaseInfoDataAdapter {
    
    private let array: [OjraDetails]
    
    init(array: [OjraDetails]) {
        self.array = array
    }
    
    func convert() -> [BaseInfoDataModel] {
        var tempArr = [BaseInfoDataModel]()
        for model in self.array {
            
            guard let imageURL    = model._ojraUploadImagesList.first?._imageOffer,
                  let isFavorite  = model._ojraWorkingSetUpList.first?._isItemAdded ,
                  let name        = model._ojraAccountInfoList.first?._companyName,
                  let office      = model._ojraWorkingSetUpList.first?._office,
                  let workingFrom = model._ojraWorkingSetUpList.first?._workingFrom,
                  let workingTo   = model._ojraWorkingSetUpList.first?._workingTo,
                  let web         = model._ojraWorkingSetUpList.first?._web ,
                  let rate        = model._ojraWorkingSetUpList.first?._rating,
                  let mobile      = model._ojraAccountInfoList.first?._managerMobile,
                  let images      = model._ojraRideTypeList.first?._carTypeDetails,
                  let locationURL = model._ojraWorkingSetUpList.first?._locationGPS
            else {
                continue
            }
            
            let baseImages = LimousineImageBaseInfoAdapter(array: images).convert()
            tempArr.append(
                BaseInfoDataModel(id          : model._ojra_ID,
                                  imageURL    : imageURL ,
                                  isFavorite  : isFavorite ,
                                  name        : name ,
                                  office      : office ,
                                  workingFrom : workingFrom ,
                                  workingTo   : workingTo,
                                  email       : model._ojra_Email,
                                  website     : web ,
                                  rate        : rate ,
                                  images      : baseImages ,
                                  mobile      : mobile ,
                                  locationURL : locationURL )
            )
        }
        return tempArr
    }
}
