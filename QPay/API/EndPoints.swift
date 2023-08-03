//
//  EndPoints.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/11/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation

//let BASE_URL = "http://151.106.28.182:1124/api/"

//let BASE_URL = isLiveApp ? "https://api.qatarpay.com/api/" : "http://sandbox.qatarpay.com/api/"
let BASE_URL =  "https://api.qatarpay.com/api/"

let LOGIN                   = BASE_URL + "token"
let REGISTER                = BASE_URL + "api/WalletUser/Register"
let SEND_DEVICE_TOKEN       = BASE_URL + "api/WalletUser/SaveDeviceToken"
let GET_USER_PROFILE        = BASE_URL + "api/NoqoodyUser/GetProfile"
let UPLOAD_PROFILE_IMAGE    =  BASE_URL + "api/NoqoodyUser/UploadProfileImage"
let GET_USER_BALANCE        = BASE_URL + "api/WalletUser/GetUserBalance"
let UPLOAD_SIGNATURE        = BASE_URL + "api/NoqoodyUser/UploadDigitalSignature"
let GENERATE_PHONE_TOKEN    = BASE_URL + "api/NoqoodyUser/GeneratePhoneToken"
let CONFIRM_PHONE_NUMBER    = BASE_URL + "api/NoqoodyUser/ConfirmPhoneNumber"
let UPDATE_EMAIL            = BASE_URL + "api/NoqoodyUser/UpdateEmail"
let UPDATE_GENDER           = BASE_URL + "api/NoqoodyUser/UpdateGender"
let UPDATE_PHONE_NUMBER     = BASE_URL + "api/NoqoodyUser/UpdatePhoneNumber"
let GET_ADDRESS_LIST        = BASE_URL + "api/Library/GetUserAddressList"
let VALIDATE_ADDRESS        = BASE_URL + "api/Library/ValidateAddress"
let SAVE_ADDRESS            = BASE_URL + "api/Library/SaveAddress"
let REMOVE_ADDRESS          = BASE_URL + "api/Library/RemoveUserAddress"
let SET_DEFAULT_ADDRESS     = BASE_URL + "api/Library/SetDefaultAddress"
let UPDATE_USER_ADDRESS     = BASE_URL + "api/Library/UpdateUserAddress"
let UPLOAD_QID_IMAGE        = BASE_URL + "api/NoqoodyUser/UploadQIDImage"
let UPLOAD_PASSPORT_IMAGE   = BASE_URL + "api/NoqoodyUser/UploadPassportImage"
let GET_QID_IMAGE           = BASE_URL + "api/NoqoodyUser/getQidImage"
let UPLOAD_QID_DETAILS      = BASE_URL + "api/NoqoodyUser/UploadQIDDetails"
let GET_PASSPORT_IMAGE      = BASE_URL + "api/NoqoodyUser/getPassportImage"
let UPDATE_PASSPORT_DETAILS = BASE_URL + "api/NoqoodyUser/updatePassportDetails"
let VERIFY_PIN              = BASE_URL + "api/NoqoodyUser/VerifyPIN"
let CHECK_QID               = BASE_URL + "api/NoqoodyUser/GetIDCardNumber"

let SEND_VERIFICATION_EMAIL      = BASE_URL + "api/NoqoodyUser/SendVerificationEmail"
let UPDATE_PHONE_NUMBER_REGISTER = BASE_URL + "api/NoqoodyUser/UpdatePhoneNumber"
let UPDATE_PHONE_NUMBER_AND_QID  = BASE_URL + "api/NoqoodyUser/UpdatePhoneNumberAndQID"
let SET_USER_PIN                 = BASE_URL + "api/NoqoodyUser/SetUserPin"
let FORGET_PIN_CODE              = BASE_URL + "api/NoqoodyUser/ForgetPinCode"
let CHANGE_PIN                   = BASE_URL + "api/NoqoodyUser/ChangePIN"
let FORGET_PASSWORD              = BASE_URL + "api/WalletUser/ForgetPassword"
let CONFIRM_FORGET_PASSWORD      = BASE_URL + "api/WalletUser/ConfirmForgetPassword"

let CHECK_PHONE_REGISTERED = BASE_URL + "api/NoqoodyUser/GetPhoneNumber"
let CHECK_EMAIL_REGISTERED = BASE_URL + "api/NoqoodyUser/GetEmail"
let GET_QR_CODE            = BASE_URL + "api/WalletUser/GetQrCode"

// MARK: - TRANSACTIONS

let TRANSACTIONS_LIST       = BASE_URL + "api/NoqoodyUser/GetTransactionList"
let REQUEST_MONEY_PHONE     = BASE_URL + "api/NoqoodyUser/NoqsTransferTopupRequestWithPhoneNumber"
let EXTERNAL_PAYMENT_EMAIL  = BASE_URL + "api/PaymentRequest/ExternalPaymentRequest"
let EXTERNAL_PAYMENT_MOBILE = BASE_URL + "api/PaymentRequest/ExternalPaymentMobileRequest"
let REQUEST_MONEY_EMAIL     = BASE_URL + "api/NoqoodyUser/NoqsTransferTopupRequest"
let REQUEST_MONEY_QPAN      = BASE_URL + "api/NoqoodyUser/NoqsTransferTopupRequestviaQPAN"
let REQUEST_MONEY_QR        = BASE_URL + "api/NoqoodyUser/NoqsTransferTopupRequestviaQRCode"

// MARK: - PAYMENT REQUESTS

let NOTIFICATION_LIST          = BASE_URL + "api/NoqoodyUser/GetNotificationList"
let UPDATE_NOTIFICATION_STATUS = BASE_URL + "api/NoqoodyUser/UpdateNotificationStatus"
let VALIDATE_TRANSFER          = BASE_URL + "api/NoqoodyUser/ValidateTransfer"
let NOTIFICATION_TYPE_LIST     = BASE_URL + "api/NoqoodyUser/GetNotificationTypeList"
let PAYMENT_REQUESTS           = BASE_URL + "api/NoqoodyUser/GetTopupRequstList"
let CONFIRM_PAYMENT_REQUESTS   = BASE_URL + "api/NoqoodyUser/PayTopupRequest"
let CANCEL_PAYMENT_REQUESTS    = BASE_URL + "api/NoqoodyUser/CancelTopupRequest"
let REMOVE_NOTIFICATION        = BASE_URL + "api/NoqoodyUser/RemoveNotification"

// MARK: - REFILL WALLET

let REFILL_WALLET    = BASE_URL + "api/NoqoodyUser/GetPaymentURL"
let GET_CHANNEL_LIST = BASE_URL + "api/SystemSettings/GetChannelList"

public func getRefillChargeURL(_ amount: Double, channelID: Int) -> String {
    return "\(BASE_URL)api/SystemSettings/GetRefillServiceCharge?Amount=\(amount)&channel_id=\(channelID)"
}

// MARK: - PAY REQUESTS

let PAY_FROM_QR_CODE                      = BASE_URL + "api/NoqoodyUser/NoqsTransferMerchanantFromQRRequest"
let PAY_TO_MERCHANT                       = BASE_URL + "api/NoqoodyUser/PayToMerchant"
let VALIDATE_MERCHANT_QR_CODE_PAYMENT     = BASE_URL + "api/Merchant/ValidateMerchantQRCodePaymentRequest"
let VALIDATE_MERCHANT_QR_CODE_WITH_AMOUNT = BASE_URL + "api/Merchant/ValidateGetQrCodeWithAmount"
let VALIDATE_MERCHANT_QR                  = BASE_URL + "api/Merchant/ValidateMerchantQRCode"
let NOQS_TRANSFER_QR                      = BASE_URL + "api/NoqoodyUser/NoqsTransferQR"
let TRANSFER_QR_CODE_PAYMENT              = BASE_URL + "api/Merchant/TransferQRCodePayment"
let TRANSFER_QR_CODE_WITH_AMOUNT          = BASE_URL + "api/Merchant/TransferQrCodeWithAmount"

// MARK: - TRANSFER

let TRANSFER_TO_PHONE          = BASE_URL + "api/NoqoodyUser/NoqsTransferRequestViaMobileNo"
let TRANSFER_TO_EMAIL          = BASE_URL + "api/NoqoodyUser/NoqsTransferRequest"
let TRANSFER_TO_QPAN           = BASE_URL + "api/NoqoodyUser/NoqsTransferRequestViaQPan"
let TRANSFER_TO_QR             = BASE_URL + "api/NoqoodyUser/NoqsTransferFromQRRequest"
let CONFIRM_TRANSFER           = BASE_URL + "api/NoqoodyUser/NoqsTransfer"
let GET_BENEFICIARIES_BY_PHONE = BASE_URL + "api/Library/GetBeneficiaryDataByPhoneNumber"

// MARK: - BENEFICIARIES

let GET_BENEFICIARIES_LIST    = BASE_URL + "api/Library/GetUserBeneficiariesList"
let GET_BENEFICIARY_BY_QPAN   = BASE_URL + "api/Library/GetBeneficiaryDataByQPan"
let GET_BENEFICIARY_BY_QRCODE = BASE_URL + "api/Library/GetBeneficiaryDataByQRCode"
let ADD_BENEFICIARY           = BASE_URL + "api/Library/AddBeneficiary"
let REMOVE_BENEFICIARY        = BASE_URL + "api/Library/RemoveBeneficiary"

// MARK: - COUNTRIES

fileprivate let COUNTRIES_LIST = BASE_URL + "api/NoqoodyUser/GetCountryCodeList?LanguageId="

func getCountriesURL(langId: String) -> String {
    return COUNTRIES_LIST + langId
}

// MARK: - TOPUP

let GET_TOPUP_CARD_LIST         = BASE_URL + "api/NoqoodyUser/GetTopupCardList"
let GET_TOPUP_PAYMENT_CARD_LIST = BASE_URL + "api/NoqoodyUser/GetPaymentCardList"
let TOPUP_PAYMENT_SETTING       = BASE_URL + "api/NoqoodyUser/TopupPaymentSetting"
let GET_TOPUP_SETTINGS          = BASE_URL + "api/NoqoodyUser/GetTopupSetting"
let UPDATE_TOPUP_SETTINGS       = BASE_URL + "api/NoqoodyUser/UpdateTopupSetting"

// MARK: - My Library

let ADD_DRIVING_LICENSE      = BASE_URL + "api/Library/AddDrivingLicense"
let GET_DRIVING_LICENSE_LIST = BASE_URL + "api/Library/GetDrivingLicenseList"
let DELETE_DRIVING_LICENSE   = BASE_URL + "api/Library/DeleteDrivingLicense"
let UPDATE_DRIVING_LICENSE   = BASE_URL + "api/Library/UpdateDrivingLicense"

let GET_ID_CARD_LIST = BASE_URL + "api/Library/GetIDCardList"
let ADD_ID_CARD      = BASE_URL + "api/Library/AddIDCard"
let DELETE_ID_CARD   = BASE_URL + "api/Library/DeleteIDCard"
let UPDATE_ID_CARD   = BASE_URL + "api/Library/UpdateIDCard"

let GET_PASSPORT_LIST = BASE_URL + "api/Library/GetPassportList"
let ADD_PASSPORT      = BASE_URL + "api/Library/AddPassportCard"
let DELETE_PASSPORT   = BASE_URL + "api/Library/DeletePassport"
let UPDATE_PASSPORT   = BASE_URL + "api/Library/UpdatePassport"

let ADD_PAYMENT_CARD            = BASE_URL + "api/NoqoodyUser/AddPaymentCard"
let UPDATE_PAYMENT_CARD         = BASE_URL + "api/NoqoodyUser/UpdatePaymentCard"
private let DELETE_PAYMENT_CARD = BASE_URL + "api/NoqoodyUser/DeletePaymentCard/"
let GET_PAYMENT_CARDS           = BASE_URL + "api/NoqoodyUser/GetPaymentCard"
let PAYMENT_URL                 = BASE_URL + "api/NoqoodyUser/GetPaymentURL"

let ADD_BANK_DETAILS     = BASE_URL + "api/NoqoodyUser/AddBankDetails"
let UPDATE_BANK_DETAILS  = BASE_URL + "api/NoqoodyUser/UpdateBankDetails"
private let DELETE_BANK  = BASE_URL + "api/NoqoodyUser/DeleteBankDetails/"
let BANK_DETAILS         = BASE_URL + "api/NoqoodyUser/GetBankDetails"
let BANK_NAME_LIST       = BASE_URL + "api/NoqoodyUser/GetBankList"

func deletePaymentCardURL(_ cardID: String) -> String {
    return DELETE_PAYMENT_CARD + cardID
}

func deleteBankURL(_ bankID: String) -> String {
    return DELETE_BANK + bankID
}

let GET_LOYALTY_LIST       = BASE_URL + "api/Library/GetLoyaltyCardList"
let GET_LOYALTY_BRAND_LIST = BASE_URL + "api/Library/GetLoyaltyBrandList"
let DELETE_LOYALTY         = BASE_URL + "api/Library/DeleteLoyaltyCard"
let ADD_LOYALTY            = BASE_URL + "api/Library/AddLoyaltyCard"
let UPDATE_LOYALTY         = BASE_URL + "api/Library/UpdateLoyaltyCard"

let GET_DOCUMENT_LIST      = BASE_URL + "api/Library/GetDocumentList"
let DELETE_DOCUMENT        = BASE_URL + "api/Library/DeleteDocument"
let ADD_DOCUMENT           = BASE_URL + "api/Library/AddDocument"
let UPDATE_DOCUMENT        = BASE_URL + "api/Library/UpdateDocument"

let UPLOAD_DOCUMENT        = BASE_URL + "api/Library/UploadDocument"
let UPLOAD_LIBRARY_IMAGE   = BASE_URL + "api/Library/UploadImage"

// MARK: - E-Store

let GET_DASHBOARD_CHART_DATA  = BASE_URL + "api/NoqoodyUser/GetDashboardChartData"
let DASHBOARD_DATA            = BASE_URL + "api/NoqoodyUser/GetDashboardData"

// MARK: - SHOP

let CREATE_SHOP                           = BASE_URL + "api/Ecommerce/CreateShop"
let UPDATE_SHOP_IMAGE                     = BASE_URL + "api/Ecommerce/UpdateShopImage"
let UPDATE_SHOP_DETAILS                   = BASE_URL + "api/Ecommerce/UpdateShopDetails"
let UPDATE_SHOP_STATUS                    = BASE_URL + "api/Ecommerce/UpdateShopStatus"
let GET_SHOP_LIST                         = BASE_URL + "api/Ecommerce/GetShopList"
fileprivate let GET_PRODUCTS_BY_SHOP_ID   = BASE_URL + "api/Ecommerce/GetProductListByShopID/"
let ADD_PRODUCT                           = BASE_URL + "api/Ecommerce/AddShopProducts"
let UPDATE_PRODUCT                        = BASE_URL + "api/Ecommerce/EditProduct"
let REMOVE_PRODUCT                        = BASE_URL + "api/Ecommerce/RemoveShopProducts"
let UPDATE_PRODUCT_STATUS                 = BASE_URL + "api/Ecommerce/UpdateShopProductsStatus"
let GET_ORDER_LIST                        = BASE_URL + "api/Ecommerce/GetOrderList"
let GET_ARCHIVE_ORDER_LIST                = BASE_URL + "api/Ecommerce/GetArchiveOrderList"
let CREATE_SHOP_ORDER                     = BASE_URL + "api/Ecommerce/ShopOrder"
fileprivate let GET_ORDER_LIST_BY_SHOP_ID = BASE_URL + "api/Ecommerce/GetOrderListByShopID/"
let DELETE_ORDER                          = BASE_URL + "api/Ecommerce/DeleteOrder"
let ARCHIVE_ORDER                         = BASE_URL + "api/Ecommerce/ArchiveOrder"
let MARK_ORDER_AS_READ                    = BASE_URL + "api/Ecommerce/CompleteOrder"
let RESEND_ORDER                          = BASE_URL + "api/Ecommerce/ResendOrder"
let UPLOAD_ESTORE_IMAGE                   = BASE_URL + "api/Ecommerce/UploadImage"
let UPDATE_PRODUCT_IMAGE                  = BASE_URL + "api/Ecommerce/UpdateProductImage"
let GET_ORDER_DETAILS                     = BASE_URL + "api/Ecommerce/GetOrderDetailByOrderID"
fileprivate let GET_ORDER_LIST_BY_FILTER  = BASE_URL + "api/Ecommerce/GetOrderListByFilter"

func getSubscriptionStatusURL(shopID: Int) -> String {
    return BASE_URL + "api/Ecommerce/GetSubscriptionStatusByShopID?ShopID=\(shopID)"
}

func subscriptionCharges(shopID: Int) -> String {
    return BASE_URL + "api/Shop/SubscriptionCharges?ShopID=\(shopID)"
}

func getProductsByShopIDURL(shopID: String) -> String {
    return GET_PRODUCTS_BY_SHOP_ID + shopID
}

func getOrderListByShopIDURL(shopID: String) -> String {
    return GET_ORDER_LIST_BY_SHOP_ID + shopID
}

func getOrderListByFilterURL(shopID: String, fromDate: String, toDate: String) -> String {
    return "\(GET_ORDER_LIST_BY_FILTER)?ShopID=\(shopID)&DateFrom=\(fromDate)&DateTo=\(toDate)"
}

// MARK: - PHONE

let ADD_PHONE_TO_GROUP                = BASE_URL + "api/NoqoodyUser/AddPhoneNumberToGroup"
let SAVE_PHONE_USER_GROUP             = BASE_URL + "api/NoqoodyUser/SavePhoneGroup"
let GET_PHONE_USER_OPERATORS          = BASE_URL + "api/NoqoodyUser/GetOperatorList"
let GET_GROUP_LIST_WITH_PHONE_NUMBERS = BASE_URL + "api/NoqoodyUser/GetGroupListByPhoneNumbers"
let SAVE_PAYMENT_REQUEST_PHONE_BILL   = BASE_URL + "api/DueToPayPayment/PaymentRequestViaPhoneBill"
let EDIT_PHONE_GROUP_NAME             = BASE_URL + "api/NoqoodyUser/EditPhoneGroupName"
let REMOVE_PHONE_GROUP                = BASE_URL + "api/NoqoodyUser/RemovePhoneGroup"

public func getPhoneUserGroupURL(operatorID: Int) -> String {
    return BASE_URL + "api/NoqoodyUser/GetUserGroup?OperatorID=\(operatorID)"
}

public func getPaymentsHistoryByPhoneURL(phoneNumber: String) -> String {
    return BASE_URL + "api/DueToPayPayment/GetPaymentsHistoryviaPhoneBill?PhoneNumber=\(phoneNumber)"
}

let EDIT_PHONE_BILL_NAME              = BASE_URL + "api/NoqoodyUser/EditPhoneBillName"
let REMOVE_PHONE_NUMBER               = BASE_URL + "api/NoqoodyUser/RemovePhoneNumber"
let UPDATE_PAYMENT_REQUEST_PHONE_BILL = BASE_URL + "api/DueToPayPayment/UpdatePaymentRequestViaPhoneBill"
let DELETE_PAYMENT_REQUEST_PHONE_BILL = BASE_URL + "api/DueToPayPayment/DeletePaymentRequestViaPhoneBill"

public func getPaymentRequestviaPhoneBill(operatorID   : Int ,
                                         groupID       : Int ,
                                         mobileNumber  : String) -> String {
    return BASE_URL + "api/DueToPayPayment/GetPaymentRequestviaPhoneBill?OperatorID=\(operatorID)&GroupID=\(groupID)&MobileNumber=\(mobileNumber)"
}

// MARK: - KAHRAMAA

let ADD_KAHRAMAA_TO_GROUP                = BASE_URL + "api/NoqoodyUser/AddKaharmaNumberToGroup"
let GET_KAHRAMAA_USER_GROUPS             = BASE_URL + "api/NoqoodyUser/GetKaharmaUserGroup"
let SAVE_KAHRAMAA_USER_GROUP             = BASE_URL + "api/NoqoodyUser/SaveKaharmaGroup"
let GET_GROUP_LIST_WITH_KAHRAMAA_NUMBERS = BASE_URL + "api/NoqoodyUser/GetGroupListByKaharmaNumbers"

let EDIT_KAHRAMAA_NAME                   = BASE_URL + "api/NoqoodyUser/EditKaharmaName"
let REMOVE_KAHRAMAA_NUMBER               = BASE_URL + "api/NoqoodyUser/RemoveKaharmaNumber"
let UPDATE_PAYMENT_REQUEST_KAHRAMAA_BILL = BASE_URL + "api/DueToPayPayment/UpdatePaymentRequestViaKahramaBill"
let DELETE_PAYMENT_REQUEST_KAHRAMAA_BILL = BASE_URL + "api/DueToPayPayment/DeletePaymentRequestViaKahrama"
let SAVE_PAYMENT_REQUEST_KAHRAMAA_BILL   = BASE_URL + "api/DueToPayPayment/PaymentRequestViaKahramaBill"
let EDIT_KAHRAMAA_GROUP_NAME             = BASE_URL + "api/NoqoodyUser/EditKaharmaGroupName"
let REMOVE_KAHRAMAA_GROUP                = BASE_URL + "api/NoqoodyUser/RemoveKaharmaGroup"


public func getPaymentsHistoryByKahrmaURL(kahrmaNumber: String) -> String {
    return BASE_URL + "api/DueToPayPayment/GetPaymentsHistoryviaKhrmBill?KahramaNumber=\(kahrmaNumber)"
}

public func getPaymentRequestKahrmaURL(groupID       : Int ,
                                       mobileNumber  : String  ) -> String {
    return BASE_URL + "api/DueToPayPayment/GetPaymentRequestviaKahrama?GroupID=\(groupID)&Number=\(mobileNumber)"
}

// MARK: - QATAR COOL

let ADD_QATAR_COOL_TO_GROUP                = BASE_URL + "api/NoqoodyUser/AddQatarCoolNumberToGroup"
let GET_QATAR_COOL_USER_GROUPS             = BASE_URL + "api/NoqoodyUser/GetQatarCoolUserGroup"
let SAVE_QATAR_COOL_USER_GROUP             = BASE_URL + "api/NoqoodyUser/SaveQatarCoolGroup"
let GET_GROUP_LIST_WITH_QATAR_COOL_NUMBERS = BASE_URL + "api/NoqoodyUser/GetGroupListByQatarCoolNumbers"
let PAYMENT_VIA_DUE_TO_PAY = BASE_URL + "api/NoqoodyUser/PaymentRequestViaDuetoPay"

let EDIT_QATAR_COOL_NAME                   = BASE_URL + "api/NoqoodyUser/EditQatarCoolName"
let REMOVE_QATAR_COOL_NUMBER               = BASE_URL + "api/NoqoodyUser/RemoveQatarCoolNumber"
let UPDATE_PAYMENT_REQUEST_QATAR_COOL_BILL = BASE_URL + "api/DueToPayPayment/UpdatePaymentRequestViaQatarCool"
let DELETE_PAYMENT_REQUEST_QATAR_COOL_BILL = BASE_URL + "api/DueToPayPayment/DeletePaymentRequestViaQatarCool"
let SAVE_PAYMENT_REQUEST_QATAR_COOL_BILL   = BASE_URL + "api/DueToPayPayment/PaymentRequestViaQatarCool"
let EDIT_QATAR_COOL_GROUP_NAME             = BASE_URL + "api/NoqoodyUser/EditQatarCoolGroupName"
let REMOVE_QATAR_COOL_GROUP                = BASE_URL + "api/NoqoodyUser/RemoveQatarCoolGroup"


public func getPaymentsHistoryByQatarCoolURL(qatarCoolNumber: String) -> String {
    return BASE_URL + "api/DueToPayPayment/GetPaymentsHistoryviaQatarCool?QatarCoolNumber=\(qatarCoolNumber)"
}

public func getPaymentRequestQatarCoolURL(groupID : Int ,
                                          number  : String  ) -> String {
    return BASE_URL + "api/DueToPayPayment/GetPaymentRequestviaQatarCool?GroupID=\(groupID)&Number=\(number)"
}


// MARK: -  NoqsTransferBillPayment
let NOQS_TRANSFER_BILL_PAYMENT  = BASE_URL + "api/DueToPayPayment/NoqsTransferBillPayment"



// MARK: - METRO

let ADD_METRO_CARD          = BASE_URL + "api/NoqoodyUser/AddMetroCard"
let GET_METRO_CARDS         = BASE_URL + "api/NoqoodyUser/GetMetroCardList"
let GET_METRO_CARDS_DETAILS = BASE_URL + "api/noqoodyuser/GetMetroCardsWithDetails"
let REFILL_METRO_CARD       = BASE_URL + "api/NoqoodyUser/RefillRequest"

func deleteMetroCardURL(_ cardID: Int) -> String {
    return "\(BASE_URL)api/NoqoodyUser/RemoveMetroCard/\(cardID)?LanguageId=1"
}

// MARK: - PARKING

let GET_PARKINGS_LIST          = BASE_URL + "api/Qparking/GetParkingList"
let GET_PARKING_TICKET_DETAILS = BASE_URL + "api/Qparking/GetParkingTicketDetails"
let PAY_PARKING_VIA_NOQS       = BASE_URL + "api/Qparking/PayQParkingViaNoqs"

// MARK: - GIFT

let GET_GIFT_STORES            = BASE_URL + "api/EStore/GetStores"
let GET_GIFT_DENOMINATION_LIST = BASE_URL + "api/EStore/GetDenominationList"
let INITIATE_GIFT_TRANSACTION  = BASE_URL + "api/EStore/InitiateTransaction"
let BUY_GIFT_DENOMINATION      = BASE_URL + "api/EStore/BuyDenomination"

public func getBrandsByStoreURL(storeID: Int) -> String {
    return "\(BASE_URL)api/EStore/GetBrandListByStoreID/\(storeID)"
}

// MARK: - E-STORE TOPUP

let GET_ESTORE_COUNTRY_LIST = BASE_URL + "api/EStore/GetCountryList"
let MSDN_REQUEST            = BASE_URL + "api/EStore/MSDNRequest"
let RESERVE_ID_REQUEST      = BASE_URL + "api/EStore/ReserveIDRequest"
let CONFIRM_ESTORE_TOPUP    = BASE_URL + "api/EStore/ConfirmTopup"

// MARK: - KARWA BUS

let GET_KARWA_BUS_CARD_LIST    = BASE_URL + "api/NoqoodyUser/GetKarwaBusCardList"
let ADD_KARWA_BUS_CARD         = BASE_URL + "api/NoqoodyUser/AddKarwaBusCard"
let GET_KARWA_BUS_CARD_BALANCE = BASE_URL + "api/EStore/GetKarwaBusCardBalance"
let INITIATE_KARWA_BUS_TOPUP   = BASE_URL + "api/EStore/InitiateKarwaTopupRequest"
let CONFIRM_KARWA_BUS_TOPUP    = BASE_URL + "api/EStore/ConfirmKarwaToup"

func deleteKarwaBusCardURL(_ cardID: Int, languageId: Int) -> String {
    return "\(BASE_URL)api/NoqoodyUser/RemoveKarwaBusCard/\(cardID)?LanguageId=\(languageId)"
}

// MARK: - LIMOUSINE

let GET_LIMOUSINE_CONTACT_LIST    = BASE_URL + "api/Library/GetLimousineContactList"
let GET_MY_LIMOUSINE_CONTACT_LIST = BASE_URL + "api/Library/GetMyLimousineContactList"
let ADD_MY_LIMOUSINE_CONTACT      = BASE_URL + "api/Library/AddMyLimousineContactList"
let REMOVE_MY_LIMOUSINE_CONTACT   = BASE_URL + "api/Library/RemoveMyLimousineContactList"

// MARK: - COUPON

let GET_COUPON_LIST       = BASE_URL + "api/Coupon/CouponList"
let GET_COUPON_CATEGORIES = BASE_URL + "api/Coupon/CouponCategoryList"
let GET_COUPON_DETAILS    = BASE_URL + "api/Coupon/CouponDetail"

// MARK: - CHARITY

let GET_CHARITY_TYPES          = BASE_URL + "api/NoqoodyUser/GetCharityTypes"
let GET_CHARITY_DONATION_TYPES = BASE_URL + "api/NoqoodyUser/GetCharityDonationTypes"
let TRANSFER_VIA_CHARITY       = BASE_URL + "api/NoqoodyUser/NoqsTransferRequestViaCharity"

// MARK: - STOCKS

let GET_MARKET_SUMMARY = BASE_URL + "api/Stocks/GetMarketSummaryStocks"
let GET_STOCK_TRACKER  = BASE_URL + "api/Stocks/GetStocksTrackerDetails"
let GET_STOCK_GROUP    = BASE_URL + "api/Stocks/GetStockGroup"

let GET_STOCK_DETAILS  = BASE_URL + "api/Stocks/GetStockDetails"

let GET_STOCK_ADV      = BASE_URL + "api/Stocks/GetStockAds"
let GET_USER_STOCKS    = BASE_URL + "api/Stocks/GetUserStocks"
let GET_MARKET_NAMES   = BASE_URL + "api/Stocks/GetMarketName"
let ADD_NEW_STOCK      = BASE_URL + "api/Stocks/AddNewStock"

let GET_STOCK_NEWS     = BASE_URL + "api/Stocks/GetStockNews"
let GET_STOCK_HISTORY  = BASE_URL + "api/Stocks/GetUserStockHistory"

let GET_STOCKS         = BASE_URL + "api/Stocks/GetStocks"
let SAVE_STOCKS_GROUP  = BASE_URL + "api/Stocks/SaveStocksGroup"
let UPDATE_STOCKS      = BASE_URL + "api/Stocks/UpdateStock"
let REMOVE_STOCKS      = BASE_URL + "api/Stocks/RemoveStock"

// MARK: - CV

let GET_CV_LIST               =  BASE_URL + "api/CV/GetCVList"
let ADD_UPDATE_CV             =  BASE_URL + "api/CV/AddUpdateCV"
let GET_CV_LIST_SEARCH        =  BASE_URL + "api/CV/GetCVListSearch"
let DELETE_CV_JOB             =  BASE_URL + "api/CV/DeleteJob"
let DELETE_CV_EDUCATION       =  BASE_URL + "api/CV/DeleteEducation"
let UPLOAD_CV_PROFILE_IMAGE   =  BASE_URL + "api/CV/UploadProfileImage"
let UPLOAD_CV_FILE            = BASE_URL + "api/CV/UploadCvFile"

// MARK: - LIMOUSINE

let GET_LIMOUSINE_TAB                    = BASE_URL + "api/EStore/GetOjraBuisnessCategoryDetails"
fileprivate let GET_LIMOUSINE_LIST_BY_ID = BASE_URL + "api/EStore/GetOjraDirectory_BuisCateg?BuisCategID="
let GET_MY_LIMOUSINE_LIST                = BASE_URL + "api/EStore/GetMyOjraList"
let ADD_LIMOUSINE_TO_MY_LIST             = BASE_URL + "api/EStore/Add_MyOjraList"
let DELETE_LIMOUSINE_FROM_MY_LIST        = BASE_URL + "api/EStore/RemoveMyOjraContactList"

func getLimousineListByBuisCategIDURL(buisCategID: String) -> String {
    return GET_LIMOUSINE_LIST_BY_ID + buisCategID
}
// MARK: - CHILD CARE

let GET_CHILD_CARE_TAB                     = BASE_URL + "api/EStore/GetNurseryBuisnessCategoryDetails"
fileprivate let GET_CHILD_CARE_LIST_BY_ID  = BASE_URL + "api/EStore/GetNurseryDirectory_BuisCateg?BuisCategID="
let GET_MY_CHILD_CARE_LIST                 = BASE_URL + "api/EStore/GetMyNurseryDirectory"
let ADD_CHILD_CARE_TO_MY_LIST              = BASE_URL + "api/EStore/Add_MyNurseryList"
let REMOVE_CHILD_CARE_FROM_MY_LIST         = BASE_URL + "api/EStore/RemoveMyNurseryList"

func getChildCareListByIDURL(buisCategID: String) -> String {
    return GET_CHILD_CARE_LIST_BY_ID + buisCategID
}

// MARK: - Hotel (Qatar Stay In Out)

let GET_HOTEL_TAB                    = BASE_URL + "api/EStore/GetHotelBuisnessCategoryDetails"
fileprivate let GET_HOTEL_LIST_BY_ID = BASE_URL + "api/EStore/GetHotelDirectory__BuisCateg?BuisCategID="
let GET_MY_HOTEL_LIST                = BASE_URL + "api/EStore/GetMyHotelDirectory"
let ADD_HOTEL_TO_MY_LIST             = BASE_URL + "api/EStore/Add_MyHotelList"
let REMOVE_HOTEL_FROM_MY_LIST        = BASE_URL + "api/EStore/RemoveMyHotelList"

func getHotelListByIDURL(buisCategID: String) -> String {
    return GET_HOTEL_LIST_BY_ID + buisCategID
}

// MARK: - DINE

let GET_DINE_TAB                     = BASE_URL + "api/EStore/GetDineBuisnessCategoryDetails"
fileprivate let GET_DINE_LIST_BY_ID  = BASE_URL + "api/EStore/GetDineDirectory_BuisCateg?BuisCategID="
let GET_MY_DINE_LIST                 = BASE_URL + "api/EStore/GetMyDineDirectory"
let ADD_DINE_TO_MY_LIST              = BASE_URL + "api/EStore/Add_MyDineList"
let REMOVE_DINE_FROM_MY_LIST         = BASE_URL + "api/EStore/RemoveMyDineList"

func getDineListByIDURL(buisCategID: String) -> String {
    return GET_DINE_LIST_BY_ID + buisCategID
}

// MARK: - INSURANCE

let GET_INSURANCE_TAB                      = BASE_URL + "api/EStore/GetInsuranceBuisnessCategoryDetails"
fileprivate let GET_INSURANCE_LIST_BY_ID   = BASE_URL + "api/EStore/GetInsuranceDirectory_BuisCateg?BuisCategID="
let GET_MY_INSURANCE_LIST                  = BASE_URL + "api/EStore/GetMyInsuranceDirectory"
let ADD_INSURANCE_TO_MY_LIST               = BASE_URL + "api/EStore/Add_MyInsuranceList"
let REMOVE_INSURANCE_FROM_MY_LIST          = BASE_URL + "api/EStore/RemoveMyInsuranceList"

func getInsuranceListByIDURL(buisCategID: String) -> String {
    return GET_INSURANCE_LIST_BY_ID + buisCategID
}

// MARK: - MEDICAL_CENTER

let GET_MEDICAL_CENTER_TAB                     = BASE_URL + "api/EStore/GetClinicsBuisnessCategoryDetails"
fileprivate let GET_MEDICAL_CENTER_LIST_BY_ID  = BASE_URL + "api/EStore/GetClinicsDirectory_BuisCateg?BuisCategID="
let GET_MY_MEDICAL_CENTER_LIST                 = BASE_URL + "api/EStore/GetMyClinicsDirectory"
let ADD_MEDICAL_CENTER_TO_MY_LIST              = BASE_URL + "api/EStore/Add_MyClinicsList"
let REMOVE_MEDICAL_CENTER_FROM_MY_LIST         = BASE_URL + "api/EStore/RemoveMyClinicsList"

func getMedicalCenterListByIDURL(buisCategID: String) -> String {
    return GET_MEDICAL_CENTER_LIST_BY_ID + buisCategID
}

// MARK: - QATARSCHOOL

let GET_SCHOOL_TAB                     = BASE_URL + "api/EStore/GetSchoolBuisnessCategoryDetails"
fileprivate let GET_SCHOOL_LIST_BY_ID  = BASE_URL + "api/EStore/GetSchoolDirectory_BuisCateg?BuisCategID="
let GET_MY_SCHOOL_LIST                 = BASE_URL + "api/EStore/GetMySchoolDirectory"
let ADD_SCHOOL_TO_MY_LIST              = BASE_URL + "api/EStore/Add_MySchoolList"
let REMOVE_SCHOOL_FROM_MY_LIST         = BASE_URL + "api/EStore/RemoveMySchoolList"

func getSchoolListByIDURL(buisCategID: String) -> String {
    return GET_SCHOOL_LIST_BY_ID + buisCategID
}

// MARK: - JOBHUNT

// MARK: - JOB_SEEKER

let GET_JOB_SEEKER_LIST  = BASE_URL + "api/CV/GetjobjunterList"
let GET_MY_JOB_LIST      = BASE_URL + "api/CV/GetjMyobjunterList"
let ADD_JOB_HUNT         = BASE_URL + "api/CV/AddJobhunter"
let UPDATE_JOB_HUNT      = BASE_URL + "api/CV/UpdateJobhunter"
let DELETE_JOB_HUNTER    = BASE_URL + "api/CV/DeleteJobhunter"

// MARK: - EMPLOYER

let GET_EMPLOYER_LIST    = BASE_URL + "api/CV/GetEmployerList"
let GET_MY_Employer_LIST = BASE_URL + "api/CV/GetMyEmployerList"
let ADD_EMPLOYER         = BASE_URL + "api/CV/AddEmployer"
let UPDATE_EMPLOYER      = BASE_URL + "api/CV/UpdateEmployer"
let DELETE_EMPLOYER      = BASE_URL + "api/CV/DeleteEmployer"

// MARK: - KULUD PHARMACY

let KULUD_CONFIRM_PAYMENT = BASE_URL + "api/Kulud/KuludConfirmPayment"

func getProcessTokenizedPaymentURL(amount: Double , cardID : Int) -> String {
    return BASE_URL + "api/SystemSettings/ProcessTokenizedPayment?Amount=\(amount)&card_id=\(cardID)"
}

// MARK: -  TOKENIZED PAYMENT

let PROCESS_TOKENIZED_PAYMENT_QR           = BASE_URL + "api/SystemSettings/ProcessTokenizedPayment_QR"
let GET_TOKENIZED_CARD_DETAILS             = BASE_URL + "api/Tokenized/GetTokenizedCardDetails"
let SET_DEFAULT_CARD_TOKENIZED = BASE_URL + "api/Tokenized/SetDefaultCard_Tokenized?Card_ID="
fileprivate let DELETE_PAMENT_CARD         = BASE_URL + "api/NoqoodyUser/DeletePaymentCard/?ID="

func deleteTokenizedPamentCardURL(ID: Int) -> String {
    return DELETE_PAMENT_CARD + "\(ID)"
}

func setDefaultCard(cardID: Int) -> String {
    return SET_DEFAULT_CARD_TOKENIZED + "\(cardID)"
}

