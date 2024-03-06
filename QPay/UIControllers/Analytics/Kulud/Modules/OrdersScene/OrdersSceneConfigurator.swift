//
//  OrdersSceneConfigurator.swift
//  kulud
//
//  Created by Hussam Elsadany on 09/06/2021.
//  Copyright (c) 2021 Qmobile-IT. All rights reserved.
//

class OrdersSceneConfigurator {

    static func configure() -> OrdersViewController {
        let viewController = OrdersViewController()
        let presenter = OrdersScenePresenter(displayView: viewController)
        let interactor = OrdersSceneInteractor(presenter: presenter)
        let router = OrdersSceneRouter(controller: viewController)
        viewController.interactor = interactor
        viewController.dataStore = interactor
        viewController.router = router
        viewController.viewStore = presenter
        return viewController
    }
}
