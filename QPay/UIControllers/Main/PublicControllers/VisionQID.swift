//
//  VisionQID.swift
//  QPay
//
//  Created by Mohammed Hamad on 09/09/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit

struct VisionQID {
    var image: UIImage?
    var number: String?
    var nationality: String?
    var expiryDate: DateComponents?
    var dobDate: DateComponents?
    
    var description: String {
        get {
            return "\(number ?? "Number") =>> \(nationality ?? "Nationality") =>> \(expiryDate?.year ?? -1) =>> \(dobDate?.year ?? -2)"
        }
    }
}
