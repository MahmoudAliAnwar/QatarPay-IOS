//
//  UserProfile.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/3/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit

class UserProfile {
    
    private static var object: UserProfile?
    
    private init() {
        
    }
    
    public static var shared: UserProfile {
        
        if let userProfile = object {
            return userProfile
        }else {
            object = UserProfile()
            return object!
        }
    }

    private let KEY_IMAGE_LOCATION = "imageLocation"

    private let KEY_USER = "user"
    private let KEY_PROFILE = "profile"
    private let KEY_CART_ITEMS = "cart_items"
    private let KEY_PRODUCTS = "products"
    private let KEY_PRODUCTS_DICTIONARY_ARRAY = "products_dictionary_array"
    
    private let KEY_USER_ACCOUNT_TYPE = "user_account_type"
    private let KEY_USER_FIRST_NAME = "user_first_name"
    private let KEY_USER_LAST_NAME = "user_last_name"
    private let KEY_USER_EMAIL = "user_email"
    private let KEY_USER_PASSWORD = "user_password"
    private let KEY_USER_CONFIRM_PASSWORD = "user_confirm_password"
    
    private let KEY_USE_FINGER_PRINT = "use_finger_print"
    private let KEY_EXTEND_LOGIN_SESSION = "extend_session"
    
    private let KEY_IS_LOGGED_IN = "is_logged_in"
    
    private let KEY_IS_FIRST_RUN = "is_first_run"
    
    private let KEY_REFRESH_TOKEN_TIME = "refresh_token_time"
    
    private let KEY_CV = "cv"
    
    private let KEY_INVOICE_USER = "invoice_user"
    
    private let KEY_KULUD_TOKEN = "kulud_token"
    
    private var userDefaults = UserDefaults.standard
    
    // MARK: - CV
    
    var cv: CV? {
        get {
            do {
                return try userDefaults.getObject(forKey: KEY_CV, castTo: CV.self)
            } catch {
                print(error.localizedDescription)
                return nil
            }
        }
        set {
            do {
                try userDefaults.setObject(newValue, forKey: KEY_CV)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - INVOICE USER
    
    var invoiceUser: InvoiceUser? {
        get {
            do {
                return try userDefaults.getObject(forKey: KEY_INVOICE_USER, castTo: InvoiceUser.self)
            } catch {
                print(error.localizedDescription)
                return nil
            }
        }
        set {
            do {
                try userDefaults.setObject(newValue, forKey: KEY_INVOICE_USER)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - KULUD TOKEN
    
    var kuludToken: String? {
        get {
            self.userDefaults.string(forKey: KEY_KULUD_TOKEN)
        }
        set {
            self.userDefaults.set(newValue, forKey: KEY_KULUD_TOKEN)
        }
    }
    
    // MARK: - REFRESH TOKEN TIME
    
    func saveRefreshTokenTime() {
        userDefaults.set(Date(), forKey: KEY_REFRESH_TOKEN_TIME)
    }
    
    func getRefreshTokenTime() -> Date? {
        return userDefaults.object(forKey: KEY_REFRESH_TOKEN_TIME) as? Date
    }
    
    func removeRefreshTokenTime() {
        userDefaults.removeObject(forKey: KEY_REFRESH_TOKEN_TIME)
    }
    
    // MARK: - PROFILE
    
    func saveProfile(profile: Profile) {
        do {
            try userDefaults.setObject(profile, forKey: KEY_PROFILE)
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getProfile() -> Profile? {
        do {
            let profile = try userDefaults.getObject(forKey: KEY_PROFILE, castTo: Profile.self)
            return profile
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    // MARK: - USER
    
    func saveUser(user: User) {
        do {
            try userDefaults.setObject(user, forKey: KEY_USER)
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getUser() -> User? {
        do {
            let user = try userDefaults.getObject(forKey: KEY_USER, castTo: User.self)
            return user
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    func removeUser() {
        userDefaults.removeObject(forKey: KEY_USER)
        self.cv = nil
    }
    
    // MARK: - CART ITEMS
    
    public func saveCartItems(_ items: [CartItem]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(items){
            self.userDefaults.set(encoded, forKey: KEY_CART_ITEMS)
        }
    }
    
    public func getCartItems() -> [CartItem] {
        if let objects = self.userDefaults.value(forKey: KEY_CART_ITEMS) as? Data {
            let decoder = JSONDecoder()
            if let objectsDecoded = try? decoder.decode(Array.self, from: objects) as [CartItem] {
                return objectsDecoded
            }
        }
        return []
    }
    
    public func removeCartItems() {
        userDefaults.removeObject(forKey: KEY_CART_ITEMS)
    }
    
    // MARK: - PRODUCRS
    
    func saveProducts(products: [Product]) {
        
        let data = products.map({ try? JSONEncoder().encode($0) })
        userDefaults.set(data, forKey: KEY_PRODUCTS)
    }
    
    func getProducts() -> [Product] {
        guard let encodedData = userDefaults.array(forKey: KEY_PRODUCTS) as? [Data] else {
            return []
        }

        return encodedData.map { try! JSONDecoder().decode(Product.self, from: $0) }
    }
    
    func removeProducts() {
        userDefaults.removeObject(forKey: KEY_PRODUCTS)
    }
    
    // MARK: - PRODUCRS DICTIONARY ARRAY
    
    func saveDictionaryArray(_ arrayOfDictionary: [[String : Any]]) {
        
        userDefaults.set(arrayOfDictionary, forKey: KEY_PRODUCTS_DICTIONARY_ARRAY)
    }
    
    func getDictionaryArray() -> [[String : Any]]? {
        
        return userDefaults.array(forKey: KEY_PRODUCTS_DICTIONARY_ARRAY) as? [[String : Any]]
    }
    
    func removeDictionaryArray() {
        userDefaults.removeObject(forKey: KEY_PRODUCTS_DICTIONARY_ARRAY)
    }

    func logout() {
        removeUser()
    }
    
    func isLoggedIn() -> Bool {
        
        if let user = self.getUser() {
            let token = user.access_token ?? ""
            return token.isNotEmpty
        }
        return false
    }
    
    func updateImageLocation(location: String) {
        userDefaults.set(location, forKey: KEY_IMAGE_LOCATION)
    }
    
    // MARK: - FINGER PRINT
    
    func saveUseFingerPrint(status: Bool) {
        userDefaults.set(status, forKey: KEY_USE_FINGER_PRINT)
    }
    
    func getUseFingerPrint() -> Bool {
        return userDefaults.bool(forKey: KEY_USE_FINGER_PRINT)
    }
    
    // MARK: - EXTEND LOGIN SESSION
    
    func saveExtendLoginSession(status: Bool) {
        userDefaults.set(status, forKey: KEY_EXTEND_LOGIN_SESSION)
    }
    
    func getExtendLoginSession() -> Bool {
        return userDefaults.bool(forKey: KEY_EXTEND_LOGIN_SESSION)
    }
    
    // MARK: - ACCOUNT TYPE
    
    func saveAccountType(type: AccountType) {
        userDefaults.set(type.rawValue, forKey: KEY_USER_ACCOUNT_TYPE)
    }
    
    func getAccountType() -> AccountType? {
        
        let accountType = userDefaults.string(forKey: KEY_USER_ACCOUNT_TYPE)
        if let type = accountType {
            let myType = AccountType.init(rawValue: type)
            return myType
        }
        return nil
    }
    
    func removeAccountType() {
        userDefaults.removeObject(forKey: KEY_USER_ACCOUNT_TYPE)
    }
    
    // MARK: - SIGN UP DATA
    
    func saveSignUpData(data: SignUpData) {
        
        userDefaults.set(data.firstName, forKey: KEY_USER_FIRST_NAME)
        userDefaults.set(data.lastName, forKey: KEY_USER_LAST_NAME)
        userDefaults.set(data.email, forKey: KEY_USER_EMAIL)
        userDefaults.set(data.password, forKey: KEY_USER_PASSWORD)
        userDefaults.set(data.confirmPassword, forKey: KEY_USER_CONFIRM_PASSWORD)
    }
    
    func getSignUpData() -> SignUpData {
        
        let firstName = userDefaults.string(forKey: KEY_USER_FIRST_NAME) ?? ""
        let lastName = userDefaults.string(forKey: KEY_USER_LAST_NAME) ?? ""
        let email = userDefaults.string(forKey: KEY_USER_EMAIL) ?? ""
        let password = userDefaults.string(forKey: KEY_USER_PASSWORD) ?? ""
        let confirm = userDefaults.string(forKey: KEY_USER_CONFIRM_PASSWORD) ?? ""
        
        let signupData: SignUpData = (firstName: firstName, lastName: lastName, email: email, password: password, confirmPassword: confirm)

        return signupData
    }
    
    func removeSignUpData() {
        userDefaults.removeObject(forKey: KEY_USER_FIRST_NAME)
        userDefaults.removeObject(forKey: KEY_USER_LAST_NAME)
        userDefaults.removeObject(forKey: KEY_USER_EMAIL)
        userDefaults.removeObject(forKey: KEY_USER_PASSWORD)
        userDefaults.removeObject(forKey: KEY_USER_CONFIRM_PASSWORD)
    }
    
    
    // MARK: - IS FIRST RUN
    
    func isFirstRun() -> Bool {
        let firstRunVar = userDefaults.string(forKey: KEY_IS_FIRST_RUN) ?? ""
        
        if firstRunVar.isEmpty {
            return true
        }
        return false
    }
    
    func changeFirstRunStatus() {
        userDefaults.set("exists", forKey: KEY_IS_FIRST_RUN)
    }
    
//    func saveUserData(username: String, password: String) {
//
//        userDefaults.set(username, forKey: KEY_USERNAME)
//        userDefaults.set(password, forKey: KEY_PASSWORD)
//    }
//
//    func getUserData() -> (username: String?, password: String?) {
//
//        let username = userDefaults.string(forKey: KEY_USERNAME)
//        let password = userDefaults.string(forKey: KEY_PASSWORD)
//
//        return (username, password)
//    }
//
//    func removeUserData() {
//
//        userDefaults.removeObject(forKey: KEY_USERNAME)
//        userDefaults.removeObject(forKey: KEY_PASSWORD)
//    }
    
}
