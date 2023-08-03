//
//  ResponseResult.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/20/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit

enum ResponseResult {
    
    case Success(_ data: Any?)
    case Failure(_ error: ErrorType)
}
