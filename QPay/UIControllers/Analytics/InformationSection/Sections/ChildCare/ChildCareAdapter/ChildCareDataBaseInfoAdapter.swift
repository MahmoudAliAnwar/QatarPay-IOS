//
//  ChildCareDataBaseInfoAdapter.swift
//  QPay
//
//  Created by Mohammed Hamad on 08/06/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation

class ChildCareDataBaseInfoAdapter : BaseInfoDataAdapter {
    
    private let array: [ChildCareItmeDetails]
    
    init(array: [ChildCareItmeDetails]) {
        self.array = array
    }
    
    func convert() -> [BaseInfoDataModel] {
        var tempArr = [BaseInfoDataModel]()
        for model in self.array {
            
            guard let imageURL    = model._uploadImagesList.first?._imageOffer,
                  let isFavorite  = model._workingSetUpList.first?._isItemAdded ,
                  let name        = model._accountInfoList.first?._companyName,
                  let office      = model._workingSetUpList.first?._office,
                  let workingFrom = model._workingSetUpList.first?._workingFrom,
                  let workingTo   = model._workingSetUpList.first?._workingTo,
                  let web         = model._workingSetUpList.first?._web ,
                  let rate        = model._workingSetUpList.first?._rating,
                  let mobile      = model._accountInfoList.first?._managerMobile,
                  let images      = model._serviceTypeList.first?._serviceTypeDetails,
                  let locationURL = model._workingSetUpList.first?._locationGPS
            else {
                continue
            }
            
            let baseImages = ChildCareImageBaseInfoAdapter(array: images).convert()
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
