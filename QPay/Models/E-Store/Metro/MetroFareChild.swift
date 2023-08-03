//
//  
//  MetroFareChild.swift
//  QPay
//
//  Created by Mohammed Hamad on 19/02/2022.
//  Copyright © 2022 Dev. Mohmd. All rights reserved.
//
//
import Foundation
import UIKit
import ObjectMapper

struct MetroFareChild : Mappable {
    
    var fareType : String?
    var currency : String?
    var amount : Double?
    var additionalNotes : String?
    
    var _fareType : String {
        get {
            return fareType ?? ""
        }
    }
    
    var _currency : String {
        get {
            return currency ?? ""
        }
    }
    
    var _amount : Double {
        get {
            return amount ?? 0.0
        }
    }
    
    /// return Amount with Currency (QAR 0.0)
    var _amountWithCurrency: String {
        get {
            guard self._amount != 0 else { return "" }
            return "\(self._currency) \(self._amount)"
        }
    }
    
    var _additionalNotes : String {
        get {
            return additionalNotes ?? ""
        }
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        self.fareType <- map["FareType"]
        self.currency <- map["Curreny"]
        self.amount <- map["Amount"]
        self.additionalNotes <- map["AdditionalNotes"]
    }
}
