//
//  
//  InvoiceStatistics.swift
//  QPay
//
//  Created by Mohammed Hamad on 08/02/2022.
//  Copyright © 2022 Dev. Mohmd. All rights reserved.
//
//
import Foundation
import UIKit
import ObjectMapper

struct InvoiceStatistics : Codable, Mappable {
    
    var name: String?
    var value: Int? = 10
    
    var _name: String {
        get {
            return self.name ?? ""
        }
    }
    
    var _value: Int {
        get {
            return self.value ?? 0
        }
    }
    
    var _type: Types? {
        get {
            return Types(rawValue: self._name)
        }
    }
    
    enum Types: String, CaseIterable {
        case active_account
        case new_account
        case expired_account
        case profile_opens
        
        var gradientView: GradientView {
            get {
                let gradient = GradientView()
                gradient.startColor = self.startColor
                gradient.endColor = self.endColor
                return gradient
            }
        }
        
        private var startColor: UIColor {
            get {
                switch self {
                case .active_account: return .mInvoice_App_Light_Green
                case .expired_account: return .mInvoice_App_Light_Red
                case .new_account: return .mInvoice_App_Light_Yellow
                case .profile_opens: return .mInvoice_App_Light_Purple
                }
            }
        }
        
        private var endColor: UIColor {
            get {
                switch self {
                case .active_account: return .mInvoice_App_Dark_Green
                case .expired_account: return .mInvoice_App_Dark_Red
                case .new_account: return .mInvoice_App_Dark_Yellow
                case .profile_opens: return .mInvoice_App_Dark_Purple
                }
            }
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try values.decodeIfPresent(String.self, forKey: .name)
    }
    
    init(type: Types) {
        self.name = type.rawValue
    }
    
    init(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        self.name <- map["name"]
    }
}

extension InvoiceStatistics {
    
    static func demoData() -> [InvoiceStatistics] {
        return Types.allCases.compactMap({ return InvoiceStatistics(type: $0) })
    }
}
