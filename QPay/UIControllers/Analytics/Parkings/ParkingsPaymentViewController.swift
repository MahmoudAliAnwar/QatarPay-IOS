//
//  ParkingsPaymentViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 26/01/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit

class ParkingsPaymentViewController: ParkingsController {
    
    @IBOutlet weak var topViewDesign: ViewDesign!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var ticketNumberLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var ticketExpireErrorStackView: UIStackView!
    @IBOutlet weak var proceedButton: UIButton!
    
    @IBOutlet weak var paymentDetailsTableView: UITableView!
    
    var data = [ParkingPayment]()
    
    var ticket: ParkingTicket?
    
    struct ParkingPayment {
        let icon: UIImage
        let name: String
        let amount: Double
        let code: String?
    }
    
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

extension ParkingsPaymentViewController {
    
    func setupView() {
        self.paymentDetailsTableView.delegate = self
        self.paymentDetailsTableView.dataSource = self
        self.paymentDetailsTableView.tableFooterView = UIView()
        
        self.topViewDesign.setViewCorners([.topLeft, .topRight])
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
        guard let ticket = self.ticket else { return }
        
        if let timeInDate = ticket._timeIn.formatToDate(ServerDateFormat.Server2.rawValue) {
            let dateAfterDay = timeInDate.addingTimeInterval((60 * 60 * 24)) // Add 1 day
            self.setIsProceedButtonEnabled(dateAfterDay.isBeforeToday.toggleAndReturn())
        }
        
        self.totalAmountLabel.text = ticket._totalAmount.formatNumber()
        self.ticketNumberLabel.text = ticket._number
        self.timeLabel.text = ticket._totalTime
        
        self.data = [
            .init(icon: #imageLiteral(resourceName: "ic_money_parkings.png"), name: "Parking Charge", amount: ticket._amount, code: nil),
            .init(icon: #imageLiteral(resourceName: "ic_coins_parkings.png"), name: "Service Charge", amount: ticket._serviceCharge, code: nil),
//            .init(icon: #imageLiteral(resourceName: "ic_promotions_parkings.png"), name: "Promotion Amount", amount: 3.12, code: "DXPU-H31K-D0FZ-L4VI")
        ]
    }
}

// MARK: - ACTIONS

extension ParkingsPaymentViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func redeemYourCodeAction(_ sender: UIButton) {
        
    }
    
    @IBAction func proceedAction(_ sender: UIButton) {
        guard let tkt = self.ticket else { return }
        
        let vc = self.getStoryboardView(ConfirmPinCodeViewController.self)
        vc.handler = { (code) in
            self.requestProxy.requestService()?.delegate = self
            self.requestProxy.requestService()?.payParkingViaNoqs(tkt, pinCode: code, completion: { status, response in
                guard status else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                    self.showSuccessMessage(response?._message ?? "Pay parking successfully")
                }
            })
        }
        self.present(vc, animated: true)
    }
}

// MARK: - TABLE VIEW DELEGATE

extension ParkingsPaymentViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(ParkingPaymentTableViewCell.self, for: indexPath)
        
        let object = self.data[indexPath.row]
        cell.object = object
        
        return cell
    }
}

// MARK: - REQUESTS DELEGATE

extension ParkingsPaymentViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .payParkingViaNoqs {
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

extension ParkingsPaymentViewController {
    
    private func setIsProceedButtonEnabled(_ status: Bool) {
        self.proceedButton.setBackgroundImage(status ? UIImage(named: "ic_blue_gradient_parking") : .none, for: .normal)
        self.proceedButton.backgroundColor = status ? .clear : .darkGray
        self.proceedButton.isEnabled = status
        self.ticketExpireErrorStackView.isHidden = status
    }
}
