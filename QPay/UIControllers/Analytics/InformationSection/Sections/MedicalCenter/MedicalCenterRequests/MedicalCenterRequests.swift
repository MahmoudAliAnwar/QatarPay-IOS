//
//  MedicalCenterRequests.swift
//  QPay
//
//  Created by Mohammed Hamad on 10/06/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation

class MedicalCenterRequests: BaseInfoRequests {
    
    func getTabs(_ completion: @escaping ((Result<[BaseInfoTabModel], Error>) -> Void)) {
        self.requestProxy.requestService()?.getMedicalCenterTab({  response in
            
            guard let resp = response else {
                completion(.failure(ErrorType.Exception("Invalid Response")))
                return
            }
            
            guard resp._success else {
                completion(.failure(ErrorType.Exception(resp._message)))
                return
            }
            
            let MedicalCenterArray = resp._list
            let arr = MedicalCenterTabBaseInfoAdapter(array: MedicalCenterArray).convert()
            
            completion(.success(arr))
        })
    }
    
    func getData(tabId: Int,  _ completion: @escaping  ((Result<[BaseInfoDataModel], Error>) -> Void)) {
        self.requestProxy.requestService()?.getMedicalCenterItmes(BuisCategID: tabId, { response in
            guard let resp = response else {
                completion(.failure(ErrorType.Exception("Invalid Response")))
                return
            }
            
            guard resp._success else {
                completion(.failure(ErrorType.Exception(resp._message)))
                return
            }
            
            let MedicalCenterArray = resp._list
            let arr = MedicalCenterDataBaseInfoAdapter(array: MedicalCenterArray).convert()
            completion(.success(arr))
        })
    }
    
    func getMyFavoriteList(_ completion: @escaping ((Result<[BaseInfoDataModel], Error>) -> Void)) {
        self.requestProxy.requestService()?.getMyMedicalCenterList({ (response) in
            guard let resp = response else {
                completion(.failure(ErrorType.Exception("Invalid Response")))
                return
            }
            
            guard resp._success else {
                completion(.failure(ErrorType.Exception(resp._message)))
                return
            }
            
            let MedicalCenterArray = resp._list
            
            let arr = MedicalCenterDataBaseInfoAdapter(array: MedicalCenterArray).convert()
            completion(.success(arr))
        })
    }
    
    func addToFavorite(itemId: Int, _ completion: @escaping ((Result<BaseResponse, Error>) -> Void)) {
        self.requestProxy.requestService()?.addMedicalCenterToMyList(id: itemId, { (response) in
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
        self.requestProxy.requestService()?.removeMedicalCenterFromMyList(id: itemId, { (response) in
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
