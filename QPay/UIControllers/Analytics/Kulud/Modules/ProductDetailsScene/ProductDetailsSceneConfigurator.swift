//
//  ProductDetailsSceneConfigurator.swift
//  kulud
//
//  Created by Hussam Elsadany on 10/03/2021.
//  Copyright (c) 2021 Qmobile-IT. All rights reserved.
//

class ProductDetailsSceneConfigurator {

    static func configure() -> ProductDetailsViewController {
        let viewController = ProductDetailsViewController()
        let presenter = ProductDetailsScenePresenter(displayView: viewController)
        let interactor = ProductDetailsSceneInteractor(presenter: presenter)
        let router = ProductDetailsSceneRouter(controller: viewController)
        viewController.interactor = interactor
        viewController.dataStore = interactor
        viewController.router = router
        viewController.viewStore = presenter
        return viewController
    }
}
