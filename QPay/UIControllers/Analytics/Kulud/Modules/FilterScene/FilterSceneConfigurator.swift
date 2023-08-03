//
//  FilterSceneConfigurator.swift
//  kulud
//
//  Created by Hussam Elsadany on 06/06/2021.
//  Copyright (c) 2021 Qmobile-IT. All rights reserved.
//

class FilterSceneConfigurator {

    static func configure() -> FilterViewController {
        let viewController = FilterViewController()
        let presenter = FilterScenePresenter(displayView: viewController)
        let interactor = FilterSceneInteractor(presenter: presenter)
        let router = FilterSceneRouter(controller: viewController)
        viewController.interactor = interactor
        viewController.dataStore = interactor
        viewController.router = router
        viewController.viewStore = presenter
        return viewController
    }
}
