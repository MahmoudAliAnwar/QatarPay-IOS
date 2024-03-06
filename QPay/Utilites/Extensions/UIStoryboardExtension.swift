//
//  UIStoryboard.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/3/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    
    private static var authStoryboard = UIStoryboard(name: "Auth", bundle: nil)
    
    private static var mainStoryboard = UIStoryboard(name: "Main", bundle: nil)

    private static var libraryStoryboard = UIStoryboard(name: "MyLibrary", bundle: nil)
    
    private static var storeStoryboard = UIStoryboard(name: "Store", bundle: nil)

    private static var othersStoryboard = UIStoryboard(name: "Others", bundle: nil)

    private static var transportsStoryboard = UIStoryboard(name: "Transports", bundle: nil)

    private static var eShopsStoryboard = UIStoryboard(name: "EShops", bundle: nil)

    private static var informationStoryboard = UIStoryboard(name: "Information", bundle: nil)

    private static var charityStoryboard = UIStoryboard(name: "Charity", bundle: nil)
    
    private static var invoiceStoryboard = UIStoryboard(name: "Invoice", bundle: nil)

    private static var cvStoryboard = UIStoryboard(name: "CV", bundle: nil)

    @available(iOS 13.0, *)
    static func view(view: Views) -> UIViewController {
        self.getViewFromStoryboard(with: view.rawValue)
    }
    
    static func getStoryboardFromController<T: UIViewController>(with controller: T.Type) -> T {
        return getViewFromStoryboard(with: T.reuseIdentifier) as! T
    }
    
    static func getViewFromStoryboard(with identifier: String) -> UIViewController {
        
        let dictionaryKey = "identifierToNibNameMap"
        
        if let availableIdentifiers = authStoryboard.value(forKey: dictionaryKey) as? [String: Any] {
            if availableIdentifiers[identifier] != nil {
                return authStoryboard.instantiateViewController(identifier: identifier)
            }
        }
        
        if let availableIdentifiers = mainStoryboard.value(forKey: dictionaryKey) as? [String: Any] {
            if availableIdentifiers[identifier] != nil {
                return mainStoryboard.instantiateViewController(identifier: identifier)
            }
        }
        if let availableIdentifiers = eShopsStoryboard.value(forKey: dictionaryKey) as? [String: Any] {
            if availableIdentifiers[identifier] != nil {
                return eShopsStoryboard.instantiateViewController(identifier: identifier)
            }
        }
        if let availableIdentifiers = storeStoryboard.value(forKey: dictionaryKey) as? [String: Any] {
            if availableIdentifiers[identifier] != nil {
                return storeStoryboard.instantiateViewController(identifier: identifier)
            }
        }
        if let availableIdentifiers = othersStoryboard.value(forKey: dictionaryKey) as? [String: Any] {
            if availableIdentifiers[identifier] != nil {
                return othersStoryboard.instantiateViewController(identifier: identifier)
            }
        }
        if let availableIdentifiers = charityStoryboard.value(forKey: dictionaryKey) as? [String: Any] {
            if availableIdentifiers[identifier] != nil {
                return charityStoryboard.instantiateViewController(identifier: identifier)
            }
        }
        if let availableIdentifiers = transportsStoryboard.value(forKey: dictionaryKey) as? [String: Any] {
            if availableIdentifiers[identifier] != nil {
                return transportsStoryboard.instantiateViewController(identifier: identifier)
            }
        }
        if let availableIdentifiers = informationStoryboard.value(forKey: dictionaryKey) as? [String: Any] {
            if availableIdentifiers[identifier] != nil {
                return informationStoryboard.instantiateViewController(identifier: identifier)
            }
        }
        if let availableIdentifiers = invoiceStoryboard.value(forKey: dictionaryKey) as? [String: Any] {
            if availableIdentifiers[identifier] != nil {
                return invoiceStoryboard.instantiateViewController(identifier: identifier)
            }
        }
        if let availableIdentifiers = cvStoryboard.value(forKey: dictionaryKey) as? [String: Any] {
            if availableIdentifiers[identifier] != nil {
                return cvStoryboard.instantiateViewController(identifier: identifier)
            }
        }
        return libraryStoryboard.instantiateViewController(identifier: identifier)
    }
}
