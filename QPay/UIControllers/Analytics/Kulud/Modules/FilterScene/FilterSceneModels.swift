//
//  FilterSceneModels.swift
//  kulud
//
//  Created by Hussam Elsadany on 06/06/2021.
//  Copyright (c) 2021 Qmobile-IT. All rights reserved.
//

enum FilterScene {
    enum SubCategories { }
}

extension FilterScene.SubCategories {
    struct SubCategory {
        let name: String
    }
    
    struct ViewModel {
        let subCategories: [SubCategory]
    }
}
