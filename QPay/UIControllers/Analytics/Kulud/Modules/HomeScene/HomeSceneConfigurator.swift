//
//  HomeSceneConfigurator.swift
//  kulud
//
//  Created by Hussam Elsadany on 10/03/2021.
//  Copyright (c) 2021 Qmobile-IT. All rights reserved.
//

class HomeSceneConfigurator {

    static func configure() -> KuludHomeViewController {
        let viewController = KuludHomeViewController()
        let presenter = HomeScenePresenter(displayView: viewController)
        let interactor = HomeSceneInteractor(presenter: presenter)
        let router = HomeSceneRouter(controller: viewController)
        viewController.interactor = interactor
        viewController.dataStore = interactor
        viewController.viewStore = presenter
        viewController.router = router
        return viewController
    }
}
