//
//  KarwaViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/4/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class KarwaBusViewController: KarwaBusController {

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
        
        self.requestProxy.requestService()?.delegate = self
    }
}

extension KarwaBusViewController {
    
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

extension KarwaBusViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(AddKarwaBusCardViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - REQUESTS DELEGATE

extension KarwaBusViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .addKarwaBusCard {
            showLoadingView(self)
        }
    }
    
    func requestFinished(request: RequestType, result: ResponseResult) {
        hideLoadingView()
        
        switch result {
        case .Success(_):
            break
        case .Failure(let error):
            switch error {
            case .Exception(_):
                break
            case .AlamofireError(_):
                break
            case .Runtime(_):
                break
            }
        }
    }
}

// MARK: - CUSTOM FUNCTIONS

extension KarwaBusViewController {
    
}
