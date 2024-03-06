//
//  DocumentsViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 10/24/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class DocumentDetailsViewController: MainController {

    @IBOutlet weak var documentImageView: UIImageView!
    
    var document: Document!
    
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
        
        if let location = self.document.location {
            location.getImageFromURLString { (status, image) in
                if status, let img = image {
                    self.documentImageView.image = img
                }
            }
        }
    }
}

extension DocumentDetailsViewController {
    
    func setupView() {
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension DocumentDetailsViewController {

    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - PRIVATE FUNCTIONS

extension DocumentDetailsViewController {
    
}
