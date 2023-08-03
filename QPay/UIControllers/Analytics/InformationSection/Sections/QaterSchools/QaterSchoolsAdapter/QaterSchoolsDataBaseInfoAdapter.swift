//
//  QaterSchoolsDataBaseInfoAdapter.swift
//  QPay
//
//  Created by Mohammed Hamad on 12/06/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation

class QaterSchoolsDataBaseInfoAdapter : BaseInfoDataAdapter {
    
    private let array: [QaterSchoolItmeDetails]
    
    init(array: [QaterSchoolItmeDetails]) {
        self.array = array
    }
    
    func convert() -> [BaseInfoDataModel] {
        var tempArr = [BaseInfoDataModel]()
        for model in self.array {
            
            guard let imageURL    = model._schoolUploadImagesList.first?._imageOffer,
                  let isFavorite  = model._schoolWorkingSetUpList.first?._isItemAdded ,
                  let name        = model._schoolAccountInfoList.first?._companyName,
                  let office      = model._schoolWorkingSetUpList.first?._office,
                  let workingFrom = model._schoolWorkingSetUpList.first?._workingFrom,
                  let workingTo   = model._schoolWorkingSetUpList.first?._workingTo,
                  let web         = model._schoolWorkingSetUpList.first?._web ,
                  let rate        = model._schoolWorkingSetUpList.first?._rating,
                  let mobile      = model._schoolAccountInfoList.first?._managerMobile,
                  let images      = model._schoolServiceTypeList.first?._serviceTypeDetails,
                  let locationURL = model._schoolWorkingSetUpList.first?._locationGPS
            else {
                continue
            }
            
            let baseImages = QaterSchoolsImagesBaseInfoAdapter(array: images).convert()
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
