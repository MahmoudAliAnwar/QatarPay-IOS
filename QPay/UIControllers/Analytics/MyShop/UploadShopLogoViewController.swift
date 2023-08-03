//
//  MyShopViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/7/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class UploadShopLogoViewController: ShopController {
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    var shopName: String?
    var shopDesc: String?
    
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

extension UploadShopLogoViewController {
    
    func setupView() {
        self.imagePicker.delegate = self
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension UploadShopLogoViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func uploadImageAction(_ sender: UIButton) {
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.allowsEditing = false
        self.present(self.imagePicker, animated: true)
    }
    
    @IBAction func skipAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(UploadShopBannerViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - IMAGE PICKER DELEGATE

extension UploadShopLogoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.imagePicker.dismiss(animated: true)
        
        if let image = info[.originalImage] as? UIImage {
//            print("Image \(image.size)")
            self.logoImageView.image = image
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if let name = self.shopName, let desc = self.shopDesc {
                    let vc = self.getStoryboardView(UploadShopBannerViewController.self)
                    vc.logoImage = image
                    vc.shopName = name
                    vc.shopDesc = desc
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
}
