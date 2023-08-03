//
//  FilterSceneRouter.swift
//  kulud
//
//  Created by Hussam Elsadany on 06/06/2021.
//  Copyright (c) 2021 Qmobile-IT. All rights reserved.
//

protocol FilterSceneRoutingLogic: AnyObject {
    typealias Controller = FilterSceneDisplayView & FilterViewController
}

class FilterSceneRouter {

    // MARK: Stored Properties
    var viewController: Controller?

    // MARK: Initializers
    required init(controller: Controller?) {
        self.viewController = controller
    }
}

extension FilterSceneRouter: FilterSceneRoutingLogic {

}
