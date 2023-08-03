//
//  ChildCareRequests.swift
//  QPay
//
//  Created by Mohammed Hamad on 08/06/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit

class ChildCareRequests: BaseInfoRequests {
    
    func getTabs(_ completion: @escaping ((Result<[BaseInfoTabModel], Error>) -> Void)) {
        self.requestProxy.requestService()?.getChildCareTab({  response in
            
            guard let resp = response else {
                completion(.failure(ErrorType.Exception("Invalid Response")))
                return
            }
            
            guard resp._success else {
                completion(.failure(ErrorType.Exception(resp._message)))
                return
            }
            
            let childCareArray = resp._list
            let arr = ChildCareTabBaseInfoAdapter(array: childCareArray).convert()
            
            completion(.success(arr))
        })
    }
    
    func getData(tabId: Int,  _ completion: @escaping  ((Result<[BaseInfoDataModel], Error>) -> Void)) {
        self.requestProxy.requestService()?.getChildCareItmes(BuisCategID: tabId, { response in
            guard let resp = response else {
                completion(.failure(ErrorType.Exception("Invalid Response")))
                return
            }
            
            guard resp._success else {
                completion(.failure(ErrorType.Exception(resp._message)))
                return
            }
            
            let childCareArray = resp._list
            let arr = ChildCareDataBaseInfoAdapter(array: childCareArray).convert()
            completion(.success(arr))
        })
    }
    
    func getMyFavoriteList(_ completion: @escaping ((Result<[BaseInfoDataModel], Error>) -> Void)) {
        self.requestProxy.requestService()?.getMyChildCareList({ (response) in
            guard let resp = response else {
                completion(.failure(ErrorType.Exception("Invalid Response")))
                return
            }
            
            guard resp._success else {
                completion(.failure(ErrorType.Exception(resp._message)))
                return
            }
            
            let childCare = resp._list
            
            let arr = ChildCareDataBaseInfoAdapter(array: childCare).convert()
            completion(.success(arr))
        })
    }
    
    func addToFavorite(itemId: Int, _ completion: @escaping ((Result<BaseResponse, Error>) -> Void)) {
        self.requestProxy.requestService()?.addChildCareToMyList(id: itemId, { (response) in
            guard let resp = response else {
                completion(.failure(ErrorType.Exception("add to fava response")))
                print("error add")
                return
            }
            guard resp._success else {
                print(resp._success)
                completion(.failure(ErrorType.Exception("resp._success")))
                return
            }
            completion(.success(resp))
        })
    }
    
    func removeFromFavorite(itemId: Int, _ completion: @escaping((Result<BaseResponse, Error>) -> Void)) {
        self.requestProxy.requestService()?.removeChildCareFromMyList(id: itemId, { (response) in
            guard let resp = response else {
                completion(.failure(ErrorType.Exception("remove from fava response")))
                return
            }
            guard resp._success else {
                completion(.failure(ErrorType.Exception("resp._success")))
                return
            }
            completion(.success(resp))
        })
    }
}

