//
//  CartSceneConfigurator.swift
//  kulud
//
//  Created by Hussam Elsadany on 10/03/2021.
//  Copyright (c) 2021 Qmobile-IT. All rights reserved.
//

class CartSceneConfigurator {

    static func configure() -> CartViewController {
        let viewController = CartViewController()
        let presenter = CartScenePresenter(displayView: viewController)
        let interactor = CartSceneInteractor(presenter: presenter)
        let router = CartSceneRouter(controller: viewController)
        viewController.interactor = interactor
        viewController.dataStore = interactor
        viewController.router = router
        viewController.viewStore = presenter
        return viewController
    }
}
