//
//  ServerDateFormat.swift
//  QPay
//
//  Created by Dev. Mohmd on 10/19/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit

public enum ServerDateFormat: String {
    ///"yyyy-MM-dd'T'HH:mm:ss.SSS"
    case Server1 = "yyyy-MM-dd'T'HH:mm:ss.SSS"
    /// "yyyy-MM-dd'T'HH:mm:ss"
    case Server2 = "yyyy-MM-dd'T'HH:mm:ss"
    /// "yyyy-MM-dd'T'"
    case DateWithoutTime = "yyyy-MM-dd'T'"
    /// "yyyy-MM-d'T'H:mm:ss.SSSSSSS+HH:mm"
    case Server3 = "yyyy-MM-d'T'H:mm:ss.SSSSSSS+HH:mm"
    
    case Server4 = "yyyy-MM-dd"
}
