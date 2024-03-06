//
//  GiftCard.swift
//  QPay
//
//  Created by Mohammed Hamad on 28/03/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

struct GiftCard: Mappable {
    
    var image: UIImage?
    
    var _image: UIImage {
        get {
            return self.image ?? UIImage()
        }
    }
    
    init(image: UIImage) {
        self.image = image
    }

    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        image <- map[""]
    }
}
