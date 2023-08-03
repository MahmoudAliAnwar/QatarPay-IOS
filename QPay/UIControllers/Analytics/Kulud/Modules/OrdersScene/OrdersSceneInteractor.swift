//
//  OrdersSceneInteractor.swift
//  kulud
//
//  Created by Hussam Elsadany on 09/06/2021.
//  Copyright (c) 2021 Qmobile-IT. All rights reserved.
//

protocol OrdersSceneBusinessLogic: AnyObject {

}

protocol OrdersSceneDataStore: AnyObject {

}

class OrdersSceneInteractor: OrdersSceneBusinessLogic, OrdersSceneDataStore {

    // MARK: Stored Properties
    let presenter: OrdersScenePresentationLogic

    // MARK: Initializers
    required init(presenter: OrdersScenePresentationLogic) {
        self.presenter = presenter
    }
}

extension OrdersSceneInteractor {

}
