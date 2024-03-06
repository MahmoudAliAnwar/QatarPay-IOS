//
//  UploadCVProfileImage.swift
//  QPay
//
//  Created by Mohammed Hamad on 30/05/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation
import ObjectMapper

struct UploadCVProfileImage : Mappable , Codable {
    
    var imageID       : Int?
    var imageLocation : String?
    var fileName      : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        imageID       <- map["ImageID"]
        imageLocation <- map["ImageLocation"]
        fileName      <- map["FileName"]
    }
}
