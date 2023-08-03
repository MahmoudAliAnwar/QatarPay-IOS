//
//  HotelDataBaseInfoAdapter.swift
//  QPay
//
//  Created by Mohammed Hamad on 10/06/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation

class HotelDataBaseInfoAdapter : BaseInfoDataAdapter {
    
    private let array: [HotelItmeDetails]
    
    init(array: [HotelItmeDetails]) {
        self.array = array
    }
    
    func convert() -> [BaseInfoDataModel] {
        var tempArr = [BaseInfoDataModel]()
        for model in self.array {
            
            guard let imageURL    = model._hotelUploadImagesList.first?._imageOffer,
                  let isFavorite  = model._hotelWorkingSetUpList.first?._isItemAdded ,
                  let name        = model._hotelAccountInfoList.first?._companyName,
                  let office      = model._hotelWorkingSetUpList.first?._office,
                  let workingFrom = model._hotelWorkingSetUpList.first?._workingFrom,
                  let workingTo   = model._hotelWorkingSetUpList.first?._workingTo,
                  let web         = model._hotelWorkingSetUpList.first?._web ,
                  let rate        = model._hotelWorkingSetUpList.first?._rating,
                  let mobile      = model._hotelAccountInfoList.first?._managerMobile,
                  let images      = model._hotelServiceTypeList.first?._serviceTypeDetails,
                  let locationURL = model._hotelWorkingSetUpList.first?._locationGPS
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
