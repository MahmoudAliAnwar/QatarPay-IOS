//
//  FilterScenePresenter.swift
//  kulud
//
//  Created by Hussam Elsadany on 06/06/2021.
//  Copyright (c) 2021 Qmobile-IT. All rights reserved.
//

protocol FilterScenePresentationLogic: AnyObject {
    func presentSubCategory(subCategories: [CategoryModel])
}

protocol FilterSceneViewStore: AnyObject {
    var subCategories: FilterScene.SubCategories.ViewModel? { get set }
}

class FilterScenePresenter: FilterScenePresentationLogic, FilterSceneViewStore {

    // MARK: Stored Properties
    weak var displayView: FilterSceneDisplayView?

    var subCategories: FilterScene.SubCategories.ViewModel? = nil
    
    // MARK: Initializers
    required init(displayView: FilterSceneDisplayView) {
        self.displayView = displayView
    }
}

extension FilterScenePresenter {
    
    func presentSubCategory(subCategories: [CategoryModel]) {
        var newSubCategories = [FilterScene.SubCategories.SubCategory]()
        subCategories.forEach {
            let category = FilterScene.SubCategories.SubCategory(name: $0.localizedName ?? "")
            newSubCategories.append(category)
        }
        self.subCategories = FilterScene.SubCategories.ViewModel(subCategories: newSubCategories)
        self.displayView?.displaySubCategories(viewModel: self.subCategories!)
    }
}
