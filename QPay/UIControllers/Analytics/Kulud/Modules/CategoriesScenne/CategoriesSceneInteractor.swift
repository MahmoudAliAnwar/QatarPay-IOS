//
//  CategoriesSceneInteractor.swift
//  kulud
//
//  Created by Hussam Elsadany on 27/03/2021.
//  Copyright (c) 2021 Qmobile-IT. All rights reserved.
//

protocol CategoriesSceneBusinessLogic: AnyObject {
    func getCategoryName()
    func getCategoryProducts()
    func search(keyword: String)
    func applyFilter()
}

protocol CategoriesSceneDataStore: AnyObject {
    var selectedCategory: CategoryModel? { get set }
    var minmumPrice: Double? { get set }
    var maximumPrice: Double? { get set }
}

class CategoriesSceneInteractor: CategoriesSceneBusinessLogic, CategoriesSceneDataStore {

    // MARK: Stored Properties
    let presenter: CategoriesScenePresentationLogic

    private let worker = CategoriesSceneWorker()
    
    var selectedCategory: CategoryModel? = nil
    
    var minmumPrice: Double? = nil
    
    var maximumPrice: Double? = nil
    
    // MARK: Initializers
    required init(presenter: CategoriesScenePresentationLogic) {
        self.presenter = presenter
    }
}

extension CategoriesSceneInteractor {

    func getCategoryName() {
        self.presenter.presetCategoryTitle(self.selectedCategory!)
    }
    
    func getCategoryProducts() {
        
        self.search(keyword: "")
//        guard let categoryId = self.selectedCategory?.id else { return }
//
//        self.worker.getCategoryProducts(categoryId: categoryId) { categories in
//            guard categories.count > 0 else { return }
//            let category = categories[0]
//            self.selectedCategory = category
//            self.presenter.presetCategory(category)
//        } failure: { error in
//            self.presenter.presentnError(error)
//        }
    }
    
    func search(keyword: String) {

        guard let categoryId = self.selectedCategory?.id else { return }

        self.worker.search(cactegoryId: categoryId, keyword: keyword) { response in
            var products = response?.products
            if self.minmumPrice != nil {
                products = products?.filter{ $0.price ?? 0 > self.minmumPrice! }
            }
            if self.maximumPrice != nil {
                products = products?.filter{ $0.price ?? 0 < self.maximumPrice! }
            }
            self.selectedCategory?.products = products
            self.selectedCategory?.subCategories = response?.subCategories ?? []
            self.presenter.presetCategory(self.selectedCategory!)
        } failure: { error in
            self.presenter.presentnError(error)
        }
    }
    
    func applyFilter() {
        self.search(keyword: "")
    }
}
