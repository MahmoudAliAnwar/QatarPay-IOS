//
//  CategoriesScenePresenter.swift
//  kulud
//
//  Created by Hussam Elsadany on 27/03/2021.
//  Copyright (c) 2021 Qmobile-IT. All rights reserved.
//

protocol CategoriesScenePresentationLogic: AnyObject {
    func presetCategory(_ category: CategoryModel)
    func presetCategoryTitle(_ category: CategoryModel)
    func presentnError(_ error: Error)
}

protocol CategoriesSceneViewDataStore: AnyObject {
    var products: CategoriesScene.Products.ViewModel? { get set }
}

class CategoriesScenePresenter: CategoriesScenePresentationLogic, CategoriesSceneViewDataStore {

    // MARK: Stored Properties
    weak var displayView: CategoriesSceneDisplayView?

    var products: CategoriesScene.Products.ViewModel?
    
    // MARK: Initializers
    required init(displayView: CategoriesSceneDisplayView) {
        self.displayView = displayView
    }
}

extension CategoriesScenePresenter {

    func presetCategory(_ category: CategoryModel) {
        
        var productList = [CategoriesScene.Products.Product]()
        category.products?.forEach {
            let product = CategoriesScene.Products.Product(name: $0.localizedName ?? "",
                                                           desc: $0.localizedDescription ?? "",
                                                           isWishList: $0.isWishList ?? false,
                                                           price: String(format: "%.2f", $0.price ?? 0),
                                                           image: $0.image,
                                                           images: $0.productsImages?.compactMap{$0.image} ?? [])
            productList.append(product)
        }
        
        self.products = CategoriesScene.Products.ViewModel(products: productList)
        self.displayView?.displayProducts(viewModel: self.products!)
    }
    
    func presetCategoryTitle(_ category: CategoryModel) {
        let viewModel = CategoriesScene.Category.ViewModel(Category: CategoriesScene.Category.Category(name: category.localizedName ?? ""))
        self.displayView?.displayTitle(viewModel: viewModel)
    }
    
    func presentnError(_ error: Error) {
        self.displayView?.displayError(message: error.localizedDescription)
    }
}
