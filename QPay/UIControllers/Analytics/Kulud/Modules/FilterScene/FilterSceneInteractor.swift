//
//  FilterSceneInteractor.swift
//  kulud
//
//  Created by Hussam Elsadany on 06/06/2021.
//  Copyright (c) 2021 Qmobile-IT. All rights reserved.
//

protocol FilterSceneBusinessLogic: AnyObject {
    func openSubCategories()
}

protocol FilterSceneDataStore: AnyObject {
    var subCategories: [CategoryModel] { set get }
    var selectedSubCategory: CategoryModel? { set get }
}

class FilterSceneInteractor: FilterSceneBusinessLogic, FilterSceneDataStore {
    
    // MARK: Stored Properties
    let presenter: FilterScenePresentationLogic

    var subCategories: [CategoryModel] = []
    
    var selectedSubCategory: CategoryModel? = nil
    
    // MARK: Initializers
    required init(presenter: FilterScenePresentationLogic) {
        self.presenter = presenter
    }
}

extension FilterSceneInteractor {
    
    func openSubCategories() {
        self.presenter.presentSubCategory(subCategories: self.subCategories)
    }
}
