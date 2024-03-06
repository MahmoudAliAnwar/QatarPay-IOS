//
//  CategoriesSceneWorker.swift
//  kulud
//
//  Created by Hussam Elsadany on 29/05/2021.
//  Copyright © 2021 Qmobile-IT. All rights reserved.
//

struct CategoriesSceneWorker {
    
    func getCategoryProducts(categoryId: Int,
                             success: @escaping([CategoryModel]) -> Void,
                             failure: @escaping(Error) -> Void) {
        let request = StoreApiBuilder.getStoreCategoryProducts(categoryId: categoryId)
        Network.shared.request(request: request) { (result: KuludResult<ApiResponse<[CategoryModel]>>) in
            switch result {
            case .success(let response):
                success(response.responseObject ?? [])
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    func search(cactegoryId: Int, keyword: String,
                success: @escaping(SearchModel?) -> Void,
                failure: @escaping(Error) -> Void) {
        
        let request = StoreApiBuilder.search(categoryId: cactegoryId, keyWord: keyword)
        Network.shared.request(request: request) { (result: KuludResult<ApiResponse<SearchModel>>) in
            switch result {
            case .success(let response):
                success(response.responseObject)
            case .failure(let error):
                failure(error)
            }
        }
    }
}
