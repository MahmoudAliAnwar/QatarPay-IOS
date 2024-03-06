//
//  PaymentVC.swift
//  QPay
//
//  Created by Mahmoud on 31/01/2024.
//  Copyright © 2024 Dev. Mohmd. All rights reserved.
//

import UIKit
import PassKit


protocol PaymentProtocol: AnyObject{
    func didTapConfirm(response: PaymentRequestViaBillResponse?, payWithWallet: Bool?, baseResponse: BaseResponse?, isTokenized: Bool)
}

class PaymentVC: ViewController {
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
   
    @IBOutlet weak var holderView: UIView!{
        didSet{
            holderView.isHidden = true
            holderView.layer.borderColor = UIColor(red: 0/255, green: 71/255, blue: 131/255, alpha: 1).cgColor
            holderView.layer.borderWidth = 2
            holderView.layer.cornerRadius = 10
            holderView.clipsToBounds = true
        }
    }
    @IBOutlet weak var topView: UIView!{
        didSet{
            
            topView.layer.cornerRadius = 5
            topView.clipsToBounds = true
        }
    }

    var savedCards = [TokenizedCard]()
    var channels = [Channel]()
    var amountToPay: Double?
    var processTokenized: ProcessTokenizedModel?
    var typeOfwallet: TypeOfWallet!
    var isPaymentRequest: Bool?
    var isShard = false
    var applePaymentSataus = PKPaymentAuthorizationStatus.failure
    private var paymentRequest : PKPaymentRequest?

    var payWithWallet = false
    var paymentModelApplePay: BaseResponse?
    
    var paymentSuccess: (()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        
        tableView.registerNib(PaymentCell.self)
        tableView.registerNib(TokenizedPaymentCell.self)
        self.amountLabel.text = "Noqs \(amountToPay ?? 0)"
        getChannels()
        getTokenized()
        
        self.dispatchGroup.notify(queue: .main) {
            self.hideLoadingView()
            self.holderView.isHidden = false
            self.tableView.reloadData()
        }
    }

    func openApplePay(amount: Double?){
        self.paymentRequest = createApplePayRequest(amount: amount)
        
        let controller = PKPaymentAuthorizationViewController.init(paymentRequest: self.paymentRequest ?? PKPaymentRequest())
        controller?.delegate = self
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.present(controller ?? UIViewController(), animated: true)
        }
        
    }
    
    func createApplePayRequest(amount: Double?) -> PKPaymentRequest{
        
        let request  = PKPaymentRequest()
        request.currencyCode = "QAR" // 1
        request.countryCode = "QA" // 2
        request.merchantIdentifier = "merchant.com.noqoody.applenoqoody" // 3
        request.merchantCapabilities = PKMerchantCapability.capability3DS // 4
        request.supportedNetworks = [.amex, .mada, .masterCard, .visa]// 5
        request.paymentSummaryItems  = [PKPaymentSummaryItem(label: "QPay", amount:  NSDecimalNumber(value:  amount ?? 0.0))]
        return request
    }

    func getChannels(){
        self.showLoadingView(self)
        self.dispatchGroup.enter()
        self.requestProxy.requestService()?.getChannelList( weakify { strong, list in
            strong.channels = list?.filter({$0.showInIOS ?? true}) ?? []
        
            strong.dispatchGroup.leave()
        })
    }
    
    func getTokenized(){
        self.dispatchGroup.enter()
        self.requestProxy.requestService()?.getTokenizedCardDetails( weakify { strong, cardList in
            
            guard let list    = cardList else {
                self.showSnackMessage("Something went wrong")
                return
            }
            strong.savedCards = list
            strong.dispatchGroup.leave()
           
        })
    }
    
    func processTokenized(object: Channel? = nil,card: TokenizedCard? = nil ,isTokenized: Bool, payWithWallet: Bool){
        self.showLoadingView(self)
    
        self.processTokenized?.ChannelID = object?._id
        self.processTokenized?.IsTokenized = isTokenized
        let tokenizedData = TokenizedDataModel(Card_ID: card?._id)
        self.processTokenized?.TokenizedData = tokenizedData
        var billPayment: PaymentRequestPhoneBillParams? = self.processTokenized?.BillPaymentData
        billPayment?.IsShared = self.isShard
        
        self.processTokenized?.BillPaymentData = billPayment
        
            self.requestProxy.requestService()?.processTokenizedPayment(paymentModel: processTokenized, weakify { strong, response in
            self.hideLoadingView()
            guard let resp = response else {
                self.showSnackMessage("Something went wrong, please try again later")
                return
            }
                if self.payWithWallet {
                    if isTokenized {
                        self.showSuccessMessage("Payment Success!") {
                            self.dismiss(animated: true)
                            self.paymentSuccess?()
                    }
                    }else{
                        self.openWebView(with:  resp.paymentLink)
                    }
                }else{
                    self.pushToConfirm(respo: nil, payWithWallet: false, baseResponse: resp, isTokenized: isTokenized)
                }
        })
    }
    
    
    func payWithWallet(request:PaymentRequestPhoneBillParams, _ completion: @escaping CallObjectBack<PaymentRequestViaBillResponse>){
        
        switch self.typeOfwallet{
        case .phoneBill:
            
            self.requestProxy.requestService()?.savePaymentRequestPhoneBill(paymentRequestPhoneBillParams: request, completion)
            
        case .khrmaBill:
            
            self.requestProxy.requestService()?.savePaymentRequestkaharmaBill(paymentRequestPhoneBillParams: request, completion)
            
        case .qatarCoolBill:
            
            self.requestProxy.requestService()?.savePaymentRequestQatarCoolBill(paymentRequestPhoneBillParams: request, completion)
        default:
            break
        }
       
       
        
    }
    
    func payUsingWallet(){
        self.showLoadingView(self)
      
        self.payWithWallet(request: self.processTokenized?.BillPaymentData ?? PaymentRequestPhoneBillParams(), { paymentRequestViaBillResponse in
                self.hideLoadingView()
    
                DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
    
                    guard let resp = paymentRequestViaBillResponse else {
                        self.showSnackMessage("Something went wrong")
                        return
                    }
                   
                    guard resp._success else {
                        if resp._message.contains("Insufficient Fund in your wallet"){
                            self.showPaymentPopup(resp.RemainingAmount, serviceAmount: resp.ServiceCharge, bankAmount: resp.BankingCharge) {
                                self.pushToConfirm(respo: resp, payWithWallet: true, baseResponse: nil, isTokenized: false)
                                
                            }
                           
                        }else{
                            self.showErrorMessage(resp._message)
                        }
                        return
                    }
//                    self.dismiss(animated: true)
                    if self.isPaymentRequest ?? true {
                       
                        let vc = self.getStoryboardView(ConfirmPinCodeViewController.self)
                        vc.paymentViaBillResponse = resp
                        vc.succesClosure = {
                            self.dismiss(animated: true)
                            self.paymentSuccess?()
                        }
                        self.present(vc, animated: true)
    
                    } else {
                        self.dismiss(animated: true)
                    }
                }
            })
    }
    
    
    func createSessionApplePay(object: Channel? = nil,card: TokenizedCard? = nil ,isTokenized: Bool){
        self.showLoadingView(self)
    
        self.processTokenized?.ChannelID = object?._id
        self.processTokenized?.IsTokenized = isTokenized
        let tokenizedData = TokenizedDataModel(Card_ID: card?._id)
        self.processTokenized?.TokenizedData = tokenizedData
        var billPayment: PaymentRequestPhoneBillParams? = self.processTokenized?.BillPaymentData
        billPayment?.IsShared = self.isShard
        
        self.processTokenized?.BillPaymentData = billPayment
        
            self.requestProxy.requestService()?.createSessionApplePay(paymentModel: processTokenized, weakify { strong, response in
            self.hideLoadingView()
            guard let resp = response else {
                self.showSnackMessage("Something went wrong, please try again later")
                return
            }
                self.paymentModelApplePay = resp
                self.openApplePay(amount: resp._baseAmount)
        })
    }
    
    func proccessSessionApplePay(){
        self.showLoadingView(self)
    
      
        
        self.requestProxy.requestService()?.processSessionApplePay(paymentModel: self.paymentModelApplePay, weakify { strong, response in
            self.hideLoadingView()
            guard let resp = response else {
                self.showSnackMessage("Something went wrong, please try again later")
                return
            }
            self.showSuccessMessage("Payment Success!") {
                self.dismiss(animated: true)
                self.paymentSuccess?()
        }
               
        })
    }
    
    private func pushToConfirm(respo: PaymentRequestViaBillResponse?, payWithWallet: Bool?, baseResponse: BaseResponse?,isTokenized: Bool) {
        let vc = self.getStoryboardView(ConfirmRefillWalletViewController.self)
        vc.fromPaymentVC = true
        vc.response = respo
        vc.payWithWallet = payWithWallet
        vc.object = baseResponse
        vc.isTokenized = isTokenized
        vc.delgate = self
       
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func backButtonAction(){
        self.dismiss(animated: true)
    }
    
    @IBAction func payByWallet(){

        self.payUsingWallet()
    }

}

extension PaymentVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            self.savedCards.count
        }else{
            self.channels.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueCell(TokenizedPaymentCell.self, for: indexPath)
            
            cell.config(cardSaved: self.savedCards[indexPath.row])
            return cell
        }else{
            let cell = tableView.dequeueCell(PaymentCell.self, for: indexPath)
            
            cell.confige(image: channels[indexPath.row]._imageLocation)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            self.processTokenized(card: self.savedCards[indexPath.row], isTokenized: true, payWithWallet: false)
        }else{
            switch self.channels[indexPath.row]._id{
            case 4:
                createSessionApplePay(object: self.channels[indexPath.row],isTokenized: false)
            default:
                self.processTokenized(object: self.channels[indexPath.row], isTokenized: false, payWithWallet: false)
            }
        }
    }
    
    
    
}


// MARK: -  PAY WITH APPLE

extension PaymentVC : PKPaymentAuthorizationViewControllerDelegate {
    
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true) {
            
            if self.applePaymentSataus == .success{
                self.proccessSessionApplePay()
            }
        }
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        
        if  payment.token.paymentData.isEmpty{
            completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
            self.applePaymentSataus = .failure
            
        }else {
            print(payment.token)
            self.applePaymentSataus = .success
            self.paymentModelApplePay?.paymentToken = String(describing: payment.token)
            completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
        }
      
            
       
    }
}



extension PaymentVC: UpdateViewElement {
    private func openWebView(with url: String?) {
        let vc = PaymentWebViewController(link: url ?? "")
        
        vc.paymentSucces = {
                self.showSuccessMessage("Payment Success!") {
                    self.dismiss(animated: true)
                    self.paymentSuccess?()
            }
        }
        
        vc.paymentFailure = {
            self.showErrorMessage("Payment Failure!") {
                self.dismiss(animated: true)
            }
        }
      
        self.navigationController?.pushViewController(vc, animated: true)
    }

func elementUpdated(fromSourceView view: UIViewController, status: Bool, data: Any?) {
guard status == true,
      let message = data as? String else {
    return
}

DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
    self.showSuccessMessage(message)
}
}
}


extension PaymentVC: PaymentProtocol{
    func didTapConfirm(response: PaymentRequestViaBillResponse?, payWithWallet: Bool?, baseResponse: BaseResponse?, isTokenized: Bool) {

        
        
        if payWithWallet ?? false{
            self.topView.isHidden = true
            var billPayment: PaymentRequestPhoneBillParams? = self.processTokenized?.BillPaymentData
            billPayment?.IsShared = payWithWallet ?? false
            billPayment?.amount = response?.RemainingAmount ?? 0.0
            self.processTokenized?.BillPaymentData = billPayment
            self.isShard = payWithWallet ?? false
            self.processTokenized?.Amount = response?.RemainingAmount
            self.payWithWallet = true
        }else{
            if isTokenized {
                self.showSuccessMessage("Payment Success!") {
                    self.dismiss(animated: true)
                    self.paymentSuccess?()
            }
            }else{
                self.openWebView(with:  baseResponse?.paymentLink)
            }
        }
    }
    
   
}
