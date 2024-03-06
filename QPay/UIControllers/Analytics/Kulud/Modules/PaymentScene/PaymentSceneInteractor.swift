//
//  PaymentSceneInteractor.swift
//  kulud
//
//  Created by Hussam Elsadany on 07/06/2021.
//  Copyright (c) 2021 Qmobile-IT. All rights reserved.
//

protocol PaymentSceneBusinessLogic: AnyObject {

}

protocol PaymentSceneDataStore: AnyObject {

}

class PaymentSceneInteractor: PaymentSceneBusinessLogic, PaymentSceneDataStore {

    // MARK: Stored Properties
    let presenter: PaymentScenePresentationLogic

    // MARK: Initializers
    required init(presenter: PaymentScenePresentationLogic) {
        self.presenter = presenter
    }
}

extension PaymentSceneInteractor {

}
