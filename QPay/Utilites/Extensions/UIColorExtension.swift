//
//  UIImageViewExtension.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/30/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    static let appBackgroundColor = UIColor(red: 72/255, green: 2/255, blue: 38/255, alpha: 1)
    
    static let stockUpGreen       = UIColor(red: 66/255, green: 154/255, blue: 32/255, alpha: 1)
    static let stockDownRed       = UIColor(red: 221/255, green: 72/255, blue: 72/255, alpha: 1)
    static let stockUnchangedGray = UIColor(red: 120/255, green: 117/255, blue: 117/255, alpha: 1)
    
    static let mUnread_Notification = UIColor(named: "unread_notification")!
    
    static let mPhone_Bill_Red      = UIColor(named: "phone_bill_red")!
    
    static let mKahramaa_Dark_Blue  = UIColor(named: "kahramaa_dark_blue")!
    
    static let mLabel_Light_Gray = UIColor(named: "label_light_gray")!
    static let mLabel_Dark_Gray  = UIColor(named: "label_dark_gray")!

    static let mDark_Gray = UIColor(named: "dark_gray")!
    static let mDark_Red  = UIColor(named: "dark_red")!
    static let mDark_Blue = UIColor(named: "dark_blue")!
    
    static let mLight_Gray     = UIColor(named: "light_gray")!
    static let mLight_Red      = UIColor(named: "light_red")!
    static let mLight_Blue     = UIColor(named: "light_blue")!
    static let mVery_Dark_Blue = UIColor(named: "very_dark_blue")!
    
    static let mRed    = UIColor(named: "my_red")!
    static let mBrown  = UIColor(named: "brown")!
    static let mYellow = UIColor(named: "Yellow")!
    
    static let mChart_Shopping  = UIColor(named: "chart_shopping")!
    static let mChart_Charity   = UIColor(named: "chart_charity")!
    static let mChart_Bills     = UIColor(named: "chart_bills")!
    static let mChart_E_Shops   = UIColor(named: "chart_e_shops")!
    static let mChart_Transport = UIColor(named: "chart_transport")!
    static let mChart_Wallet    = UIColor(named: "chart_wallet")!
    
    static let mAmount_Awqaf       = UIColor(named: "amount_awqaf")!
    static let mAmount_Eid         = UIColor(named: "amount_eid")!
    static let mAmount_Qatar_Black = UIColor(named: "amount_qatar_black")!
    static let mAmount_Qatar       = UIColor(named: "amount_qatar")!
    
    static let mCart_Awqaf_Green        = UIColor(named: "cart_awqaf_green")!
    static let mCart_Eid_Red            = UIColor(named: "cart_eid_red")!
    static let mCart_Qatar_Crescent_Red = UIColor(named: "cart_qatar_crescent_red")!
    static let mCart_Qatar_Charity_Pink = UIColor(named: "cart_qatar_charity_pink")!
    
    static let mParkings_Dark_Red  = UIColor(named: "parkings_dark_red")!
    static let mParkings_Light_Red = UIColor(named: "parkings_light_red")!
    
    static let mStocks_light_Gray = UIColor(named: "stocks_light_green")!
    static let mStocks_Dark_Gray  = UIColor(named: "stocks_dark_green")!
    
    static let mStocks_Blue       = UIColor(named: "stocks_blue")!
    static let mKarwa_Dark_Red    = UIColor(named: "karwa_dark_red")!
    
    static let mOrange            = UIColor(named: "orange")!
    static let mStocks_Label_Blue = UIColor(named: "stocks_label_blue")!
    static let mChildCare         = UIColor(named: "child_care_color")!
    static let mHotel             = UIColor(named: "hotel_color")!
    static let mDine              = UIColor(named: "dine_color")!
    static let mMedicalCenter     = UIColor(named: "medical_center_color")!
    static let mSchool            = UIColor(named: "school_color")!
    static let mInsurance         = UIColor(named: "insurance_color")!
    static let mMarketWatch       = UIColor(named: "market_watch_color")!
    static let mStockHistory       = UIColor(named: "stock_history_color")!
    
    
    static let mBook_Selected_Tab = #colorLiteral(red: 0.6901960784, green: 0.06666666667, blue: 0.3294117647, alpha: 1)
    static let mBook_Blue = #colorLiteral(red: 0.1098039216, green: 0.5960784314, blue: 0.8470588235, alpha: 1)
    static let mBook_Green = #colorLiteral(red: 0.1882352941, green: 0.5294117647, blue: 0.01960784314, alpha: 1)
    static let mBook_Orange = #colorLiteral(red: 1, green: 0.5411764706, blue: 0, alpha: 1)
    static let mBook_Red = #colorLiteral(red: 0.8470588235, green: 0.1098039216, blue: 0.1098039216, alpha: 1)
    static let mBook_Teal = #colorLiteral(red: 0, green: 0.6352941176, blue: 0.537254902, alpha: 1)
    
    static let mInvoice_App_Light_Green = #colorLiteral(red: 0.2980392157, green: 0.8352941176, blue: 0.3333333333, alpha: 1)
    static let mInvoice_App_Dark_Green = #colorLiteral(red: 0, green: 0.7058823529, blue: 0.05098039216, alpha: 1)
    
    static let mInvoice_App_Light_Red = #colorLiteral(red: 0.8235294118, green: 0.2666666667, blue: 0.2666666667, alpha: 1)
    static let mInvoice_App_Dark_Red = #colorLiteral(red: 0.768627451, green: 0, blue: 0, alpha: 1)
    
    static let mInvoice_App_Light_Yellow = #colorLiteral(red: 0.9803921569, green: 0.7294117647, blue: 0.1568627451, alpha: 1)
    static let mInvoice_App_Dark_Yellow = #colorLiteral(red: 0.7960784314, green: 0.5529411765, blue: 0, alpha: 1)
    
    static let mInvoice_App_Light_Purple = #colorLiteral(red: 0.4352941176, green: 0.4470588235, blue: 0.7098039216, alpha: 1)
    static let mInvoice_App_Dark_Purple = #colorLiteral(red: 0.03137254902, green: 0.04705882353, blue: 0.5803921569, alpha: 1)
    
    static let mGift_Background_Gray = UIColor(named: "gift_background_gray")!
}
