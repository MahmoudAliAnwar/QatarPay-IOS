//
//  HomeSceneModels.swift
//  kulud
//
//  Created by Hussam Elsadany on 10/03/2021.
//  Copyright (c) 2021 Qmobile-IT. All rights reserved.
//

enum HomeScene {
    enum Collections { }
    enum Categories { }
    enum Advertisements { }
}

extension HomeScene.Categories {
    struct Category {
        var name: String
        var image: String
    }
    
    struct ViewModel {
        let categories: [Category]
    }
}

extension HomeScene.Advertisements {
    struct Advertisement {
        var name: String
        var image: String
    }
    
    struct ViewModel {
        let advertisements: [Advertisement]
    }
}

extension HomeScene.Collections {
    struct Product {
        let name: String
        let desc: String
        let isWishList: Bool
        let price: String
        let image: String
        let images: [String]
        let isCart: Bool
        let quantity: Int
    }
    
    struct Collection {
        let name: String
        let products: [Product]
    }
    
    struct ViewModel {
        let collections: [Collection]
    }
}
