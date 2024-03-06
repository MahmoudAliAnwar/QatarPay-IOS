//
//  FilterViewController.swift
//  kulud
//
//  Created by Hussam Elsadany on 06/06/2021.
//  Copyright (c) 2021 Qmobile-IT. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import ActionSheetPicker_3_0

protocol FilterViewControllerDelegate {
    func filterSceneDidTapFilter(subCategory: CategoryModel?, minimumPrice: Double?, maximumPrice: Double?)
}

protocol FilterSceneDisplayView: AnyObject {
    func displaySubCategories(viewModel: FilterScene.SubCategories.ViewModel)
}

class FilterViewController: KuludViewController {

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var subCategoryField: SkyFloatingLabelTextField!
    @IBOutlet private weak var maximumField: SkyFloatingLabelTextField!
    @IBOutlet private weak var minimumField: SkyFloatingLabelTextField!
    
    var interactor: FilterSceneBusinessLogic!
    var dataStore: FilterSceneDataStore!
    var viewStore: FilterSceneViewStore!
    var router: FilterSceneRoutingLogic!

    var delegate: FilterViewControllerDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    func setupView() {
        self.containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func openSubCategory(_ sender: Any) {
        self.interactor.openSubCategories()
    }
    
    @IBAction func applyFilter(_ sender: Any) {
        let minimum = self.minimumField.text?.doubleValue
        let maximum = self.maximumField.text?.doubleValue
        self.delegate?.filterSceneDidTapFilter(subCategory: self.dataStore.selectedSubCategory,
                                               minimumPrice: minimum,
                                               maximumPrice: maximum)
        self.dismiss(animated: true, completion: nil)
    }
}

extension FilterViewController: FilterSceneDisplayView {
    
    func displaySubCategories(viewModel: FilterScene.SubCategories.ViewModel) {

        ActionSheetStringPicker.show(withTitle: "Sub Categories", rows: viewModel.subCategories.map{$0.name}, initialSelection: 0, doneBlock: { picker, indexes, values in
            if viewModel.subCategories.count == 0 { return }
            self.subCategoryField.text = viewModel.subCategories[indexes].name
            self.dataStore.selectedSubCategory = self.dataStore.subCategories[indexes]
        }, cancel: { ActionMultipleStringCancelBlock in return }, origin: self.view)
    }
}
