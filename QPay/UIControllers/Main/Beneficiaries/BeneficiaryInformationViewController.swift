//
//  BeneficiaryInformationViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 13/02/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit

class BeneficiaryInformationViewController: MainController {

    @IBOutlet weak var containerViewDesign: ViewDesign!
    
    @IBOutlet weak var beneficiarieImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var qpanLabel: UILabel!
    @IBOutlet weak var mobileLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!

    var beneficiary: Beneficiary?
    
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
        
        self.statusBarView?.isHidden = true
        
        self.requestProxy.requestService()?.delegate = self
    }
}

extension BeneficiaryInformationViewController {
    
    func setupView() {
        self.containerViewDesign.setViewCorners([.topLeft, .topRight])
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
        if let ben = self.beneficiary {
            self.nameLabel.text = ben._fullName
            self.qpanLabel.text = ben._qpan
            self.mobileLabel.text = ben._mobileNumber
            self.emailLabel.text = ben._emailAddress
            
            if let imageURLString = ben.profilePicture {
                imageURLString.getImageFromURLString { (status, image) in
                    guard status else { return }
                    self.beneficiarieImageView.image = image
                }
            }
        }
    }
}

// MARK: - ACTIONS

extension BeneficiaryInformationViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteAction(_ sender: UIButton) {
        guard let ben = self.beneficiary,
              let id = ben.userID else {
                  return
              }
        self.requestProxy.requestService()?.removeBeneficiary(id: id, completion: { (status, response) in
            guard status else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                self.navigationController?.popViewController(animated: true)
                self.showSuccessMessage(response?.message ?? "Beneficiary deleted successfully!")
            }
        })
    }
    
    @IBAction func modifyAction(_ sender: UIButton) {
        
    }
}

// MARK: - REQUESTS DELEGATE

extension BeneficiaryInformationViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .removeBeneficiary {
            showLoadingView(self)
        }
    }
    
    func requestFinished(request: RequestType, result: ResponseResult) {
        self.hideLoadingView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
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
}

// MARK: - CUSTOM FUNCTIONS

extension BeneficiaryInformationViewController {
    
}
