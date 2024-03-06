//
//  PaymentModel.swift
//  QPay
//
//  Created by Mahmoud on 02/02/2024.
//  Copyright © 2024 Dev. Mohmd. All rights reserved.
//

import Foundation

struct ProcessTokenizedModel: Codable{
    var Amount: Double?
    var ChannelID ,ServiceID: Int?
    var IsBillPayment,  IsTokenized: Bool?
    var BillPaymentData: PaymentRequestPhoneBillParams?
    var TokenizedData: TokenizedDataModel?
    var IsPlatformApplePay: Bool?
}


//struct BillPaymentDataModel:Codable{
//    var OperatorID, IsLanguageId: Int?
//    var GroupDetails: [GroupDetails]?
//    var PlatForm = "IOS"
//    var ScheduledDate: String? = ""
//    var IsFullAmount, IsRecurringPayment, IsPartialAmount: Bool?
//    var Amount: Double?
//    
//    
//    var json: [String: Any] {
//        return [
//               "OperatorID": OperatorID ?? 0,
//               "GroupDetails": GroupDetails?.map({$0.json}) ?? [] ,
//               "IsFullAmount": IsFullAmount ?? false,
//               "IsRecurringPayment": IsRecurringPayment ?? false,
//               "IsPartialAmount": IsPartialAmount ?? false,
//               "PlatForm": "IOS",
//               "ScheduledDate": ScheduledDate ?? "",
//               "IsLanguageId": IsLanguageId ?? 1,
//               "Amount": Amount ?? 0
//        ]
//    }
//}

//struct GroupDetailsModel: Codable{
//    var GroupID: Int?
//    var Number: [String]?
//    
//    var json : [String: Any] {
//        return [
//            "GroupID": GroupID ??  0,
//            "Number": Number ?? [],
//          
//        ]
//    }
//}

struct TokenizedDataModel: Codable{
    var Card_ID: Int?
    
    var json: [String: Any] {
        return [
            "Card_ID" : Card_ID ?? 0
        ]
    }
}

enum TypeOfWallet: String{
    case phoneBill
    case khrmaBill
    case qatarCoolBill
}
