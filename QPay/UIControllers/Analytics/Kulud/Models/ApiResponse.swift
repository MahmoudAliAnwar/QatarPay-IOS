//
//  ApiResponse.swift
//  kulud
//
//  Created by Hussam Elsadany on 16/05/2021.
//  Copyright © 2021 Qmobile-IT. All rights reserved.
//

struct ApiResponse<T: Codable>: Codable {
    let responseObject: T?
    let errorMessage: String?
    let sucessMessage: String?
    let success: Bool?
}
