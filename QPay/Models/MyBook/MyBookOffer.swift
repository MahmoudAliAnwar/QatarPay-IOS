//
//  MyBookOfferCollectionViewCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 09/02/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit

struct MyBookOffer {
    let logo: UIImage?
    let title: String?
    let description: String?
    let expires: String?
    
    var _expires: String {
        get {
            return "Expires on \(self.expires ?? "")"
        }
    }
}
