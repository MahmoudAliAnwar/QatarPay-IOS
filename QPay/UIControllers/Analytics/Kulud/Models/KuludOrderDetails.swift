//
//  
//  KuludOrderDetails.swift
//  QPay
//
//  Created by Mohammed Hamad on 18/01/2022.
//  Copyright © 2022 Dev. Mohmd. All rights reserved.
//
//
import Foundation
import UIKit

struct KuludOrderDetails : Codable {
    
    var quantity: Int?
    var status: Int?
    var orderId: String?
    var product: ProductModel?
    
    var _quantity: Int {
        get {
            return self.quantity ?? 0
        }
    }
    
    var _status: Int {
        get {
            return self.status ?? 0
        }
    }
    
    var _orderId: String {
        get {
            return self.orderId ?? ""
        }
    }
}
