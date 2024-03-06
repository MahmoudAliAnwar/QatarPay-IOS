//
//  KarwaTaxiCar.swift
//  QPay
//
//  Created by Mohammed Hamad on 07/02/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit

struct KarwaTaxiCar {
    let image: UIImage?
    let name: String?
    let passengers: Int?
    let amount: Int?
    let time: Int?
    
    init(image: UIImage, name: String, passengers: Int, amount: Int, time: Int) {
        self.image = image
        self.name = name
        self.passengers = passengers
        self.amount = amount
        self.time = time
    }
    
    var _image: UIImage {
        get {
            return image ?? UIImage()
        }
    }
    
    var _name: String {
        get {
            return self.name ?? ""
        }
    }
    
    var _passengers: String {
        get {
            return "\(self.passengers ?? 0) Passengers"
        }
    }
    
    var _amount: String {
        get {
            return "QR \(self.amount ?? 0)"
        }
    }
    
    var _time: String {
        get {
            return "\(self.time ?? 0) min"
        }
    }
}
