//
//  SignInViewModel.swift
//  QPay
//
//  Created by Mohammed Hamad on 01/05/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit

class SignInViewModel {
    
    var user: User?
    
    public func fetch(email: String, password: String, completion: @escaping (MResult<User, Error>) -> ()) {
        
        let request = GenericRequestService.getInstance()
        let login = LoginRequest(email: email, password: password)
        
        request.send(endPoint: login) { result in
            switch result {
            case .success(let data):
                /// Code for convert data to user object...
                
                do {
                    var object = try JSONDecoder().decode(User.self, from: data)
                    object.password = password
                    UserProfile.shared.saveUser(user: object)
                    self.user = object
                    completion(.success(object))
                    
                } catch {
                    completion(.failure(error))
                    print(error)
                }
                
//                let str = String(decoding: data, as: UTF8.self)
//                print(str)
                break
                
            case .failure(let error):
                completion(.failure(error))
                print(error)
                break
            }
        }
    }
}
