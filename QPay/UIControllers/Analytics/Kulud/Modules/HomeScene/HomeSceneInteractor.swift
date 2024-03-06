//
//  HomeSceneInteractor.swift
//  kulud
//
//  Created by Hussam Elsadany on 10/03/2021.
//  Copyright (c) 2021 Qmobile-IT. All rights reserved.
//
import Foundation

protocol HomeSceneBusinessLogic: AnyObject {
    func getStoreDetails()
    func addProductToCart(indexPath: IndexPath)
    func updateProductQuantity(indexPath: IndexPath, quantity: Int)
}

protocol HomeSceneDataStore: AnyObject {
    var storeDetails: StoreModel? { get set }
}

class HomeSceneInteractor: HomeSceneBusinessLogic, HomeSceneDataStore {
    
    // MARK: Stored Properties
    let presenter: HomeScenePresentationLogic
    
    private let worker = HomeSceneWorker()
    
    var storeDetails: StoreModel?

    // MARK: Initializers
    required init(presenter: HomeScenePresentationLogic) {
        self.presenter = presenter
    }
}

extension HomeSceneInteractor {

    func getStoreDetails() {
        self.worker.getStoreDetails { store in
            if let store = store {
                self.storeDetails = store
                self.presenter.presentStore(details: store)
                CartManager.shated.updateCartCount()
            } else {
                self.presenter.presentFailure(error: CustomError.notFound)
            }
        } failure: { error in
            self.presenter.presentFailure(error: error)
        }
    }
    
    func addProductToCart(indexPath: IndexPath) {
        
        guard let productId = self.storeDetails?.collections?[indexPath.section].products?[indexPath.row].id else {
            return
        }
        
        self.worker.addToCart(productId: productId,
                              quantity: 1) { statusCode in
            if statusCode == 200 {
                self.storeDetails?.collections?[indexPath.section].products?[indexPath.row].quantity = 1
                self.storeDetails?.collections?[indexPath.section].products?[indexPath.row].isCart = true
                self.presenter.presentStore(details: self.storeDetails!)
                CartManager.shated.updateCartCount()
            }
        }
    }
    
    func updateProductQuantity(indexPath: IndexPath, quantity: Int) {
        guard let productId = self.storeDetails?.collections?[indexPath.section].products?[indexPath.row].id else {
            return
        }
        
        self.worker.updateCart(productId: productId, quantity: quantity) { statusCode in
            if statusCode == 200 {
                self.storeDetails?.collections?[indexPath.section].products?[indexPath.row].quantity = quantity
                self.storeDetails?.collections?[indexPath.section].products?[indexPath.row].isCart = (quantity != 0)
                self.presenter.presentStore(details: self.storeDetails!)
                CartManager.shated.updateCartCount()
            }
        }
    }
}
