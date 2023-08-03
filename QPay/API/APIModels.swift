//
//  APIModels.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/27/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit

enum APIModels: String {
    
    case Transaction
    case PaymentRequest
    case NotificationModel
    case NotificationType
    case Bank
    case BankName
    case Country
    case Group
    case PhoneOperator
    case Parking
    case Order
    case MetroCard
    case MetroFareCard
    case Shop
    case Passport
    case Loyalty
    case Document
    case Topup
    case LoyaltyBrand
    case Beneficiary
    case GiftStore
    case GiftBrand
    case GiftDenomination
    case TopupCountry
    case KarwaBusCard
    case Address
    case Channel
    case Limousine
    case Coupon
    case CouponCategory
    case CouponDetails
    case CharityType
    case CharityDonation
    case InvoiceApp
    case InvoiceContact
    case StockGroup
    case UserStock
    case StockMarket
    case StockAdv
    
    case StocksNews
    case StockHistory
    
    case MyStocksGroupDetails
    
    case CV
    
    case JobHunterList
    case EmployerList
    
    case LimousineTab
    case OjraDetails
    
    case ChildCareTab
    case ChildCareItmeDetails
    
    case HotelTab
    case HotelItmeDetails
    
    case DineTab
    case DineItmeDetails
    
    case InsurancesTab
    case InsurancesItmeDetails
    
    case MedicalCenterTab
    case MedicalCenterItmeDetails
    
    case QaterSchoolTab
    case QaterSchoolItmeDetails
    
    case TokenizedCard
    case PaymentsHistory
    
}
