//
//  ErrorType.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/20/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

enum ErrorType: Error {
    
    case Exception(_ error: String)
    case AlamofireError(_ error: AFError)
    case Runtime(_ error: String)
}
