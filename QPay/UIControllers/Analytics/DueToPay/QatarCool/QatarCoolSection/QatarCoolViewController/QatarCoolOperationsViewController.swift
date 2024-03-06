//
//  QatarCoolOperationsViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 23/07/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import UIKit

class QatarCoolOperationsViewController: ViewController {
    
    @IBOutlet weak var currentBalanceAmountLabel : UILabel!
    
    @IBOutlet weak var groupNameLabel            : UILabel!
    
    @IBOutlet weak var numberGroupLabel          : UILabel!
    
    @IBOutlet weak var amountLabel               : UILabel!
    
    @IBOutlet weak var fullAmountCheckBox        : CheckBox!
    
    @IBOutlet weak var partialAmountCheckBox     : CheckBox!
    
    @IBOutlet weak var recurringPaymentCheckBox  : CheckBox!
    
    @IBOutlet weak var partialAmountTextField    : UITextField!
    
    @IBOutlet weak var partialAmountStackView    : UIStackView!
    
    @IBOutlet weak var recurringPaymentStackView : UIStackView!
    
    @IBOutlet weak var tableView                 : UITableView!
    
    var number    :  QatarCoolNumber?
    var serviceID: Int?
    
    private var calendarType: CalendarType?
    private var paymentStatus : PaymentStatus = .fullAmount
    private var selectedDate         : Date?
    private var scheduleRequestsList = [ScheduleRequests]()
    private var paymentRequestDetails: PaymentRequestDetails?
    
    
    private let calendarPopup: CalendarPopup = {
        let popup = CalendarPopup()
        return popup
    }()
    
    enum PaymentStatus {
        case fullAmount
        case partialAmount
    }
    
    enum CalendarType {
        case saveDate
        case editDate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupView()
        localized()
        setupData()
        fetchData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.dispatchGroup.enter()
        
        self.showLoadingView(self)
        self.requestProxy.requestService()?.getUserBalance { (status, balance) in
            if status,
               let blnc = balance {
                self.currentBalanceAmountLabel.text = "Noqs \(blnc.formatNumber())"
            }
            
            self.dispatchGroup.leave()
        }
        
        guard let data = self.number else {
            return
        }
        
//        self.dispatchGroup.enter()
        
//        self.requestProxy.requestService()?.getPaymentRequestviaQatarCoolBill(groupID: data._groupID,
//                                                                              mobileNumber: data._number, { paymentRequestVia in
//            guard let resp = paymentRequestVia else {
//                self.showSnackMessage("Something went wrong",messageStatus: .Error)
//                return
//            }
//            
//            self.scheduleRequestsList = resp._scheduleRequests
//            self.tableView.reloadData()
//            self.dispatchGroup.leave()
//        })
        
        self.dispatchGroup.notify(queue: .main) {
            self.hideLoadingView()
        }
    }
}

extension QatarCoolOperationsViewController {
    
    func setupView() {
        [
            self.fullAmountCheckBox,
            self.partialAmountCheckBox
        ].forEach { check in
            check.style       = .circle
            check.borderStyle = .rounded
            check.tintColor   = .black
            check.borderWidth = 1.5
        }
                
        self.recurringPaymentCheckBox.style           = .tick
        self.recurringPaymentCheckBox.borderStyle     = .square
        self.recurringPaymentCheckBox.checkmarkColor  = .red
        self.recurringPaymentCheckBox.borderWidth     = 1
        self.recurringPaymentCheckBox.tintColor       = .darkGray
        
        self.fullAmountCheckBox.addTarget(self, action: #selector(didChangeFullAmountCheckBox(_:)), for: .valueChanged)
        self.partialAmountCheckBox.addTarget(self, action: #selector(didChangePartialAmountCheckBox(_:)), for: .valueChanged)
        self.recurringPaymentCheckBox.addTarget(self, action: #selector(onCheckBoxValueChange(_:)), for: .valueChanged)
        
        
        self.tableView.delegate   = self
        self.tableView.dataSource = self
        self.tableView.registerNib(PhoneBillOperationTableViewCell.self)
        
        self.setupCalendarPopup()
    }
    
    func localized() {
    }
    
    func setupData() {
        guard let data = self.number else {
            return
        }
        
        self.groupNameLabel.text   = data._subscriberName
        self.numberGroupLabel.text = "\(data._number)"
        self.amountLabel.text      = "QRA \(data._currentBill)"
    }
    
    func fetchData() {
        
    }
}

// MARK: - ACTIONS

extension QatarCoolOperationsViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(EditNameNumberViewController.self)
        vc.qatarCoolNumber  = self.number
        vc.type = .qatarCoolBill
        vc.updateViewDelegate = self
        self.present(vc, animated: true)
    }
    
    @IBAction func deleteAction(_ sender: UIButton) {
        
        guard let data = self.number else {
            self.showSnackMessage("Something went wrong",messageStatus: .Error)
            return
        }
        
        let alert = UIAlertController(title: "", message: "Do you want Delete this number ?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive , handler: { _ in
            self.showLoadingView(self)
            
            self.requestProxy.requestService()?.removeQatarCoolNumber(id: data._numberID, { baseResponse in
                self.hideLoadingView()
                
                guard let resp = baseResponse else {
                    self.showSnackMessage("Something went wrong",messageStatus: .Error)
                    return
                }
                
                guard resp._success else {
                    self.showErrorMessage(resp._message)
                    return
                }
                self.showSuccessMessage(resp._message)
            })
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true)
    }
    
    @IBAction func dateAction(_ sender: UIButton) {
        let alert = UIAlertController.init(title: "", message: "Choose any date to RecurringPayment", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive , handler: { _ in
            self.calendarType = .saveDate
            self.calendarPopup.isHidden = false
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true)
    }
    
    @IBAction func historyAction(_ sender: UIButton) {
        let vc    = self.getStoryboardView(HistoryQatarCoolBillViewController.self)
        vc.number = self.number?._number
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        
        guard let number = self.number else {
            self.showSnackMessage("Something went wrong")
            return
        }
        var isPaymentRequest = true
        var paymentRequestPhoneBillParams = PaymentRequestPhoneBillParams()
        let paymentVC = PaymentVC()
        var amountToPay: Double = number._currentBill
        if let partialAmount = self.partialAmountTextField.text,
           partialAmount.isNotEmpty {
            amountToPay = Double(partialAmount) ?? 0.0
        }
        
        if let calendarType = self.calendarType,
           calendarType == .saveDate {
            
            guard let date = self.selectedDate else {
                self.showSnackMessage("You should select date")
                return
            }
            
            paymentRequestPhoneBillParams.scheduledDate = date.server4DateToString()
            paymentRequestPhoneBillParams.isRecurringPayment = self.recurringPaymentCheckBox.isChecked
            
            isPaymentRequest = false
        }
        let groupDetails = GroupDetails(groupID: number._groupID, number: [number._number])
        
       
        paymentRequestPhoneBillParams.operatorID         = number.operatorID ?? 0
        paymentRequestPhoneBillParams.groupDetails       = [groupDetails]
        paymentRequestPhoneBillParams.isFullAmount       = self.paymentStatus == .fullAmount
        paymentRequestPhoneBillParams.isPartialAmount    = self.paymentStatus == .partialAmount
        paymentRequestPhoneBillParams.amount = amountToPay
       
        paymentVC.amountToPay = amountToPay
        let processTokenized = ProcessTokenizedModel(Amount: amountToPay, ServiceID: self.serviceID, IsBillPayment: true, BillPaymentData: paymentRequestPhoneBillParams)
        paymentVC.processTokenized = processTokenized
        //        paymentVC.number = number
        paymentVC.isPaymentRequest = isPaymentRequest
        paymentVC.typeOfwallet = .qatarCoolBill
        let navPaymentVC = UINavigationController(rootViewController: paymentVC)
        navPaymentVC.isNavigationBarHidden = true
        navPaymentVC.modalPresentationStyle = .overFullScreen
        
        paymentVC.paymentSuccess = {[weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        self.present(navPaymentVC, animated: true)
        
//        var isPaymentRequest = true
//        let groupDetails = GroupDetails(groupID: number._groupID, number: [number._number])
//        
//        var paymentRequestPhoneBillParams = PaymentRequestPhoneBillParams()
//        paymentRequestPhoneBillParams.groupDetails       = [groupDetails]
//        paymentRequestPhoneBillParams.isFullAmount       = self.paymentStatus == .fullAmount
//        paymentRequestPhoneBillParams.isPartialAmount    = self.paymentStatus == .partialAmount
//        
//        if let partialAmount = self.partialAmountTextField.text,
//           partialAmount.isNotEmpty {
//            paymentRequestPhoneBillParams.amount = Double(partialAmount) ?? 0.0
//        }
//        
//        if let calendarType = self.calendarType,
//           calendarType == .saveDate {
//            
//            guard let date = self.selectedDate else {
//                self.showSnackMessage("You should select date")
//                return
//            }
//            
//            paymentRequestPhoneBillParams.scheduledDate = date.server4DateToString()
//            paymentRequestPhoneBillParams.isRecurringPayment = self.recurringPaymentCheckBox.isChecked
//            
//            isPaymentRequest = false
//        }
        
//        self.showLoadingView(self)
        
//        self.requestProxy.requestService()?.savePaymentRequestQatarCoolBill(paymentRequestPhoneBillParams: paymentRequestPhoneBillParams, { paymentRequestViaBillResponse in
//            self.hideLoadingView()
//            
//            DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
//                
//                guard let resp = paymentRequestViaBillResponse else {
//                    self.showSnackMessage("Something went wrong")
//                    return
//                }
//                
//                guard resp._success else {
//                    self.showErrorMessage(resp._message)
//                    return
//                }
//                
//                //            self.showSuccessMessage(resp._message)
//                
//                if isPaymentRequest {
//                    let vc = self.getStoryboardView(ConfirmPinCodeViewController.self)
//                    vc.paymentViaBillResponse = resp
//                    self.present(vc, animated: true)
//                    
//                } else {
//                    self.viewWillAppear(true)
//                }
//            }
//        })
    }
}

// MARK: - TABLE VIEW DELEGATE

extension QatarCoolOperationsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.scheduleRequestsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(PhoneBillOperationTableViewCell.self, for: indexPath)
        
        let object    = self.scheduleRequestsList[indexPath.row]
        cell.object   = object
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

// MARK: - BaseOperationTableViewCellDelegate

extension QatarCoolOperationsViewController : PhoneBillOperationTableViewCellDelegate {
    
    func didTapEdit(_ cell: PhoneBillOperationTableViewCell) {
        
        let alert = UIAlertController(title: "", message: "Do you want Edit ?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .destructive , handler: { _ in
            
            self.calendarType = .editDate
            
            var object = PaymentRequestDetails()
            object.paymentRequestID    = cell.object?._paymentRequestID ?? ""
            object.groupID             = self.number?._groupID ?? 0
            object.number              = cell.object?._number ?? ""
            object.isFullAmount        = cell.object?._isFullAmount ?? false
            object.isRecurringPayment  = cell.object?._isRecurringPayment ?? false
            object.isPartialAmount     = cell.object?._isPartialAmount ?? false
            object.amount              = cell.object?._amount ?? 0.0
            self.paymentRequestDetails = object
            
            self.calendarPopup.isHidden = false
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true)
    }
    
    func didTapDelete(_ cell: PhoneBillOperationTableViewCell) {
        
        guard let id = cell.object?._paymentRequestID else {
            self.showSnackMessage("Something went wrong",messageStatus: .Error)
            return
        }
        
        let alert = UIAlertController(title: "", message: "Do you want Delete ?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive , handler: { _ in
            
            self.showLoadingView(self)
            
            self.requestProxy.requestService()?.deletePaymentRequestViaQatarCoolBill(paymentRequestID: [id], { baseResponse in
                self.hideLoadingView()
                
                guard let resp = baseResponse else {
                    self.showSnackMessage("Something went wrong",messageStatus: .Error)
                    return
                }
                
                guard resp._success else {
                    self.showErrorMessage(resp._message)
                    return
                }
                
                self.showSuccessMessage(resp._message)
                self.scheduleRequestsList.removeAll(where: { $0._paymentRequestID == id })
                self.tableView.reloadData()
            })
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true)
    }
}

// MARK: - UPDATE VIEW ELEMENT DELEGATE

extension QatarCoolOperationsViewController: UpdateViewElement {
    
    func elementUpdated(fromSourceView view: UIViewController, status: Bool, data: Any?) {
        if view is EditNameNumberViewController {
            self.viewWillAppear(true)
        }
    }
}

// MARK: - CUSTOM FUNCTIONS

extension QatarCoolOperationsViewController {
    
    @objc
    private func didChangeFullAmountCheckBox(_ checkBox: CheckBox) {
        self.paymentStatus = .fullAmount
        self.partialAmountCheckBox.isChecked = !checkBox.isChecked
        self.partialAmountStackView.isHidden = checkBox.isChecked
    }
    
    @objc
    private func didChangePartialAmountCheckBox(_ checkBox: CheckBox) {
        self.paymentStatus = .partialAmount
        self.fullAmountCheckBox.isChecked    = !checkBox.isChecked
        self.partialAmountStackView.isHidden = !checkBox.isChecked
    }
    
    @objc
    private func onCheckBoxValueChange(_ checkBox: CheckBox) {
        self.recurringPaymentCheckBox.isChecked = checkBox.isChecked
    }
    
    fileprivate func getPaymentRequestViaQatarCoolBillFun(_ data: QatarCoolNumber?) {
        
        guard let object = data else {
            self.showSnackMessage("Something went wrong",messageStatus: .Error)
            return
        }
        
        self.showLoadingView(self)
        self.requestProxy.requestService()?.getPaymentRequestviaQatarCoolBill(groupID: object._groupID,
                                                                           mobileNumber: object._number, { paymentRequestVia in
            self.hideLoadingView()
            guard let resp = paymentRequestVia else {
                self.showSnackMessage("Something went wrong",messageStatus: .Error)
                return
            }
            
            self.scheduleRequestsList = resp._scheduleRequests
            self.tableView.reloadData()
        })
    }
    
    private func setupCalendarPopup() {
        
        [calendarPopup].forEach { v in
            v.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(v)
        }
        let g = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            
            // custom picker view should cover the whole view
            calendarPopup.topAnchor.constraint(equalTo: g.topAnchor),
            calendarPopup.leadingAnchor.constraint(equalTo: g.leadingAnchor),
            calendarPopup.trailingAnchor.constraint(equalTo: g.trailingAnchor),
            calendarPopup.bottomAnchor.constraint(equalTo: g.bottomAnchor),
        ])
        
        // hide custom picker view
        calendarPopup.isHidden = true
        
        // add closures to custom picker view
        calendarPopup.dismissClosure = { [weak self] in
            guard let _ = self else {
                return
            }
        }
        
        calendarPopup.okBtnClosure = { [weak self] date in
            guard let self = self,
                  let calendarType = self.calendarType else {
                return
            }
            
            switch calendarType {
            case .saveDate:
                self.recurringPaymentStackView.isHidden = false
                self.selectedDate = date
                break
                
            case .editDate:
                guard var objectDetails = self.paymentRequestDetails else {
                    self.showSnackMessage("Something went wrong")
                    return
                }
                
                objectDetails.scheduledDate = date.server4DateToString()
                
                var object = PaymentRequestDetailsObject()
                object.array = [objectDetails]
                
                self.requestProxy.requestService()?.updatePaymentRequestViaQatarCoolBill(paymentRequestObject: object, { response in
                    guard let resp = response else {
                        self.showSnackMessage("Something went wrong")
                        return
                    }
                    
                    guard resp._success else {
                        self.showErrorMessage(resp._message)
                        return
                    }
                    self.showSuccessMessage(resp._message)
                    //                    self.getPaymentRequestViaPhoneBillFun()
                    self.viewWillAppear(true)
                })
                break
            }
        }
    }
}
