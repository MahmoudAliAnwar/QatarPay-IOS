//
//  RequestType.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/14/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation

enum RequestType: Int, CaseIterable {
    
    case signIn
    case signUp
    case getUserProfile
    case generatePhoneToken
    case checkEmailRegisterd
    case checkPhoneRegisterd
    case confirmPhoneNumber
    case updatePhoneNumber
    case updateEmail
    case updateGender
    case getAddressList
    case validateAddress
    case saveAddress
    case removeAddress
    case setDefaultAddress
    case updateUserAddress
    case sendDeviceToken
    case getQRCode
    case sendVerificationEmail
    case updatePhoneNumberFromRegister
    case updatePhoneNumberAndQID
    case setUserPin
    case forgetPinCode
    case changePIN
    case verifyPin
    case forgetPassword
    case confirmForgetPassword
    case dashboardChartData
    case transactionsList
    case refillWallet
    case getChannelList
    case getRefillCharge
    case paymentRequests
    case getNotificationList
    case updateNotificationStatus
    case validateTransfer
    case getNotificationTypeList
    case confirmPaymentRequests
    case cancelPaymentRequests
    case removeNotification
    case countriesList
    case requestMoneyByEmail
    case externalPaymentEmail
    case externalPaymentMobile
    case requestMoneyByPhone
    case requestMoneyByQPAN
    case requestMoneyByQR
    case payFromQRCode
    case payToMerchant
    case validateMerchantQRCodePayment
    case validateMerchantQRCodeWithAmount
    case validateMerchantQR
    case noqsTransferQR
    case transferQRCodePayment
    case transferQRCodeWithAmount
    case transferToPhone
    case transferToEmail
    case transferToQPAN
    case transferToQR
    case confirmTransfer
    case getBeneficiaryList
    case getBeneficiaryByQPAN
    case getBeneficiaryByQRCode
    case getBeneficiariesByPhone
    case addBeneficiary
    case removeBeneficiary
    
    // MARK: - TOPUP
    case getTopupCardList
    case getTopupPaymentCardList
    case getTopupSettings
    case updateTopupSettings
    case topupPaymentSetting
    
    // MARK: - LIBRARY
    
    case getLibraryPaymentCards
    case addLibraryPaymentCard
    case deleteLibraryPaymentCard
    case updateLibraryPaymentCard
    
    case addBankDetails
    case updateBankDetails
    case bankDetails
    case getBankNameList
    case deleteBank
    
    case addDrivingLicense
    case getDrivingLicenseList
    case deleteDrivingLicense
    case updateDrivingLicense
    
    case getIDCardList
    case addIDCard
    case deleteIDCard
    case updateIDCard
    
    case getPassportList
    case addPassport
    case deletePassport
    case updatePassport
    
    case getLoyaltyList
    case getLoyaltyBrandList
    case deleteLoyalty
    case addLoyalty
    case updateLoyalty
    
    case getDocumentList
    case deleteDocument
    case addDocument
    case updateDocument
    
    // MARK: - E-STORE
    
    case dashboardData
    
    case updateShopDetails
    case updateShopStatus
    case getShopList
    case getProductListByShopID
    case addProduct
    case updateProduct
    case removeProduct
    case updateProductStatus
    case getOrderList
    case getArchiveOrderList
    case deleteOrder
    case archiveOrder
    case markOrderAsRead
    case resendOrder
    case getOrderListByShopID
    case getOrderDetails
    case getOrderListByFilter
    case createShopOrder
    case getSubscriptionStatus
    case subscriptionCharges
    
    case getPhoneUserOperators
    case addPhoneToGroup
    case getPhoneUserGroups
    case savePhoneUserGroups
    case getGroupListWithPhoneNumbers
    
    case addKahramaaToGroup
    case getKahramaaUserGroups
    case saveKahramaaUserGroups
    case getGroupListWithKahramaaNumbers
    
    case addQatarCoolToGroup
    case getQatarCoolUserGroups
    case saveQatarCoolUserGroups
    case getGroupListWithQatarCoolNumbers
    
    case paymentDueToPay
    
    case addMetroCard
    case getMetroCards
    case getMetroFareCards
    case removeMetroCard
    case refillMetroCard
    
    case getParkingsList
    case getParkingTicketDetails
    case payParkingViaNoqs
    
    case getGiftStoreList
    case getGiftBrandList
    case getGiftDenominationList
    case initiateGiftTransaction
    case buyGiftDenomination
    
    case getQIDImage
    case uploadQIDDetails
    case getPassportImage
    case updatePassportDetails
    
    case estoreTopupCountryList
    case msdnRequest
    case reserveIDRequest
    case confirmEstoreTopup
    
    case getKarwaBusCardList
    case addKarwaBusCard
    case deleteKarwaBusCard
    case getKarwaBusCardBalance
    case initiateKarwaBus
    case confirmKarwaBusTopup
    
    case getLimousineContactList
    case getMyLimousineContactList
    case addMyLimousineContact
    case removeMyLimousineContact
    
    case getCouponList
    case getCouponCategories
    case getCouponDetails
    
    case getCharityTypes
    case getCharityDonationTypes
    case transferToCharity
    
    // MARK: - STOCKS
    case getMarketSummary
    case getStockTracker
    case getStockGroup
    case getStockMarkets
    case getUserStocks
    case addNewStock
    case getStockAdv
    
    case getStocksNews
    case getStockHistory
    
    case getStocksGroupDetails
    case saveStocksGroup
    case removeStocks
    case updateStocks
    
    // MARK: - CV
    case getCVList
    case addUpdateCV
    case getCVListSearch
    case deleteJob
    case deleteEducation
    
    // MARK: - Limousine
    case getLimousineTabs
    case getLimousineItmes
    case getMyLimousineList
    case addLimousineToMyList
    case deleteLimousineFromMyList
    
    // MARK: - ChildCare
    case getChildCareTabs
    case getChildCareItmes
    case getMyChildCareList
    case addChildCareToMyList
    case removeChildCareFromMyList
    
    // MARK: - Hotel
    case getHotelTabs
    case getHotelItmes
    case getMyHotelList
    case addHotelToMyList
    case removeHotelFromMyList
    
    // MARK: - Dine
    case getDineTabs
    case getDineItmes
    case getMyDineList
    case addDineToMyList
    case removeDineFromMyList
    
    // MARK: - Insurances
    case getInsurancesTabs
    case getInsurancesItmes
    case getMyInsurancesList
    case addInsurancesToMyList
    case removeInsurancesFromMyList
    
    // MARK: - MedicalCenter
    case getMedicalCenterTabs
    case getMedicalCenterItmes
    case getMyMedicalCenterList
    case addMedicalCenterToMyList
    case removeMedicalCenterFromMyList
    
    // MARK: - QaterSchool
    case getQaterSchoolTabs
    case getQaterSchoolItmes
    case getMyQaterSchoolList
    case addQaterSchoolToMyList
    case removeQaterSchoolFromMyList
    
    // MARK: - JOBHUNT
    case getJobHunterList
    case getMyJobHuntList
    case addJobHunt
    case updateJobHunt
    case deleteJobHunt
    
    case getEmployerList
    case getMyEmployerList
    case addEmployer
    case updateEmployer
    case deleteEmployer
    
    case kuludConfirmPayment
    
    case getProcessTokenizedPayment
    case addProcessTokenizedPaymentQR
    case getTokenizedCardDetails
    case deleteTokenizedPaymentCard
    case setDefaultCardTokenized
    case processTokenizedPayment
    case createSessionApplePay
    case processSessionApplePay
    case processWithoutTokenized
    
    // MARK: - PHONE BILL
    case editPhoneBillName
    case removePhoneNumber
    case getPaymentRequestviaPhoneBill
    case getPaymentHistoryByPhone
    case updatePaymentRequestPhoneBill
    case deletePaymentRequestPhoneBill
    case savePaymentRequestViaPhoneBill
    case editPhoneGroupName
    case removePhoneGroup

    // MARK: - Kaharma
    case editKaharmaName
    case removeKaharmaNumber
    case getPaymentRequestKahrmaBill
    case getHistoryKaharmaBill
    case deletePaymentRequestKaharmaBill
    case updatePaymentRequestKaharmaBill
    case savePaymentRequestViaKaharmaBill
    case editKaharmaGroupName
    case removeKaharmaGroup


    
    // MARK: - QATAR COOL
    case editQatarCoolName
    case removeQatarCoolNumber
    case getPaymentRequestQatarCoolBill
    case getHistoryQatarCoolBill
    case deletePaymentRequestQatarCoolBill
    case updatePaymentRequestQatarCoolBill
    case savePaymentRequestViaQatarCoolBill
    case editQatarCoolGroupName
    case removeQatarCoolGroup
    
    // MARK: - NoqsTransferBillPayment
    case noqsTransferBillPayment
    
    
}
