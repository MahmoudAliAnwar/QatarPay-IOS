//
//  PayYourParkingViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 26/01/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit
import AVFoundation

class PayYourParkingViewController: ParkingsController {
    
    @IBOutlet weak var topViewDesign: ViewDesign!
    @IBOutlet weak var ticketNumberTextField: UITextField!
    
    var parking: Parking?
    
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
        
       // self.changeStatusBarBG(color: .mParkings_Dark_Red)
        
        self.requestProxy.requestService()?.delegate = self
    }
}

extension PayYourParkingViewController {
    
    func setupView() {
        self.topViewDesign.setViewCorners([.topLeft, .topRight])
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension PayYourParkingViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func scanQRAction(_ sender: UIButton) {
        self.pushToQRScannerView(metadataTypes: [.qr])
    }
    
    @IBAction func scanBarcodeAction(_ sender: UIButton) {
        self.pushToQRScannerView(metadataTypes: [.code39, .code93, .code128])
    }
    
    @IBAction func proceedAction(_ sender: UIButton) {
        guard let id = self.parking?.id else {
            self.showErrorMessage("Something went wrong\nplease, try again later")
            return
        }
        guard let ticketNumber = self.ticketNumberTextField.text,
              ticketNumber.isNotEmpty else {
            self.showErrorMessage("Please, enter ticket number or scan it")
            return
        }
        
        self.requestProxy.requestService()?.getParkingTicketDetails(number: ticketNumber, parkingID: id, completion: { ticket in
            guard let ticket = ticket else {
                return
            }
            
            let vc = self.getStoryboardView(ParkingsPaymentViewController.self)
            vc.ticket = ticket
            self.navigationController?.pushViewController(vc, animated: true)
        })
    }
}

// MARK: - UPDATE ELEMENT DELEGATE

extension PayYourParkingViewController: UpdateViewElement {
    
    func elementUpdated(fromSourceView view: UIViewController, status: Bool, data: Any?) {
        guard view is QRScannerViewController,
              let ticketNumber = data as? String else {
            return
        }
        self.ticketNumberTextField.text = ticketNumber
    }
}

// MARK: - REQUESTS DELEGATE

extension PayYourParkingViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .getParkingTicketDetails {
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

extension PayYourParkingViewController {
    private func pushToQRScannerView(metadataTypes: [AVMetadataObject.ObjectType]) {
        let vc = self.getStoryboardView(QRScannerViewController.self)
        vc.updateElementDelegate = self
        vc.metadataTypes = metadataTypes
        vc.isVendexView = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
