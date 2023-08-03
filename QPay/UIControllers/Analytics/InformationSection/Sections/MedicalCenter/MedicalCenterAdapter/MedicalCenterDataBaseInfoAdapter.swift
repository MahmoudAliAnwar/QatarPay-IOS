//
//  MedicalCenterDataBaseInfoAdapter.swift
//  QPay
//
//  Created by Mohammed Hamad on 10/06/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation

class MedicalCenterDataBaseInfoAdapter : BaseInfoDataAdapter {
    
    private let array: [MedicalCenterItmeDetails]
    
    init(array: [MedicalCenterItmeDetails]) {
        self.array = array
    }
    
    func convert() -> [BaseInfoDataModel] {
        var tempArr = [BaseInfoDataModel]()
        for model in self.array {
            
            guard let imageURL    = model._clinicsUploadImagesList.first?._imageOffer,
                  let isFavorite  = model._clinicsWorkingSetUpList.first?._isItemAdded ,
                  let name        = model._clinicsAccountInfoList.first?._companyName,
                  let office      = model._clinicsWorkingSetUpList.first?._office,
                  let workingFrom = model._clinicsWorkingSetUpList.first?._workingFrom,
                  let workingTo   = model._clinicsWorkingSetUpList.first?._workingTo,
                  let web         = model._clinicsWorkingSetUpList.first?._web ,
                  let rate        = model._clinicsWorkingSetUpList.first?._rating,
                  let mobile      = model._clinicsAccountInfoList.first?._managerMobile,
                  let images      = model._clinicsServiceTypeList.first?._serviceTypeDetails,
                  let locationURL = model._clinicsWorkingSetUpList.first?._locationGPS
            else {
                continue
            }
            
            let baseImages = MedicalCenterImagesBaseInfoAdapter(array: images).convert()
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
