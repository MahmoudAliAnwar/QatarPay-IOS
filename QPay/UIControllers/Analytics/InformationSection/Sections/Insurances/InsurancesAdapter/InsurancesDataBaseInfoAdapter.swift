//
//  InsurancesDataBaseInfoAdapter.swift
//  QPay
//
//  Created by Mohammed Hamad on 10/06/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation

class InsurancesDataBaseInfoAdapter : BaseInfoDataAdapter {
    
    private let array: [InsurancesItmeDetails]
    
    init(array: [InsurancesItmeDetails]) {
        self.array = array
    }
    
    func convert() -> [BaseInfoDataModel] {
        var tempArr = [BaseInfoDataModel]()
        for model in self.array {
            
            guard let imageURL    = model._insuranceUploadImagesList.first?._imageOffer,
                  let isFavorite  = model._insuranceWorkingSetUpList.first?._isItemAdded ,
                  let name        = model._insuranceAccountInfoList.first?._companyName,
                  let office      = model._insuranceWorkingSetUpList.first?._office,
                  let workingFrom = model._insuranceWorkingSetUpList.first?._workingFrom,
                  let workingTo   = model._insuranceWorkingSetUpList.first?._workingTo,
                  let web         = model._insuranceWorkingSetUpList.first?._web ,
                  let rate        = model._insuranceWorkingSetUpList.first?._rating,
                  let mobile      = model._insuranceAccountInfoList.first?._managerMobile,
                  let images      = model._insuranceServiceTypeList.first?._serviceTypeDetails,
                  let locationURL = model._insuranceWorkingSetUpList.first?._locationGPS
            else {
                continue
            }
            
            let baseImages = InsurancesImagesBaseInfoAdapter(array: images).convert()
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
