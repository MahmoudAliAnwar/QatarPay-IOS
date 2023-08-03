//
//  BaseInfoProtocol.swift
//  QPay
//
//  Created by Mohammed Hamad on 06/06/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit

class BaseInfoConfiguration {
    
    var requests: BaseInfoRequests
    var config: BaseInfoConfig
    
    /// Limousine Section Configuration
    static var limousineShared = BaseInfoConfiguration(requests: LimousineRequests(),
                                                       config: LimousineConfig()
    )
    
    /// Child Care Section Configuration
    static var childCareShared = BaseInfoConfiguration(requests: ChildCareRequests(),
                                                       config: ChildCareConfig()
    )
    
    /// Hotel Section Configuration
    static var hotelShared = BaseInfoConfiguration(requests: HotelRequests(),
                                                   config: HotelConfig()
    )
    
    /// Dine Section Configuration
    static var dineShared = BaseInfoConfiguration(requests: DineRequests(),
                                                   config: DineConfig()
    )
    
    /// Insurances Section Configuration
    static var insurancesShared = BaseInfoConfiguration(requests: InsurancesRequests(),
                                                  config: InsurancesConfig()
    )
    
    /// MedicalCenter Section Configuration
    static var medicalCenterShared = BaseInfoConfiguration(requests: MedicalCenterRequests(),
                                                        config: MedicalCenterConfig()
    )
    
    /// QaterSchools Section Configuration
    static var qaterSchoolsShared = BaseInfoConfiguration(requests: QaterSchoolsRequests(),
                                                           config: QaterSchoolsConfig()
    )
    
    public init(requests: BaseInfoRequests, config: BaseInfoConfig) {
        self.requests = requests
        self.config = config
    }
}

protocol BaseInfoRequests {
    func getTabs            (_ completion: @escaping  ((Result<[BaseInfoTabModel], Error>) -> Void))
    func getData            (tabId: Int,  _ completion: @escaping ((Result<[BaseInfoDataModel], Error>) -> Void))
    func getMyFavoriteList  (_ completion: @escaping ((Result<[BaseInfoDataModel], Error>) -> Void))
    func addToFavorite      (itemId: Int,  _ completion: @escaping ((Result<BaseResponse, Error>) -> Void))
    func removeFromFavorite (itemId: Int,  _ completion: @escaping ((Result<BaseResponse, Error>) -> Void))
}

extension BaseInfoRequests {
    
    var requestProxy: RequestServiceProxy {
        get {
            RequestServiceProxy.shared
        }
    }
}
