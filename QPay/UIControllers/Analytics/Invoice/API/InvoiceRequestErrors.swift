//
//  RequestError.swift
//  ScanQR
//
//  Created by Mohammed Hamad on 18/07/2021.
//

import Foundation
import UIKit

// MARK: - Custom Error

public struct InvoiceCustomError: LocalizedError, Error {
    
    public var errorDescription: String? { return self.description }
    
    private var description: String
    
    init(description: String) {
        self.description = description
    }
}

// MARK: - Request Error

public enum InvoiceRequestErrors: LocalizedError, Error, Equatable {
    case noIntenetConnection
    case invalidURL
    case invalidData
    case decodingIssue
    case timedOut
    case unknownError
    case statusCode(RequestStatusCodes)
    case unknownStatusCode(Int)
    case encodingParameters(Error)
    case customError(InvoiceCustomError)
    case alamofire(Error)
    
    public enum RequestStatusCodes: Int, CaseIterable {
        case BadRequest = 400
        case Unauthorized = 401
        case ServerError = 500
    }
    
    /// Text Translation...
    public var errorDescription: String? {
        get {
            switch self {
            case .noIntenetConnection: return "Check your internet connection"
            case .invalidURL: return "URL is not valid"
            case .invalidData: return "invalid data"
            case .decodingIssue: return "Error when decoding object"
            case .timedOut: return "Something went wrong, request timed out"
            case .statusCode(let code): return "unexpected status code" + " \(code.rawValue)"
            case .unknownStatusCode(let code): return "unknown status code error" + " \(code)"
            case .unknownError: return "Unkown Error"
            case .encodingParameters(let err): return err.localizedDescription
            case .customError(let err): return err.localizedDescription
            case .alamofire(let err): return err.localizedDescription
            }
        }
    }
    
    public static func == (lhs: InvoiceRequestErrors, rhs: InvoiceRequestErrors) -> Bool {
        switch (lhs, rhs) {
        case (let left, let right):
            return left.localizedDescription == right.localizedDescription
        }
    }
}
