//
//  super.requestService.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/11/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireObjectMapper
import TTGSnackbar
import SystemConfiguration
import ObjectMapper

// MARK: - DEFAULT HEADERS

public var defaultHeaders: HTTPHeaders {
    get {
        var headers = HTTPHeaders.default
        headers.add(.acceptJSON)
        headers.add(.contentTypeJSON)
        return headers
    }
}

// MARK: - REQUEST SERVICE PROXY

class RequestServiceProxy {
    
    private let requestController: RequestsProtocol
    private let queue: DispatchQueue
    
    private init() {
        self.requestController = RequestsController.shared
        self.queue = DispatchQueue(label: "request_service_queue")
    }
    
    private static var object: RequestServiceProxy?
    
    public static var shared: RequestServiceProxy {
        if let requestServiceProxy = object {
            return requestServiceProxy
        }else {
            object = RequestServiceProxy()
            return object!
        }
    }
    
    public func requestService() -> RequestService? {
        
        if self.requestController.isConnectedToInternet() {
            return RequestService.shared
            
        }else {
            let snack = TTGSnackbar(message: "Check Internet Connection", duration: TTGSnackbarDuration.middle)
            snack.backgroundColor = .red
            snack.cornerRadius = 6
            snack.show()
            
            return nil
        }
    }
}

// MARK: - REQUESTS PROTOCOL

protocol RequestsProtocol {
    var headers: HTTPHeaders { get }
    var params: Parameters { get }
    
    func getTokenWithBearer(_ token: String) -> String
    func isConnectedToInternet() -> Bool
    func internetConnectionClousure(_ callback: @escaping InternetConnectionChecker)
}

// MARK: - REQUESTS CONTROLLER

class RequestsController: RequestsProtocol {
    
    private static var object: RequestsController?
    
    private init() {
    }
    
    public static var shared: RequestsController {
        return RequestsController()
        //        if let requestService = object {
        //            return requestService
        //        }else {
        //            object = RequestsController()
        //            return object!
        //        }
    }
    
    var headers: HTTPHeaders {
        get {
            return HTTPHeaders([.acceptJSON])
        }
    }
    
    var params: Parameters {
        get {
            return [:]
        }
    }
    
    public func getTokenWithBearer(_ token: String) -> String {
        return "bearer \(token)"
    }
    
    public func getAuthorizationAcceptHeaders(_ token: String) -> HTTPHeaders {
        var headers = self.headers
        headers["Authorization"] = self.getTokenWithBearer(token)
        return headers
    }
    
    public func isConnectedToInternet() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
    public func internetConnectionClousure(_ callback: @escaping InternetConnectionChecker) {
        if isConnectedToInternet() {
            //callback intenrt connection available
        }
        callback(self.isConnectedToInternet())
    }
}

// MARK: - REQUEST SERVICE

class RequestService {
    
    weak var delegate: RequestsDelegate?
    
    private let userProfile: UserProfile!
    private let requestsController: RequestsProtocol = RequestsController.shared
    
    private func getToken() -> String {
        if let user = self.userProfile.getUser(), let token = user.access_token {
            return self.requestsController.getTokenWithBearer(token)
            //            return "\(self.requestsController.bearer) \(token)"
        }
        return ""
    }
    
    private static var object: RequestService?
    
    private init() {
        userProfile = UserProfile.shared
    }
    
    fileprivate static var shared: RequestService {
        if object == nil {
            object = RequestService()
        }
        return object!
    }
    
    private lazy var AlamofireManager: Session = {
        let session = Session.default
        session.sessionConfiguration.timeoutIntervalForRequest = 10
        session.sessionConfiguration.timeoutIntervalForResource = 10
        
        return session
    }()
    
    // MARK: - SIGN IN
    
    func signIn(_ email: String, _ password: String, callDelegate: Bool = true, _ completion: @escaping CallObjectBack<User>) {
        
        if self.requestsController.isConnectedToInternet() {
            if callDelegate {
                self.delegate?.requestStarted(request: .signIn)
            }
            
            var params: Parameters = [:]
            params["username"] = email
            params["password"] = password
            params["grant_type"] = "password"
            params["response_type"] = "token"
            
            let headers: HTTPHeaders = self.requestsController.headers
            
            self.AlamofireManager.request(LOGIN, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<User, AFError>) in
                
                switch response.result {
                case .success(var user):
                    user.password = password
                    self.userProfile.saveUser(user: user)
                    if callDelegate {
                        self.delegate?.requestFinished(request: .signIn, result: .Success(user))
                    }
                    completion(user)
                    break
                    
                case .failure(let error):
                    if callDelegate {
                        self.delegate?.requestFinished(request: .signIn, result: .Failure(.AlamofireError(error)))
                    }
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Sign in Request
    
    // MARK: - SIGN UP
    
    func signUp(signUpData: SignUpData, accountType: AccountType, completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .signUp)
            
            var params: Parameters = [:]
            params["Email"] = signUpData.email
            params["Password"] = signUpData.password
            params["ConfirmPassword"] = signUpData.confirmPassword
            params["FirstName"] = signUpData.firstName
            params["LastName"] = signUpData.lastName
            params["IDCardNumber"] = "Na"
            params["UserType"] = accountType.serverAccountNumber
            params["PhoneNumber"] = "00"
            
            let headers: HTTPHeaders = self.requestsController.headers
            
            self.AlamofireManager.request(REGISTER, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .signUp, result: .Success(baseResponse))
                        completion(true, baseResponse)
                    }else {
                        self.delegate?.requestFinished(request: .signUp, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .signUp, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Sign Up Request
    
    // MARK: - GET USER PROFILE
    
    func getUserProfile(_ completion: @escaping CallObjectBack<Profile>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getUserProfile)
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            let params: Parameters = [:]
            
            self.AlamofireManager.request(GET_USER_PROFILE, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseObjectResponse<Profile>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        if let profile = baseResponse.object {
                            UserProfile.shared.saveProfile(profile: profile)
                        }
                        self.delegate?.requestFinished(request: .getUserProfile, result: .Success(baseResponse))
                        completion(baseResponse.object)
                    }else {
                        self.delegate?.requestFinished(request: .getUserProfile, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getUserProfile, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Get User Profile Request
    
    // MARK: - GET USER BALANCE
    
    func getUserBalance(completion: @escaping ClosureObjectBack<Double>) {
        
        if self.requestsController.isConnectedToInternet() {
            
            let params: Parameters = [:]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_USER_BALANCE, method: .get, parameters: params, headers: headers).validate().responseJSON(queue: .main, options: .mutableContainers) { (response) in
                
                switch response.result {
                case .success(let json):
                    if let dic = json as? [String : Any],
                       let balance = dic["Balance"] as? Double {
                        completion(true, balance)
                        return
                    }
                    completion(false, 0.0)
                    
                case .failure(_):
                    completion(false, 0.0)
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Get User Balance Request
    
    // MARK: - GENERATE PHONE TOKEN
    
    func generatePhoneToken(phone: String, completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            
            self.delegate?.requestStarted(request: .generatePhoneToken)
            
            var params: Parameters = [:]
            params["PhoneNumber"] = phone
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GENERATE_PHONE_TOKEN, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .generatePhoneToken, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .generatePhoneToken, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .generatePhoneToken, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Generate Phone Token Request
    
    // MARK: - CONFIRM PHONE NUMBER
    
    func confirmPhoneNumber(_ phone: String, code: String, _ completion: @escaping CallObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            
            self.delegate?.requestStarted(request: .confirmPhoneNumber)
            
            var params: Parameters = [:]
            params["PhoneNumber"] = phone
            params["Code"] = code
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(CONFIRM_PHONE_NUMBER, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .confirmPhoneNumber, result: .Success(baseResponse))
                        completion(baseResponse)
                    }else {
                        self.delegate?.requestFinished(request: .confirmPhoneNumber, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .confirmPhoneNumber, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Confirm Phone Number Request
    
    // MARK: - UPDATE PHONE NUMBER
    
    func updatePhoneNumber(phone: String, completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .updatePhoneNumber)
            
            let params: Parameters = [:]
            
            let url = "\(UPDATE_PHONE_NUMBER)?Phonenumber=\(phone)"
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(url, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .updatePhoneNumber, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .updatePhoneNumber, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .updatePhoneNumber, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Update Phone Number Request
    
    // MARK: - UPDATE Email
    
    func updateEmail(email: String, completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            
            self.delegate?.requestStarted(request: .updateEmail)
            
            let params: Parameters = [:]
            
            let url = "\(UPDATE_EMAIL)?Emailadd=\(email)"
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(url, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .updateEmail, result: .Success(baseResponse))
                        completion(true, baseResponse)
                    }else {
                        self.delegate?.requestFinished(request: .updateEmail, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .updateEmail, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Update Email Request
    
    // MARK: - UPDATE GENDER
    
    func updateGender(_ gender: Profile.Gender, _ completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .updateGender)
            
            let params: Parameters = [
                "Gender" : gender.serverType
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(UPDATE_GENDER, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .updateGender, result: .Success(baseResponse))
                        completion(true, baseResponse)
                    }else {
                        self.delegate?.requestFinished(request: .updateGender, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .updateGender, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Update Gender Request
    
    // MARK: - GET ADDRESS LIST
    
    func getAddressList(completion: @escaping ClosureArrayBack<Address>) {
        
        if self.requestsController.isConnectedToInternet() {
            
            self.delegate?.requestStarted(request: .getAddressList)
            
            let params: Parameters = [:]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_ADDRESS_LIST, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<Address>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getAddressList, result: .Success(baseResponse))
                        completion(true, baseResponse.list)
                    }else {
                        self.delegate?.requestFinished(request: .getAddressList, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getAddressList, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Get Address List Request
    
    // MARK: - VALIDATE ADDRESS
    
    func validateAddress(address: Address, completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            
            self.delegate?.requestStarted(request: .validateAddress)
            
            var params: Parameters = [:]
            params["Zone"] = address._zone
            params["BuildingNumber"] = address._buildingNumber
            params["Street"] = address._streetNumber
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(VALIDATE_ADDRESS, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                    switch response.result {
                    case .success(let baseResponse):
                        if baseResponse.success == true {
                            self.delegate?.requestFinished(request: .validateAddress, result: .Success(baseResponse))
                            completion(true, baseResponse)
                        }else {
                            self.delegate?.requestFinished(request: .validateAddress, result: .Failure(.Exception(baseResponse._message)))
                            completion(false, nil)
                        }
                        break
                        
                    case .failure(let error):
                        self.delegate?.requestFinished(request: .validateAddress, result: .Failure(.AlamofireError(error)))
                        completion(false, nil)
                        break
                    }
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Validate Address Request
    
    // MARK: - SAVE ADDRESS
    
    func saveAddress(address: Address, completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            
            self.delegate?.requestStarted(request: .saveAddress)
            
            var params: Parameters = [:]
            params["Zone"] = address._zone
            params["BuildingNumber"] = address._buildingNumber
            params["Street"] = address._streetNumber
            params["Address"] = address._streetName
            params["AddressName"] = address._name
            params["CIty"] = "NA"
            params["Country"] = "NA"
            params["PoBox"] = "NA"
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(SAVE_ADDRESS, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                    switch response.result {
                    case .success(let baseResponse):
                        if baseResponse.success == true {
                            self.delegate?.requestFinished(request: .saveAddress, result: .Success(baseResponse))
                            completion(true, baseResponse)
                        }else {
                            self.delegate?.requestFinished(request: .saveAddress, result: .Failure(.Exception(baseResponse._message)))
                            completion(false, nil)
                        }
                        break
                        
                    case .failure(let error):
                        self.delegate?.requestFinished(request: .saveAddress, result: .Failure(.AlamofireError(error)))
                        completion(false, nil)
                        break
                    }
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Save Address Request
    
    // MARK: - REMOVE ADDRESS
    
    func removeAddress(_ id: Int, completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            
            self.delegate?.requestStarted(request: .removeAddress)
            
            var params: Parameters = [:]
            params["AddressID"] = id
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(REMOVE_ADDRESS, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                    switch response.result {
                    case .success(let baseResponse):
                        if baseResponse.success == true {
                            self.delegate?.requestFinished(request: .removeAddress, result: .Success(baseResponse))
                            completion(true, baseResponse)
                        }else {
                            self.delegate?.requestFinished(request: .removeAddress, result: .Failure(.Exception(baseResponse._message)))
                            completion(false, nil)
                        }
                        break
                        
                    case .failure(let error):
                        self.delegate?.requestFinished(request: .removeAddress, result: .Failure(.AlamofireError(error)))
                        completion(false, nil)
                        break
                    }
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Remove Address Request
    
    // MARK: - SET DEFAULT ADDRESS
    
    func setDefaultAddress(_ id: Int, completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            
            self.delegate?.requestStarted(request: .setDefaultAddress)
            
            var params: Parameters = [:]
            params["AddressID"] = id
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(SET_DEFAULT_ADDRESS, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                    switch response.result {
                    case .success(let baseResponse):
                        if baseResponse.success == true {
                            self.delegate?.requestFinished(request: .setDefaultAddress, result: .Success(baseResponse))
                            completion(true, baseResponse)
                        }else {
                            self.delegate?.requestFinished(request: .setDefaultAddress, result: .Failure(.Exception(baseResponse._message)))
                            completion(false, nil)
                        }
                        break
                        
                    case .failure(let error):
                        self.delegate?.requestFinished(request: .setDefaultAddress, result: .Failure(.AlamofireError(error)))
                        completion(false, nil)
                        break
                    }
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Set Default Address Request
    
    // MARK: - UPDATE ADDRESS
    
    func updateUserAddress(_ address: Address, completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            
            self.delegate?.requestStarted(request: .updateUserAddress)
            
            var params: Parameters = [:]
            params["AddressID"] = address._id
            params["Zone"] = address._zone
            params["BuildingNumber"] = address._buildingNumber
            params["Street"] = address._streetNumber
            params["Address"] = address._streetName
            params["AddressName"] = "NA"
            params["CIty"] = "NA"
            params["Country"] = "NA"
            params["PoBox"] = "NA"
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(UPDATE_USER_ADDRESS, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                    switch response.result {
                    case .success(let baseResponse):
                        if baseResponse.success == true {
                            self.delegate?.requestFinished(request: .updateUserAddress, result: .Success(baseResponse))
                            completion(true, baseResponse)
                        }else {
                            self.delegate?.requestFinished(request: .updateUserAddress, result: .Failure(.Exception(baseResponse._message)))
                            completion(false, nil)
                        }
                        break
                        
                    case .failure(let error):
                        self.delegate?.requestFinished(request: .updateUserAddress, result: .Failure(.AlamofireError(error)))
                        completion(false, nil)
                        break
                    }
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Update User Address Request
    
    // MARK: - SEND DEVICE TOKEN
    
    func sendDeviceToken(_ token: String, _ completion: @escaping CallObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            
            var params: Parameters = [:]
            params["DeviceToken"] = token
            params["DeviceType"] = UIDevice.current.systemName
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(SEND_DEVICE_TOKEN, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    completion(baseResponse)
                    break
                    
                case .failure(_):
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Send Device Token Request
    
    // MARK: - CHECK QID
    
    func checkQID(qidNumber: String, completion: @escaping CallBack) {
        
        if self.requestsController.isConnectedToInternet() {
            //            self.delegate?.requestStarted()
            
            let params: Parameters = [
                "IDCardNumber" : qidNumber,
            ]
            
            let headers: HTTPHeaders = self.requestsController.headers
            
            self.AlamofireManager.request(CHECK_QID, method: .get, parameters: params, headers: headers).validate().responseJSON(queue: .main, options: .mutableContainers) { (response) in
                switch response.result {
                    
                case .success(let json):
                    if let dic = json as? [String : Any],
                       let reg = dic["registered"] as? Bool {
                        //                        self.delegate?.requestFinished(result: .Success(reg))
                        completion(reg)
                    }
                    completion(false)
                    
                case .failure(_):
                    //                    self.delegate?.requestFinished(result: .Failure(.AlamofireError(error)))
                    completion(false)
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Check QID Request
    
    // MARK: - CHECK PHONE REGISTERED
    
    func checkPhoneRegisterd(phoneNumber: String, completion: @escaping CallBack) {
        
        if self.requestsController.isConnectedToInternet() {
            //            self.delegate?.requestStarted()
            
            let params: Parameters = [
                "phoneNumber" : phoneNumber,
            ]
            
            let headers: HTTPHeaders = self.requestsController.headers
            
            self.AlamofireManager.request(CHECK_PHONE_REGISTERED, method: .get, parameters: params, headers: headers).validate().responseJSON(queue: .main, options: .mutableContainers) { (response) in
                
                switch response.result {
                case .success(let json):
                    if let dic = json as? [String : Any],
                       let reg = dic["registered"] as? Bool {
                        //                        self.delegate?.requestFinished(result: .Success(reg))
                        completion(reg)
                        return
                    }
                    completion(false)
                    
                case .failure(_):
                    //                    self.delegate?.requestFinished(result: .Failure(.AlamofireError(error)))
                    completion(false)
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Check Phone Registered Request
    
    // MARK: - CHECK EMAIL REGISTERED
    
    func checkEmailRegisterd(_ email: String, _ completion: @escaping CallBack) {
        
        if self.requestsController.isConnectedToInternet() {
            //            self.delegate?.requestStarted()
            
            let params: Parameters = [
                "emailId" : email,
            ]
            
            let headers: HTTPHeaders = self.requestsController.headers
            
            self.AlamofireManager.request(CHECK_EMAIL_REGISTERED, method: .get, parameters: params, headers: headers).validate().responseJSON(queue: .main, options: .mutableContainers) { (response) in
                
                switch response.result {
                case .success(let json):
                    if let dic = json as? [String : Any],
                       let reg = dic["registered"] as? Bool {
                        //                            self.delegate?.requestFinished(result: .Success(reg))
                        completion(reg)
                        return
                    }
                    completion(false)
                    
                case .failure(_):
                    //                        self.delegate?.requestFinished(result: .Failure(.AlamofireError(error)))
                    completion(false)
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Check Email Registered Request
    
    // MARK: - GET QR CODE
    
    func getQRCode(_ completion: @escaping CallObjectBack<String>) {
        
        if self.requestsController.isConnectedToInternet() {
            
            self.delegate?.requestStarted(request: .getQRCode)
            
            let params: Parameters = [:]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_QR_CODE, method: .get, parameters: params, headers: headers).validate().responseJSON(queue: .main, options: .mutableContainers) { (response) in
                
                switch response.result {
                case .success(let json):
                    if let dic = json as? [String : Any],
                       let qrString = dic["UserQrCode"] as? String {
                        self.delegate?.requestFinished(request: .getQRCode, result: .Success(qrString))
                        completion(qrString)
                    }
                    completion(nil)
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getQRCode, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Get QR Code Request
    
    // MARK: - SEND VERIFICATION EMAIL
    
    func sendVerificationEmail(_ completion: @escaping CallObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            
            self.delegate?.requestStarted(request: .sendVerificationEmail)
            
            let params: Parameters = [:]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(SEND_VERIFICATION_EMAIL, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .sendVerificationEmail, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .sendVerificationEmail, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .sendVerificationEmail, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Send Verification Email
    
    // MARK: - UPDATE PHONE NUMBER FROM REGISTER
    
    func updatePhoneNumberFromRegister(phoneNumber: String, _ completion: @escaping CallObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .updatePhoneNumberFromRegister)
            
            var params: Parameters = [:]
            params["PhoneNumber"] = phoneNumber
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(UPDATE_PHONE_NUMBER_REGISTER, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .updatePhoneNumberFromRegister, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    } else {
                        self.delegate?.requestFinished(request: .updatePhoneNumberFromRegister, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .updatePhoneNumberFromRegister, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End UPDATE PHONE NUMBER FROM REGISTER Request
    
    // MARK: - UPDATE PHONE NUMBER AND QID
    
    func updatePhoneNumberAndQIDAndPassport(cardIDNumber: String, passportNumber: String, phoneNumber: String ,completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .updatePhoneNumberAndQID)
            
            let params: Parameters = [
                "IDCardNumber" : cardIDNumber,
                "PhoneNumber" : phoneNumber,
                "PassportNumber" : passportNumber,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(UPDATE_PHONE_NUMBER_AND_QID, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .updatePhoneNumberAndQID, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .updatePhoneNumberAndQID, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .updatePhoneNumberAndQID, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End UPDATE PHONE NUMBER AND QID Request
    
    // MARK: - GET QID IMAGE
    
    func getQIDImage(completion: @escaping ClosureObjectBack<QID>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getQIDImage)
            
            let params: Parameters = [:]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_QID_IMAGE, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<QID, AFError>) in
                
                switch response.result {
                case .success(let qid):
                    if qid.success == true {
                        self.delegate?.requestFinished(request: .getQIDImage, result: .Success(qid))
                        completion(true, qid)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getQIDImage, result: .Failure(.Exception(qid._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getQIDImage, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End GET QID IMAGE
    
    // MARK: - UPLOAD QID DETAILS
    
    func uploadQIDDetails(_ qid: QID, _ completion: @escaping CallObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .uploadQIDDetails)
            
            let params: Parameters = [
                "IDCardNumber" : qid._number,
                "ExpiryDate" : qid._expiryDate,
                "DateofBirth" : qid._dateOfBirth,
                "CountryName" : qid._countryName,
                "ReminderTypeID" : 1,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(UPLOAD_QID_DETAILS, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                    switch response.result {
                    case .success(let baseResponse):
                        if baseResponse.success == true {
                            self.delegate?.requestFinished(request: .uploadQIDDetails, result: .Success(baseResponse))
                            completion(baseResponse)
                            
                        }else {
                            self.delegate?.requestFinished(request: .uploadQIDDetails, result: .Failure(.Exception(baseResponse._message)))
                            completion(nil)
                        }
                        break
                        
                    case .failure(let error):
                        self.delegate?.requestFinished(request: .uploadQIDDetails, result: .Failure(.AlamofireError(error)))
                        completion(nil)
                        break
                    }
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Upload QID Details
    
    // MARK: - UPDATE PASSPORT DETAILS
    
    func updatePassportDetails(_ passportDetails: PassportDetails, completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .updatePassportDetails)
            
            let params: Parameters = [
                "PassportNumber" : passportDetails._number,
                "ExpiryDate" : passportDetails._expiryDate,
                "ReminderTypeID" : passportDetails._reminderTypeID,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(UPDATE_PASSPORT_DETAILS, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .updatePassportDetails, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .updatePassportDetails, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .updatePassportDetails, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Update Passport Details Request
    
    // MARK: - GET PASSPORT DETAILS
    
    func getPassportDetails(completion: @escaping ClosureObjectBack<PassportDetails>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getPassportImage)
            
            let params: Parameters = [:]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_PASSPORT_IMAGE, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<PassportDetails, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getPassportImage, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getPassportImage, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getPassportImage, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Get Passport Details Request
    
    // MARK: - SET USER PIN
    
    func setUserPin(newPin: String, completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .setUserPin)
            
            let params: Parameters = [
                "NewPin" : newPin,
                "ConfirmNewPin" : newPin,
                "LanguageId" : 1,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(SET_USER_PIN, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .setUserPin, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .setUserPin, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .setUserPin, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End SET USER PIN
    
    // MARK: - FORGET PIN CODE
    
    func forgetPinCode(completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .forgetPinCode)
            
            var params: Parameters = [:]
            
            if let user = self.userProfile.getUser() {
                params["Email"] = user._email
                params["MobileNumber"] = user._mobileNumber
                params["LanguageId"] = 1
            }
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(FORGET_PIN_CODE, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .forgetPinCode, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .forgetPinCode, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .forgetPinCode, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End FORGET PIN CODE
    
    // MARK: -  CHANGE PIN
    
    func changePIN(oldPIN: String, newPin: String, completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            if let delegate = self.delegate {
                delegate.requestStarted(request: .changePIN)
            }
            
            let params: Parameters = [
                "OldPIN" : oldPIN,
                "NewPin" : newPin,
                "ConfirmNewPin" : newPin,
                "LanguageId" : 1,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(CHANGE_PIN, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .changePIN, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .changePIN, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .changePIN, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Change PIN
    
    // MARK: - VERIFY PIN
    
    func verifyPin(pin: String, completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .verifyPin)
            
            let params: Parameters = [
                "PIN" : pin,
                "LanguageId" : 1,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(VERIFY_PIN, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .verifyPin, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .verifyPin, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .verifyPin, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Verify PIN
    
    // MARK: -  FORGET PASSWORD
    
    func forgetPassword(email: String = "", mobileNumber: String = "", completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .forgetPassword)
            
            let params: Parameters = [
                "Email" : email,
                "MobileNumber" : mobileNumber,
                "LanguageId" : 1,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(FORGET_PASSWORD, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .forgetPassword, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .forgetPassword, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .forgetPassword, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End FORGET PASSWORD
    
    // MARK: -  CONFIRM FORGET PASSWORD
    
    func confirmForgetPassword(requestID: Int, code: String, newPassword: String, completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .confirmForgetPassword)
            
            let params: Parameters = [
                "RequestID" : requestID,
                "Code" : code,
                "Password" : newPassword,
                "ConfirmPassword" : newPassword,
                "LanguageId" : 1,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(CONFIRM_FORGET_PASSWORD, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .confirmForgetPassword, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .confirmForgetPassword, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .confirmForgetPassword, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End CONFIRM FORGET PASSWORD Request
    
    // MARK: - TRANSACTIONS LIST
    
    func transactionsList(_ completion: @escaping CallArrayBack<Transaction>) {
        
        if self.requestsController.isConnectedToInternet() {
            if let delegate = self.delegate {
                delegate.requestStarted(request: .transactionsList)
            }
            let params: Parameters = [:]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(TRANSACTIONS_LIST, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<Transaction>, AFError>) in
                
                guard response.response?.statusCode != 401 else {
                    self.delegate?.requestFinished(request: .transactionsList, result: .Failure(.Exception("401")))
                    completion(nil)
                    return
                }
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .transactionsList, result: .Success(baseResponse.list))
                        completion(baseResponse.list)
                        
                    }else {
                        self.delegate?.requestFinished(request: .transactionsList, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .transactionsList, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Transactions List Request
    
    // MARK: - NOTIFICATION LIST
    
    func getNotificationList(_ completion: @escaping CallArrayBack<NotificationModel>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getNotificationList)
            
            let params: Parameters = [:]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(NOTIFICATION_LIST, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<NotificationModel>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getNotificationList, result: .Success(baseResponse.list))
                        completion(baseResponse.list)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getNotificationList, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getNotificationList, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Notification List Request
    
    // MARK: - UPDATE NOTIFICATIONS STATUS
    
    func updateNotificationStatus(_ id: Int, completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .updateNotificationStatus)
            
            let params: Parameters = [
                "NotificationID" : id,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(UPDATE_NOTIFICATION_STATUS, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .updateNotificationStatus, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .updateNotificationStatus, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .updateNotificationStatus, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Update Notification Status Request
    
    // MARK: - VALIDATE TRANSFER
    
    func validateTransfer(referenceID: Int, completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .validateTransfer)
            
            let params: Parameters = [
                "ReferenceID" : referenceID,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(VALIDATE_TRANSFER, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    self.delegate?.requestFinished(request: .validateTransfer, result: .Success(baseResponse))
                    completion(baseResponse.success == true, baseResponse)
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .validateTransfer, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Validate Transfer Request
    
    // MARK: - NOTIFICATION TYPE LIST
    
    func getNotificationTypeList(completion: @escaping ClosureArrayBack<NotificationType>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getNotificationTypeList)
            
            let params: Parameters = [:]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(NOTIFICATION_TYPE_LIST, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<NotificationType>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getNotificationTypeList, result: .Success(baseResponse.list))
                        completion(true, baseResponse.list)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getNotificationTypeList, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getNotificationTypeList, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Notification Type List Request
    
    // MARK: - PAYMENT REQUESTS LIST
    
    func paymentRequests(completion: @escaping ClosureArrayBack<PaymentRequest>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .paymentRequests)
            
            let params: Parameters = [:]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(PAYMENT_REQUESTS, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<PaymentRequest>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .paymentRequests, result: .Success(baseResponse.list))
                        completion(true, baseResponse.list)
                        
                    }else {
                        self.delegate?.requestFinished(request: .paymentRequests, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .paymentRequests, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Payment Requests Request
    
    // MARK: - CONFIRM PAYMENT REQUESTS
    
    func confirmPaymentRequests(id: Int, pinCode: String, completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .confirmPaymentRequests)
            
            let params: Parameters = [
                "ID" : id,
                "PinCode" : pinCode,
                "PlatForm" : UIDevice.current.systemName,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(CONFIRM_PAYMENT_REQUESTS, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .confirmPaymentRequests, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .confirmPaymentRequests, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .confirmPaymentRequests, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Confirm Payment Requests Request
    
    // MARK: - CANCEL PAYMENT REQUESTS
    
    func cancelPaymentRequests(id: Int, completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .cancelPaymentRequests)
            
            let params: Parameters = [
                "ID" : id,
                "PlatForm" : UIDevice.current.systemName,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(CANCEL_PAYMENT_REQUESTS, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                    switch response.result {
                    case .success(let baseResponse):
                        if baseResponse.success == true {
                            self.delegate?.requestFinished(request: .cancelPaymentRequests, result: .Success(baseResponse))
                            completion(true, baseResponse)
                            
                        }else {
                            self.delegate?.requestFinished(request: .cancelPaymentRequests, result: .Failure(.Exception(baseResponse._message)))
                            completion(false, nil)
                        }
                        break
                        
                    case .failure(let error):
                        self.delegate?.requestFinished(request: .cancelPaymentRequests, result: .Failure(.AlamofireError(error)))
                        completion(false, nil)
                        break
                    }
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Cancel Payment Requests Request
    
    // MARK: - REMOVE NOTIFICATION
    
    func removeNotification(id: Int, completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .removeNotification)
            
            let params: Parameters = [
                "NotificationID" : id
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(REMOVE_NOTIFICATION, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                    switch response.result {
                    case .success(let baseResponse):
                        if baseResponse.success == true {
                            self.delegate?.requestFinished(request: .removeNotification, result: .Success(baseResponse))
                            completion(true, baseResponse)
                            
                        }else {
                            self.delegate?.requestFinished(request: .removeNotification, result: .Failure(.Exception(baseResponse._message)))
                            completion(false, nil)
                        }
                        break
                        
                    case .failure(let error):
                        self.delegate?.requestFinished(request: .removeNotification, result: .Failure(.AlamofireError(error)))
                        completion(false, nil)
                        break
                    }
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Remove Notification Request
    
    // MARK: - COUNTRIES LIST
    
    func countriesList(completion: @escaping ClosureArrayBack<Country>) {
        
        if self.requestsController.isConnectedToInternet() {
            //            self.delegate?.requestStarted(request: .countriesList)
            
            let params: Parameters = [:]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            let url = getCountriesURL(langId: "1")
            
            self.AlamofireManager.request(url, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<Country>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        //                        self.delegate?.requestFinished(request: .countriesList, result: .Success(baseResponse.list))
                        completion(true, baseResponse.list)
                    }else {
                        //                        self.delegate?.requestFinished(request: .countriesList, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(_):
                    //                    self.delegate?.requestFinished(request: .countriesList, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Countries List Request
    
    // MARK: - REQUEST MONEY EMAIL
    
    func requestMoneyByEmail(ammount: Double, email: String, completion: @escaping ClosureObjectBack<Transfer>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .requestMoneyByEmail)
            
            let params: Parameters = [
                "Amount" : ammount,
                "PlatForm" : UIDevice.current.systemName,
                "DestinationEmail" : email,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(REQUEST_MONEY_EMAIL, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<Transfer, AFError>) in
                
                switch response.result {
                case .success(let object):
                    if object.success == true {
                        self.delegate?.requestFinished(request: .requestMoneyByEmail, result: .Success(object))
                        completion(true, object)
                    }else {
                        if object.code == "5858" {
                            self.delegate?.requestFinished(request: .requestMoneyByEmail, result: .Failure(.Exception(object._code)))
                            
                        } else {
                            self.delegate?.requestFinished(request: .requestMoneyByEmail, result:                                                                 .Failure(.Exception(object._message)))
                        }
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .requestMoneyByEmail, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Request Money Email Request
    
    // MARK: - EXTERNAL PAYMENT EMAIL
    
    func externalPaymentEmail(_ email: String, amount: Double, _ completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .externalPaymentEmail)
            
            let params: Parameters = [
                "Amount" : amount,
                "Email" : email,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(EXTERNAL_PAYMENT_EMAIL, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let object):
                    if object.success == true {
                        self.delegate?.requestFinished(request: .externalPaymentEmail, result: .Success(object))
                        completion(true, object)
                    }else {
                        self.delegate?.requestFinished(request: .externalPaymentEmail, result:                                                                 .Failure(.Exception(object._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .externalPaymentEmail, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End External Payment Email Request
    
    // MARK: - EXTERNAL PAYMENT MOBILE
    
    func externalPaymentMobile(_ mobile: String, amount: Double, _ completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .externalPaymentMobile)
            
            let params: Parameters = [
                "Amount" : amount,
                "Mobile" : mobile,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(EXTERNAL_PAYMENT_MOBILE, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let object):
                    if object.success == true {
                        self.delegate?.requestFinished(request: .externalPaymentMobile, result: .Success(object))
                        completion(true, object)
                    }else {
                        self.delegate?.requestFinished(request: .externalPaymentMobile, result:                                                                 .Failure(.Exception(object._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .externalPaymentMobile, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End External Payment Mobile Request
    
    // MARK: - REQUEST MONEY PHONE
    
    func requestMoneyByPhone(ammount: Double, phone: String, completion: @escaping ClosureObjectBack<Transfer>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .requestMoneyByEmail)
            
            let params: Parameters = [
                "Amount" : ammount,
                "PlatForm" : UIDevice.current.systemName,
                "DestinationPhoneNumber" : phone,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(REQUEST_MONEY_PHONE, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<Transfer, AFError>) in
                
                switch response.result {
                case .success(let object):
                    if object.success == true {
                        self.delegate?.requestFinished(request: .requestMoneyByPhone, result: .Success(object))
                        completion(true, object)
                    }else {
                        self.delegate?.requestFinished(request: .requestMoneyByPhone, result: .Failure(.Exception(object._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .requestMoneyByPhone, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Request Money Email Request
    
    // MARK: - REQUEST MONEY BY QPAN
    
    func requestMoneyByQPAN(amount: Double, qpanNumber: String, completion: @escaping ClosureObjectBack<Transfer>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .requestMoneyByQPAN)
            
            let params: Parameters = [
                "Amount" : amount.description,
                "PlatForm" : UIDevice.current.systemName,
                "QPAN" : qpanNumber,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(REQUEST_MONEY_QPAN, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<Transfer, AFError>) in
                
                switch response.result {
                case .success(let transfer):
                    if transfer.success == true {
                        self.delegate?.requestFinished(request: .requestMoneyByQPAN, result: .Success(transfer))
                        completion(true, transfer)
                        
                    }else {
                        self.delegate?.requestFinished(request: .requestMoneyByQPAN, result: .Failure(.Exception(transfer._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .requestMoneyByQPAN, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Request money by QPAN Request
    
    // MARK: - REQUEST MONEY By QR
    
    func requestMoneyByQR(amount: Double, QR: String, completion: @escaping ClosureObjectBack<Transfer>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .requestMoneyByQR)
            
            let params: Parameters = [
                "Amount" : amount.description,
                "PlatForm" : UIDevice.current.systemName,
                "QRCode" : QR,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(REQUEST_MONEY_QR, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<Transfer, AFError>) in
                
                switch response.result {
                case .success(let transfer):
                    if transfer.success == true {
                        self.delegate?.requestFinished(request: .requestMoneyByQR, result: .Success(transfer))
                        completion(true, transfer)
                        
                    }else {
                        self.delegate?.requestFinished(request: .requestMoneyByQR, result: .Failure(.Exception(transfer._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .requestMoneyByQR, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Request To QR Request
    
    // MARK: - PAY FROM QR CODE MERCHANT
    
    func payFromQRCode(amount: Double, QRCode: String, completion: @escaping ClosureObjectBack<Transfer>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .payFromQRCode)
            
            let params: Parameters = [
                "Amount" : amount,
                "PlatForm" : UIDevice.current.systemName,
                "QRCode" : QRCode,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(PAY_FROM_QR_CODE, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<Transfer, AFError>) in
                
                switch response.result {
                case .success(let object):
                    if object.success == true {
                        self.delegate?.requestFinished(request: .payFromQRCode, result: .Success(object))
                        completion(true, object)
                        
                    }else {
                        self.delegate?.requestFinished(request: .payFromQRCode, result: .Failure(.Exception(object._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .payFromQRCode, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Pay From QR Code Request
    
    // MARK: - VALIDATE MERCHANT QR CODE PAYMENT
    
    func validateMerchantQRCodePayment(QRCodeData: String, completion: @escaping CallObjectBack<ValidateMerchantQRCode>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .validateMerchantQRCodePayment)
            
            let params: Parameters = [
                "QrCodeData" : QRCodeData,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(VALIDATE_MERCHANT_QR_CODE_PAYMENT, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<ValidateMerchantQRCode, AFError>) in
                
                switch response.result {
                case .success(let object):
                    if object.success == true {
                        self.delegate?.requestFinished(request: .validateMerchantQRCodePayment, result: .Success(object))
                        completion(object)
                    }else {
                        self.delegate?.requestFinished(request: .validateMerchantQRCodePayment, result: .Failure(.Exception(object._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .validateMerchantQRCodePayment, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Validate Merchant QR Code Payment Request
    
    // MARK: - VALIDATE MERCHANT QR CODE WITH AMOUNT
    
    func validateMerchantQRCodeWithAmount(QRCodeData: String, completion: @escaping CallObjectBack<ValidateMerchantQRCode>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .validateMerchantQRCodeWithAmount)
            
            let params: Parameters = [
                "QrCodeData" : QRCodeData,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(VALIDATE_MERCHANT_QR_CODE_WITH_AMOUNT, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<ValidateMerchantQRCode, AFError>) in
                
                switch response.result {
                case .success(let object):
                    if object.success == true {
                        self.delegate?.requestFinished(request: .validateMerchantQRCodeWithAmount, result: .Success(object))
                        completion(object)
                    }else {
                        self.delegate?.requestFinished(request: .validateMerchantQRCodeWithAmount, result: .Failure(.Exception(object._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .validateMerchantQRCodeWithAmount, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Validate Merchant QR Code With Amount Request
    
    // MARK: - VALIDATE MERCHANT QR
    
    func validateMerchantQR(QRCodeData: String, completion: @escaping CallObjectBack<ValidateMerchantQRCode>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .validateMerchantQR)
            
            let params: Parameters = [
                "QrCodeData" : QRCodeData,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(VALIDATE_MERCHANT_QR, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<ValidateMerchantQRCode, AFError>) in
                
                switch response.result {
                case .success(let object):
                    if object.success == true {
                        self.delegate?.requestFinished(request: .validateMerchantQR, result: .Success(object))
                        completion(object)
                    }else {
                        self.delegate?.requestFinished(request: .validateMerchantQR, result: .Failure(.Exception(object._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .validateMerchantQR, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Validate Merchant QR Request
    
    // MARK: - NOQS TRANSFER QR
    
    func noqsTransferQR(accessToken: String, verificationID: String, requestID: String, pinCode: String, qrCode: String, completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .noqsTransferQR)
            
            let params: Parameters = [
                "AccessToken" : accessToken,
                "VerificationID" : verificationID,
                "RequestID" : requestID,
                "PinCode" : pinCode,
                "QrCode" : qrCode,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(NOQS_TRANSFER_QR, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let object):
                    if object.success == true {
                        self.delegate?.requestFinished(request: .noqsTransferQR, result: .Success(object))
                        completion(true, object)
                        
                    }else {
                        self.delegate?.requestFinished(request: .noqsTransferQR, result: .Failure(.Exception(object._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .noqsTransferQR, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Noqs Transfer QR Request
    
    // MARK: - TRANSFER QR CODE PAYMENT
    
    func transferQRCodePayment(pinCode: String, qrData: String, sessionID: String, uuid: String, completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .transferQRCodePayment)
            
            let params: Parameters = [
                "PinCode" : pinCode,
                "QrCodeData" : qrData,
                "SessionID" : sessionID,
                "UUID" : uuid,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(TRANSFER_QR_CODE_PAYMENT, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .transferQRCodePayment, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .transferQRCodePayment, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .transferQRCodePayment, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Transfer QRCode Payment
    
    // MARK: - TRANSFER QR CODE WITH AMOUNT
    
    func transferQRCodeWithAmount(pinCode: String, qrData: String, completion: @escaping ClosureObjectBack<ValidateMerchantQRCode>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .transferQRCodeWithAmount)
            
            let params: Parameters = [
                "PinCode" : pinCode,
                "QrCodeData" : qrData,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(TRANSFER_QR_CODE_WITH_AMOUNT, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<ValidateMerchantQRCode, AFError>) in
                
                switch response.result {
                case .success(let response):
                    if response.success == true {
                        self.delegate?.requestFinished(request: .transferQRCodeWithAmount, result: .Success(response))
                        completion(true, response)
                        
                    }else {
                        self.delegate?.requestFinished(request: .transferQRCodeWithAmount, result: .Failure(.Exception(response._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .transferQRCodeWithAmount, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Transfer QRCode With Amount
    
    // MARK: - PAY TO MERCHANT
    
    func payToMerchant(_ transfer: Transfer, pinCode: String, completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .payToMerchant)
            
            let params: Parameters = [
                "AccessToken" : transfer._accessToken,
                "VerificationID" : transfer._verificationID,
                "RequestID" : transfer._requestID,
                "PinCode" : pinCode,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(PAY_TO_MERCHANT, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let object):
                    if object.success == true {
                        self.delegate?.requestFinished(request: .payToMerchant, result: .Success(object))
                        completion(true, object)
                    }else {
                        self.delegate?.requestFinished(request: .payToMerchant, result: .Failure(.Exception(object._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .payToMerchant, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Pay To Merchant Request
    
    // MARK: - REFILL WALLET EMAIL
    
    func refillWallet(ammount: Double, completion: @escaping ClosureObjectBack<RefillWallet>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .refillWallet)
            
            let params: Parameters = [
                "Amount" : ammount,
                "PlatForm" : UIDevice.current.systemName,
                "ServiceID" : 23,
                "PaymentDescription" : "Refill",
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(REFILL_WALLET, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<RefillWallet, AFError>) in
                
                switch response.result {
                case .success(let object):
                    if object.success == true {
                        self.delegate?.requestFinished(request: .refillWallet, result: .Success(object))
                        completion(true, object)
                        
                    }else {
                        self.delegate?.requestFinished(request: .refillWallet, result: .Failure(.Exception(object._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .refillWallet, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Refill Wallet Request
    
    // MARK: - GET CHANNEL LIST
    
    func getChannelList(_ completion: @escaping CallArrayBack<Channel>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getChannelList)
            
            let params: Parameters = [:]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_CHANNEL_LIST, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<Channel>, AFError>) in
                
                switch response.result {
                case .success(let object):
                    if object.success == true {
                        self.delegate?.requestFinished(request: .getChannelList, result: .Success(object))
                        completion(object.list)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getChannelList, result: .Failure(.Exception(object._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getChannelList, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Get Channel List Request
    
    // MARK: - GET REFILL CHARGE
    
    func getRefillCharge(_ amount: Double, channelID: Int, _ completion: @escaping CallObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getRefillCharge)
            
            let params: Parameters = [:]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(getRefillChargeURL(amount, channelID: channelID), method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let object):
                    if object.success == true {
                        self.delegate?.requestFinished(request: .getRefillCharge, result: .Success(object))
                        completion(object)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getRefillCharge, result: .Failure(.Exception(object._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getRefillCharge, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Get Refill Charge Request
    
    // MARK: - TRANSFER TO PHONE
    
    func transferToPhone(amount: Double, phone: String, completion: @escaping ClosureObjectBack<Transfer>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .transferToPhone)
            
            let params: Parameters = [
                "Amount" : amount.description,
                "PlatForm" : UIDevice.current.systemName,
                "DestinationMobileNo" : phone,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(TRANSFER_TO_PHONE, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<Transfer, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .transferToPhone, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .transferToPhone, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .transferToPhone, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Transfer To Phone Request
    
    // MARK: - TRANSFER TO EMAIL
    
    func transferToEmail(amount: Double, email: String, completion: @escaping ClosureObjectBack<Transfer>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .transferToEmail)
            
            let params: Parameters = [
                "Amount" : amount.description,
                "PlatForm" : UIDevice.current.systemName,
                "DestinationEmail" : email,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(TRANSFER_TO_EMAIL, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<Transfer, AFError>) in
                
                switch response.result {
                case .success(let transfer):
                    if transfer.success == true {
                        self.delegate?.requestFinished(request: .transferToEmail, result: .Success(transfer))
                        completion(true, transfer)
                        
                    }else {
                        self.delegate?.requestFinished(request: .transferToEmail, result: .Failure(.Exception(transfer._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .transferToEmail, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Transfer To Email Request
    
    // MARK: - TRANSFER TO QPAN
    
    func transferToQPAN(amount: Double, qpanNumber: String, completion: @escaping ClosureObjectBack<Transfer>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .transferToQPAN)
            
            let params: Parameters = [
                "Amount" : amount.description,
                "PlatForm" : UIDevice.current.systemName,
                "QPanNo" : qpanNumber,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(TRANSFER_TO_QPAN, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<Transfer, AFError>) in
                
                switch response.result {
                case .success(let transfer):
                    if transfer.success == true {
                        self.delegate?.requestFinished(request: .transferToQPAN, result: .Success(transfer))
                        completion(true, transfer)
                        
                    }else {
                        self.delegate?.requestFinished(request: .transferToQPAN, result: .Failure(.Exception(transfer._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .transferToQPAN, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Transfer To QPan Request
    
    // MARK: - TRANSFER TO QR
    
    func transferToQR(amount: Double, QR: String, completion: @escaping ClosureObjectBack<Transfer>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .transferToQR)
            
            let params: Parameters = [
                "Amount" : amount.description,
                "PlatForm" : UIDevice.current.systemName,
                "QRCode" : QR,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(TRANSFER_TO_QR, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<Transfer, AFError>) in
                
                switch response.result {
                case .success(let transfer):
                    if transfer.success == true {
                        self.delegate?.requestFinished(request: .transferToQR, result: .Success(transfer))
                        completion(true, transfer)
                        
                    }else {
                        self.delegate?.requestFinished(request: .transferToQR, result: .Failure(.Exception(transfer._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .transferToQR, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Transfer To QR Request
    
    // MARK: - CONFIRM TRANSFER
    
    func confirmTransfer(_ transfer: Transfer, pinCode: String, completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .confirmTransfer)
            
            let params: Parameters = [
                "AccessToken" : transfer._accessToken,
                "VerificationID" : transfer._verificationID,
                "RequestID" : transfer._requestID,
                "PinCode" : pinCode,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(CONFIRM_TRANSFER, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .confirmTransfer, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .confirmTransfer, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .confirmTransfer, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Confirm Transfer Request
    
    // MARK: - GET BENEFICIARY LIST
    
    func getBeneficiaryList(_ completion: @escaping CallArrayBack<Beneficiary>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getBeneficiaryList)
            
            let params: Parameters = [:]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_BENEFICIARIES_LIST, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<Beneficiary>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getBeneficiaryList, result: .Success(baseResponse))
                        completion(baseResponse.list)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getBeneficiaryList, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getBeneficiaryList, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Get Beneficiary List Request
    
    // MARK: - GET BENEFICIARY BY QPAN
    
    func getBeneficiaryByQPAN(_ qpan: String, completion: @escaping ClosureObjectBack<Beneficiary>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getBeneficiaryByQPAN)
            
            let params: Parameters = [
                "QPAN" : qpan
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_BENEFICIARY_BY_QPAN, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseObjectResponse<Beneficiary>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getBeneficiaryByQPAN, result: .Success(baseResponse))
                        completion(true, baseResponse.object)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getBeneficiaryByQPAN, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getBeneficiaryByQPAN, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Get Beneficiary By QPAN Request
    
    // MARK: - GET BENEFICIARY BY QR-CODE
    
    func getBeneficiaryByQRCode(_ qrCode: String, completion: @escaping ClosureObjectBack<Beneficiary>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getBeneficiaryByQRCode)
            
            let params: Parameters = [
                "QRCode" : qrCode
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_BENEFICIARY_BY_QRCODE, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseObjectResponse<Beneficiary>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getBeneficiaryByQRCode, result: .Success(baseResponse))
                        completion(true, baseResponse.object)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getBeneficiaryByQRCode, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getBeneficiaryByQRCode, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Get Beneficiary By QRCode Request
    
    // MARK: - GET BENEFICIARY BY PHONE
    
    func getBeneficiariesByPhone(_ phone: String, completion: @escaping ClosureArrayBack<Beneficiary>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getBeneficiariesByPhone)
            
            let params: Parameters = [
                "PhoneNUmber" : phone,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_BENEFICIARIES_BY_PHONE, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<Beneficiary>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getBeneficiariesByPhone, result: .Success(baseResponse))
                        completion(true, baseResponse.list)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getBeneficiariesByPhone, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getBeneficiariesByPhone, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Get Beneficiary By Phone Request
    
    // MARK: - ADD BENEFICIARY
    
    func addBeneficiary(id: Int, completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .addBeneficiary)
            
            let params: Parameters = [
                "BeneficiaryID" : id,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(ADD_BENEFICIARY, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .addBeneficiary, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .addBeneficiary, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .addBeneficiary, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Add Beneficiary Request
    
    // MARK: - REMOVE BENEFICIARY
    
    func removeBeneficiary(id: Int, completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .removeBeneficiary)
            
            let params: Parameters = [
                "BeneficiaryID" : id,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(REMOVE_BENEFICIARY, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .removeBeneficiary, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .removeBeneficiary, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .removeBeneficiary, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Remove Beneficiary Request
    
    // MARK: - GET TOPUP CARD LIST
    
    func getTopupCardList(completion: @escaping ClosureArrayBack<Topup>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getTopupCardList)
            
            let params: Parameters = [:]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_TOPUP_CARD_LIST, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<Topup>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getTopupCardList, result: .Success(baseResponse))
                        completion(true, baseResponse.list)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getTopupCardList, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getTopupCardList, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Get Topup Card List Request
    
    // MARK: - GET TOPUP PAYMENT CARD LIST
    
    func getTopupPaymentCardList(completion: @escaping ClosureObjectBack<LibraryCardsDetails>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getTopupPaymentCardList)
            
            let params: Parameters = [:]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_TOPUP_PAYMENT_CARD_LIST, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<LibraryCardsDetails, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getTopupPaymentCardList, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getTopupPaymentCardList, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getTopupPaymentCardList, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Get Topup Payment Card List Request
    
    // MARK: - TOPUP PAYMENT SETTING
    
    func topupPaymentSetting(topupPaymentList: [Topup], completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .topupPaymentSetting)
            
            var params: Parameters = [:]
            var arrayOfdictionary = Array<Dictionary<String, Any>>()
            
            for topup in topupPaymentList {
                var objectDic = Dictionary<String, Any>()
                objectDic["PaymentCardID"] = topup.cardID ?? -1
                objectDic["isDefault"] = topup.isDefault ?? false
                
                arrayOfdictionary.append(objectDic)
            }
            
            let topupCardListParamKey = "TopupCardList"
            
            if topupPaymentList.isEmpty {
                params[topupCardListParamKey] = []
            }else {
                if let jsonData = try? JSONSerialization.data(withJSONObject: arrayOfdictionary, options: []),
                   let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []) {
                    params[topupCardListParamKey] = jsonObject
                }
            }
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(TOPUP_PAYMENT_SETTING, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .topupPaymentSetting, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .topupPaymentSetting, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .topupPaymentSetting, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Get Topup Payment Setting Request
    
    // MARK: - GET TOPUP SETTINGS
    
    func getTopupSettings(completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getTopupSettings)
            
            let params: Parameters = [:]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_TOPUP_SETTINGS, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getTopupSettings, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getTopupSettings, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getTopupSettings, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Get Topup Settings Request
    
    // MARK: - UPDATE TOPUP SETTINGS
    
    func updateTopupSettings(maxPerDay: Double, maxPerMonth: Double, defaultTopup: Double, completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .updateTopupSettings)
            
            let params: Parameters = [
                "MaxAmountPerDay" : maxPerDay,
                "MaxAmountPerMonth" : maxPerMonth,
                "DefaultTopupAmount" : defaultTopup,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(UPDATE_TOPUP_SETTINGS, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .updateTopupSettings, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .updateTopupSettings, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .updateTopupSettings, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Update Topup Settings Request
    
    // MARK: - MY LIBRARY REQUESTS ...
    
    // MARK: - GET LIBRARY PAYMENT CARDS
    
    func getLibraryPaymentCards(completion: @escaping ClosureObjectBack<LibraryCardsDetails>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getLibraryPaymentCards)
            
            let params: Parameters = [:]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_PAYMENT_CARDS, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<LibraryCardsDetails, AFError>) in
                
                switch response.result {
                case .success(let object):
                    if object.success == true {
                        self.delegate?.requestFinished(request: .getLibraryPaymentCards, result: .Success(object))
                        completion(true, object)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getLibraryPaymentCards, result: .Failure(.Exception(object._message)))
                        completion(false, nil)
                    }
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getLibraryPaymentCards, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Get Payment Cards Request
    
    // MARK: - ADD LIBRARY PAYMENT CARD
    
    func addLibraryPaymentCard(card: LibraryCard, completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .addLibraryPaymentCard)
            
            let params: Parameters = [
                "CardName" : card._name,
                "CardType" : card._cardType,
                "CardNumber" : card._number,
                "OwnerName" : card._ownerName,
                "ExpiryDate" : card._expiryDate,
                "CVV" : card._cvv,
                "PaymentCardType" : card._paymentCardType,
                "ReminderType" : card._reminderType,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(ADD_PAYMENT_CARD, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .addLibraryPaymentCard, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .addLibraryPaymentCard, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .addLibraryPaymentCard, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Add Library Payment Card Request
    
    // MARK: - UPDATE LIBRARY PAYMENT CARD
    
    func updateLibraryPaymentCard(_ id: Int, card: LibraryCard, completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .updateLibraryPaymentCard)
            
            let params: Parameters = [
                "CardName" : card._name,
                "CardType" : card._cardType,
                "CardNumber" : card._number,
                "OwnerName" : card._ownerName,
                "ExpiryDate" : card._expiryDate,
                "CVV" : card._cvv,
                "PaymentCardType" : card._paymentCardType,
                "ReminderType" : card._reminderType,
                "PaymentCardID" : id,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(UPDATE_PAYMENT_CARD, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .updateLibraryPaymentCard, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .updateLibraryPaymentCard, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .updateLibraryPaymentCard, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Update Library Payment Card Request
    
    // MARK: - DELETE LIBRARY PAYMENT CARD
    
    func deleteLibraryPaymentCard(cardID: Int, completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .deleteLibraryPaymentCard)
            
            let params: Parameters = [:]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            let url = deletePaymentCardURL(cardID.description)
            
            self.AlamofireManager.request(url, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                    
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .deleteLibraryPaymentCard, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .deleteLibraryPaymentCard, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .deleteLibraryPaymentCard, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Delete Library Payment Card Request
    
    // MARK: - BANK DETAILS
    
    func bankDetails(completion: @escaping ClosureArrayBack<Bank>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .bankDetails)
            
            let params: Parameters = [:]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(BANK_DETAILS, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<Bank>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .bankDetails, result: .Success(baseResponse))
                        completion(true, baseResponse.list)
                        
                    }else {
                        self.delegate?.requestFinished(request: .bankDetails, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .bankDetails, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Bank Details Request
    
    // MARK: - BANK DETAILS
    
    func getBankNameList(completion: @escaping ClosureArrayBack<BankName>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getBankNameList)
            
            let params: Parameters = [:]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(BANK_NAME_LIST, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<BankName>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getBankNameList, result: .Success(baseResponse))
                        completion(true, baseResponse.list)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getBankNameList, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getBankNameList, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Bank Details Request
    
    // MARK: - ADD BANK DETAILS
    
    func addBankDetails(bank: Bank, bankName: BankName, completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .addBankDetails)
            
            let params: Parameters = [
                "CountryName" : bank._countryName,
                "AccountName" : bank._accountName,
                "BankName" : bankName._text,
                "BankNameID" : bankName._id,
                "AccountNumber" : bank._accountNumber,
                "IBAN" : bank._iban,
                "SwiftCode" : bank._swiftCode,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(ADD_BANK_DETAILS, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .addBankDetails, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .addBankDetails, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .addBankDetails, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Add Bank Details Request
    
    // MARK: - UPDATE BANK DETAILS
    
    func updateBankDetails(_ id: Int, bank: Bank, bankName: BankName, completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .updateBankDetails)
            
            let params: Parameters = [
                "CountryName" : bank._countryName,
                "AccountName" : bank._accountName,
                "BankName" : bankName._text,
                "BankNameID" : bankName._id,
                "AccountNumber" : bank._accountNumber,
                "SwiftCode" : bank._swiftCode,
                "IBAN" : bank._iban,
                "BankDetailID" : id,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(UPDATE_BANK_DETAILS, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .updateBankDetails, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .updateBankDetails, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .updateBankDetails, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Update Bank Details Request
    
    // MARK: - DELETE BANK
    
    func deleteBank(bankID: Int, completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .deleteBank)
            
            let params: Parameters = [:]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            let url = deleteBankURL(bankID.description)
            
            self.AlamofireManager.request(url, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .deleteBank, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .deleteBank, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .deleteBank, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Delete Bank Request
    
    // MARK: - GET LOYALTY LIST
    
    func getLoyaltyList(completion: @escaping ClosureArrayBack<Loyalty>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getLoyaltyList)
            
            let params: Parameters = [:]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_LOYALTY_LIST, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<Loyalty>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getLoyaltyList, result: .Success(baseResponse))
                        completion(true, baseResponse.list)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getLoyaltyList, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getLoyaltyList, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Get Loyalty List Request
    
    // MARK: - GET LOYALTY BRAND LIST
    
    func getLoyaltyBrandList(completion: @escaping ClosureArrayBack<LoyaltyBrand>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getLoyaltyBrandList)
            
            let params: Parameters = [:]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_LOYALTY_BRAND_LIST, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<LoyaltyBrand>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getLoyaltyBrandList, result: .Success(baseResponse))
                        completion(true, baseResponse.list)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getLoyaltyBrandList, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getLoyaltyBrandList, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Get Loyalty List Request
    
    // MARK: - DELETE LOYALTY
    
    func deleteLoyalty(id: Int, completion: @escaping ClosureArrayBack<Loyalty>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .deleteLoyalty)
            
            let params: Parameters = [
                "ID" : id
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(DELETE_LOYALTY, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<Loyalty>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .deleteLoyalty, result: .Success(baseResponse))
                        completion(true, baseResponse.list)
                        
                    }else {
                        self.delegate?.requestFinished(request: .deleteLoyalty, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .deleteLoyalty, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Delete Loyalty Request
    
    // MARK: - ADD LOYALTY
    
    func addLoyalty(_ card: Loyalty, FrontSideImageID: Int, BackSideImageID: Int, completion: @escaping ClosureArrayBack<Loyalty>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .addLoyalty)
            
            let params: Parameters = [
                "CardNumber" : card._number,
                "Name" : card._name,
                "Brand" : card._brand,
                "CardName" : card._cardName,
                "ExpiryDate" : card._expiryDate,
                "ReminderType" : card._reminderType,
                "FrontSideImageID" : FrontSideImageID,
                "BackSideImageID" : BackSideImageID,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(ADD_LOYALTY, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<Loyalty>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .addLoyalty, result: .Success(baseResponse))
                        completion(true, baseResponse.list)
                        
                    }else {
                        self.delegate?.requestFinished(request: .addLoyalty, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .addLoyalty, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Add Loyalty Request
    
    // MARK: - UPDATE LOYALTY
    
    func updateLoyalty(_ id: Int, card: Loyalty, FrontSideImageID: Int, BackSideImageID: Int, completion: @escaping ClosureArrayBack<Loyalty>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .updateLoyalty)
            
            let params: Parameters = [
                "ID" : id,
                "CardNumber" : card._number,
                "Name" : card._name,
                "Brand" : card._brand,
                "CardName" : card._cardName,
                "ExpiryDate" : card._expiryDate,
                "ReminderType" : card._reminderType,
                "FrontSideImageID" : FrontSideImageID,
                "BackSideImageID" : BackSideImageID,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(UPDATE_LOYALTY, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<Loyalty>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .updateLoyalty, result: .Success(baseResponse))
                        completion(true, baseResponse.list)
                        
                    }else {
                        self.delegate?.requestFinished(request: .updateLoyalty, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .updateLoyalty, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Update Loyalty Request
    
    // MARK: - ADD DRIVING LICENSE
    
    func addDrivingLicense(_ license: DrivingLicense, frontSideImageID: Int, backSideImageID: Int, completion: @escaping ClosureObjectBack<IDLicenses>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .addDrivingLicense)
            
            let params: Parameters = [
                "Name" : license.name ?? "",
                "Nationality" : license.nationality ?? "",
                "DateofBirth" : license.dateofBirth ?? "",
                "BloodType" : license.bloodType ?? "",
                "FirstIssueDate" : license.firstIssueDate ?? "",
                "Validity" : license.validity ?? "",
                "ReminderType" : license.reminderType ?? "",
                "FrontSideImageID" : frontSideImageID,
                "BackSideImageID" : backSideImageID,
                "LicenceNumber" : license.number ?? "",
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(ADD_DRIVING_LICENSE, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<IDLicenses, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .addDrivingLicense, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .addDrivingLicense, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .addDrivingLicense, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Add Driving License Request
    
    // MARK: - GET DRIVING LICENSE LIST
    
    func getDrivingLicenseList(completion: @escaping ClosureObjectBack<IDLicenses>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getDrivingLicenseList)
            
            let params: Parameters = [:]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_DRIVING_LICENSE_LIST, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<IDLicenses, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getDrivingLicenseList, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getDrivingLicenseList, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getDrivingLicenseList, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
        
    } // End Get Driving License List Request
    
    // MARK: - DELETE DRIVING LICENSE
    
    func deleteDrivingLicense(id: Int, completion: @escaping ClosureObjectBack<IDLicenses>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .deleteDrivingLicense)
            
            let params: Parameters = [
                "ID" : id
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(DELETE_DRIVING_LICENSE, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<IDLicenses, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .deleteDrivingLicense, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .deleteDrivingLicense, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .deleteDrivingLicense, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Delete Driving License Request
    
    // MARK: - UPDATE DRIVING LICENSE
    
    func updateDrivingLicense(_ id: Int, license: DrivingLicense, frontSideImageID: Int, backSideImageID: Int, completion: @escaping ClosureObjectBack<IDLicenses>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .updateDrivingLicense)
            
            let params: Parameters = [
                "ID" : id,
                "Name" : license.name ?? "",
                "Nationality" : license.nationality ?? "",
                "DateofBirth" : license.dateofBirth ?? "",
                "BloodType" : license.bloodType ?? "",
                "FirstIssueDate" : license.firstIssueDate ?? "",
                "Validity" : license.validity ?? "",
                "ReminderType" : license.reminderType ?? "",
                "FrontSideImageID" : frontSideImageID,
                "BackSideImageID" : backSideImageID,
                "LicenceNumber" : license.number ?? "",
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(UPDATE_DRIVING_LICENSE, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<IDLicenses, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .updateDrivingLicense, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .updateDrivingLicense, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .updateDrivingLicense, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Update Driving License Request
    
    // MARK: - GET ID CARD LIST
    
    func getIDCardList(completion: @escaping ClosureObjectBack<IDLicenses>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getIDCardList)
            
            let params: Parameters = [:]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_ID_CARD_LIST, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<IDLicenses, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getIDCardList, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getIDCardList, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getIDCardList, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Get ID Card List Request
    
    // MARK: - ADD ID CARD
    
    func addIDCard(_ card: IDCard, frontSideImageID: Int, backSideImageID: Int, completion: @escaping ClosureObjectBack<IDLicenses>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .addIDCard)
            
            let params: Parameters = [
                "Name" : card.name ?? "",
                "Nationality" : card.nationality ?? "",
                "DateofBirth" : card.dateofBirth ?? "",
                "PlaceofIssue" : card.placeOfIssue ?? "",
                "DateofIssue" : card.dateofIssue ?? "",
                "DateofExpiry" : card.dateofExpiry ?? "",
                "ReminderType" : card.reminderType ?? "",
                "FrontSideImageID" : frontSideImageID,
                "BackSideImageID" : backSideImageID,
                "IDCardNumber" : card.number ?? "",
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(ADD_ID_CARD, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<IDLicenses, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .addIDCard, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .addIDCard, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .addIDCard, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Add ID Card Request
    
    // MARK: - DELETE ID CARD
    
    func deleteIDCard(id: Int, completion: @escaping ClosureObjectBack<IDLicenses>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .deleteIDCard)
            
            let params: Parameters = [
                "ID" : id
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(DELETE_ID_CARD, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<IDLicenses, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .deleteIDCard, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .deleteIDCard, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .deleteIDCard, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Delete ID Card Request
    
    // MARK: - UPDATE ID CARD
    
    func updateIDCard(id: Int, card: IDCard, frontSideImageID: Int, backSideImageID: Int, completion: @escaping ClosureObjectBack<IDLicenses>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .updateIDCard)
            
            let params: Parameters = [
                "ID" : id,
                "Name" : card.name ?? "",
                "Nationality" : card.nationality ?? "",
                "DateofBirth" : card.dateofBirth ?? "",
                "PlaceofIssue" : card.placeOfIssue ?? "",
                "DateofIssue" : card.dateofIssue ?? "",
                "DateofExpiry" : card.dateofExpiry ?? "",
                "ReminderType" : card.reminderType ?? "",
                "FrontSideImageID" : frontSideImageID,
                "BackSideImageID" : backSideImageID,
                "IDCardNumber" : card.number ?? "",
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(UPDATE_ID_CARD, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<IDLicenses, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .updateIDCard, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .updateIDCard, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .updateIDCard, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Update ID Card Request
    
    // MARK: - GET ID CARD LIST
    
    func getPassportList(completion: @escaping ClosureArrayBack<Passport>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getPassportList)
            
            let params: Parameters = [:]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_PASSPORT_LIST, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<Passport>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getPassportList, result: .Success(baseResponse))
                        completion(true, baseResponse.list)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getPassportList, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getPassportList, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Get Passport List Request
    
    // MARK: - ADD PASSPORT
    
    func addPassport(_ passport: Passport, passportImageID: Int, completion: @escaping ClosureArrayBack<Passport>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .addPassport)
            
            let params: Parameters = [
                "PasssportNumber" : passport._number,
                "PassportType" : passport._type,
                "PlaceofIssue" : passport._placeOfIssue,
                "SurName" : passport._surName,
                "GivenName" : passport._givenName,
                "DateofBirth" : passport._dateOfBirth,
                "DateofIssue" : passport._dateOfIssue,
                "DateofExpiry" : passport._dateOfExpiry,
                "ReminderType" : passport._reminderType,
                "PassportImageID" : passportImageID,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(ADD_PASSPORT, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<Passport>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .addPassport, result: .Success(baseResponse))
                        completion(true, baseResponse.list)
                        
                    }else {
                        self.delegate?.requestFinished(request: .addPassport, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .addPassport, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Add Passport Request
    
    // MARK: - DELETE PASSPORT
    
    func deletePassport(id: Int, completion: @escaping ClosureArrayBack<Passport>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .deletePassport)
            
            let params: Parameters = [
                "ID" : id
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(DELETE_PASSPORT, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<Passport>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .deletePassport, result: .Success(baseResponse))
                        completion(true, baseResponse.list)
                        
                    }else {
                        self.delegate?.requestFinished(request: .deletePassport, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .deletePassport, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Delete Passport Request
    
    // MARK: - UPDATE PASSPORT
    
    func updatePassport(_ id: Int, passport: Passport, passportImageID: Int, completion: @escaping ClosureArrayBack<Passport>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .updatePassport)
            
            let params: Parameters = [
                "ID" : id,
                "PasssportNumber" : passport._number,
                "PassportType" : passport._type,
                "PlaceofIssue" : passport._placeOfIssue,
                "SurName" : passport._surName,
                "GivenName" : passport._givenName,
                "DateofBirth" : passport._dateOfBirth,
                "DateofIssue" : passport._dateOfIssue,
                "DateofExpiry" : passport._dateOfExpiry,
                "ReminderType" : passport._reminderType,
                "PassportImageID" : passportImageID,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(UPDATE_PASSPORT, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<Passport>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .updatePassport, result: .Success(baseResponse))
                        completion(true, baseResponse.list)
                        
                    }else {
                        self.delegate?.requestFinished(request: .updatePassport, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .updatePassport, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Update Passport Request
    
    // MARK: - GET DOCUMENT LIST
    
    func getDocumentList(completion: @escaping ClosureArrayBack<Document>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getDocumentList)
            
            let params: Parameters = [:]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_DOCUMENT_LIST, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<Document>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getDocumentList, result: .Success(baseResponse))
                        completion(true, baseResponse.list)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getDocumentList, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getDocumentList, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Get Document List Request
    
    // MARK: - DELETE DOCUMENT
    
    func deleteDocument(id: Int, completion: @escaping ClosureArrayBack<Document>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .deleteDocument)
            
            let params: Parameters = [
                "ID" : id
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(DELETE_DOCUMENT, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<Document>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .deleteDocument, result: .Success(baseResponse))
                        completion(true, baseResponse.list)
                        
                    }else {
                        self.delegate?.requestFinished(request: .deleteDocument, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .deleteDocument, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Delete Document Request
    
    // MARK: - ADD DOCUMENT
    
    func addDocument(_ document: Document, documentLocationID: Int, completion: @escaping ClosureArrayBack<Document>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .addDocument)
            
            let params: Parameters = [
                "DocuemntName" : document._name,
                "DocumentType" : document._type,
                "DocumentLocationID" : documentLocationID,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(ADD_DOCUMENT, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<Document>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .addDocument, result: .Success(baseResponse))
                        completion(true, baseResponse.list)
                        
                    }else {
                        self.delegate?.requestFinished(request: .addDocument, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .addDocument, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
        
    } // End Add Document Request
    
    // MARK: - UPDATE DOCUMENT
    
    func updateDocument(id: Int, document: Document, documentLocationID: Int, completion: @escaping ClosureArrayBack<Document>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .updateDocument)
            
            let params: Parameters = [
                "ID" : id,
                "DocuemntName" : document._name,
                "DocumentType" : document._type,
                "DocumentLocationID" : documentLocationID,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(UPDATE_DOCUMENT, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<Document>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .updateDocument, result: .Success(baseResponse))
                        completion(true, baseResponse.list)
                        
                    }else {
                        self.delegate?.requestFinished(request: .updateDocument, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .updateDocument, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Update Loyalty Request
    
    
    
    // MARK: - E-STORE REQUESTS ...
    
    
    
    // MARK: - DASHBOARD CHART DATA
    
    func dashboardChartData(_ completion: @escaping CallObjectBack<DashboardChart>) {
        
        if self.requestsController.isConnectedToInternet() {
            if let delegate = self.delegate {
                delegate.requestStarted(request: .dashboardChartData)
            }
            let params: Parameters = [:]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_DASHBOARD_CHART_DATA, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<DashboardChart, AFError>) in
                
                switch response.result {
                case .success(let dashboardChartData):
                    if dashboardChartData.success == true {
                        self.delegate?.requestFinished(request: .dashboardChartData, result: .Success(dashboardChartData))
                        completion(dashboardChartData)
                        
                    }else {
                        self.delegate?.requestFinished(request: .dashboardChartData, result: .Failure(.Exception(dashboardChartData._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .dashboardChartData, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Dashboard Chart Data Request
    
    // MARK: - DASHBOARD DATA
    
    func dashboardData(_ completion: @escaping CallObjectBack<Dashboard>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .dashboardData)
            
            let params: Parameters = [
                "LanguageId" : 1
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(DASHBOARD_DATA, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<Dashboard, AFError>) in
                
                //                if let data = response.data,
                //                   let string = String(data: data, encoding: .utf8) {
                //                    print("Response Data => \(string)")
                //                }
                
                switch response.result {
                case .success(let dashboard):
                    if dashboard.success == true {
                        self.delegate?.requestFinished(request: .dashboardData, result: .Success(dashboard))
                        completion(dashboard)
                    } else {
                        self.delegate?.requestFinished(request: .dashboardData, result: .Failure(.Exception(dashboard._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .dashboardData, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Dashboard Data Request
    
    // MARK: - UPDATE SHOP DETAILS
    
    func updateShopDetails(_ shopID: Int, shopName: String, shopDescription: String, _ completion: @escaping CallObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .updateShopDetails)
            
            let params: Parameters = [
                "ShopID" : shopID,
                "ShopName" : shopName,
                "ShopDescription" : shopDescription,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(UPDATE_SHOP_DETAILS, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .updateShopDetails, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .updateShopDetails, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .updateShopDetails, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Update Shop Details Request
    
    // MARK: - UPDATE SHOP STATUS
    
    func updateShopStatus(shopID: Int, completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .updateShopStatus)
            
            let params: Parameters = [
                "ShopID" : shopID
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(UPDATE_SHOP_STATUS, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .updateShopStatus, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .updateShopStatus, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .updateShopStatus, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Update Shop Status Request
    
    // MARK: - SHOP LIST
    
    func getShopList(_ completion: @escaping CallArrayBack<Shop>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getShopList)
            
            let params: Parameters = [:]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_SHOP_LIST, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<Shop>, AFError>) in
                
                switch response.result {
                case .success(let shopResponse):
                    if shopResponse.success == true {
                        self.delegate?.requestFinished(request: .getShopList, result: .Success(shopResponse.list))
                        completion(shopResponse.list)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getShopList, result: .Failure(.Exception(shopResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getShopList, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Shop List Request
    
    // MARK: - PRODUCT LIST BY SHOP ID
    
    func getProductListByShopID(shopID: Int, completion: @escaping ClosureArrayBack<Shop>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getProductListByShopID)
            
            let params: Parameters = [:]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            let url = getProductsByShopIDURL(shopID: shopID.description)
            
            self.AlamofireManager.request(url, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<Shop>, AFError>) in
                
                switch response.result {
                case .success(let shopResponse):
                    if shopResponse.success == true {
                        self.delegate?.requestFinished(request: .getProductListByShopID, result: .Success(shopResponse.list))
                        completion(true, shopResponse.list)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getProductListByShopID, result: .Failure(.Exception(shopResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getProductListByShopID, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Product List By ShopID Request
    
    // MARK: - ORDER LIST BY SHOP ID
    
    func getOrderListByShopID(shopID: Int, completion: @escaping ClosureArrayBack<Order>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getOrderListByShopID)
            
            let params: Parameters = [:]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            let url = getOrderListByShopIDURL(shopID: shopID.description)
            
            self.AlamofireManager.request(url, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<Order>, AFError>) in
                
                switch response.result {
                case .success(let shopResponse):
                    if shopResponse.success == true {
                        self.delegate?.requestFinished(request: .getOrderListByShopID, result: .Success(shopResponse.list))
                        completion(true, shopResponse.list)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getOrderListByShopID, result: .Failure(.Exception(shopResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getOrderListByShopID, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Order List By ShopID Request
    
    // MARK: - DELETE ORDER
    
    func deleteOrder(_ orderID: Int, shopID: Int, _ completion: @escaping CallObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .deleteOrder)
            
            let params: Parameters = [
                "OrderID" : orderID,
                "ShopID" : shopID,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(DELETE_ORDER, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .deleteOrder, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .deleteOrder, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .deleteOrder, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Delete Order Request
    
    // MARK: - ARCHIVE ORDER
    
    func archiveOrder(_ orderID: Int, shopID: Int, _ completion: @escaping CallObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .archiveOrder)
            
            let params: Parameters = [
                "OrderId" : orderID,
                "ShopId" : shopID,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(ARCHIVE_ORDER, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .archiveOrder, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .archiveOrder, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .archiveOrder, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Archive Order Request
    
    // MARK: - MARK ORDER AS READ
    
    func markOrderAsRead(orderID: Int, shopID: Int, completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .markOrderAsRead)
            
            let params: Parameters = [
                "ShopID" : shopID,
                "OrderID" : orderID,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(MARK_ORDER_AS_READ, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .markOrderAsRead, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .markOrderAsRead, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .markOrderAsRead, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Mark Order As Read Request
    
    // MARK: - RESEND ORDER
    
    func resendOrder(_ orderID: Int, shopID: Int, orderNumber: String, completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .resendOrder)
            
            let params: Parameters = [
                "ShopID" : shopID,
                "OrderID" : orderID,
                "OrderNumber" : orderNumber,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(RESEND_ORDER, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .resendOrder, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .resendOrder, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .resendOrder, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Resend Order Request
    
    // MARK: - ADD PRODUCT
    
    func addProduct(shopID: Int, product: Product, imageID: Int, completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .addProduct)
            
            let params: Parameters = [
                "ShopID" : shopID,
                "ProductName" : product._name,
                "ProductNameAR" : product.nameAR ?? "NA",
                "ProductDescription" : product._description,
                "ProductDescriptionAR" : product.descriptionAR ?? "NA",
                "ProductPrice" : product._price,
                "ImageID" : imageID,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(ADD_PRODUCT, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .addProduct, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .addProduct, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .addProduct, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Add Product Request
    
    // MARK: - UPDATE PRODUCT
    
    func updateProduct(shopID: Int, product: Product, completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .updateProduct)
            
            let params: Parameters = [
                "ShopID" : shopID,
                "ProductID" : product._id,
                "ProductName" : product._name,
                "ProductDescription" : product._description,
                "ProductPrice" : product._price,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(UPDATE_PRODUCT, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .updateProduct, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .updateProduct, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .updateProduct, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Add Product Request
    
    // MARK: - REMOVE PRODUCT
    
    func removeProduct(shopID: Int, productID: Int, completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .removeProduct)
            
            let params: Parameters = [
                "ShopID" : shopID,
                "ProductID" : productID,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(REMOVE_PRODUCT, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .removeProduct, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .removeProduct, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .removeProduct, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Remove Product Request
    
    // MARK: - UPDATE PRODUCT STATUS
    
    func updateProductStatus(_ productID: Int, shopID: Int, completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .updateProductStatus)
            
            let params: Parameters = [
                "ShopID" : shopID,
                "ProductID" : productID,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(UPDATE_PRODUCT_STATUS, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .updateProductStatus, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .updateProductStatus, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .updateProductStatus, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Remove Product Request
    
    // MARK: - GET ORDER LIST
    
    func getOrderList(_ completion: @escaping CallArrayBack<Order>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getOrderList)
            
            let params: Parameters = [
                "LanguageId" : 1
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_ORDER_LIST, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<Order>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getOrderList, result: .Success(baseResponse))
                        completion(baseResponse.list)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getOrderList, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getOrderList, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Get Order List Request
    
    // MARK: - GET ARCHIVE ORDER LIST
    
    func getArchiveOrderList(_ completion: @escaping CallArrayBack<Order>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getArchiveOrderList)
            
            let params: Parameters = [:]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_ARCHIVE_ORDER_LIST, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<Order>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getArchiveOrderList, result: .Success(baseResponse))
                        completion(baseResponse.list)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getArchiveOrderList, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getArchiveOrderList, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Get Archive Order List Request
    
    // MARK: - GET ORDER DETAILS
    
    func getOrderDetails(_ orderID: Int, completion: @escaping ClosureObjectBack<Order>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getOrderDetails)
            
            let params: Parameters = [
                "OrderID" : orderID
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_ORDER_DETAILS, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseObjectResponse<Order>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getOrderDetails, result: .Success(baseResponse))
                        completion(true, baseResponse.object)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getOrderDetails, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getOrderDetails, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Get Order Details Request
    
    // MARK: - GET ORDER LIST BY FILTER
    
    func getOrderListByFilter(shopID: Int, fromDate: String, toDate: String, completion: @escaping ClosureArrayBack<Order>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getOrderListByFilter)
            
            let params: Parameters = [:]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            let url = getOrderListByFilterURL(shopID: shopID.description, fromDate: fromDate, toDate: toDate)
            
            self.AlamofireManager.request(url, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<Order>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getOrderListByFilter, result: .Success(baseResponse))
                        completion(true, baseResponse.list)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getOrderListByFilter, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getOrderListByFilter, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Get Order List By Filter Request
    
    // MARK: - CREATE SHOP ORDER
    
    func createShopOrder(shopID: Int, order: Order, items: [OrderItem], completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .createShopOrder)
            
            let dateString = order._orderDate
            let dueDateString = order._orderDueDate
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let date = dateFormatter.date(from: dateString)
            let dueDate = dateFormatter.date(from: dueDateString)
            
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let myDate = dateFormatter.string(from: date!)
            let myDueDate = dateFormatter.string(from: dueDate!)
            
            var params: Parameters = [:]
            params["OrderNumber"] = order._orderNumber
            params["OrderDate"] = myDate
            params["OrderDueDate"] = myDueDate
            params["OrderNote"] = order._orderNote
            params["CustomerName"] = order._customerName
            params["CustomerEmail"] = order._customerEmail
            params["CustomerMobile"] = order._customerMobile
            params["CompanyName"] = order._companyName
            params["Discount"] = order._discount
            params["DeliveryCharges"] = order._deliveryCharges
            params["ShopID"] = shopID
            
            for (index, value) in items.enumerated() {
                var objectDic = [String : Any]()
                
                objectDic["ShopID"] = shopID
                objectDic["ProductID"] = value.ProductID
                objectDic["Quantity"] = value.Quantity
                
                params["ProductList[\(index)]"] = objectDic
            }
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(CREATE_SHOP_ORDER, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .createShopOrder, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .createShopOrder, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .createShopOrder, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Create Shop Order Request
    
    // MARK: - GET SUBSCRIPTION STATUS BY SHOP ID
    
    func getSubscriptionStatus(shopID: Int, completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getSubscriptionStatus)
            
            let params: Parameters = [:]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            let url = getSubscriptionStatusURL(shopID: shopID)
            
            self.AlamofireManager.request(url, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getSubscriptionStatus, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getSubscriptionStatus, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getSubscriptionStatus, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Get Subscription Status Request
    
    // MARK: - SUBSCRIPTION CHARGES
    
    func subscriptionCharges(shopID: Int, completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .subscriptionCharges)
            
            let params: Parameters = [:]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            let url = getSubscriptionStatusURL(shopID: shopID)
            
            self.AlamofireManager.request(url, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .subscriptionCharges, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .subscriptionCharges, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .subscriptionCharges, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Subscription Charges Request
    
    // MARK: - GET PHONE USER OPERATORS
    
    func getPhoneUserOperators(completion: @escaping ClosureArrayBack<PhoneOperator>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getPhoneUserOperators)
            
            let params: Parameters = [
                "LanguageId" : 1
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_PHONE_USER_OPERATORS, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<PhoneOperator>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getPhoneUserOperators, result: .Success(baseResponse))
                        completion(true, baseResponse.list)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getPhoneUserOperators, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getPhoneUserOperators, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Get Phone User Operators Request
    
    // MARK: - ADD PHONE TO GROUP
    
    func addPhoneToGroup(groupID: Int, phoneNumber: String, QID: String, subscriberName: String, operatorID: Int, completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .addPhoneToGroup)
            
            let params: Parameters = [
                "GroupID" : groupID,
                "PhoneNumber" : phoneNumber,
                "QID" : QID,
                "SubscriberName" : subscriberName,
                "OperatorID" : operatorID,
                "LanguageId" : 1,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(ADD_PHONE_TO_GROUP, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .addPhoneToGroup, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .addPhoneToGroup, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .addPhoneToGroup, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Add Phone To Group Request
    
    // MARK: - GET PHONE USER GROUPS
    
    func getPhoneUserGroups(operatorID: Int, completion: @escaping ClosureArrayBack<Group>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getPhoneUserGroups)
            
            let params: Parameters = [
                "LanguageId" : 1
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            let url = getPhoneUserGroupURL(operatorID: operatorID)
            
            self.AlamofireManager.request(url, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<Group>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getPhoneUserGroups, result: .Success(baseResponse))
                        completion(true, baseResponse.list)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getPhoneUserGroups, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getPhoneUserGroups, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Get Phone User Groups Request
    
    // MARK: - SAVE PHONE USER GROUPS
    
    func savePhoneUserGroups(groupName: String, operatorID: Int, description: String = "", completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .savePhoneUserGroups)
            
            let params: Parameters = [
                "GroupName" : groupName,
                "OperatorID" : operatorID,
                "GroupDescription" : description,
                "LanguageId" : 1,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(SAVE_PHONE_USER_GROUP, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .savePhoneUserGroups, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .savePhoneUserGroups, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .savePhoneUserGroups, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Save Phone User Group Request
    
    // MARK: - GET GROUP LIST WITH PHONE NUMBERS
    
    func getGroupListWithPhoneNumbers(operatorID: Int, completion: @escaping ClosureObjectBack<BaseArrayResponse<GroupWithNumbers<PhoneNumber>>>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getGroupListWithPhoneNumbers)
            
            let params: Parameters = [
                "OperatorID" : operatorID
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_GROUP_LIST_WITH_PHONE_NUMBERS, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<GroupWithNumbers<PhoneNumber>>, AFError>) in
                
                DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                    switch response.result {
                    case .success(let baseResponse):
                        if baseResponse.success == true {
                            self.delegate?.requestFinished(request: .getGroupListWithPhoneNumbers, result: .Success(baseResponse))
                            completion(true, baseResponse)
                            
                        }else {
                            self.delegate?.requestFinished(request: .getGroupListWithPhoneNumbers, result: .Failure(.Exception(baseResponse._message)))
                            completion(false, nil)
                        }
                        break
                        
                    case .failure(let error):
                        self.delegate?.requestFinished(request: .getGroupListWithPhoneNumbers, result: .Failure(.AlamofireError(error)))
                        completion(false, nil)
                        break
                    }
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Get Group List With Phone Numbers Request
    
    // MARK: - ADD KAHRAMAA TO GROUP
    
    func addKahramaaToGroup(groupID: Int, kahramaNumber: String, QID: String, subscriberName: String, completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .addKahramaaToGroup)
            
            let params: Parameters = [
                "GroupID" : groupID,
                "KaharmaNumber" : kahramaNumber,
                "QID" : QID,
                "SubscriberName" : subscriberName,
                "LanguageId" : 1,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(ADD_KAHRAMAA_TO_GROUP, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .addKahramaaToGroup, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .addKahramaaToGroup, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .addKahramaaToGroup, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Add Kahramaa To Group Request
    
    // MARK: - GET KAHRAMAA USER GROUPS
    
    func getKahramaaUserGroups(completion: @escaping ClosureArrayBack<Group>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getKahramaaUserGroups)
            
            let params: Parameters = [
                "LanguageId" : 1
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_KAHRAMAA_USER_GROUPS, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<Group>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getKahramaaUserGroups, result: .Success(baseResponse))
                        completion(true, baseResponse.list)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getKahramaaUserGroups, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getKahramaaUserGroups, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Get Kahramaa User Groups Request
    
    // MARK: - SAVE KAHRAMAA USER GROUPS
    
    func saveKahramaaUserGroups(groupName: String, description: String = "", completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .saveKahramaaUserGroups)
            
            let params: Parameters = [
                "GroupName" : groupName,
                "GroupDescription" : description,
                "LanguageId" : 1,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(SAVE_KAHRAMAA_USER_GROUP, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .saveKahramaaUserGroups, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .saveKahramaaUserGroups, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .saveKahramaaUserGroups, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Save Kahramaa User Group Request
    
    // MARK: - GET GROUP LIST WITH KAHRAMAA NUMBERS
    
    func getGroupListWithKahramaaNumbers(completion: @escaping ClosureObjectBack<BaseArrayResponse<GroupWithNumbers<KahramaaNumber>>>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getGroupListWithKahramaaNumbers)
            
            let params: Parameters = [
                "LanguageId" : 1
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_GROUP_LIST_WITH_KAHRAMAA_NUMBERS, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<GroupWithNumbers<KahramaaNumber>>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getGroupListWithKahramaaNumbers, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getGroupListWithKahramaaNumbers, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getGroupListWithKahramaaNumbers, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Get Group List With Kahramaa Numbers Request
    
    // MARK: - ADD QATAR COOL TO GROUP
    
    func addQatarCoolToGroup(groupID: Int, qatarCoolNumber: String, QID: String, subscriberName: String, completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .addQatarCoolToGroup)
            
            let params: Parameters = [
                "GroupID" : groupID,
                "QatarCoolNumber" : qatarCoolNumber,
                "QID" : QID,
                "SubscriberName" : subscriberName,
                "LanguageId" : 1,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(ADD_QATAR_COOL_TO_GROUP, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .addQatarCoolToGroup, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .addQatarCoolToGroup, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .addQatarCoolToGroup, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Add Qatar Cool To Group Request
    
    // MARK: - GET QATAR COOL USER GROUPS
    
    func getQatarCoolUserGroups(completion: @escaping ClosureArrayBack<Group>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getQatarCoolUserGroups)
            
            let params: Parameters = [
                "LanguageId" : 1
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_QATAR_COOL_USER_GROUPS, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<Group>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getQatarCoolUserGroups, result: .Success(baseResponse))
                        completion(true, baseResponse.list)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getQatarCoolUserGroups, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getQatarCoolUserGroups, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Get Qatar Cool User Groups Request
    
    // MARK: - SAVE QATAR COOL USER GROUPS
    
    func saveQatarCoolUserGroups(groupName: String, description: String = "", completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .saveQatarCoolUserGroups)
            
            let params: Parameters = [
                "GroupName" : groupName,
                "GroupDescription" : description,
                "LanguageId" : 1,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(SAVE_QATAR_COOL_USER_GROUP, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .saveQatarCoolUserGroups, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .saveQatarCoolUserGroups, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .saveQatarCoolUserGroups, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Save Qatar Cool User Group Request
    
    // MARK: - GET GROUP LIST WITH QATAR COOL NUMBERS
    
    func getGroupListWithQatarCoolNumbers(completion: @escaping ClosureObjectBack<BaseArrayResponse<GroupWithNumbers<QatarCoolNumber>>>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getGroupListWithQatarCoolNumbers)
            
            let params: Parameters = [
                "LanguageId" : 1
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_GROUP_LIST_WITH_QATAR_COOL_NUMBERS, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<GroupWithNumbers<QatarCoolNumber>>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getGroupListWithQatarCoolNumbers, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getGroupListWithQatarCoolNumbers, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getGroupListWithQatarCoolNumbers, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Get Group List With Kahramaa Numbers Request
    
    // MARK: - PAYMENT VIA DUE TO PAY
    
    func paymentDueToPay(amount: Double, qidNumber: String, serviceNumber: String, mobile: String, paymentMethod: Int, type: String, completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .paymentDueToPay)
            
            let params: Parameters = [
                "Amount" : amount,
                "PlatForm" : UIDevice.current.systemName,
                "QIDNo" : qidNumber,
                "ServiceNo" : serviceNumber,
                "MobileNumber" : mobile,
                "PaymentMethodID" : paymentMethod,
                "Type" : type,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(PAYMENT_VIA_DUE_TO_PAY, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .paymentDueToPay, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .paymentDueToPay, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .paymentDueToPay, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Add Metro Card Request
    
    // MARK: - ADD METRO CARD
    
    func addMetroCard(cardNumber: String, completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .addMetroCard)
            
            let params: Parameters = [
                "CardNumber" : cardNumber,
                "LanguageId" : 1,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(ADD_METRO_CARD, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .addMetroCard, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .addMetroCard, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .addMetroCard, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Add Metro Card Request
    
    // MARK: - GET METRO CARDS
    
    func getMetroCards(completion: @escaping ClosureArrayBack<MetroCard>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getMetroCards)
            
            let params: Parameters = [
                "LanguageId" : 1,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_METRO_CARDS, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<MetroCard>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getMetroCards, result: .Success(baseResponse))
                        completion(true, baseResponse.list)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getMetroCards, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getMetroCards, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Get Metro Cards Request
    
    // MARK: - GET METRO FARE CARDS
    
    func getMetroFareCards(completion: @escaping ClosureArrayBack<MetroFareCard>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getMetroFareCards)
            
            let params: Parameters = [
                "LanguageId" : 1,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_METRO_CARDS_DETAILS, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<MetroFareCard>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getMetroFareCards, result: .Success(baseResponse))
                        completion(true, baseResponse.list)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getMetroFareCards, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getMetroFareCards, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Get Metro Fare Cards Request
    
    // MARK: - REMOVE METRO CARD
    
    func removeMetroCard(cardID: Int, completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .removeMetroCard)
            
            let params: Parameters = [:]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            let url = deleteMetroCardURL(cardID)
            
            self.AlamofireManager.request(url, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .removeMetroCard, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .removeMetroCard, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .removeMetroCard, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Remove Metro Card Request
    
    // MARK: - REMOVE METRO CARD
    
    func refillMetroCard(cardNumber: String, amount: Double, completion: @escaping ClosureObjectBack<Transfer>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .refillMetroCard)
            
            let params: Parameters = [
                "CardNumber" : cardNumber,
                "Amount" : amount,
                "PlatForm" : UIDevice.current.systemName,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(REFILL_METRO_CARD, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<Transfer, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .refillMetroCard, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .refillMetroCard, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .refillMetroCard, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Remove Metro Card Request
    
    // MARK: - GET PARKINGS LIST
    
    func getParkingsList(completion: @escaping CallArrayBack<Parking>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getParkingsList)
            
            let params: Parameters = [:]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_PARKINGS_LIST, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<Parking>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getParkingsList, result: .Success(baseResponse))
                        completion(baseResponse.list)
                        
                    } else {
                        self.delegate?.requestFinished(request: .getParkingsList, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getParkingsList, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Get Parkings List Request
    
    // MARK: - GET PARKING TICKET
    
    func getParkingTicketDetails(number: String, parkingID: Int, completion: @escaping CallObjectBack<ParkingTicket>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getParkingTicketDetails)
            
            let params: Parameters = [
                "TicketNumber" : number,
                "ParkingID" : "\(parkingID)",
                "LanID" : 1,
                "RequestFrom" : 1
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_PARKING_TICKET_DETAILS, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<ParkingTicket, AFError>) in
                
                switch response.result {
                case .success(let response):
                    if response.success == true {
                        self.delegate?.requestFinished(request: .getParkingTicketDetails, result: .Success(response))
                        completion(response)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getParkingTicketDetails, result: .Failure(.Exception(response._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getParkingTicketDetails, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Get Parkings List Request
    
    // MARK: - PAY PARKING VIA NOQS
    
    func payParkingViaNoqs(_ ticket: ParkingTicket, pinCode: String, completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .payParkingViaNoqs)
            
            let params: Parameters = [
                "AccessToken" : ticket._accessToken,
                "RequestID" : ticket._requestID,
                "PinCode" : pinCode,
                "LanguageId" : "1",
                "VerificationID" : ticket._verificationID,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(PAY_PARKING_VIA_NOQS, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let response):
                    if response.success == true {
                        self.delegate?.requestFinished(request: .payParkingViaNoqs, result: .Success(response))
                        completion(true, response)
                        
                    }else {
                        self.delegate?.requestFinished(request: .payParkingViaNoqs, result: .Failure(.Exception(response._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .payParkingViaNoqs, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Pay Parking Via Noqs Request
    
    // MARK: - GET GIFT STORE LIST
    
    func getGiftStoreList(completion: @escaping ClosureObjectBack<GiftResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getGiftStoreList)
            
            let params: Parameters = [:]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_GIFT_STORES, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<GiftResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getGiftStoreList, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getGiftStoreList, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getGiftStoreList, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Get Gift Store List Request
    
    // MARK: - GET GIFT BRANDS BY STORE ID
    
    func getGiftBrandList(storeID: Int, completion: @escaping ClosureArrayBack<GiftBrand>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getGiftBrandList)
            
            let params: Parameters = [
                "ID" : storeID
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            let url = getBrandsByStoreURL(storeID: storeID)
            
            self.AlamofireManager.request(url, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<GiftBrand>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getGiftBrandList, result: .Success(baseResponse))
                        completion(true, baseResponse.list)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getGiftBrandList, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getGiftBrandList, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Get Gift Brands by storeID Request
    
    // MARK: - GET GIFT DENOMINATIONS BY BRAND ID & STORE ID
    
    func getGiftDenominationList(storeID: Int, brandID: Int, completion: @escaping ClosureArrayBack<GiftDenomination>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getGiftDenominationList)
            
            let params: Parameters = [
                "StoreID" : storeID,
                "BrandID" : brandID,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_GIFT_DENOMINATION_LIST, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<GiftDenomination>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getGiftDenominationList, result: .Success(baseResponse))
                        completion(true, baseResponse.list)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getGiftDenominationList, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getGiftDenominationList, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Get Gift Denominations by BrandID storeID Request
    
    // MARK: - INITIATE GIFT TRANSACTION
    
    func initiateGiftTransaction(denominationID: Int, completion: @escaping ClosureObjectBack<GiftTransfer>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .initiateGiftTransaction)
            
            let params: Parameters = [
                "DenominationID" : denominationID,
                "PlatForm" : UIDevice.current.systemName,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(INITIATE_GIFT_TRANSACTION, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<GiftTransfer, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .initiateGiftTransaction, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .initiateGiftTransaction, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .initiateGiftTransaction, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Initiate Gift Transaction Request
    
    // MARK: - BUY GIFT DENOMINATION
    
    func buyGiftDenomination(giftTransfer: GiftTransfer, pinCode: String, completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .buyGiftDenomination)
            
            let params: Parameters = [
                "AccessToken" : giftTransfer._accessToken,
                "VerificationID" : giftTransfer._verificationID,
                "RequestID" : giftTransfer._requestID,
                "PinCode" : pinCode,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(BUY_GIFT_DENOMINATION, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .buyGiftDenomination, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .buyGiftDenomination, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .buyGiftDenomination, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Buy Gift Denomination Request
    
    // MARK: - E-STORE TOPUP COUNTRY LIST
    
    func estoreTopupCountryList(completion: @escaping ClosureArrayBack<Country>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .estoreTopupCountryList)
            
            let params: Parameters = [:]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_ESTORE_COUNTRY_LIST, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<Country>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .estoreTopupCountryList, result: .Success(baseResponse))
                        completion(true, baseResponse.list)
                        
                    }else {
                        self.delegate?.requestFinished(request: .estoreTopupCountryList, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .estoreTopupCountryList, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End E-Store Topup Country List Request
    
    // MARK: - MSISDN
    
    func msdnRequest(msidn: String, countryCode: String, completion: @escaping ClosureObjectBack<MSISDN>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .msdnRequest)
            
            let params: Parameters = [
                "MSISDN" : msidn,
                "CountryCode" : countryCode,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(MSDN_REQUEST, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseObjectResponse<MSISDN>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .msdnRequest, result: .Success(baseResponse))
                        completion(true, baseResponse.object)
                        
                    }else {
                        self.delegate?.requestFinished(request: .msdnRequest, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .msdnRequest, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End MSISDN Request
    
    // MARK: - RESERVE ID REQUEST
    
    func reserveIDRequest(requestID: String, referenceNumber: String? = "NA", costPrice: Double, productCode: String, msidn: String, countryCode: String, completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .reserveIDRequest)
            
            let params: Parameters = [
                "RequestID" : requestID,
                "ReferenceNumber" : referenceNumber ?? "",
                "CostPrice" : costPrice,
                "ProductCode" : productCode,
                "MSISDN" : msidn,
                "CountryCode" : countryCode,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(RESERVE_ID_REQUEST, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .reserveIDRequest, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .reserveIDRequest, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .reserveIDRequest, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Reserve ID Request
    
    // MARK: - CONFIRM ESTORE TOPUP
    
    func confirmEstoreTopup(_ transfer: Transfer, pinCode: String, completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .confirmEstoreTopup)
            
            let params: Parameters = [
                "AccessToken" : transfer._accessToken,
                "VerificationID" : transfer._verificationID,
                "RequestID" : transfer._requestID,
                "PinCode" : pinCode,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(CONFIRM_ESTORE_TOPUP, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .confirmEstoreTopup, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .confirmEstoreTopup, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .confirmEstoreTopup, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Confirm EStore Topup Request
    
    // MARK: - GET KARWA BUS CARD LIST
    
    func getKarwaBusCardList(completion: @escaping ClosureArrayBack<KarwaBusCard>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getKarwaBusCardList)
            
            let params: Parameters = [
                "LanguageId" : 1
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_KARWA_BUS_CARD_LIST, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<KarwaBusCard>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getKarwaBusCardList, result: .Success(baseResponse))
                        completion(true, baseResponse.list)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getKarwaBusCardList, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getKarwaBusCardList, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Get Karwa Bus Card List Request
    
    // MARK: - ADD KARWA BUS CARD
    
    func addKarwaBusCard(cardNumber: String, completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .addKarwaBusCard)
            
            var params: Parameters = [
                "CardNumber" : cardNumber,
                "LanguageId" : 1,
            ]
            
            if let user = self.userProfile.getUser() {
                params["MobileNumber"] = user._mobileNumber
            }
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(ADD_KARWA_BUS_CARD, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .addKarwaBusCard, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .addKarwaBusCard, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .addKarwaBusCard, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Add Karwa Bus Card Request
    
    // MARK: - DELETE KARWA BUS CARD
    
    func deleteKarwaBusCard(cardID: Int, completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .deleteKarwaBusCard)
            
            let params: Parameters = [:]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            let url = deleteKarwaBusCardURL(cardID, languageId: 1)
            
            self.AlamofireManager.request(url, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                    switch response.result {
                    case .success(let baseResponse):
                        if baseResponse.success == true {
                            self.delegate?.requestFinished(request: .deleteKarwaBusCard, result: .Success(baseResponse))
                            completion(true, baseResponse)
                            
                        }else {
                            self.delegate?.requestFinished(request: .deleteKarwaBusCard, result: .Failure(.Exception(baseResponse._message)))
                            completion(false, nil)
                        }
                        break
                        
                    case .failure(let error):
                        self.delegate?.requestFinished(request: .deleteKarwaBusCard, result: .Failure(.AlamofireError(error)))
                        completion(false, nil)
                        break
                    }
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Delete Karwa Bus Card Request
    
    // MARK: - GET KARWA CARD BALANCE
    
    func getKarwaBusCardBalance(cardNumber: String, completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getKarwaBusCardBalance)
            
            let params: Parameters = [
                "CardNumber" : cardNumber,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_KARWA_BUS_CARD_BALANCE, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getKarwaBusCardBalance, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getKarwaBusCardBalance, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getKarwaBusCardBalance, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Get Karwa Card Balance Request
    
    // MARK: - INITIATE KARWA TOPUP
    
    func initiateKarwaBus(cardNumber: String, mobile: String, amount: Double, clientReference: String? = "NA", completion: @escaping ClosureObjectBack<KarwaBusTransfer>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .initiateKarwaBus)
            
            let params: Parameters = [
                "CardNumber" : cardNumber,
                "MobileNumber" : mobile,
                "Amount" : amount,
                "ClientReference" : clientReference ?? "",
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(INITIATE_KARWA_BUS_TOPUP, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<KarwaBusTransfer, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .initiateKarwaBus, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .initiateKarwaBus, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .initiateKarwaBus, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Initiate Karwa Bus Request
    
    // MARK: - CONFIRM KARWA BUS TOPUP
    
    func confirmKarwaBusTopup(transfer: KarwaBusTransfer, pinCode: String, completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .confirmKarwaBusTopup)
            
            let params: Parameters = [
                "AccessToken" : transfer._accessToken,
                "VerificationID" : transfer._verificationID,
                "RequestID" : transfer._requestID,
                "PinCode" : pinCode,
                "PlatForm" : UIDevice.current.systemName,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(CONFIRM_KARWA_BUS_TOPUP, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .confirmKarwaBusTopup, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .confirmKarwaBusTopup, result: .Failure(.Exception(baseResponse._message)))
                        completion(false, nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .confirmKarwaBusTopup, result: .Failure(.AlamofireError(error)))
                    completion(false, nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Confirm Karwa Topup Request
    
    // MARK: - GET LIMOUSINE CONTACT LIST
    
    func getLimousineContactList(_ completion: @escaping CallArrayBack<Limousine>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getLimousineContactList)
            
            let params: Parameters = [:]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_LIMOUSINE_CONTACT_LIST, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<Limousine>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getLimousineContactList, result: .Success(baseResponse))
                        completion(baseResponse._list)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getLimousineContactList, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getLimousineContactList, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Get Limousine Contact List Request
    
    // MARK: - GET MY LIMOUSINE CONTACT LIST
    
    func getMyLimousineContactList(_ completion: @escaping CallArrayBack<Limousine>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getMyLimousineContactList)
            
            let params: Parameters = [:]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_MY_LIMOUSINE_CONTACT_LIST, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<Limousine>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getMyLimousineContactList, result: .Success(baseResponse))
                        completion(baseResponse._list)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getMyLimousineContactList, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getMyLimousineContactList, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Get My Limousine Contact List Request
    
    // MARK: - ADD MY LIMOUSINE CONTACT
    
    func addMyLimousineContact(id: Int, _ completion: @escaping CallObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .addMyLimousineContact)
            
            let params: Parameters = [
                "ID" : id,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(ADD_MY_LIMOUSINE_CONTACT, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .addMyLimousineContact, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .addMyLimousineContact, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .addMyLimousineContact, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Add My Limousine Contact Request
    
    // MARK: - REMOVE MY LIMOUSINE CONTACT
    
    func removeMyLimousineContact(id: Int, _ completion: @escaping CallObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .removeMyLimousineContact)
            
            let params: Parameters = [
                "ID" : id,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(REMOVE_MY_LIMOUSINE_CONTACT, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .removeMyLimousineContact, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .removeMyLimousineContact, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .removeMyLimousineContact, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Remove My Limousine Contact Request
    
    // MARK: - COUPON LIST
    
    func getCouponList(_ completion: @escaping CallArrayBack<Coupon>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getCouponList)
            
            let params: Parameters = [:]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_COUPON_LIST, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<Coupon>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getCouponList, result: .Success(baseResponse))
                        completion(baseResponse._list)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getCouponList, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getCouponList, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Get Coupon List Request
    
    // MARK: - COUPON CATEGORIES
    
    func getCouponCategories(_ completion: @escaping CallArrayBack<CouponCategory>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getCouponCategories)
            
            let params: Parameters = [:]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_COUPON_CATEGORIES, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<CouponCategory>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getCouponCategories, result: .Success(baseResponse))
                        completion(baseResponse._list)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getCouponCategories, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getCouponCategories, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Get Coupon List Request
    
    // MARK: - COUPON DETAILS
    
    func getCouponDetails(_ id: Int, _ completion: @escaping CallArrayBack<CouponDetails>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getCouponDetails)
            
            let params: Parameters = [
                "ID" : id,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_COUPON_DETAILS, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<CouponDetails>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getCouponDetails, result: .Success(baseResponse))
                        completion(baseResponse._list)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getCouponDetails, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getCouponDetails, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Get Coupon Details Request
    
    
    
    
    // MARK: - CHARITY SECTION
    
    
    
    // MARK: - CHARITY TYPES
    
    func getCharityTypes(_ charityID: Int, _ completion: @escaping CallArrayBack<CharityType>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getCharityTypes)
            
            let params: Parameters = [
                "LanguageId" : 1
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_CHARITY_TYPES, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<CharityType>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getCharityTypes, result: .Success(baseResponse))
                        completion(baseResponse._list)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getCharityTypes, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getCharityTypes, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Get Charity Types Request
    
    // MARK: - CHARITY DONATION TYPES
    
    func getCharityDonationTypes(_ charityID: Int, _ completion: @escaping CallArrayBack<CharityDonation>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getCharityDonationTypes)
            
            let params: Parameters = [
                "CharityID" : charityID,
                "LanguageId" : 1,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_CHARITY_DONATION_TYPES, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<CharityDonation>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getCharityDonationTypes, result: .Success(baseResponse))
                        completion(baseResponse._list)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getCharityDonationTypes, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getCharityDonationTypes, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Get Charity Donation Types Request
    
    // MARK: - TRANSFER VIA CHARITY
    
    func transferToCharity(_ charityID: Int, donationID: Int, amount: Double, _ completion: @escaping CallObjectBack<Transfer>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .transferToCharity)
            
            let params: Parameters = [
                "DestinationCharityID" : charityID,
                "DestinationDonationID" : donationID,
                "Amount" : amount,
                "Platform" : UIDevice.current.systemName,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(TRANSFER_VIA_CHARITY, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<Transfer, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .transferToCharity, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .transferToCharity, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .transferToCharity, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Get Charity Donation Types Request
    
    
    
    
    // MARK: - STOCKS
    
    
    
    // MARK: - GET MARKET SUMMARY
    
    func getMarketSummary(_ completion: @escaping CallObjectBack<MarketSummary>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getMarketSummary)
            
            let params: Parameters = [
                "LanguageId" : 1
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_MARKET_SUMMARY, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<MarketSummary, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getMarketSummary, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getMarketSummary, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getMarketSummary, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Get Market Summary Request
    
    // MARK: - GET STOCK TRACKER
    
    func getStockTracker(_ completion: @escaping CallObjectBack<StockTracker>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getStockTracker)
            
            let params: Parameters = [
                "LanguageId" : 1
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_STOCK_TRACKER, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<StockTracker, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getStockTracker, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getStockTracker, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getStockTracker, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Get Stock Tracker Request
    
    // MARK: - GET USER STOCKS
    
    func getUserStocks(_ completion: @escaping CallArrayBack<UserStock>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getUserStocks)
            
            let params: Parameters = [
                "LanguageId" : 1
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_USER_STOCKS, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<UserStock>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getUserStocks, result: .Success(baseResponse))
                        completion(baseResponse._list)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getUserStocks, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getUserStocks, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Get User Stocks Request
    
    // MARK: - GET STOCK ADV
    
    func getStockAdv(_ completion: @escaping CallArrayBack<StockAdv>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getStockAdv)
            
            let params: Parameters = [
                "LanguageId" : 1
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_STOCK_ADV, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<StockAdv>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getStockAdv, result: .Success(baseResponse))
                        completion(baseResponse._list)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getStockAdv, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getStockAdv, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Get Stock Adv Request
    
    // MARK: - GET STOCK MARKETS
    
    func getStockMarkets(_ completion: @escaping CallArrayBack<StockMarket>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getStockMarkets)
            
            let params: Parameters = [
                "LanguageId" : 1
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_MARKET_NAMES, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<StockMarket>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getStockMarkets, result: .Success(baseResponse))
                        completion(baseResponse._list)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getStockMarkets, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getStockMarkets, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Get Stock Markets Request
    
    // MARK: - GET STOCK GROUP
    
    func getStockGroup(_ completion: @escaping CallArrayBack<StockGroup>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getStockGroup)
            
            let params: Parameters = [
                "LanguageId" : 1
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_STOCK_GROUP, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<StockGroup>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getStockGroup, result: .Success(baseResponse))
                        completion(baseResponse._list)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getStockGroup, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getStockGroup, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Get Stock Group Request
    
    // MARK: - GET STOCK GROUP Details
    
    func getStocks(_ completion: @escaping CallArrayBack<MyStocksGroupDetails>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getStocksGroupDetails)
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_STOCKS, method: .post, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<MyStocksGroupDetails>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getStocksGroupDetails, result: .Success(baseResponse))
                        completion(baseResponse._list)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getStocksGroupDetails, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getStocksGroupDetails, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } //
    
    // MARK: - ADD NEW STOCK
    
    func addNewStock(groupID: Int, marketID: Int, stockID: Int, quantity: Int, price: Double, date: String, _ completion: @escaping CallObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .addNewStock)
            
            let params: Parameters = [
                "LanguageId" : 1,
                "GroupID" : groupID,
                "MarketID" : marketID,
                "StockID" : stockID,
                "Quantity" : quantity,
                "Price" : price,
                "PurchaseDate" : date,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(ADD_NEW_STOCK, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .addNewStock, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .addNewStock, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .addNewStock, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Get Stock Group Request
    
    // MARK: - SAVE STOCK GROUP
    
    func saveStocksGroup(groupName: String,
                         groupDescription: String? = nil,
                         _ completion: @escaping ClosureObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .saveStocksGroup)
            
            let params: Parameters = [
                "LanguageId"       : 1,
                "GroupName"        : groupName,
                "GroupDescription" : groupDescription ?? ""
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(SAVE_STOCKS_GROUP, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .saveStocksGroup, result: .Success(baseResponse))
                        completion(true, baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .saveStocksGroup, result: .Failure(.Exception(baseResponse._message)))
                        completion(false,nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .saveStocksGroup, result: .Failure(.AlamofireError(error)))
                    completion(false,nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    }
    
    // MARK: - UPDATE STOCK
    
    func updateStocks(stock : MyStockList,
                      groupID : Int,
                      marketID: Int,
                      stockID : Int,
                      _ completion: @escaping CallObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .updateStocks)
            
            let params: Parameters = [
                "LanguageId"   : 1,
                "RequestID"    : stock._requestID,
                "GroupID"      : groupID,
                "MarketID"     : marketID,
                "StockID"      : stockID,
                "Quantity"     : stock._quantity,
                "Price"        : stock._price   ,
                "PurchaseDate" : stock._purchaseDate
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(UPDATE_STOCKS, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .updateStocks, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .updateStocks, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .updateStocks, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    }
    
    // MARK: - REMOVE STOCK
    
    func removeStocks(requestID: Int,
                      _ completion: @escaping CallObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .removeStocks)
            
            let params: Parameters = [
                "LanguageId"       : 1,
                "RequestID"        : requestID,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(REMOVE_STOCKS, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .removeStocks, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .removeStocks, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .removeStocks, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    }
    
    // MARK: - GET STOCK History
    
    func getStockHistory(_ completion: @escaping CallArrayBack<StockHistory>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getStockHistory)
            
            let params: Parameters = [
                "LanguageId" : 1
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_STOCK_HISTORY, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<StockHistory>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getStockHistory, result: .Success(baseResponse))
                        completion(baseResponse._list)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getStockHistory, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getStockHistory, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    }
    
    
    // MARK: - GET STOCK NEWS
    
    func getStockNews(_ completion: @escaping CallArrayBack<StocksNews>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getStocksNews)
            
            let params: Parameters = [
                "LanguageId" : 1
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_STOCK_NEWS, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<StocksNews>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getStocksNews, result: .Success(baseResponse))
                        completion(baseResponse._list)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getStocksNews, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getStocksNews, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    }
    
    
    // MARK: - CV
    
    
    // MARK: - GET CV LIST
    
    func getCVList(phoneNumber: String, _ completion: @escaping CallObjectBack<BaseArrayResponse<CV>>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getCVList)
            
            let params: Parameters = [
                "phoneNumber" : phoneNumber,
                "key" : Constant.KEY,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_CV_LIST, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<CV>, AFError>) in
                
                //                if let data = response.data,
                //                   let string = String(data: data, encoding: .utf8) {
                //                    print("String \(string)")
                //                }
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getCVList, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getCVList, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getCVList, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Get CV List Request
    
    
    // MARK: - ADD UPDATE CV
    
    func addUpdateCV(cv: CV, _ completion: @escaping CallObjectBack<BaseResponse> ) {
        
        if self.requestsController.isConnectedToInternet() {
            
            self.delegate?.requestStarted(request: .addUpdateCV)
            
            do {
                let url = URL(string: ADD_UPDATE_CV)!
                let encoder = JSONEncoder()
                let data = try encoder.encode(cv)
                
                var headers: HTTPHeaders = self.requestsController.headers
                headers["Authorization"] = self.getToken()
                
                var request = URLRequest(url: url)
                request.httpMethod = HTTPMethod.post.rawValue
                request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
                request.setValue(self.getToken(), forHTTPHeaderField: "Authorization")
                request.httpBody = data
                
                self.AlamofireManager.request(request).responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                    
                    switch response.result {
                    case .success(let baseResponse):
                        if baseResponse.success == true {
                            self.delegate?.requestFinished(request: .addUpdateCV, result: .Success(baseResponse))
                            completion(baseResponse)
                            
                        }else {
                            self.delegate?.requestFinished(request: .addUpdateCV, result: .Failure(.Exception(baseResponse._message)))
                            completion(baseResponse)
                        }
                        break
                        
                    case .failure(let error):
                        self.delegate?.requestFinished(request: .addUpdateCV, result: .Failure(.AlamofireError(error)))
                        completion(nil)
                        break
                    }
                } // End Alamofire Response
                
            } catch {
                print("ERROR \(error.localizedDescription)")
                return
            }
            
        } // End Internet Check Status
    }//End ADD UPDATE CV
    /*
     if self.requestsController.isConnectedToInternet() {
     self.delegate?.requestStarted(request: .addUpdateCV)
     
     let params: Parameters = [
     "PhoneNumber"      : cv._phoneNumber,
     "key"              : Constant.KEY,
     "Name"             : cv._name,
     "Skills"           : cv._skills,
     "ProfilePicture"   : cv._profilePicture,
     "Resident"         : cv._resident,
     "Nationality"      : cv._nationality,
     "Languages"        : cv._languages,
     "Gender"           : cv._gender,
     "Email"            : cv._email,
     "Website"          : cv._website,
     "Im"               : cv._im,
     "Twitter"          : cv._twitter,
     "Facebook"         : cv._facebook,
     "PrivacyStatus"    : cv._privacyStatus,
     "TotalExperience"  : cv._totalExperience,
     "CurrentJobList"   : cv._currentJobList,
     "PreviousJobList"  : cv._previousJobList,
     "EducationList"    : cv._educationList,
     "CVFIEL"           : cv._cVFIEL,
     "LanguageId"       : 1,
     "Industry_Area"    : cv._industry_Area,
     "Profession_Area"  : cv._profession_Area,
     "Graduate"         : cv._graduate,
     "SalaryExpect"     : cv._salaryExpect,
     "ProfilePicID"     : profilePicId ?? 0
     ]
     
     var headers: HTTPHeaders = self.requestsController.headers
     headers["Authorization"] = self.getToken()
     
     self.AlamofireManager.request(ADD_UPDATE_CV, method: .post, parameters: params, headers: headers).responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
     
     if let data = response.data,
     let string = String(data: data, encoding: .utf8) {
     print("Response Data \(string)")
     }
     
     switch response.result {
     case .success(let baseResponse):
     if baseResponse.success == true {
     self.delegate?.requestFinished(request: .addUpdateCV, result: .Success(baseResponse))
     completion(baseResponse)
     
     }else {
     self.delegate?.requestFinished(request: .addUpdateCV, result: .Failure(.Exception(baseResponse._message)))
     completion(nil)
     }
     break
     
     case .failure(let error):
     self.delegate?.requestFinished(request: .addUpdateCV, result: .Failure(.AlamofireError(error)))
     completion(nil)
     break
     }
     } // End Alamofire Response
     }
     */
    
    // MARK: - GET CV LIST SEARCH
    
    func getCVListSearch( searchParams : SearchCVParameter ,
                          _ completion: @escaping CallObjectBack<BaseArrayResponse<CV>>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getCVListSearch)
            
            let params: Parameters = [
                "key"              : Constant.KEY,
                "Nationality"      : searchParams.nationality,
                "Yearofexperience" : searchParams.yearofexperience,
                "Resident"         : searchParams.resident,
                "Skills"           : searchParams.skills,
                "gender"           : searchParams.gender,
                "Email"            : searchParams.email
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_CV_LIST_SEARCH, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<CV>, AFError>) in
                
                //                if let data = response.data,
                //                   let string = String(data: data, encoding: .utf8) {
                //                    print("String \(string)")
                //                }
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getCVListSearch, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getCVListSearch, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getCVListSearch, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Get CV List Request
    
    // MARK: - DELETE CV JOB
    
    func deleteCVJob(id: Int, _ completion: @escaping CallObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .deleteJob)
            
            let params: Parameters = [
                "ID" : id,
                "key" : Constant.KEY,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(DELETE_CV_JOB, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                //                if let data = response.data,
                //                   let string = String(data: data, encoding: .utf8) {
                //                    print("String \(string)")
                //                }
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .deleteJob, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .deleteJob, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .deleteJob, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End DELETE CV JOB
    
    // MARK: - DELETE CV EDUCATION
    
    func deleteCVEducation(id: Int, _ completion: @escaping CallObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .deleteEducation)
            
            let params: Parameters = [
                "ID" : id,
                "key" : Constant.KEY,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(DELETE_CV_EDUCATION, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                //                if let data = response.data,
                //                   let string = String(data: data, encoding: .utf8) {
                //                    print("String \(string)")
                //                }
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .deleteEducation, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .deleteEducation, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .deleteEducation, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End DELETE CV JOB
    
    
    
    // MARK: - LIMOUSINE
    
    // MARK: - LIMOUSINE TAB
    func getLimousineTab(_ completion: @escaping CallObjectBack<BaseArrayResponse<LimousineTab>>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getLimousineTabs)
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_LIMOUSINE_TAB , method: .get,  headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<LimousineTab>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getLimousineTabs, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getLimousineTabs, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getLimousineTabs, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    }
    
    // MARK: - LIMOUSINE ITMES
    func getLimousineItmes(BuisCategID : Int, _ completion: @escaping CallObjectBack<BaseArrayResponse<OjraDetails>>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getLimousineItmes)
            let params: Parameters = [:]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            let url = getLimousineListByBuisCategIDURL(buisCategID: "\(BuisCategID)")
            self.AlamofireManager.request( url ,
                                           method     : .get,
                                           parameters : params,
                                           headers    : headers )
            .validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<OjraDetails>, AFError>) in
                
                switch response.result {
                    
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getLimousineItmes, result: .Success(baseResponse))
                        completion(baseResponse)
                    } else {
                        self.delegate?.requestFinished(request: .getLimousineItmes, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getLimousineTabs, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    }
    
    // MARK: - GET MY LIMOUSINE LIST
    func getMyLimousineList(_ completion: @escaping CallObjectBack<BaseArrayResponse<OjraDetails>>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getMyLimousineList)
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_MY_LIMOUSINE_LIST, method: .get,  headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<OjraDetails>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getMyLimousineList, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getMyLimousineList, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getMyLimousineList, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } //
    
    // MARK: - add Limousine To My List
    func addLimousineToMyList(id: Int, _ completion: @escaping CallObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .addLimousineToMyList)
            
            let params: Parameters = [
                "ID" : id,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(ADD_LIMOUSINE_TO_MY_LIST, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .addLimousineToMyList, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .addLimousineToMyList, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .addLimousineToMyList, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } //
    
    // MARK: - delete Limousine From My List
    
    func deleteLimousineFromMyList(id: Int, _ completion: @escaping CallObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .deleteLimousineFromMyList)
            
            let params: Parameters = [
                "ID" : id,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(DELETE_LIMOUSINE_FROM_MY_LIST, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .deleteLimousineFromMyList, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .deleteLimousineFromMyList, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .deleteLimousineFromMyList, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } //
    
    //--------------------------------------------
    // MARK: - CHILD CARE
    
    // MARK: - CHILD CARE TAB
    
    func getChildCareTab(_ completion: @escaping CallObjectBack<BaseArrayResponse<ChildCareTab>>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getChildCareTabs)
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_CHILD_CARE_TAB , method: .get,  headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<ChildCareTab>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getChildCareTabs, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getChildCareTabs, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getChildCareTabs, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    }
    
    // MARK: - CHILD CARE ITMES
    
    func getChildCareItmes(BuisCategID : Int, _ completion: @escaping CallObjectBack<BaseArrayResponse<ChildCareItmeDetails>>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getChildCareItmes)
            let params: Parameters = [:]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            let url = getChildCareListByIDURL(buisCategID: "\(BuisCategID)")
            self.AlamofireManager.request( url ,
                                           method     : .get,
                                           parameters : params,
                                           headers    : headers )
            .validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<ChildCareItmeDetails>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getChildCareItmes, result: .Success(baseResponse))
                        completion(baseResponse)
                    } else {
                        self.delegate?.requestFinished(request: .getChildCareItmes, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getChildCareItmes, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    }
    
    // MARK: - GET MY CHILD CARE LIST
    
    func getMyChildCareList(_ completion: @escaping CallObjectBack<BaseArrayResponse<ChildCareItmeDetails>>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getMyChildCareList)
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_MY_CHILD_CARE_LIST, method: .get,  headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<ChildCareItmeDetails>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getChildCareItmes, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getChildCareItmes, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getChildCareItmes, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } //
    
    // MARK: - ADD CILED CARE TO MY LIST
    
    func addChildCareToMyList(id: Int, _ completion: @escaping CallObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .addChildCareToMyList)
            
            let params: Parameters = [
                "ID" : id,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(ADD_CHILD_CARE_TO_MY_LIST, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .addChildCareToMyList, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .addChildCareToMyList, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .addChildCareToMyList, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } //
    
    // MARK: - REMOVE CHILD CARE FROM MY LIST
    
    func removeChildCareFromMyList(id: Int, _ completion: @escaping CallObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .removeChildCareFromMyList)
            
            let params: Parameters = [
                "ID" : id,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(REMOVE_CHILD_CARE_FROM_MY_LIST, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .removeChildCareFromMyList, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .removeChildCareFromMyList, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .removeChildCareFromMyList, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } //
    
    
    //--------------------------------------------
    // MARK: - HOTEL
    
    // MARK: - HOTER TAB
    
    func getHotelTab(_ completion: @escaping CallObjectBack<BaseArrayResponse<HotelTab>>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getHotelTabs)
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_HOTEL_TAB , method: .get,  headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<HotelTab>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getHotelTabs, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getHotelTabs, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getHotelTabs, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    }
    
    // MARK: - HOTEL ITMES
    
    func getHotelItmes(BuisCategID : Int, _ completion: @escaping CallObjectBack<BaseArrayResponse<HotelItmeDetails>>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getHotelItmes)
            let params: Parameters = [:]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            let url = getHotelListByIDURL(buisCategID: "\(BuisCategID)")
            self.AlamofireManager.request( url ,
                                           method     : .get,
                                           parameters : params,
                                           headers    : headers )
            .validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<HotelItmeDetails>, AFError>) in
                switch response.result {
                    
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getHotelItmes, result: .Success(baseResponse))
                        completion(baseResponse)
                    } else {
                        self.delegate?.requestFinished(request: .getHotelItmes, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getHotelItmes, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    }
    
    // MARK: - GET MY HOTET LIST
    
    func getMyHotelList(_ completion: @escaping CallObjectBack<BaseArrayResponse<HotelItmeDetails>>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getMyHotelList)
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_MY_HOTEL_LIST, method: .get,  headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<HotelItmeDetails>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getMyHotelList, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getMyHotelList, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getMyHotelList, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } //
    
    // MARK: - ADD HOTEL TO MY LIST
    
    func addHotelToMyList(id: Int, _ completion: @escaping CallObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .addHotelToMyList)
            
            let params: Parameters = [
                "ID" : id,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(ADD_HOTEL_TO_MY_LIST, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .addHotelToMyList, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .addHotelToMyList, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .addHotelToMyList, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } //
    
    // MARK: - REMOVE HOTEL FROM MY LIST
    
    func removeHotelFromMyList(id: Int, _ completion: @escaping CallObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .removeHotelFromMyList)
            
            let params: Parameters = [
                "ID" : id,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(REMOVE_HOTEL_FROM_MY_LIST, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .removeHotelFromMyList, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .removeHotelFromMyList, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .removeHotelFromMyList, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } //
    
    
    //--------------------------------------------
    // MARK: - DINE
    
    // MARK: - DINE TAB
    
    func getDineTab(_ completion: @escaping CallObjectBack<BaseArrayResponse<DineTab>>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getDineTabs)
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_DINE_TAB , method: .get,  headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<DineTab>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getDineTabs, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getDineTabs, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getDineTabs, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    }
    
    // MARK: - DINE ITMES
    
    func getDineItmes(BuisCategID : Int, _ completion: @escaping CallObjectBack<BaseArrayResponse<DineItmeDetails>>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getDineItmes)
            let params: Parameters = [:]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            let url = getDineListByIDURL(buisCategID: "\(BuisCategID)")
            self.AlamofireManager.request( url ,
                                           method     : .get,
                                           parameters : params,
                                           headers    : headers )
            .validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<DineItmeDetails>, AFError>) in
                
                switch response.result {
                    
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getDineItmes, result: .Success(baseResponse))
                        completion(baseResponse)
                    } else {
                        self.delegate?.requestFinished(request: .getDineItmes, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getDineItmes, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    }
    
    // MARK: - GET MY DINE LIST
    
    func getMyDineList(_ completion: @escaping CallObjectBack<BaseArrayResponse<DineItmeDetails>>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getMyDineList)
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_MY_DINE_LIST, method: .get,  headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<DineItmeDetails>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getMyDineList, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getMyDineList, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getMyDineList, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } //
    
    // MARK: - ADD DINE TO MY LIST
    
    func addDineToMyList(id: Int, _ completion: @escaping CallObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .addDineToMyList)
            
            let params: Parameters = [
                "ID" : id,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(ADD_DINE_TO_MY_LIST, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .addDineToMyList, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .addDineToMyList, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .addDineToMyList, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } //
    
    // MARK: - REMOVE DINE FROM MY LIST
    
    func removeDineFromMyList(id: Int, _ completion: @escaping CallObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .removeDineFromMyList)
            
            let params: Parameters = [
                "ID" : id,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(REMOVE_DINE_FROM_MY_LIST, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .removeDineFromMyList, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .removeDineFromMyList, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .removeDineFromMyList, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } //
    //--------------------------------------------
    
    // MARK: - Insurances
    
    // MARK: - Insurances TAB
    
    func getInsurancesTab(_ completion: @escaping CallObjectBack<BaseArrayResponse<InsurancesTab>>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getInsurancesTabs)
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_INSURANCE_TAB , method: .get,  headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<InsurancesTab>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getInsurancesTabs, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getInsurancesTabs, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getInsurancesTabs, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    }
    
    // MARK: - Insurances ITMES
    
    func getInsurancesItmes(BuisCategID : Int, _ completion: @escaping CallObjectBack<BaseArrayResponse<InsurancesItmeDetails>>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getInsurancesItmes)
            let params: Parameters = [:]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            let url = getInsuranceListByIDURL(buisCategID: "\(BuisCategID)")
            self.AlamofireManager.request( url ,
                                           method     : .get,
                                           parameters : params,
                                           headers    : headers )
            .validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<InsurancesItmeDetails>, AFError>) in
                
                switch response.result {
                    
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getInsurancesItmes, result: .Success(baseResponse))
                        completion(baseResponse)
                    } else {
                        self.delegate?.requestFinished(request: .getInsurancesItmes, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getInsurancesItmes, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    }
    
    // MARK: - GET MY Insurances LIST
    
    func getMyInsurancesList(_ completion: @escaping CallObjectBack<BaseArrayResponse<InsurancesItmeDetails>>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getMyInsurancesList)
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_MY_INSURANCE_LIST, method: .get,  headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<InsurancesItmeDetails>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getMyInsurancesList, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getMyInsurancesList, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getMyInsurancesList, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } //
    
    // MARK: - ADD Insurances TO MY LIST
    
    func addInsurancesToMyList(id: Int, _ completion: @escaping CallObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .addInsurancesToMyList)
            
            let params: Parameters = [
                "ID" : id,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(ADD_INSURANCE_TO_MY_LIST, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .addInsurancesToMyList, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .addInsurancesToMyList, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .addInsurancesToMyList, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } //
    
    // MARK: - REMOVE Insurances FROM MY LIST
    
    func removeInsurancesFromMyList(id: Int, _ completion: @escaping CallObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .removeInsurancesFromMyList)
            
            let params: Parameters = [
                "ID" : id,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(REMOVE_INSURANCE_FROM_MY_LIST, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .removeInsurancesFromMyList, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .removeInsurancesFromMyList, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .removeInsurancesFromMyList, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } //
    //--------------------------------------------
    // MARK: - MedicalCenter
    
    // MARK: - MedicalCenter TAB
    
    func getMedicalCenterTab(_ completion: @escaping CallObjectBack<BaseArrayResponse<MedicalCenterTab>>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getMedicalCenterTabs)
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_MEDICAL_CENTER_TAB , method: .get,  headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<MedicalCenterTab>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getMedicalCenterTabs, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getMedicalCenterTabs, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getMedicalCenterTabs, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    }
    
    // MARK: - MedicalCenter ITMES
    
    func getMedicalCenterItmes(BuisCategID : Int, _ completion: @escaping CallObjectBack<BaseArrayResponse<MedicalCenterItmeDetails>>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getMedicalCenterItmes)
            let params: Parameters = [:]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            let url = getMedicalCenterListByIDURL(buisCategID: "\(BuisCategID)")
            self.AlamofireManager.request( url ,
                                           method     : .get,
                                           parameters : params,
                                           headers    : headers )
            .validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<MedicalCenterItmeDetails>, AFError>) in
                
                switch response.result {
                    
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getMedicalCenterItmes, result: .Success(baseResponse))
                        completion(baseResponse)
                    } else {
                        self.delegate?.requestFinished(request: .getMedicalCenterItmes, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getMedicalCenterItmes, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    }
    
    // MARK: - GET MY MedicalCenter LIST
    
    func getMyMedicalCenterList(_ completion: @escaping CallObjectBack<BaseArrayResponse<MedicalCenterItmeDetails>>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getMyMedicalCenterList)
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_MY_MEDICAL_CENTER_LIST, method: .get,  headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<MedicalCenterItmeDetails>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getMyMedicalCenterList, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getMyMedicalCenterList, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getMyMedicalCenterList, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } //
    
    // MARK: - ADD MedicalCenter TO MY LIST
    
    func addMedicalCenterToMyList(id: Int, _ completion: @escaping CallObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .addMedicalCenterToMyList)
            
            let params: Parameters = [
                "ID" : id,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(ADD_MEDICAL_CENTER_TO_MY_LIST, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .addMedicalCenterToMyList, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .addMedicalCenterToMyList, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .addMedicalCenterToMyList, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } //
    
    // MARK: - REMOVE MedicalCenter FROM MY LIST
    
    func removeMedicalCenterFromMyList(id: Int, _ completion: @escaping CallObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .removeMedicalCenterFromMyList)
            
            let params: Parameters = [
                "ID" : id,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(REMOVE_MEDICAL_CENTER_FROM_MY_LIST, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .removeMedicalCenterFromMyList, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .removeMedicalCenterFromMyList, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .removeMedicalCenterFromMyList, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } //
    //--------------------------------------------
    
    // MARK: - QaterSchool
    
    // MARK: - QaterSchool TAB
    
    func getQaterSchoolTab(_ completion: @escaping CallObjectBack<BaseArrayResponse<QaterSchoolTab>>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getQaterSchoolTabs)
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_SCHOOL_TAB , method: .get,  headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<QaterSchoolTab>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getQaterSchoolTabs, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getQaterSchoolTabs, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getQaterSchoolTabs, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    }
    
    // MARK: - QaterSchool ITMES
    
    func getQaterSchoolItmes(BuisCategID : Int, _ completion: @escaping CallObjectBack<BaseArrayResponse<QaterSchoolItmeDetails>>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getQaterSchoolItmes)
            let params: Parameters = [:]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            let url = getSchoolListByIDURL(buisCategID: "\(BuisCategID)")
            self.AlamofireManager.request( url ,
                                           method     : .get,
                                           parameters : params,
                                           headers    : headers )
            .validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<QaterSchoolItmeDetails>, AFError>) in
                
                switch response.result {
                    
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getQaterSchoolItmes, result: .Success(baseResponse))
                        completion(baseResponse)
                    } else {
                        self.delegate?.requestFinished(request: .getQaterSchoolItmes, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getQaterSchoolItmes, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    }
    
    // MARK: - GET MY QaterSchool LIST
    
    func getMyQaterSchoolList(_ completion: @escaping CallObjectBack<BaseArrayResponse<QaterSchoolItmeDetails>>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getMyQaterSchoolList)
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_MY_SCHOOL_LIST, method: .get,  headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<QaterSchoolItmeDetails>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getMyQaterSchoolList, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getMyQaterSchoolList, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getMyQaterSchoolList, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } //
    
    // MARK: - ADD QaterSchool TO MY LIST
    
    func addQaterSchoolToMyList(id: Int, _ completion: @escaping CallObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .addQaterSchoolToMyList)
            
            let params: Parameters = [
                "ID" : id,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(ADD_SCHOOL_TO_MY_LIST, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .addQaterSchoolToMyList, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .addQaterSchoolToMyList, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .addQaterSchoolToMyList, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } //
    
    // MARK: - REMOVE QaterSchool FROM MY LIST
    
    func removeQaterSchoolFromMyList(id: Int, _ completion: @escaping CallObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .removeQaterSchoolFromMyList)
            
            let params: Parameters = [
                "ID" : id,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(REMOVE_SCHOOL_FROM_MY_LIST, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .removeQaterSchoolFromMyList, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .removeQaterSchoolFromMyList, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .removeQaterSchoolFromMyList, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } //
    //--------------------------------------------
    
    
    // MARK: - JOBHUNTER
    
    // MARK: - GET JOB HUNTER
    
    func getJobHuntList(jobParameter : JobHuntSearchBodyParameter ,
                        _ completion: @escaping CallObjectBack<BaseArrayResponse<JobHunterList>>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getJobHunterList)
            
            let params: Parameters = [
                "key"              : Constant.KEY,
                "Employmenttype"   : jobParameter.employmentType,
                "Yearofexperience" : jobParameter.yearOfExperience,
                "Jobtitle"         : jobParameter.jobtitle,
                "Skills"           : jobParameter.skills,
                "gender"           : jobParameter.gender,
                "Email"            : jobParameter.email
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_JOB_SEEKER_LIST, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<JobHunterList>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getJobHunterList, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getJobHunterList, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getJobHunterList, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Get CV List Request
    // MARK: - Get Employer List
    
    func getEmployerList( jobParameter : JobHuntSearchBodyParameter ,
                          _ completion: @escaping CallObjectBack<BaseArrayResponse<EmployerList>>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getEmployerList)
            
            let params: Parameters = [
                "key"              : Constant.KEY,
                "Employmenttype"   : jobParameter.employmentType,
                "Yearofexperience" : jobParameter.yearOfExperience,
                "Jobtitle"         : jobParameter.jobtitle,
                "Skills"           : jobParameter.skills,
                "gender"           : jobParameter.gender,
                "Email"            : jobParameter.email
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_EMPLOYER_LIST, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<EmployerList>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getEmployerList, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getEmployerList, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getEmployerList, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    }
    
    // MARK: - GET JOB HUNTER
    
    func getMyJobHuntList(
        _ completion: @escaping CallObjectBack<BaseArrayResponse<JobHunterList>>) {
            
            if self.requestsController.isConnectedToInternet() {
                self.delegate?.requestStarted(request: .getMyJobHuntList)
                
                let params: Parameters = [
                    "key" : Constant.KEY,
                ]
                
                var headers: HTTPHeaders = self.requestsController.headers
                headers["Authorization"] = self.getToken()
                
                self.AlamofireManager.request(GET_MY_JOB_LIST, method: .post ,parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<JobHunterList>, AFError>) in
                    
                    //                                if let data = response.data,
                    //                                   let string = String(data: data, encoding: .utf8) {
                    //                                    print("String \(string)")
                    //                                }
                    
                    switch response.result {
                    case .success(let baseResponse):
                        if baseResponse.success == true {
                            self.delegate?.requestFinished(request: .getMyJobHuntList, result: .Success(baseResponse))
                            completion(baseResponse)
                            
                        }else {
                            self.delegate?.requestFinished(request: .getMyJobHuntList, result: .Failure(.Exception(baseResponse._message)))
                            completion(nil)
                        }
                        break
                        
                    case .failure(let error):
                        self.delegate?.requestFinished(request: .getMyJobHuntList, result: .Failure(.AlamofireError(error)))
                        completion(nil)
                        break
                    }
                } // End Alamofire Response
            } // End Internet Check Status
        }
    
    
    // MARK: - GET My Employer List
    
    func getMyEmployerList(
        _ completion: @escaping CallArrayBack<EmployerList>) {
            
            if self.requestsController.isConnectedToInternet() {
                self.delegate?.requestStarted(request: .getMyEmployerList)
                
                let params: Parameters = [
                    "key" : Constant.KEY,
                ]
                
                var headers: HTTPHeaders = self.requestsController.headers
                headers["Authorization"] = self.getToken()
                
                self.AlamofireManager.request(GET_MY_Employer_LIST, method: .post ,parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<EmployerList>, AFError>) in
                    
                    switch response.result {
                    case .success(let baseResponse):
                        if baseResponse.success == true {
                            self.delegate?.requestFinished(request: .getMyEmployerList, result: .Success(baseResponse))
                            completion(baseResponse._list)
                            
                        }else {
                            self.delegate?.requestFinished(request: .getMyEmployerList, result: .Failure(.Exception(baseResponse._message)))
                            completion(nil)
                        }
                        break
                        
                    case .failure(let error):
                        self.delegate?.requestFinished(request: .getMyEmployerList, result: .Failure(.AlamofireError(error)))
                        completion(nil)
                        break
                    }
                } // End Alamofire Response
            } // End Internet Check Status
        }
    
    
    // MARK: - ADD JOBHUNTER
    
    func addJobHunt(job : JobHunterList , profilePicture : Int? = nil, fileID : Int? = nil,
                    _ completion: @escaping CallObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .addJobHunt)
            
            let params: Parameters = [
                "key"                : Constant.KEY,
                "Phonenumber"        : job._phoneNumber,
                "Name"               : job._employerName,
                "Employername"       : job._employerName,
                "Employmenttype"     : job._employType,
                "Jobtitle"           : job._jobTitle,
                "Language"           : job._language,
                "Yearofexperience"   : job._yearOfExperience,
                "Industry"           : job._industry,
                "ProfilePicture"     : profilePicture ?? 0 ,
                "Resident"           : job._resident,
                "Nationality"        : job._nationality,
                "Skills"             : job._skills,
                "Email"              : job._email,
                "CV_URL"             : job._CV_URL,
                "Profile_pictureURL" : job._profilePictureURL,
                "Currentlocation"    : job._currentLocation,
                "Noredoo_PhoneNo"    : job._noredooPhoneNo,
                "ID_emp"             : job._iD_emp,
                "expired_date"       : job._expairedDate,
                "membertype"         : job._memberType,
                "ip"                 : job._iPDevice,
                "region"             : job._region,
                "add_cat"            : job._addCat,
                "sim_location"       : job._simLocation,
                "post_location"      : job._postLocation,
                "AllowNoredochat"    : job._allowNoredochat,
                "Account_ID"         : job._accountID,
                "gender"             : job._gender,
                "FileID"             : fileID ?? 0 ,
                "Job_Seeker_ID"      : job._jobSeekerID
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(ADD_JOB_HUNT, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                //                                                if let data = response.data,
                //                                                   let string = String(data: data, encoding: .utf8) {
                //                                                    print("String \(string)")
                //                                                }
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .addJobHunt, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .addJobHunt, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .addJobHunt, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    }
    
    // MARK: - UPDATE JOBHUNTER
    
    func updateJobHunt(job : JobHunterList , profilePicture : Int? = nil, fileID : Int? = nil,
                       _ completion: @escaping CallObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .updateJobHunt)
            
            let params: Parameters = [
                "key"                : Constant.KEY,
                "Phonenumber"        :job._phoneNumber,
                "Name"               :job._employerName,
                "Employername"       :job._employerName,
                "Employmenttype"     : job._employType,
                "Jobtitle"           : job._jobTitle,
                "Language"           : job._language,
                "Yearofexperience"   : job._yearOfExperience,
                "Industry"           : job._industry,
                "ProfilePicture"     : profilePicture ?? 0 ,
                "Resident"           : job._resident,
                "Nationality"        : job._nationality,
                "Skills"             : job._skills,
                "Email"              : job._email,
                "CV_URL"             : job._CV_URL,
                "Profile_pictureURL" : job._profilePictureURL,
                "Currentlocation"    : job._currentLocation,
                "Noredoo_PhoneNo"    : job._noredooPhoneNo,
                "ID_emp"             : job._iD_emp,
                "expired_date"       : job._expairedDate,
                "membertype"         : job._memberType,
                "ip"                 : job._iPDevice,
                "region"             : job._region,
                "add_cat"            : job._addCat,
                "sim_location"       : job._simLocation,
                "post_location"      : job._postLocation,
                "AllowNoredochat"    : job._allowNoredochat,
                "Account_ID"         : job._accountID,
                "gender"             : job._gender,
                "FileID"             : fileID ?? 0 ,
                "Job_Seeker_ID"      : job._jobSeekerID
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(UPDATE_JOB_HUNT, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .updateJobHunt, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .updateJobHunt, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .updateJobHunt, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    }
    // MARK: - DELETE JOBHUNTER
    
    func deleteJobHunt(id : Double,
                       _ completion: @escaping CallObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .deleteJobHunt)
            
            let params: Parameters = [
                "key"           : Constant.KEY,
                "Job_Seeker_ID" : id
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(DELETE_JOB_HUNTER, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                //                if let data = response.data,
                //                   let string = String(data: data, encoding: .utf8) {
                //                    print("String \(string)")
                //                }
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .deleteJobHunt, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .deleteJobHunt, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .deleteJobHunt, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    }
    
    // MARK: - ADD Employer
    
    func addEmployer(employer : EmployerList ,companyLogoID : Int? = nil,
                     _ completion: @escaping CallObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .addEmployer)
            
            let params: Parameters = [
                "key"                : Constant.KEY,
                "Employername"       :employer._employer_name,
                "Employmenttype"     :employer._employment_type ,
                "Jobtitle"           :employer._job_title ,
                "Language"           :employer._empLanguages ,
                "Yearofexperience"   :employer._yearofexperience ,
                "Industry"           :employer._industry ,
                "Applicantlocation"  :employer._applicant_location ,
                "DesiredSkills"      :employer._desired_Skills ,
                "Jobdescription"     :employer._job_description ,
                "Website"            :employer._website ,
                "Email"              :employer._email ,
                "Phonenumber"        :employer._phone_number ,
                "Currentlocation"    :employer._current_location ,
                "Noredoo_PhoneNo"    :employer._noredoo_PhoneNo ,
                "ID_emp"             :employer._iD_emp ,
                "expired_date"       :employer._expairedDate ,
                "ip"                 :employer._iP_device ,
                "region"             :employer._region ,
                "add_cat"            :employer._add_Cat ,
                "membertype"         :employer._member_Type ,
                "sim_location"       :employer._sim_location ,
                "post_location"      :employer._post_location ,
                "AllowNoredochat"    :employer._allowNoredochat ,
                "Account_ID"         :employer._account_ID ,
                "logo"               :employer._logo ,
                "gender"             :employer._gender ,
                "Employer_id"        :employer._employer_id ,
                "CompanyLogoID"      : companyLogoID ?? 0
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(ADD_EMPLOYER, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                //                                                if let data = response.data,
                //                                                   let string = String(data: data, encoding: .utf8) {
                //                                                    print("String \(string)")
                //                                                }
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .addEmployer, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .addEmployer, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .addEmployer, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    }
    
    
    // MARK: - Update Employer
    
    func updateEmployer(employer : EmployerList ,companyLogoID : Int? = nil,
                        _ completion: @escaping CallObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .addEmployer)
            
            let params: Parameters = [
                "key"                :Constant.KEY,
                "Employername"       :employer._employer_name,
                "Employmenttype"     :employer._employment_type ,
                "Jobtitle"           :employer._job_title ,
                "Language"           :employer._empLanguages ,
                "Yearofexperience"   :employer._yearofexperience ,
                "Industry"           :employer._industry ,
                "Applicantlocation"  :employer._applicant_location ,
                "DesiredSkills"      :employer._desired_Skills ,
                "Jobdescription"     :employer._job_description ,
                "Website"            :employer._website ,
                "Email"              :employer._email ,
                "Phonenumber"        :employer._phone_number ,
                "Currentlocation"    :employer._current_location ,
                "Noredoo_PhoneNo"    :employer._noredoo_PhoneNo ,
                "ID_emp"             :employer._iD_emp ,
                "expired_date"       :employer._expairedDate ,
                "ip"                 :employer._iP_device ,
                "region"             :employer._region ,
                "add_cat"            :employer._add_Cat ,
                "membertype"         :employer._member_Type ,
                "sim_location"       :employer._sim_location ,
                "post_location"      :employer._post_location ,
                "AllowNoredochat"    :employer._allowNoredochat ,
                "Account_ID"         :employer._account_ID ,
                "logo"               :employer._logo ,
                "gender"             :employer._gender ,
                "Employer_id"        :employer._employer_id ,
                "CompanyLogoID"      :companyLogoID ?? 0
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(UPDATE_EMPLOYER, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                //                                                if let data = response.data,
                //                                                   let string = String(data: data, encoding: .utf8) {
                //                                                    print("String \(string)")
                //                                                }
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .updateEmployer, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .updateEmployer, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .updateEmployer, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    }
    
    // MARK: - DELETE EMPLOYER
    
    func deleteEmployer(employerID : Double,
                        IDEmp : String? = nil,
                        _ completion: @escaping CallObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .deleteEmployer)
            
            let params: Parameters = [
                "key"           : Constant.KEY,
                "Employer_id": employerID,
                "ID_emp": IDEmp ?? ""
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(DELETE_EMPLOYER, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .deleteEmployer, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .deleteEmployer, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .deleteEmployer, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    }
    
    // MARK: - KULUD PHARMACY
    
    // MARK: - KULUD CONFIRM PAYMENT
    
    func kuludConfirmPayment(pinCode: String, amount: Double, _ completion: @escaping CallObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .kuludConfirmPayment)
            
            let params: Parameters = [
                "PinCode" : pinCode,
                "Amount" : amount,
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(KULUD_CONFIRM_PAYMENT, method: .post, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .kuludConfirmPayment, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .kuludConfirmPayment, result: .Failure(.Exception(baseResponse._message)))
                        completion(baseResponse)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .kuludConfirmPayment, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    } // End Kulud Confirm Payment Request
    
    
    
    // MARK: - TOKENIZED PAYMENT
    
    // MARK: - ProcessTokenizedPayment
    func getProcessTokenizedPayment(amount : Double ,
                                    cardID : Int ,
                                    _ completion: @escaping CallObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getProcessTokenizedPayment)
            let params: Parameters = [:]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            let url = getProcessTokenizedPaymentURL(amount: amount, cardID: cardID)
            
            self.AlamofireManager.request(url,
                                          method     : .get,
                                          parameters : params,
                                          headers    : headers )
            .validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
//                if let data = response.data,
//                   let string = String(data: data, encoding: .utf8) {
//                    print("String \(string)")
//                }
//
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getProcessTokenizedPayment, result: .Success(baseResponse))
                        completion(baseResponse)
                    } else {
                        self.delegate?.requestFinished(request: .getProcessTokenizedPayment, result: .Failure(.Exception(baseResponse._message)))
                        completion(baseResponse)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getProcessTokenizedPayment, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    }
    
    // MARK: - ProcessTokenizedPaymentQR
    
    func addProcessTokenizedPaymentQR(amount       : Int,
                                      cardID       : Int,
                                      qrCodeData   : String,
                                      _ completion : @escaping CallObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .addProcessTokenizedPaymentQR)
            
            let params: Parameters = ["Amount"     : amount,
                                      "card_id"    : cardID,
                                      "QrCodeData" : qrCodeData
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(PROCESS_TOKENIZED_PAYMENT_QR,
                                          method     : .post,
                                          parameters : params,
                                          encoding: URLEncoding.httpBody,
                                          headers    : headers)
            .validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .addProcessTokenizedPaymentQR, result: .Success(baseResponse))
                        completion(baseResponse)
                    } else {
                        self.delegate?.requestFinished(request: .addProcessTokenizedPaymentQR, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .addProcessTokenizedPaymentQR, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    }
    
    // MARK: - GetTokenizedCardDetails
    
    func getTokenizedCardDetails( _ completion: @escaping CallArrayBack<TokenizedCard>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getTokenizedCardDetails)
            
            let params: Parameters = [:]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(GET_TOKENIZED_CARD_DETAILS, method: .get, parameters: params, headers: headers).validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<TokenizedCard>, AFError>) in
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getTokenizedCardDetails, result: .Success(baseResponse))
                        completion(baseResponse._list)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getTokenizedCardDetails, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getTokenizedCardDetails, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    }
    
    // MARK: - DELETE PAMENT
    
    func deleteTokenizedPaymentCard(id : Int,
                                    _ completion: @escaping CallObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .deleteTokenizedPaymentCard)
            
            let params: Parameters = [:]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            let url  = deleteTokenizedPamentCardURL(ID: id)
            self.AlamofireManager.request(url,
                                          method: .post,
                                          parameters: params,
                                          headers: headers)
            
            .validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                //
                //                if let data = response.data,
                //                   let string = String(data: data, encoding: .utf8) {
                //                    print("Response Data => \(string)")
                //                }
                //
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .deleteTokenizedPaymentCard, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .deleteTokenizedPaymentCard, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .deleteTokenizedPaymentCard, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    }
    
    
    // MARK: - SetDefaultCardTokenized
    
    func setDefaultCardTokenized(cardId : Int,
                                 _ completion: @escaping CallObjectBack<BaseArrayResponse<TokenizedCard>>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .setDefaultCardTokenized)
            
            let params: Parameters = [:]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            let url  = setDefaultCard(cardID: cardId)
            
            self.AlamofireManager.request(url,
                                          method: .get,
                                          parameters: params,
                                          headers: headers )
            .validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<TokenizedCard>, AFError>) in
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .setDefaultCardTokenized, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .setDefaultCardTokenized, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .setDefaultCardTokenized, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    }
    //----------------------------------------------------
    
    // MARK: - PHONE BILL
    
    // MARK: - GET PAYMENT HISTORY BY PHONE
    
    func getPaymentsHistoryByPhone(phoneNumber : String ,
                                   _ completion: @escaping CallObjectBack<BaseArrayResponse<PaymentsHistory>>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getPaymentHistoryByPhone)
            let params: Parameters = [:]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            let url = getPaymentsHistoryByPhoneURL(phoneNumber: phoneNumber)
            
            self.AlamofireManager.request(url,
                                          method     : .get,
                                          parameters : params,
                                          headers    : headers )
            .validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<PaymentsHistory>, AFError>) in
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getPaymentHistoryByPhone, result: .Success(baseResponse))
                        completion(baseResponse)
                    } else {
                        self.delegate?.requestFinished(request: .getPaymentHistoryByPhone, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getPaymentHistoryByPhone, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    }
    
    // MARK: - EDIT PHONE BILL NAME
    
    func editPhoneBillName(name         : String,
                           operatorID   : Int,
                           phoneGroupID : Int,
                           _ completion: @escaping CallObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .editPhoneBillName)
            
            let params: Parameters = ["Name"         : name,
                                      "OperatorID"   : operatorID,
                                      "LanguageId"   : 1 ,
                                      "PhoneGroupID" :phoneGroupID
            ]
            var headers: HTTPHeaders = self.requestsController.headers
            
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(EDIT_PHONE_BILL_NAME,
                                          method    : .post,
                                          parameters: params,
                                          headers   : headers)
            
            .validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .editPhoneBillName, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .editPhoneBillName, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .editPhoneBillName, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    }
    
    // MARK: - EDIT PHONE GROUP NAME
    
    func editPhoneGroupName(name        : String,
                           operatorID   : Int,
                           phoneGroupID : Int,
                           _ completion: @escaping CallObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .editPhoneGroupName)
            
            let params: Parameters = ["Name"         : name,
                                      "OperatorID"   : operatorID,
                                      "LanguageId"   : 1 ,
                                      "PhoneGroupID" :phoneGroupID
            ]
            var headers: HTTPHeaders = self.requestsController.headers
            
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(EDIT_PHONE_GROUP_NAME,
                                          method    : .post,
                                          parameters: params,
                                          headers   : headers)
            
            .validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .editPhoneGroupName, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .editPhoneGroupName, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .editPhoneGroupName, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    }
    
    // MARK: - REMOVE PHONE GROUP
    
    func removePhoneGroup(operatorID   : Int,
                          groupID      : Int,
                          _ completion : @escaping CallObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .removePhoneGroup)
            
            let params: Parameters = [
                                      "OperatorID"   : operatorID,
                                      "LanguageId"   : 1 ,
                                      "GroupID"      : groupID
            ]
            var headers: HTTPHeaders = self.requestsController.headers
            
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(REMOVE_PHONE_GROUP,
                                          method    : .post,
                                          parameters: params,
                                          headers   : headers)
            
            .validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .removePhoneGroup, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .removePhoneGroup, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .removePhoneGroup, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    }
    
    // MARK: - REMOVE PHONE  NUMBER
    
    func removePhoneNumber(operatorID   : Int,
                           id           : Int,
                           _ completion: @escaping CallObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .removePhoneNumber)
            
            let params: Parameters = ["OperatorID"   : operatorID,
                                      "LanguageId"   : 1 ,
                                      "ID"           :id
            ]
            var headers: HTTPHeaders = self.requestsController.headers
            
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(REMOVE_PHONE_NUMBER,
                                          method    : .post,
                                          parameters: params,
                                          headers   : headers)
            
            .validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .removePhoneNumber, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .removePhoneNumber, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .removePhoneNumber, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    }
    
    // MARK: - Get Payment Request Phone Bill
    
    func getPaymentRequestViaPhoneBill(operatorID   : Int,
                                       groupID      : Int,
                                       mobileNumber : String,
                                       _ completion: @escaping CallObjectBack<PaymentRequestVia>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getPaymentRequestviaPhoneBill)
            
            let params: Parameters = [:]
            var headers: HTTPHeaders = self.requestsController.headers
            
            headers["Authorization"] = self.getToken()
            let url = getPaymentRequestviaPhoneBill(operatorID: operatorID, groupID: groupID, mobileNumber: mobileNumber)
            self.AlamofireManager.request(url,
                                          method    : .get,
                                          parameters: params,
                                          headers   : headers)
            
            .validate().responseObject(queue: .main) { (response: DataResponse<PaymentRequestVia, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getPaymentRequestviaPhoneBill, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getPaymentRequestviaPhoneBill, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getPaymentRequestviaPhoneBill, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    }
    
    // MARK: - SAVE PAYMENT REQUEST PHONE BILL
    
    
    func savePaymentRequestPhoneBill(paymentRequestPhoneBillParams : PaymentRequestPhoneBillParams,
                                     _ completion: @escaping CallObjectBack<PaymentRequestViaBillResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            
            self.delegate?.requestStarted(request: .savePaymentRequestViaPhoneBill)
            
            do {
                let url = URL(string: SAVE_PAYMENT_REQUEST_PHONE_BILL)!
                let encoder = JSONEncoder()
                let data = try encoder.encode(paymentRequestPhoneBillParams)
                
                var headers: HTTPHeaders = self.requestsController.headers
                headers["Authorization"] = self.getToken()
                
                var request = URLRequest(url: url)
                request.httpMethod = HTTPMethod.post.rawValue
                request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
                request.setValue(self.getToken(), forHTTPHeaderField: "Authorization")
                request.httpBody = data
                
                self.AlamofireManager.request(request).responseObject(queue: .main) { (response: DataResponse<PaymentRequestViaBillResponse, AFError>) in
                    
                    switch response.result {
                    case .success(let baseResponse):
                        if baseResponse.success == true {
                            self.delegate?.requestFinished(request: .savePaymentRequestViaPhoneBill, result: .Success(baseResponse))
                            completion(baseResponse)
                            
                        }else {
                            self.delegate?.requestFinished(request: .savePaymentRequestViaPhoneBill, result: .Failure(.Exception(baseResponse._message)))
                            completion(baseResponse)
                        }
                        break
                        
                    case .failure(let error):
                        self.delegate?.requestFinished(request: .savePaymentRequestViaPhoneBill, result: .Failure(.AlamofireError(error)))
                        completion(nil)
                        break
                    }
                } // End Alamofire Response
                
            } catch {
                print("ERROR \(error.localizedDescription)")
                return
            }
            
        } // End Internet Check Status
    }
    
    
//    func savePaymentRequestPhoneBill(operatorID         : Int,
//                                     groupDetails       : [GroupDetails],
//                                     isFullAmount       : Bool,
//                                     isRecurringPayment : Bool,
//                                     isPartialAmount    : Bool,
//                                     amount             : Double? = nil,
//                                     platForm           : String,
//                                     scheduledDate      : String? = nil,
//                                     _ completion: @escaping CallObjectBack<PaymentRequestViaBillResponse>) {
//
//        if self.requestsController.isConnectedToInternet() {
//            self.delegate?.requestStarted(request: .savePaymentRequestViaPhoneBill)
//
//            let params: Parameters = [
//                "OperatorID"         : operatorID,
//                "GroupDetails"       : groupDetails,
//                "IsFullAmount"       : isFullAmount ,
//                "IsRecurringPayment" : isRecurringPayment,
//                "IsPartialAmount"    : isPartialAmount,
//                "Amount"             : amount ?? 0,
//                "PlatForm"           : platForm,
//                "ScheduledDate"      : scheduledDate ?? "",
//            ]
//
//            var headers: HTTPHeaders = self.requestsController.headers
//
//            headers["Authorization"] = self.getToken()
//
//            self.AlamofireManager.request(SAVE_PAYMENT_REQUEST_PHONE_BILL,
//                                          method    : .post,
//                                          parameters: params,
//                                          encoding:  URLEncoding.httpBody,
//                                          headers   : headers)
//            .validate().responseObject(queue: .main) { (response: DataResponse<PaymentRequestViaBillResponse, AFError>) in
//
//                if let data = response.data,
//                   let string = String(data: data, encoding: .utf8) {
//                    print("Response Data => \(string)")
//                }
//
//                switch response.result {
//                case .success(let baseResponse):
//                    if baseResponse.success == true {
//                        self.delegate?.requestFinished(request: .savePaymentRequestViaPhoneBill, result: .Success(baseResponse))
//                        completion(baseResponse)
//
//                    }else {
//                        self.delegate?.requestFinished(request: .savePaymentRequestViaPhoneBill, result: .Failure(.Exception(baseResponse._message)))
//                        completion(nil)
//                    }
//                    break
//
//                case .failure(let error):
//                    self.delegate?.requestFinished(request: .savePaymentRequestViaPhoneBill, result: .Failure(.AlamofireError(error)))
//                    completion(nil)
//                    break
//                }
//            } // End Alamofire Response
//        } // End Internet Check Status
//    }
    
    // MARK: - Delete Payment Request Phone Bill
    
    func deletePaymentRequestViaPhoneBill(paymentRequestID : [String],
                                       _ completion: @escaping CallObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .deletePaymentRequestPhoneBill)
            
            let params: Parameters = [
                "PaymentRequestID":paymentRequestID
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            
            headers["Authorization"] = self.getToken()
            self.AlamofireManager.request(DELETE_PAYMENT_REQUEST_PHONE_BILL,
                                          method    : .post,
                                          parameters: params,
                                          headers   : headers)
            
            .validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .deletePaymentRequestPhoneBill, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .deletePaymentRequestPhoneBill, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .deletePaymentRequestPhoneBill, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    }
    
    // MARK: - UPDATE PAYMENT REQUEST PHONE BILL
    
    func updatePaymentRequestViaPhoneBill(paymentRequestObject : PaymentRequestDetailsObject,
                                          _ completion : @escaping CallObjectBack<PaymentRequestViaBillResponse> ) {
        
        if self.requestsController.isConnectedToInternet() {
            
            self.delegate?.requestStarted(request: .updatePaymentRequestPhoneBill)
            
            do {
                let url = URL(string: UPDATE_PAYMENT_REQUEST_PHONE_BILL)!
                let encoder = JSONEncoder()
                let data = try encoder.encode(paymentRequestObject)
                
                var headers: HTTPHeaders = self.requestsController.headers
                headers["Authorization"] = self.getToken()
                
                var request = URLRequest(url: url)
                request.httpMethod = HTTPMethod.post.rawValue
                request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
                request.setValue(self.getToken(), forHTTPHeaderField: "Authorization")
                request.httpBody = data
                
                self.AlamofireManager.request(request).responseObject(queue: .main) { (response: DataResponse<PaymentRequestViaBillResponse, AFError>) in
                    
//                    if let data = response.data,
//                       let string = String(data: data, encoding: .utf8) {
//                        print("Response Data \(string)")
//                    }
                    
                    switch response.result {
                    case .success(let baseResponse):
                        if baseResponse.success == true {
                            self.delegate?.requestFinished(request: .updatePaymentRequestPhoneBill, result: .Success(baseResponse))
                            completion(baseResponse)
                            
                        }else {
                            self.delegate?.requestFinished(request: .updatePaymentRequestPhoneBill, result: .Failure(.Exception(baseResponse._message)))
                            completion(baseResponse)
                        }
                        break
                        
                    case .failure(let error):
                        self.delegate?.requestFinished(request: .updatePaymentRequestPhoneBill, result: .Failure(.AlamofireError(error)))
                        completion(nil)
                        break
                    }
                } // End Alamofire Response
            
            } catch {
                print("ERROR \(error.localizedDescription)")
                return
            }
            
        } // End Internet Check Status
    }
    
    //----------------------------------------------------
    
    // MARK: - KAHRAMAA
    
    
    // MARK: - EDIT KAHRAMAA NAME
    
    func editKaharmaName( name        : String,
                          id          : Int,
                          _ completion: @escaping CallObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .editKaharmaName)
            
            let params: Parameters = ["Name"       : name,
                                      "LanguageId" : 1 ,
                                      "ID"         : id
            ]
            var headers: HTTPHeaders = self.requestsController.headers
            
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(EDIT_KAHRAMAA_NAME,
                                          method    : .post,
                                          parameters: params,
                                          headers   : headers)
            
            .validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .editKaharmaName, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .editKaharmaName, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .editKaharmaName, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    }
    
    // MARK: - REMOVE Kaharma  NUMBER
    
    func removeKaharmaNumber(id   : Int,
                             _ completion: @escaping CallObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .removeKaharmaNumber)
            
            let params: Parameters = ["LanguageId"   : 1 ,
                                      "ID"           :id
            ]
            var headers: HTTPHeaders = self.requestsController.headers
            
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(REMOVE_KAHRAMAA_NUMBER,
                                          method    : .post,
                                          parameters: params,
                                          headers   : headers)
            
            .validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .removeKaharmaNumber, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .removeKaharmaNumber, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .removeKaharmaNumber, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    }
    
    // MARK: - EDIT Kaharma GROUP NAME
    
    func editKaharmaGroupName(name        : String,
                              groupID     : Int,
                            _ completion: @escaping CallObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .editKaharmaGroupName)
            
            let params: Parameters = ["Name"         : name,
                                      "LanguageId"   : 1 ,
                                      "GroupID" :groupID
            ]
            var headers: HTTPHeaders = self.requestsController.headers
            
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(EDIT_KAHRAMAA_GROUP_NAME,
                                          method    : .post,
                                          parameters: params,
                                          headers   : headers)
            
            .validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .editKaharmaGroupName, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .editKaharmaGroupName, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .editKaharmaGroupName, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    }
    
    // MARK: - REMOVE Kaharma GROUP
    
    func removeKaharmaGroup(groupID    : Int,
                          _ completion : @escaping CallObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .removeKaharmaGroup)
            
            let params: Parameters = [
                "LanguageId"   : 1 ,
                "GroupID"      : groupID
            ]
            var headers: HTTPHeaders = self.requestsController.headers
            
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(REMOVE_KAHRAMAA_GROUP,
                                          method    : .post,
                                          parameters: params,
                                          headers   : headers)
            
            .validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .removeKaharmaGroup, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .removeKaharmaGroup, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .removeKaharmaGroup, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    }
    
    // MARK: - GET PAYMENT HISTORY BY KAHRAMA
    
    func getPaymentsHistoryKaharma(kaharmaNumber : String ,
                                   _ completion: @escaping CallObjectBack<BaseArrayResponse<PaymentsHistory>>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getHistoryKaharmaBill)
            let params: Parameters = [:]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            let url = getPaymentsHistoryByKahrmaURL(kahrmaNumber: kaharmaNumber)
            
            self.AlamofireManager.request(url,
                                          method     : .get,
                                          parameters : params,
                                          headers    : headers )
            .validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<PaymentsHistory>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getHistoryKaharmaBill, result: .Success(baseResponse))
                        completion(baseResponse)
                    } else {
                        self.delegate?.requestFinished(request: .getHistoryKaharmaBill, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getHistoryKaharmaBill, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    }
    
    // MARK: - Get Payment Request Kahrma Bill
    
    func getPaymentRequestviaKahrmaBill(groupID      : Int,
                                        mobileNumber : String,
                                        _ completion: @escaping CallObjectBack<PaymentRequestVia>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getPaymentRequestKahrmaBill)
            
            let params: Parameters = [:]
            var headers: HTTPHeaders = self.requestsController.headers
            
            headers["Authorization"] = self.getToken()
            let url = getPaymentRequestKahrmaURL(groupID      : groupID,
                                                 mobileNumber : mobileNumber)
            
            self.AlamofireManager.request(url,
                                          method    : .get,
                                          parameters: params,
                                          headers   : headers)
            
            .validate().responseObject(queue: .main) { (response: DataResponse<PaymentRequestVia, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getPaymentRequestKahrmaBill, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getPaymentRequestKahrmaBill, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getPaymentRequestKahrmaBill, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    }
    
    // MARK: - Delete Payment Request Kahrma Bill
    
    func deletePaymentRequestViaKahrmaBill(paymentRequestID : [String],
                                          _ completion: @escaping CallObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .deletePaymentRequestKaharmaBill)
            
            let params: Parameters = [
                "PaymentRequestID":paymentRequestID
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            
            headers["Authorization"] = self.getToken()
            self.AlamofireManager.request(DELETE_PAYMENT_REQUEST_KAHRAMAA_BILL,
                                          method    : .post,
                                          parameters: params,
                                          headers   : headers)
            
            .validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .deletePaymentRequestKaharmaBill, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .deletePaymentRequestKaharmaBill, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .deletePaymentRequestKaharmaBill, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    }
    
    // MARK: - SAVE PAYMENT REQUEST kaharma BILL
    
    func savePaymentRequestkaharmaBill(paymentRequestPhoneBillParams : PaymentRequestPhoneBillParams,
                                     _ completion: @escaping CallObjectBack<PaymentRequestViaBillResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            
            self.delegate?.requestStarted(request: .savePaymentRequestViaKaharmaBill)
            
            do {
                let url = URL(string: SAVE_PAYMENT_REQUEST_KAHRAMAA_BILL)!
                let encoder = JSONEncoder()
                let data = try encoder.encode(paymentRequestPhoneBillParams)
                
                var headers: HTTPHeaders = self.requestsController.headers
                headers["Authorization"] = self.getToken()
                
                var request = URLRequest(url: url)
                request.httpMethod = HTTPMethod.post.rawValue
                request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
                request.setValue(self.getToken(), forHTTPHeaderField: "Authorization")
                request.httpBody = data
                
                self.AlamofireManager.request(request).responseObject(queue: .main) { (response: DataResponse<PaymentRequestViaBillResponse, AFError>) in
                    
                    //                    if let data = response.data,
                    //                       let string = String(data: data, encoding: .utf8) {
                    //                        print("Response Data \(string)")
                    //                    }
                    
                    switch response.result {
                    case .success(let baseResponse):
                        if baseResponse.success == true {
                            self.delegate?.requestFinished(request: .savePaymentRequestViaKaharmaBill, result: .Success(baseResponse))
                            completion(baseResponse)
                            
                        }else {
                            self.delegate?.requestFinished(request: .savePaymentRequestViaKaharmaBill, result: .Failure(.Exception(baseResponse._message)))
                            completion(baseResponse)
                        }
                        break
                        
                    case .failure(let error):
                        self.delegate?.requestFinished(request: .savePaymentRequestViaKaharmaBill, result: .Failure(.AlamofireError(error)))
                        completion(nil)
                        break
                    }
                } // End Alamofire Response
                
            } catch {
                print("ERROR \(error.localizedDescription)")
                return
            }
            
        } // End Internet Check Status
    }
    
    // MARK: - UPDATE PAYMENT REQUEST kaharma BILL
    
    func updatePaymentRequestViaKaharmaBill(paymentRequestObject : PaymentRequestDetailsObject,
                                            _ completion     : @escaping CallObjectBack<PaymentRequestViaBillResponse> ) {
        
        if self.requestsController.isConnectedToInternet() {
            
            self.delegate?.requestStarted(request: .updatePaymentRequestKaharmaBill)
            
            do {
                let url = URL(string: UPDATE_PAYMENT_REQUEST_KAHRAMAA_BILL)!
                let encoder = JSONEncoder()
                let data = try encoder.encode(paymentRequestObject)
                
//                guard let string = String(data: data, encoding: .utf8) else { return }
//                print("String \(string)")
             
                var headers: HTTPHeaders = self.requestsController.headers
                headers["Authorization"] = self.getToken()
                
                var request = URLRequest(url: url)
                request.httpMethod = HTTPMethod.post.rawValue
                request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
                request.setValue(self.getToken(), forHTTPHeaderField: "Authorization")
                request.httpBody = data
                
                self.AlamofireManager.request(request).responseObject(queue: .main) { (response: DataResponse<PaymentRequestViaBillResponse, AFError>) in
                    
//                    if let data = response.data,
//                       let string = String(data: data, encoding: .utf8) {
//                        print("Response Data \(string)")
//                    }
                    
                    switch response.result {
                    case .success(let baseResponse):
                        if baseResponse.success == true {
                            self.delegate?.requestFinished(request: .updatePaymentRequestKaharmaBill, result: .Success(baseResponse))
                            completion(baseResponse)
                            
                        }else {
                            self.delegate?.requestFinished(request: .updatePaymentRequestKaharmaBill, result: .Failure(.Exception(baseResponse._message)))
                            completion(baseResponse)
                        }
                        break
                        
                    case .failure(let error):
                        self.delegate?.requestFinished(request: .updatePaymentRequestKaharmaBill, result: .Failure(.AlamofireError(error)))
                        completion(nil)
                        break
                    }
                } // End Alamofire Response
                
            } catch {
                print("ERROR \(error.localizedDescription)")
                return
            }
            
        } // End Internet Check Status
    }
    
    
    //----------------------------------------------------
    
    // MARK: - QATAR COOL
    // MARK: - EDIT QATAR COOL NAME
    
    func editQatarCoolName( name        : String,
                            id          : Int,
                            _ completion: @escaping CallObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .editQatarCoolName)
            
            let params: Parameters = ["Name"       : name,
                                      "LanguageId" : 1 ,
                                      "ID"         : id
            ]
            var headers: HTTPHeaders = self.requestsController.headers
            
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(EDIT_QATAR_COOL_NAME,
                                          method    : .post,
                                          parameters: params,
                                          headers   : headers)
            
            .validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .editQatarCoolName, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .editQatarCoolName, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .editQatarCoolName, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    }
    
    // MARK: - REMOVE QATAR COOL NUMBER
    
    func removeQatarCoolNumber(id   : Int,
                               _ completion: @escaping CallObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .removeQatarCoolNumber)
            
            let params: Parameters = ["LanguageId"   : 1 ,
                                      "ID"           :id
            ]
            var headers: HTTPHeaders = self.requestsController.headers
            
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(REMOVE_KAHRAMAA_NUMBER,
                                          method    : .post,
                                          parameters: params,
                                          headers   : headers)
            
            .validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .removeQatarCoolNumber, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .removeQatarCoolNumber, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .removeQatarCoolNumber, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    }
    
    // MARK: - EDIT QATAR COOL GROUP NAME
    
    func editQatarCoolGroupName(name        : String,
                                groupID     : Int,
                              _ completion: @escaping CallObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .editQatarCoolGroupName)
            
            let params: Parameters = ["Name"         : name,
                                      "LanguageId"   : 1 ,
                                      "GroupID" :groupID
            ]
            var headers: HTTPHeaders = self.requestsController.headers
            
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(EDIT_QATAR_COOL_GROUP_NAME,
                                          method    : .post,
                                          parameters: params,
                                          headers   : headers)
            
            .validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .editQatarCoolGroupName, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .editQatarCoolGroupName, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .editQatarCoolGroupName, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    }
    
    // MARK: - REMOVE QATAR COOL GROUP
    
    func removeQatarCoolGroup(groupID    : Int,
                            _ completion : @escaping CallObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .removeQatarCoolGroup)
            
            let params: Parameters = [
                "LanguageId"   : 1 ,
                "GroupID"      : groupID
            ]
            var headers: HTTPHeaders = self.requestsController.headers
            
            headers["Authorization"] = self.getToken()
            
            self.AlamofireManager.request(REMOVE_QATAR_COOL_GROUP,
                                          method    : .post,
                                          parameters: params,
                                          headers   : headers)
            
            .validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .removeQatarCoolGroup, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .removeQatarCoolGroup, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .removeQatarCoolGroup, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    }
    
    // MARK: - GET PAYMENT HISTORY BY QATAR COOL
    
    func getPaymentsHistoryQatarCool(qatarCoolNumber : String ,
                                     _ completion: @escaping CallObjectBack<BaseArrayResponse<PaymentsHistory>>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getHistoryQatarCoolBill)
            let params: Parameters = [:]
            
            var headers: HTTPHeaders = self.requestsController.headers
            headers["Authorization"] = self.getToken()
            
            let url = getPaymentsHistoryByQatarCoolURL(qatarCoolNumber: qatarCoolNumber)
            
            self.AlamofireManager.request(url,
                                          method     : .get,
                                          parameters : params,
                                          headers    : headers )
            .validate().responseObject(queue: .main) { (response: DataResponse<BaseArrayResponse<PaymentsHistory>, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getHistoryQatarCoolBill, result: .Success(baseResponse))
                        completion(baseResponse)
                    } else {
                        self.delegate?.requestFinished(request: .getHistoryQatarCoolBill, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getHistoryQatarCoolBill, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    }
    
    // MARK: - Get Payment Request QATARCOOL Bill
    
    func getPaymentRequestviaQatarCoolBill(groupID      : Int,
                                           mobileNumber : String,
                                           _ completion: @escaping CallObjectBack<PaymentRequestVia>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .getPaymentRequestQatarCoolBill)
            
            let params: Parameters = [:]
            var headers: HTTPHeaders = self.requestsController.headers
            
            headers["Authorization"] = self.getToken()
            let url = getPaymentRequestQatarCoolURL(groupID: groupID,
                                                    number : mobileNumber)
            
            self.AlamofireManager.request(url,
                                          method    : .get,
                                          parameters: params,
                                          headers   : headers)
            
            .validate().responseObject(queue: .main) { (response: DataResponse<PaymentRequestVia, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .getPaymentRequestQatarCoolBill, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .getPaymentRequestQatarCoolBill, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .getPaymentRequestQatarCoolBill, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    }
    
    // MARK: - Delete Payment Request Via QatarCool Bill
    
    func deletePaymentRequestViaQatarCoolBill(paymentRequestID : [String],
                                           _ completion: @escaping CallObjectBack<BaseResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .deletePaymentRequestQatarCoolBill)
            
            let params: Parameters = [
                "PaymentRequestID":paymentRequestID
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            
            headers["Authorization"] = self.getToken()
            self.AlamofireManager.request(DELETE_PAYMENT_REQUEST_QATAR_COOL_BILL,
                                          method    : .post,
                                          parameters: params,
                                          headers   : headers)
            
            .validate().responseObject(queue: .main) { (response: DataResponse<BaseResponse, AFError>) in
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .deletePaymentRequestQatarCoolBill, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .deletePaymentRequestQatarCoolBill, result: .Failure(.Exception(baseResponse._message)))
                        completion(nil)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .deletePaymentRequestQatarCoolBill, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    }
    
    // MARK: - SAVE PAYMENT REQUEST QATARCOOL BILL
    
    func savePaymentRequestQatarCoolBill(paymentRequestPhoneBillParams : PaymentRequestPhoneBillParams,
                                       _ completion: @escaping CallObjectBack<PaymentRequestViaBillResponse>) {
        
        if self.requestsController.isConnectedToInternet() {
            
            self.delegate?.requestStarted(request: .savePaymentRequestViaQatarCoolBill)
            
            do {
                let url = URL(string: SAVE_PAYMENT_REQUEST_QATAR_COOL_BILL)!
                let encoder = JSONEncoder()
                let data = try encoder.encode(paymentRequestPhoneBillParams)
                
                var headers: HTTPHeaders = self.requestsController.headers
                headers["Authorization"] = self.getToken()
                
                var request = URLRequest(url: url)
                request.httpMethod = HTTPMethod.post.rawValue
                request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
                request.setValue(self.getToken(), forHTTPHeaderField: "Authorization")
                request.httpBody = data
                
                self.AlamofireManager.request(request).responseObject(queue: .main) { (response: DataResponse<PaymentRequestViaBillResponse, AFError>) in
                    
                    //                    if let data = response.data,
                    //                       let string = String(data: data, encoding: .utf8) {
                    //                        print("Response Data \(string)")
                    //                    }
                    
                    switch response.result {
                    case .success(let baseResponse):
                        if baseResponse.success == true {
                            self.delegate?.requestFinished(request: .savePaymentRequestViaQatarCoolBill, result: .Success(baseResponse))
                            completion(baseResponse)
                            
                        }else {
                            self.delegate?.requestFinished(request: .savePaymentRequestViaQatarCoolBill, result: .Failure(.Exception(baseResponse._message)))
                            completion(baseResponse)
                        }
                        break
                        
                    case .failure(let error):
                        self.delegate?.requestFinished(request: .savePaymentRequestViaQatarCoolBill, result: .Failure(.AlamofireError(error)))
                        completion(nil)
                        break
                    }
                } // End Alamofire Response
                
            } catch {
                print("ERROR \(error.localizedDescription)")
                return
            }
            
        } // End Internet Check Status
    }
    
    // MARK: - UPDATE PAYMENT REQUEST QATARCOOL BILL
    
    func updatePaymentRequestViaQatarCoolBill(paymentRequestObject : PaymentRequestDetailsObject,
                                              _ completion     : @escaping CallObjectBack<PaymentRequestViaBillResponse> ) {
        
        if self.requestsController.isConnectedToInternet() {
            
            self.delegate?.requestStarted(request: .updatePaymentRequestQatarCoolBill)
            
            do {
                let url = URL(string: UPDATE_PAYMENT_REQUEST_QATAR_COOL_BILL)!
                let encoder = JSONEncoder()
                let data = try encoder.encode(paymentRequestObject)
                
                var headers: HTTPHeaders = self.requestsController.headers
                headers["Authorization"] = self.getToken()
                
                var request = URLRequest(url: url)
                request.httpMethod = HTTPMethod.post.rawValue
                request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
                request.setValue(self.getToken(), forHTTPHeaderField: "Authorization")
                request.httpBody = data
                
                self.AlamofireManager.request(request).responseObject(queue: .main) { (response: DataResponse<PaymentRequestViaBillResponse, AFError>) in
                    
                    switch response.result {
                    case .success(let baseResponse):
                        if baseResponse.success == true {
                            self.delegate?.requestFinished(request: .updatePaymentRequestQatarCoolBill, result: .Success(baseResponse))
                            completion(baseResponse)
                            
                        }else {
                            self.delegate?.requestFinished(request: .updatePaymentRequestQatarCoolBill, result: .Failure(.Exception(baseResponse._message)))
                            completion(baseResponse)
                        }
                        break
                        
                    case .failure(let error):
                        self.delegate?.requestFinished(request: .updatePaymentRequestQatarCoolBill, result: .Failure(.AlamofireError(error)))
                        completion(nil)
                        break
                    }
                } // End Alamofire Response
                
            } catch {
                print("ERROR \(error.localizedDescription)")
                return
            }
            
        } // End Internet Check Status
    }
    
    
    
    // MARK: -  NOQSTransferBillPayment
    
    
    
    func noqsTransferBillPayment(accessToken    : String,
                                 verificationID : String,
                                 requestID      : [String],
                                 pinCode        : String,
                                 _ completion: @escaping CallObjectBack<BaseObjectResponse<Beneficiary>>) {
        
        if self.requestsController.isConnectedToInternet() {
            self.delegate?.requestStarted(request: .noqsTransferBillPayment)
            
            let params: Parameters = [
                "AccessToken" : accessToken,
                "VerificationID" : verificationID,
                "RequestID" : requestID,
                "PinCode" : pinCode,
                "Bill_ID" : []
            ]
            
            var headers: HTTPHeaders = self.requestsController.headers
            
            headers["Authorization"] = self.getToken()
            self.AlamofireManager.request(NOQS_TRANSFER_BILL_PAYMENT,
                                          method    : .post,
                                          parameters: params,
                                          headers   : headers)
            .validate().responseObject(queue: .main) { (response: DataResponse<BaseObjectResponse<Beneficiary>, AFError>) in
                
                if let data = response.data,
                   let string = String(data: data, encoding: .utf8) {
                    print("Response Data => \(string)")
                }
                
                switch response.result {
                case .success(let baseResponse):
                    if baseResponse.success == true {
                        self.delegate?.requestFinished(request: .noqsTransferBillPayment, result: .Success(baseResponse))
                        completion(baseResponse)
                        
                    }else {
                        self.delegate?.requestFinished(request: .noqsTransferBillPayment, result: .Failure(.Exception(baseResponse._message)))
                        completion(baseResponse)
                    }
                    break
                    
                case .failure(let error):
                    self.delegate?.requestFinished(request: .noqsTransferBillPayment, result: .Failure(.AlamofireError(error)))
                    completion(nil)
                    break
                }
            } // End Alamofire Response
        } // End Internet Check Status
    }
    
} // End Request Service Class

