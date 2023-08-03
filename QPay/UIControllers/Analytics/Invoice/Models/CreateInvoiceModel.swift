//
//  
//  CreateInvoiceModel.swift
//  QPay
//
//  Created by Mohammed Hamad on 28/03/2022.
//  Copyright © 2022 Dev. Mohmd. All rights reserved.
//
//
import Foundation
import UIKit

struct CreateInvoiceModel: Codable {
    
    var date: String = ""
    var dueDate: String = ""
    var number: String = ""
    var description: String = "Qatar Pay Payment"
    var discount: Double = 0.0
    var amount: Double = 0.0
    var note: String = ""
    var recipitantName: String = ""
    var recipitantCompany: String = ""
    var recipitantAddress: String = ""
    var recipitantEmail: String = ""
    var recipitantMobile: String = ""
    var isScheduled: Bool = false
    var endTime: String = ""
    /// value=1: Monthly, value=2: Yearly, value=3: Weekly, value=4: Quarterly, value=5: BiWeekly, value=6: Daily
    var scheduleType: Int = 0
    var deliveryCharges: Double = 0.0
    var taxCharges: Double = 0.0
    var onlineFee: Double = 0.0
    var schduledTime: String = ""
    var scheduleEndTime: String = ""
    var detail = [Item]()
    var sendMeCopy: Bool = false
    var subject: String = ""
    var emailText: String = ""
    
    enum CodingKeys: String, CodingKey {
        case date = "InvoiceDate"
        case dueDate = "InvoiceDueDate"
        case number = "InvoiceNo"
        case description = "InvoiceDescription"
        case discount = "Discount"
        case amount = "InvoiceAmount"
        case note = "InvoiceNote"
        case recipitantName = "RecipitantName"
        case recipitantCompany = "RecipitantCompany"
        case recipitantAddress = "RecipitantAddress"
        case recipitantEmail = "RecipitantEmail"
        case recipitantMobile = "RecipitantMobile"
        case isScheduled = "IsScheduled"
        case scheduleType = "ScheduleType"
        case deliveryCharges = "DeliveryCharges"
        case taxCharges = "TaxCharges"
        case onlineFee = "OnlineFee"
        case schduledTime = "SchduledTime"
        case scheduleEndTime = "ScheduleEndTime"
        case endTime = "EndTime"
        case sendMeCopy = "SendMeCopy"
        case subject = "Subject"
        case emailText = "EmailText"
        case detail = "InvoiceDetail"
    }
    
    struct Item: Codable {
        var description: String = ""
        var quantity: Double = 0.0
        var rate: Double = 0.0
        var amount: Double = 0.0
        
        enum CodingKeys: String, CodingKey {
            case description = "ItemDescription"
            case rate = "Rate"
            case quantity = "Quantity"
            case amount = "Amount"
        }
    }
}
