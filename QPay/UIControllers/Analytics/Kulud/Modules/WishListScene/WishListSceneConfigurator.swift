//
//  WishListSceneConfigurator.swift
//  kulud
//
//  Created by Hussam Elsadany on 05/06/2021.
//  Copyright (c) 2021 Qmobile-IT. All rights reserved.
//

class WishListSceneConfigurator {

    static func configure() -> WishListViewController {
        let viewController = WishListViewController()
        let presenter = WishListScenePresenter(displayView: viewController)
        let interactor = WishListSceneInteractor(presenter: presenter)
        let router = WishListSceneRouter(controller: viewController)
        viewController.interactor = interactor
        viewController.dataStore = interactor
        viewController.router = router
        viewController.viewStore = presenter
        return viewController
    }
}
