//
//  HomeController.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/3/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit
import DropDown

class CharityController: ViewController {
    
    @IBOutlet weak var donationTypeLabel: UILabel!
    @IBOutlet weak var donationTypeErrorImageView: UIImageView!
    @IBOutlet weak var donationTypeButton: UIButton!
    
    @IBOutlet weak var amountsCollectionView: UICollectionView!
    @IBOutlet weak var amountTextField: UITextField!
    
    var donations = [CharityDonation]()
    var selectedDonation: CharityDonation? {
        willSet {
            self.donationTypeLabel.text = newValue?._name
        }
    }
    
    var id: Int?
    
    var amounts = [String]()
    
    var donationTypeDropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.requestProxy.requestService()?.delegate = self
        
        self.amounts = charityAmounts
        
        self.getDonationTypesRequest()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

// MARK: - REQUESTS DELEGATE

extension CharityController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .getCharityDonationTypes ||
            request == .transferToCharity ||
            request == .confirmTransfer {
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

extension CharityController {
    
    func sendTransferRequest() {
        guard let amountString = self.amountTextField.text,
              amountString.isNotEmpty,
              let amount = Double(amountString) else {
            return
        }
        
        guard let charityID = self.id,
              let donationID = self.selectedDonation?._id else {
            return
        }
        
        self.requestProxy.requestService()?.transferToCharity(charityID, donationID: donationID, amount: amount, { transfer in
            guard let trans = transfer else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                let vc = self.getStoryboardView(ConfirmPinCodeViewController.self)
                vc.handler = { code in
                    self.requestProxy.requestService()?.delegate = self
                    self.requestProxy.requestService()?.confirmTransfer(trans, pinCode: code, completion: { status, response in
                        guard status else { return }
                        DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                            self.showSuccessMessage(response?._message ?? "Transfer Completed")
                        }
                    })
                }
                self.present(vc, animated: true)
            }
        })
    }
    
    private func getDonationTypesRequest() {
        guard let id = self.id else { return }
        self.requestProxy.requestService()?.getCharityDonationTypes(id, { list in
            self.donations = list ?? []
            self.setDonationTypeDropDownData()
        })
    }
    
    func setupDropDownAppearance(textColor: UIColor) {
        
        let appearance = DropDown.appearance()
        appearance.cellHeight = 36
        appearance.backgroundColor = .white
        appearance.selectionBackgroundColor = UIColor(red: 0.6494, green: 0.8155, blue: 1.0, alpha: 0.2)
        appearance.separatorColor = UIColor(white: 0.7, alpha: 0.8)
        appearance.cornerRadius = 10
        appearance.shadowColor = .white
        appearance.shadowOpacity = 0.3
        appearance.shadowRadius = 12
        appearance.shadowOffset = CGSize(width: 0, height: 5)
        appearance.animationduration = 0.25
        appearance.textColor = textColor
    }
    
    func setDonationTypeDropDownData() {
        self.donationTypeDropDown.dataSource = self.donations.compactMap({ return $0._name })
        self.donationTypeDropDown.reloadAllComponents()
    }
    
    func setupDonationTypeDropDown() {
        
        self.donationTypeDropDown.anchorView = self.donationTypeButton
        
        self.donationTypeDropDown.bottomOffset = CGPoint(x: 0, y: self.donationTypeButton.bottom)
        self.donationTypeDropDown.direction = .bottom
        self.donationTypeDropDown.dismissMode = .automatic
        
        self.donationTypeDropDown.selectionAction = { [weak self] (index, item) in
            guard let self = self else { return }
            self.selectDonation(self.donations[index])
        }
    }
    
    func selectDonation(_ donation: CharityDonation) {
        self.selectedDonation = donation
    }
}

