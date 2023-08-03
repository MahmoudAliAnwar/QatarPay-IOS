//
//  Product.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/8/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

struct GroupWithNumbers<T: SectionModelProtocol & Mappable> : Mappable, Equatable {
    
    var name : String?
    var id : Int?
    var isActive : Bool?
    var code : String?
    var description : String?
    var numbers : [T]?
    var total : Double?
    
    /// Special variable (Not from API)
    var isOpened: Bool = false
    var isSelected: Bool = false {
        willSet {
            for i in 0..<self._numbers.count {
                self._numbers[i].isSelected = newValue
            }
        }
    }
    
    var _name: String {
        get {
            return self.name ?? ""
        }
    }
    
    var _total: Double {
        get {
            return self.total ?? 0.0
        }
    }
    
    var _numbers: [T] {
        get {
            return self.numbers ?? []
        }
        set {
            self.numbers = newValue
        }
    }
    
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        self.name <- map["GroupName"]
        self.id <- map["GroupID"]
        self.isActive <- map["IsActive"]
        self.code <- map["GroupCode"]
        self.description <- map["GroupDescription"]
        self.total <- map["GroupTotal"]
        
        let key = self.getObjectKey()
        if map.JSON.keys.contains(key) {
            numbers <- map[key]
        }
    }
    
    private func getObjectKey() -> String {
        var name = String(describing: T.self)
        
        if name.contains("Phone") {
            name = "PhoneNumberList"
            
        }else if name.contains("Kahramaa") {
            name = "KaharmaNumberList"
            
        }else if name.contains("QatarCool") {
            name = "QatarCoolNumberList"
        }
        return name
    }
    
    static func == (lhs: GroupWithNumbers<T>, rhs: GroupWithNumbers<T>) -> Bool {
        return lhs.name == rhs.name &&
        lhs.id == rhs.id &&
        lhs.isActive == rhs.isActive &&
        lhs.code == rhs.code &&
        lhs.description == rhs.description &&
        lhs.numbers?.count == rhs.numbers?.count &&
        lhs.total == rhs.total
    }
}
