//
//  MyShopViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/7/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class CreateShopViewController: ShopController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameErrorImageView: UIImageView!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var descriptionErrorImageView: UIImageView!
    
    private let descPlaceholder = "Shop Description"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupView()
        localized()
        setupData()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
}

extension CreateShopViewController {
    
    func setupView() {
        self.descriptionTextView.text = self.descPlaceholder
        self.descriptionTextView.textColor = .lightGray

        self.descriptionTextView.delegate = self
        
        self.changeStatusBarBG(color: .clear)
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension CreateShopViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func createShopAction(_ sender: UIButton) {
        
        if self.checkViewFieldsErrors() {
            if let name = self.nameTextField.text, name.isNotEmpty,
                let desc = self.descriptionTextView.text, desc != self.descPlaceholder {
                let vc = self.getStoryboardView(UploadShopLogoViewController.self)
                vc.shopName = name
                vc.shopDesc = desc
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

// MARK: - TEXT VIEW DELEGATE

extension CreateShopViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = self.descPlaceholder
            textView.textColor = .lightGray
        }
    }
}

// MARK: - PRIVATE FUNCTIONS

extension CreateShopViewController {
    
    private func checkViewFieldsErrors() -> Bool {
        let isNameNotEmpty = self.nameTextField.text!.isNotEmpty
        self.showHideNameError(isNameNotEmpty)

        let isDescriptionNotEmpty = self.descriptionTextView.text! != self.descPlaceholder && self.descriptionTextView.text!.isNotEmpty
        self.showHideDescriptionError(isDescriptionNotEmpty)

        return isNameNotEmpty && isDescriptionNotEmpty
    }
    
    private func showHideNameError(_ isNotEmpty: Bool) {
        self.nameErrorImageView.image = isNotEmpty ? .none : Images.ic_error_circle.image
    }
    
    private func showHideDescriptionError(_ isNotEmpty: Bool) {
        self.descriptionErrorImageView.image = isNotEmpty ? .none : Images.ic_error_circle.image
    }
}
