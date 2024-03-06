//
//  InvoiceEndPoints.swift
//  QPay
//
//  Created by Mohammed Hamad on 17/02/2022.
//  Copyright © 2022 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

enum InvoiceEndPoints {
    case login(username: String, password: String)
    case createInvoice(invoice: CreateInvoiceModel)
    case createInvoiceTemplate(invoice: CreateInvoiceModel)
    case invoiceList
    case invoiceDetails(id: Int)
    case contacts
    case createContact(contact: InvoiceContact)
}

extension InvoiceEndPoints: InvoiceURLRequestBuilder {
    
    var path: String {
        switch self {
        case .login: return "token"
        case .invoiceList: return "api/Members/GetInvoiceList"
        case .invoiceDetails(id: let id): return "api/Members/GetInvoiceDetails/\(id)"
        case .createInvoice: return "api/Members/CreateInvoice"
        case .createInvoiceTemplate: return "api/Members/CreateInvoiceTemplate"
        case .contacts: return "api/Members/GetContactList"
        case .createContact: return "api/Members/CreateInvoiceContact"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .login(let username, let password):
            return [
                "response_type": "token",
                "grant_type" : "password",
                "username" : username,
                "password" : password,
            ]
            
        case .invoiceList, .createInvoice, .createInvoiceTemplate, .contacts, .invoiceDetails, .createContact:
            return nil
        }
    }
    
    var bodyData: Data? {
        switch self {
        case .createInvoiceTemplate(invoice: let invoice), .createInvoice(invoice: let invoice):
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            guard let data = try? encoder.encode(invoice) else {
                print("Invalid Data for \(requestURL.absoluteString) Request")
                return nil
            }
            return data
            
        case .createContact(contact: let contact):
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            guard let data = try? encoder.encode(contact) else {
                print("Invalid Data for \(requestURL.absoluteString) Request")
                return nil
            }
            return data
            
        default: return nil
        }
    }
    
    var headers: HTTPHeaders {
        var headers = defaultHeaders
        
        switch self {
        case .login:
            return headers
        default:
            let token = UserProfile.shared.invoiceUser?._access_token ?? ""
            headers.add(.authorization(bearerToken: token))
            return headers
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .invoiceList, .contacts, .invoiceDetails: return .get
        case .createInvoice, .createInvoiceTemplate, .login, .createContact: return .post
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .login, .createInvoice, .createInvoiceTemplate, .createContact:
            return URLEncoding.httpBody
        case .invoiceList, .contacts, .invoiceDetails:
            return URLEncoding.queryString
        }
    }
}
