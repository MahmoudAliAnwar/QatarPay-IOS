//
//  FilterOrdersDelegate.swift
//  QPay
//
//  Created by Mohammed Hamad on 12/27/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit

protocol FilterOrdersDelegate {
    func filterOrdersCallBack(with orders: [Order])
}
