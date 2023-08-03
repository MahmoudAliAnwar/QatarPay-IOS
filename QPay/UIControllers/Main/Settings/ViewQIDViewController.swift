//
//  ViewQIDViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/3/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class ViewQIDViewController: MainController {
    
    @IBOutlet weak var frontSideImageView: UIImageView!
    @IBOutlet weak var backSideImageView: UIImageView!

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

extension ViewQIDViewController {
    
    func setupView() {
        self.requestProxy.requestService()?.getQIDImage { (status, qidCard) in
            if status {
                if let qid = qidCard {
                    
                    if let frontUrl = qid.frontSide {
                        frontUrl.getImageFromURLString { (status, image) in
                            if status, let img = image {
                                self.frontSideImageView.image = img
                            }
                        }
                    }
                    
                    if let backUrl = qid.backSide {
                        backUrl.getImageFromURLString { (status, image) in
                            if status, let img = image {
                                self.backSideImageView.image = img
                            }
                        }
                    }
                }
            }
        }
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension ViewQIDViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func updateQIDAction(_ sender: UIButton) {
        
    }
}

// MARK: - REQUESTS DELEGATE

extension ViewQIDViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .getQIDImage {
            self.showLoadingView(self)
        }
    }
    
    func requestFinished(request: RequestType, result: ResponseResult) {
        hideLoadingView()
        
        switch result {
        case .Success(_):
            break
        case .Failure(let errorType):
            switch errorType {
            case .Exception(let exc):
                if showUserExceptions {
                    self.showErrorMessage(exc)
                }
                break
            case .AlamofireError(let err):
                if showAlamofireErrors {
                    self.showSnackMessage(err.localizedDescription)
                }
                break
            case .Runtime(_):
                break
            }
        }
    }
}
