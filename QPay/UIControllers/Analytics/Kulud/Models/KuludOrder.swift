//
//  
//  KuludOrder.swift
//  QPay
//
//  Created by Mohammed Hamad on 17/01/2022.
//  Copyright © 2022 Dev. Mohmd. All rights reserved.
//
//
import Foundation
import UIKit

struct KuludOrder : Codable {
    
    var id: String?
    var status: Int?
    var count: Int?
    var created: String?
    
    enum OrderStatus: Int, CaseIterable {
        case GettingPrepared = 0
        case PendingOnDeleviry
        case OutForDeleviry
        case Completed
        
        var title: String {
            get {
                switch self {
                case .GettingPrepared: return "Getting Prepared"
                case .PendingOnDeleviry: return "Pending On Deleviry"
                case .OutForDeleviry: return "Out For Deleviry"
                case .Completed: return "Completed"
                }
            }
        }
    }
    
    var _id: String {
        get {
            return self.id ?? ""
        }
    }
    
    var _status: Int {
        get {
            return self.status ?? -1
        }
    }
    
    var statusObject: OrderStatus? {
        get {
            return OrderStatus(rawValue: self._status)
        }
    }
    
    var _count: Int {
        get {
            return self.count ?? -1
        }
    }
    
    var _created: String {
        get {
            return self.created ?? ""
        }
    }
}
