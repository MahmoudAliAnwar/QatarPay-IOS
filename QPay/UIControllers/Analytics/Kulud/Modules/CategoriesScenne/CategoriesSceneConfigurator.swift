//
//  CategoriesSceneConfigurator.swift
//  kulud
//
//  Created by Hussam Elsadany on 27/03/2021.
//  Copyright (c) 2021 Qmobile-IT. All rights reserved.
//

class CategoriesSceneConfigurator {

    static func configure() -> CategoriesViewController {
        let viewController = CategoriesViewController()
        let presenter = CategoriesScenePresenter(displayView: viewController)
        let interactor = CategoriesSceneInteractor(presenter: presenter)
        let router = CategoriesSceneRouter(controller: viewController)
        viewController.interactor = interactor
        viewController.dataStore = interactor
        viewController.viewStore = presenter
        viewController.router = router
        return viewController
    }
}
