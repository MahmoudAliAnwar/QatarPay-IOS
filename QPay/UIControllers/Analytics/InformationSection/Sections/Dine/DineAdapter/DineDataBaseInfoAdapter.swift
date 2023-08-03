//
//  DineDataBaseInfoAdapter.swift
//  QPay
//
//  Created by Mohammed Hamad on 10/06/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation

class DineDataBaseInfoAdapter : BaseInfoDataAdapter {
    
    private let array: [DineItmeDetails]
    
    init(array: [DineItmeDetails]) {
        self.array = array
    }
    
    func convert() -> [BaseInfoDataModel] {
        var tempArr = [BaseInfoDataModel]()
        for model in self.array {
            
            guard let imageURL    = model._dineUploadImagesList.first?._imageOffer,
                  let isFavorite  = model._dineWorkingSetUpList.first?._isItemAdded ,
                  let name        = model._dineAccountInfoList.first?._companyName,
                  let office      = model._dineWorkingSetUpList.first?._office,
                  let workingFrom = model._dineWorkingSetUpList.first?._workingFrom,
                  let workingTo   = model._dineWorkingSetUpList.first?._workingTo,
                  let web         = model._dineWorkingSetUpList.first?._web ,
                  let rate        = model._dineWorkingSetUpList.first?._rating,
                  let mobile      = model._dineAccountInfoList.first?._managerMobile,
                  let images      = model._dineServiceTypeList.first?._serviceTypeDetails,
                  let locationURL = model._dineWorkingSetUpList.first?._locationGPS
            else {
                continue
            }
            
            let baseImages = HotelImageBaseInfoAdapter(array: images).convert()
            tempArr.append(
                BaseInfoDataModel(id          : model._ID,
                                  imageURL    : imageURL ,
                                  isFavorite  : isFavorite ,
                                  name        : name ,
                                  office      : office ,
                                  workingFrom : workingFrom ,
                                  workingTo   : workingTo,
                                  email       : model._email,
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
