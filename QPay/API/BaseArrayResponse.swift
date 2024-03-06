//
//  BaseArrayResponse.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/27/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import ObjectMapper

struct BaseArrayResponse<T: Mappable>: Mappable {
    
    var success : Bool?
    var code    : String?
    var message : String?
    var errors  : [String]?
    
    /// Phone, Kahramaa, Qatar cool response...
    var grandTotal: Double?
    var list : [T]?
    
    /// Notifiaction
    var TotalRecords: Int?
    
    var _success : Bool {
        get {
            return success ?? false
        }
    }
    
    var _code : String {
        get {
            return code ?? ""
        }
    }
    
    var _message : String {
        get {
            return message ?? ""
        }
    }
    
    var _errors : [String] {
        get {
            return errors ?? []
        }
    }
    
    var _grandTotal: Double {
        get {
            return self.grandTotal ?? 0.0
        }
    }
    
    var _list : [T] {
        get {
            return list ?? []
        }
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        self.success <- map["success"]
        self.code    <- map["code"]
        self.message <- map["message"]
        self.errors  <- map["errors"]
        
        self.grandTotal <- map["GrandTotal"]
        self.TotalRecords <- map["TotalRecords"]
        
        let key = self.getObjectKey()
        
        if map.JSON.keys.contains(key) {
            self.list <- map[key]
        }
    }
    
    func getObjectKey() -> String {
        
        var name = String(describing: T.self)
        
        let apiModel = APIModels(rawValue: name)
        
        if let model = apiModel {
            switch model {
            case .Transaction:
                name += "List"
                
            case .PaymentRequest:
                name = "TopupRequestList"
                
            case .NotificationModel:
                name = "NotificationList"
                
            case .NotificationType:
                name += "List"
                
            case .Bank:
                name = "BankDetailsLists"
                
            case .BankName:
                name = "BankList"
                
            case .Country:
                name += "CodeList"
                
            case .Group:
                name = "GroupList"
                
            case .PhoneOperator:
                name = "OperatorList"
                
            case .Parking:
                name = "ParkingsList"
                
            case .Order:
                name += "List"
                
            case .MetroCard:
                name = "CardsList"
                
            case .Shop:
                name += "List"
                
            case .Passport:
                name += "List"
                
            case .Loyalty:
                name = "LoyaltyCardList"
                
            case .Document:
                name += "List"
                
            case .Topup:
                name = "PaymentCardLists"
                
            case .LoyaltyBrand:
                name += "List"
                
            case .Beneficiary:
                name += "List"
                
            case .GiftStore:
                name = "Stores"
                
            case .GiftBrand:
                name = "Brandlists"
                
            case .GiftDenomination:
                name = "DenominationList"
                
            case .TopupCountry:
                name = "CountryCodeList"
                
            case .KarwaBusCard:
                name = "CardsList"
                
            case .Address:
                name += "List"
                
            case .Channel:
                name += "List"
                
            case .Limousine:
                name += "List"
                
            case .Coupon:
                name = "CouponList"
                
            case .CouponCategory:
                name = "CouponCategoryList"
                
            case .CouponDetails:
                name = "CouponDetailList"
                
            case .CharityType:
                name = "CharityTypes"
                
            case .CharityDonation:
                name = "CharityDonationTypes"
                
            case .MetroFareCard:
                name = "MetroCardFareDetails"
                
            case .InvoiceApp:
                name = "InvoiceList"
                
            case .InvoiceContact:
                name = "ContactList"
                
            case .StockGroup:
                name = "GroupList"
                
            case .UserStock:
                name = "StockList"
                
            case .StockMarket:
                name = "MarketList"
                
            case .StockAdv:
                name = "AdsList"
                
            case .StocksNews :
                name = "NewsList"
                
            case .StockHistory :
                name = "HistoryList"
                
            case .CV:
                name = "CVList"
                
            case .LimousineTab :
                name = "OjraBuisnessCategoryList"
                
            case .OjraDetails:
                name = "Ojra_Details"
                
            case .JobHunterList:
                name = "JobhunterList"
                
            case .EmployerList:
                name = "EmployerList"
                
            case .ChildCareTab:
                name = "NurseryBuisnessCategoryList"
                
            case .ChildCareItmeDetails:
                name = "Nursery_Details"
                
            case .HotelTab:
                name = "HotelBuisnessCategoryList"
                
            case .HotelItmeDetails:
                name = "Hotel_Details"
                
            case .DineTab:
                name = "DineBuisnessCategoryList"
                
            case .DineItmeDetails:
                name = "Dine_Details"
                
            case .InsurancesTab:
                name = "InsuranceBuisnessCategoryList"
                
            case .InsurancesItmeDetails:
                name = "Insurance_Details"
                
            case .MedicalCenterTab:
                name = "ClinicsBuisnessCategoryList"
                
            case .MedicalCenterItmeDetails:
                name = "Clinics_Details"
                
            case .QaterSchoolTab:
                name = "SchoolBuisnessCategoryList"
                
            case .QaterSchoolItmeDetails:
                name = "School_Details"
            
            case .MyStocksGroupDetails:
                name = "StockDetails"
                
            case .TokenizedCard:
                name = "TokenizedCardList"
                
            case .PaymentsHistory:
                name = "PaymentList"
                
            }
            
        }else {
            if T.self == GroupWithNumbers<PhoneNumber>.self {
                name = "GroupListWithPhoneNumbers"
                
            }else if T.self == GroupWithNumbers<KahramaaNumber>.self {
                name = "GroupListWithKaharmaNumbers"
                
            }else if T.self == GroupWithNumbers<QatarCoolNumber>.self {
                name = "GroupListWithQatarCoolNumbers"
            }
        }
        return name
    }
}
