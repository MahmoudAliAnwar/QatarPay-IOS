//
//  EndPointCases.swift
//  QPay
//
//  Created by Mohammed Hamad on 07/11/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

// MARK: - LoginRequest
class LoginRequest: PEndpoint {
    
    var method: HTTPMethod {
        get {
            return .post
        }
    }
    
    var path: String {
        get {
            return "token"
        }
    }
    
    var headers: HTTPHeaders?
    
    var params: Parameters?
    
    convenience init(email : String , password : String) {
        let params2 = [
            "username"    : email ,
            "password" : password,
            "grant_type" : "password",
            "response_type" : "token",
        ]
        self.init(params: params2)
        //        setup(header: header)
    }
    
    init(params: Parameters, header: HTTPHeaders? = nil) {
        self.params = params
        print(params)
        //        setup(header: .acceptJSON)
    }
    
    //    private func setup(header: HTTPHeader) {
    //        self.headers = .default
    //        self.headers?.add(.acceptJSON)
    //        self.headers?.add(header)
    //    }
}

enum EndPointCases {
    
    case signIn(email: String, password: String)
    case signUp(data: SignUpData, accountType: AccountType)
    case getUserProfile
    case getUserBalance
    case generatePhoneToken(phone: String)
    case confirmPhoneNumber(phone: String, code: String)
    case updatePhoneNumber(phone: String)
    case updateEmail(email: String)
    case getAddressList
    case validateAddress(address: Address)
    case saveAddress(address: Address)
    case removeAddress(id: Int)
    case setDefaultAddress(id: Int)
    case updateUserAddress(address: Address)
//    case checkEmailRegisterd
//    case checkPhoneRegisterd
//    case sendDeviceToken
//    case getQRCode
//    case sendVerificationEmail
//    case updatePhoneNumberFromRegister
//    case updatePhoneNumberAndQID
//    case setUserPin
//    case forgetPinCode
//    case changePIN
//    case verifyPin
//    case forgetPassword
//    case confirmForgetPassword
//    case dashboardChartData
    case transactionsList
//    case refillWallet
//    case getChannelList
//    case getRefillCharge
//    case paymentRequests
    case getNotificationList(page: Int)
//    case updateNotificationStatus
//    case validateTransfer
//    case getNotificationTypeList
//    case confirmPaymentRequests
//    case cancelPaymentRequests
//    case removeNotification
//    case countriesList
//    case requestMoneyByEmail
//    case externalPaymentEmail
//    case externalPaymentMobile
//    case requestMoneyByPhone
//    case requestMoneyByQPAN
//    case requestMoneyByQR
//    case payFromQRCode
//    case payToMerchant
//    case validateMerchantQRCodePayment
//    case validateMerchantQRCodeWithAmount
//    case validateMerchantQR
//    case noqsTransferQR
//    case transferQRCodePayment
//    case transferToPhone
//    case transferToEmail
//    case transferToQPAN
//    case transferToQR
//    case confirmTransfer
//    case getBeneficiaryList
//    case getBeneficiaryByQPAN
//    case getBeneficiaryByQRCode
//    case getBeneficiariesByPhone
//    case addBeneficiary
//    case removeBeneficiary
//
//    // MARK: - TOPUP
//    case getTopupCardList
//    case getTopupPaymentCardList
//    case getTopupSettings
//    case updateTopupSettings
//    case topupPaymentSetting
//
//    // MARK: - LIBRARY
//
//    case getLibraryPaymentCards
//    case addLibraryPaymentCard
//    case deleteLibraryPaymentCard
//    case updateLibraryPaymentCard
//
//    case addBankDetails
//    case updateBankDetails
//    case bankDetails
//    case getBankNameList
//    case deleteBank
//
//    case addDrivingLicense
//    case getDrivingLicenseList
//    case deleteDrivingLicense
//    case updateDrivingLicense
//
//    case getIDCardList
//    case addIDCard
//    case deleteIDCard
//    case updateIDCard
//
//    case getPassportList
//    case addPassport
//    case deletePassport
//    case updatePassport
//
//    case getLoyaltyList
//    case getLoyaltyBrandList
//    case deleteLoyalty
//    case addLoyalty
//    case updateLoyalty
//
//    case getDocumentList
//    case deleteDocument
//    case addDocument
//    case updateDocument
//
//    // MARK: - E-STORE
//
//    case dashboardData
//
//    case updateShopDetails
//    case updateShopStatus
//    case getShopList
//    case getProductListByShopID
//    case addProduct
//    case updateProduct
//    case removeProduct
//    case updateProductStatus
//    case getOrderList
//    case getArchiveOrderList
//    case deleteOrder
//    case archiveOrder
//    case markOrderAsRead
//    case resendOrder
//    case getOrderListByShopID
//    case getOrderDetails
//    case getOrderListByFilter
//    case createShopOrder
//
//    case getPhoneUserOperators
//    case addPhoneToGroup
//    case getPhoneUserGroups
//    case savePhoneUserGroups
//    case getGroupListWithPhoneNumbers
//
//    case addKahramaaToGroup
//    case getKahramaaUserGroups
//    case saveKahramaaUserGroups
//    case getGroupListWithKahramaaNumbers
//
//    case addQatarCoolToGroup
//    case getQatarCoolUserGroups
//    case saveQatarCoolUserGroups
//    case getGroupListWithQatarCoolNumbers
//
//    case addMetroCard
//    case getMetroCards
//    case removeMetroCard
//
//    case getParkingsList
//    case getParkingTicketDetails
//    case payParkingViaNoqs
//
//    case getGiftStoreList
//    case getGiftBrandList
//    case getGiftDenominationList
//    case initiateGiftTransaction
//    case buyGiftDenomination
//
//    case getQIDImage
//    case uploadQIDDetails
//    case getPassportImage
//    case updatePassportDetails
//
//    case estoreTopupCountryList
//    case msdnRequest
//    case reserveIDRequest
//    case confirmEstoreTopup
//
//    case getKarwaBusCardList
//    case addKarwaBusCard
//    case deleteKarwaBusCard
//    case getKarwaBusCardBalance
//    case initiateKarwaBus
//    case confirmKarwaBusTopup
//
//    case getLimousineContactList
//    case addMyLimousineContact
//    case removeMyLimousineContact
}

extension EndPointCases: PEndpoint {
    
    var method: HTTPMethod {
        switch self {
        case .signIn: return .post
        case .signUp: return .post
        case .getUserProfile: return .get
        case .getUserBalance: return .get
        case .generatePhoneToken: return .post
        case .confirmPhoneNumber: return .post
        case .updatePhoneNumber: return .post
        case .updateEmail: return .post
        case .getAddressList: return .get
        case .validateAddress: return .post
        case .saveAddress: return .post
        case .removeAddress: return .post
        case .setDefaultAddress: return .post
        case .updateUserAddress: return .post
        case .transactionsList: return .get
        case .getNotificationList: return .get
        }
    }
    
    var path: String {
        switch self {
        case .signIn: return "token"
        case .signUp: return "api/WalletUser/Register"
        case .getUserProfile: return "api/NoqoodyUser/GetProfile"
        case .getUserBalance: return "api/WalletUser/GetUserBalance"
        case .generatePhoneToken: return "api/NoqoodyUser/GeneratePhoneToken"
        case .confirmPhoneNumber: return "api/NoqoodyUser/ConfirmPhoneNumber"
        case .updatePhoneNumber(let phone): return "api/NoqoodyUser/UpdatePhoneNumber?Phonenumber\(phone)"            
        case .updateEmail(let email): return "api/NoqoodyUser/UpdateEmail?Emailadd=\(email)"
        case .getAddressList: return "api/Library/GetUserAddressList"
        case .validateAddress: return "api/Library/ValidateAddress"
        case .saveAddress: return "api/Library/SaveAddress"
        case .removeAddress: return "api/Library/RemoveUserAddress"
        case .setDefaultAddress: return "api/Library/SetDefaultAddress"
        case .updateUserAddress: return "api/Library/UpdateUserAddress"
        case .transactionsList: return "api/NoqoodyUser/GetTransactionList"
        case .getNotificationList: return "api/NoqoodyUser/GetNotificationList"
        }
    }
    
    var headers: HTTPHeaders? {
        var defaultHeaders: HTTPHeaders = [
            .acceptJSON,
        ]
        switch self {
        case .signIn, .signUp:
            return defaultHeaders
            
        case .getUserProfile, .getUserBalance, .generatePhoneToken, .confirmPhoneNumber, .updatePhoneNumber, .updateEmail, .getAddressList, .validateAddress, .saveAddress, .removeAddress, .setDefaultAddress, .updateUserAddress, .transactionsList, .getNotificationList:
            guard let user = UserProfile.shared.getUser() else { return nil }
            defaultHeaders.add(.authorization(appToken: user._access_token))
            return defaultHeaders
        }
    }
    
    var params: Parameters? {
        switch self {
        case .signIn(let email, let password):
            return [
                "username" : email,
                "password" : password,
                "grant_type" : "password",
                "response_type" : "token",
            ]
            
        case .signUp(let signUpData, let accountType):
            return [
                "Email" : signUpData.email,
                "Password" : signUpData.password,
                "ConfirmPassword" : signUpData.confirmPassword,
                "FirstName" : signUpData.firstName,
                "LastName" : signUpData.lastName,
                "IDCardNumber" : "Na",
                "UserType" : accountType.serverAccountNumber,
                "PhoneNumber" : "00",
            ]
            
        case .getUserProfile:
            return [:]
            
        case .getUserBalance:
            return [:]
            
        case .generatePhoneToken(let phone):
            return ["PhoneNumber" : phone]
            
        case .confirmPhoneNumber(let phone, let code):
            return [
                "PhoneNumber" : phone,
                "Code" : code,
            ]
            
        case .updatePhoneNumber:
            return [:]
            
        case .updateEmail:
            return [:]
            
        case .getAddressList:
            return [:]
            
        case .validateAddress(let address):
            return [
                "Zone" : address._zone,
                "BuildingNumber" : address._buildingNumber,
                "Street" : address._streetNumber,
            ]
            
        case .saveAddress(let address):
            return [
                "Zone" : address._zone,
                "BuildingNumber" : address._buildingNumber,
                "Street" : address._streetNumber,
                "Address" : address._streetName,
                "AddressName" : address._name,
                "CIty" : "NA",
                "Country" : "NA",
                "PoBox" : "NA",
            ]
            
        case .removeAddress(let id):
            return [
                "AddressID" : id,
            ]
            
        case .setDefaultAddress(let id):
            return [
                "AddressID" : id,
            ]
            
        case .updateUserAddress(let address):
            return [
                "AddressID" : address._id,
                "Zone" : address._zone,
                "BuildingNumber" : address._buildingNumber,
                "Street" : address._streetNumber,
                "Address" : address._streetName,
                "AddressName" : "NA",
                "CIty" : "NA",
                "Country" : "NA",
                "PoBox" : "NA",
            ]
            
        case .transactionsList:
            return [:]
        case .getNotificationList(let page):
            return ["PageNum": page]
        }
    }
}
