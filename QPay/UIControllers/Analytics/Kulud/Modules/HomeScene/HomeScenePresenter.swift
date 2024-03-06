//
//  HomeScenePresenter.swift
//  kulud
//
//  Created by Hussam Elsadany on 10/03/2021.
//  Copyright (c) 2021 Qmobile-IT. All rights reserved.
//

protocol HomeSceneViewDataStore: AnyObject {
    var categories: HomeScene.Categories.ViewModel? { get set }
    var advertisementsType1: HomeScene.Advertisements.ViewModel? { get set }
    var advertisementsType2: HomeScene.Advertisements.ViewModel? { get set }
    var collections: HomeScene.Collections.ViewModel? { get set }
}

protocol HomeScenePresentationLogic: AnyObject {
    func presentStore(details: StoreModel)
    func presentFailure(error: Error)
}

class HomeScenePresenter: HomeSceneViewDataStore {
    
    // MARK: Stored Properties
    weak var displayView: HomeSceneDisplayView?
    
    var categories: HomeScene.Categories.ViewModel?
    var advertisementsType1: HomeScene.Advertisements.ViewModel?
    var advertisementsType2: HomeScene.Advertisements.ViewModel?
    var collections: HomeScene.Collections.ViewModel?
    
    // MARK: Initializers
    required init(displayView: HomeSceneDisplayView) {
        self.displayView = displayView
    }
}

extension HomeScenePresenter: HomeScenePresentationLogic {

    func presentStore(details: StoreModel) {
        
        var advertisements1 = [HomeScene.Advertisements.Advertisement]()
        var advertisements2 = [HomeScene.Advertisements.Advertisement]()
        details.advertisement?.forEach {
            let adv = HomeScene.Advertisements.Advertisement(name: $0.localizedName ?? "", image: $0.image ?? "")
            if $0.typeID == "1" {
                advertisements1.append(adv)
            } else {
                advertisements2.append(adv)
            }
        }
        self.advertisementsType1 = HomeScene.Advertisements.ViewModel(advertisements: advertisements1)
        self.advertisementsType2 = HomeScene.Advertisements.ViewModel(advertisements: advertisements2)
        self.displayView?.displayAdvertisements1(viewModel: self.advertisementsType1!)
        self.displayView?.displayAdvertisements2(viewModel: self.advertisementsType2!)
        
        var categories = [HomeScene.Categories.Category]()
        details.categories?.forEach {
            let category = HomeScene.Categories.Category(name: $0.localizedName ?? "", image: $0.image ?? "")
            categories.append(category)
        }
        self.categories = HomeScene.Categories.ViewModel(categories: categories)
        self.displayView?.displayCategories(viewModel: self.categories!)
        
        var collections = [HomeScene.Collections.Collection]()
        details.collections?.forEach {
            var newProducts = [HomeScene.Collections.Product]()
            $0.products?.forEach {
                let images = $0.productsImages?.compactMap{$0.image} ?? []
                let image  = images.count > 0 ? images[0] : $0.image
                let product = HomeScene.Collections.Product(name: $0.localizedName ?? "",
                                                            desc: $0.localizedDescription ?? "",
                                                            isWishList: $0.isWishList ?? false,
                                                            price: String(format: "%.2f", $0.price ?? 0),
                                                            image: image ?? "",
                                                            images: images,
                                                            isCart: $0.isCart ?? false,
                                                            quantity: $0.quantity ?? 0)
                newProducts.append(product)
            }
            let collection = HomeScene.Collections.Collection(name: $0.localizedName ?? "",
                                                              products: newProducts)
            collections.append(collection)
        }
        self.collections = HomeScene.Collections.ViewModel(collections: collections)
        self.displayView?.displayCollections(viewModel: self.collections!)
    }
    
    func presentFailure(error: Error) {
        self.displayView?.displayError(message: error.localizedDescription)
    }
}
