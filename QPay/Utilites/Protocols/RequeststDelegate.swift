//
//  ViewsDelegate.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/3/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit

protocol RequestsDelegate: AnyObject {
    
    /// Called When API Request Started ...
    func requestStarted(request: RequestType)
    
    /// Called When API Request Finished ...
    /// - Parameter result: Response Result
    func requestFinished(request: RequestType, result: ResponseResult)
}
