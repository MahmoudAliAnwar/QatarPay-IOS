//
//  PCasher.swift
//  QPay
//
//  Created by Dev. Mohmd on 9/26/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit

protocol PCasher {
    func createOrder(_ cart: PCart, discount: Double, delivery: Double) -> Order
}
