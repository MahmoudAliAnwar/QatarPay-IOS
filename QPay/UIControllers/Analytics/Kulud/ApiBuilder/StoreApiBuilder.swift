//
//  StoreApiBuilder.swift
//  kulud
//
//  Created by Hussam Elsadany on 16/05/2021.
//  Copyright © 2021 Qmobile-IT. All rights reserved.
//

import Alamofire

enum StoreApiBuilder {
    case getStoreDetails(storeId: Int)
    case getStoreCategoryProducts(categoryId: Int)
    case search(categoryId: Int, keyWord: String)
}

extension StoreApiBuilder: URLRequestBuilder {
    
    var path: String {
        switch self {
        case .getStoreDetails:
            return NetworkPaths.Store.storeDetails
        case .getStoreCategoryProducts:
            return NetworkPaths.Store.categoryDetails
        case .search:
            return NetworkPaths.Store.search
        }
    }
    
    var pathArgs: [String]? {
        switch self {
        case .getStoreDetails(let storeId):
            return [String(describing: storeId)]
        case .getStoreCategoryProducts(let categoryId):
            return [String(describing: categoryId)]
        default:
            return nil
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .search(let categoryId, let keyWord):
            return ["categoryId": categoryId,
                    "storeId": Constants.STOREID,
                    "keyWord": keyWord,
                    "sort": 0]
        default:
            return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .search:
            return .post
        default:
            return .get
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .search:
            return JSONEncoding.default
        default:
            return URLEncoding(destination: .queryString)
        }
    }
}
