//
//  GiftCardPurchaseViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 29/03/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit

class GiftCardPurchaseViewController: GiftController {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var cardImageViewDesign: ImageViewDesign!
    
    @IBOutlet weak var containerViewDesign: ViewDesign!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var brandButton: UIButton!
    
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var countryLabel: UILabel!
    
    @IBOutlet weak var fullNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!

    @IBOutlet weak var mobileTextField: UITextField!

    @IBOutlet weak var purchaseCheckBox: CheckBox!
    @IBOutlet weak var termsCheckBox: CheckBox!

    @IBOutlet weak var totalAmountLabel: UILabel!

    var denomination: GiftDenomination!
    
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

extension GiftCardPurchaseViewController {
    
    func setupView() {
        self.fullNameTextField.isEnabled = false
        self.emailTextField.isEnabled = false
        self.mobileTextField.isEnabled = false
        
        self.containerViewDesign.setViewCorners([.topLeft, .topRight])
        
        self.purchaseCheckBox.borderStyle = .square
        self.termsCheckBox.borderStyle = .square
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
        self.titleLabel.text = self.denomination._brandName
        
        let price = denomination._price.formatNumber()
        self.totalAmountLabel.text = "\(price) NOQS"
        
        if let user = self.userProfile.getUser() {
            self.fullNameTextField.text = user._fullName
            self.emailTextField.text = user._email
            self.mobileTextField.text = user._mobileNumber
        }
        
        self.denomination._imageLocationPath.getImageFromURLString { (status, image) in
            if status {
                self.cardImageViewDesign.image = image!
            }
        }
        
        self.denomination._storeURl.getImageFromURLString { (status, image) in
            if status {
                self.flagImageView.image = image!
            }
        }
        
        self.descriptionLabel.text = self.denomination._description.uppercased()
        self.countryLabel.text = self.denomination._store
        self.countryLabel.text = self.denomination._store
        
        self.categoryButton.setTitle(self.denomination._categoryName, for: .normal)
        self.brandButton.setTitle(self.denomination._brandName, for: .normal)
    }
}

// MARK: - ACTIONS

extension GiftCardPurchaseViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func categoryAction(_ sender: UIButton) {
        
    }
    
    @IBAction func brandAction(_ sender: UIButton) {
        
    }
    
    @IBAction func purchaseCheckBoxButtonAction(_ sender: UIButton) {
        self.purchaseCheckBox.isChecked = !self.purchaseCheckBox.isChecked
    }
    
    @IBAction func termsCheckBoxButtonAction(_ sender: UIButton) {
        self.termsCheckBox.isChecked = !self.termsCheckBox.isChecked
    }
    
    @IBAction func termsAndConditionsAction(_ sender: UIButton) {
        let vc = Views.PrivacyPolicyViewController.storyboardView
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func checkoutAction(_ sender: UIButton) {
        guard self.purchaseCheckBox.isChecked == true,
              self.termsCheckBox.isChecked == true else {
            self.showErrorMessage("You must accept terms and conditions")
            return
        }
        guard isForDeveloping == false,
              let id = self.denomination.id else {
            return
        }
        
        self.requestProxy.requestService()?.initiateGiftTransaction(denominationID: id, completion: { (status, giftTransfer) in
            if status, let transfer = giftTransfer {
                DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                    let vc = self.getStoryboardView(ConfirmPinCodeViewController.self)
                    vc.data = transfer
                    vc.updateViewElementDelegate = self
                    self.present(vc, animated: true)
                }
            }
        })
    }
}

// MARK: - UPDATE VIEW ELEMENTS DELEGATE

extension GiftCardPurchaseViewController: UpdateViewElement {
    
    func elementUpdated(fromSourceView view: UIViewController, status: Bool, data: Any?) {
        guard status == true else { return }
        
        if view is ConfirmPinCodeViewController {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                self.viewWillAppear(true)
                
                guard let message = data as? String else { return }
                self.showSuccessMessage(message)
            }
        }
    }
}

// MARK: - REQUESTS DELEGATE

extension GiftCardPurchaseViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .initiateGiftTransaction {
            showLoadingView(self)
        }
    }
    
    func requestFinished(request: RequestType, result: ResponseResult) {
        hideLoadingView()
        
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
                case .AlamofireError(_):
                    if showAlamofireErrors {
                        self.showErrorMessage()
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

extension GiftCardPurchaseViewController {
    
}
