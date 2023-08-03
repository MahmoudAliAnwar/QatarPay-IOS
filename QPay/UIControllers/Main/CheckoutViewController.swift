//
//  CardDetailsViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/21/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class CheckoutViewController: MainController {
    
    @IBOutlet weak var channelsCollectionView : UICollectionView!
    @IBOutlet weak var savedCardsTableView    : UITableView!
    @IBOutlet weak var savedCardsStackView    : UIStackView!
    @IBOutlet weak var deductWalletStackView  : UIStackView!
        
    var amount   : Double?
    var data     : [Any]?
    var channels = [Channel]()
    
    private var savedCards = [TokenizedCard]()
    private var amountQR   : Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        localized()
        setupData()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.dispatchGroup.enter()
        self.showLoadingView(self)
        
        self.requestProxy.requestService()?.getChannelList( weakify { strong, list in
            strong.channels = list ?? []
            strong.channelsCollectionView.reloadData()
            strong.dispatchGroup.leave()
        })
        
        self.dispatchGroup.enter()
        self.requestProxy.requestService()?.getTokenizedCardDetails( weakify { strong, cardList in
            strong.dispatchGroup.leave()
            guard let list    = cardList else { return }
            strong.savedCards = list
            strong.savedCardsTableView.reloadData()
        })
        self.dispatchGroup.notify(queue: .main) {
            self.hideLoadingView()
        }
    }
}

extension CheckoutViewController {
    
    func setupView() {
        self.channelsCollectionView.delegate   = self
        self.channelsCollectionView.dataSource = self
        
        // self.savedCardsStackView.isHidden    = self.savedCards.isEmpty
        self.savedCardsTableView.delegate   = self
        self.savedCardsTableView.dataSource = self
        self.savedCardsTableView.registerNib(SavedCardsTableViewCell.self)
        
        self.deductWalletStackView.isHidden = self.data == nil
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension CheckoutViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deductFromWalletAction(_ sender: UIButton) {
        guard let array = self.data else {
            return
        }
        let vc = self.getStoryboardView(ConfirmPinCodeViewController.self)
        vc.dataArray = array
        vc.updateViewElementDelegate = self
        self.present(vc, animated: true)
    }
}

extension CheckoutViewController: UpdateViewElement {
    
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

// MARK: - COLLECTION VIEW DELEGATE

extension CheckoutViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.channels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(ChannelCollectionViewCell.self, for: indexPath)
        
        let object   = self.channels[indexPath.row]
        cell.channel = object
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let object = self.channels[indexPath.row]
        var amount: Double = 0
        
        if let mAmount = self.amount {
            amount = mAmount
        } else {
            guard let array = self.data, array.isNotEmpty else {
                self.showErrorMessage("Something went wrong")
                return
            }
            guard let obj = array[1] as? ValidateMerchantQRCode else {
                self.showErrorMessage("Something went wrong")
                return
            }
            
            amount = obj._amount
        }
        
        guard amount > 0 else {
            self.showErrorMessage("Something went wrong")
            return
        }
        
        self.showLoadingView(self)
        
        if object._id == 3 {
            self.requestProxy.requestService()?.getProcessTokenizedPayment(amount: amount, cardID: 0, { response in
                self.hideLoadingView()
                guard let resp = response else { return }
                self.pushToConfirm(resp)
            })
            
        } else {
            self.requestProxy.requestService()?.getRefillCharge(amount, channelID: object._id, weakify { strong, response in
                self.hideLoadingView()
                guard let resp = response else { return }
                self.pushToConfirm(resp)
            })
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellsInRow: CGFloat = 2
        let flowLayout: UICollectionViewFlowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let topBottomPadding : CGFloat = flowLayout.sectionInset.top + flowLayout.sectionInset.bottom
        let spaceBetweenCells: CGFloat = flowLayout.minimumLineSpacing * cellsInRow
        let cellHeight = (collectionView.height - topBottomPadding - spaceBetweenCells) / cellsInRow
        let size = CGSize(width: cellHeight, height: cellHeight)
        return size
    }
}

// MARK: - TABLE VIEW DELEGATE

extension CheckoutViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.savedCards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(SavedCardsTableViewCell.self, for: indexPath)
        
        let object    = self.savedCards[indexPath.row]
        cell.object   = object
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let alert = UIAlertController.init(title         : "",
                                           message       : "Do you want to pay?",
                                           preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel))
        
        alert.addAction(UIAlertAction(title  : "OK",
                                      style  : .destructive ,
                                      handler: { _ in
            
            let object = self.savedCards[indexPath.row]
            var amount: Double = 0
            
            if let mAmount = self.amount {
                amount = mAmount
            } else {
                guard let array = self.data, array.isNotEmpty else {
                    self.showErrorMessage("Something went wrong")
                    return
                }
                guard let obj = array[1] as? ValidateMerchantQRCode else {
                    self.showErrorMessage("Something went wrong")
                    return
                }
                amount = obj._amount
            }
            
            guard amount > 0 else {
                self.showErrorMessage("Something went wrong")
                return
            }
            
            self.showLoadingView(self)
            self.requestProxy.requestService()?.getProcessTokenizedPayment(amount: amount, cardID: object._id, { response in
                self.hideLoadingView()
                
                guard let resp = response else {
                    self.showSnackMessage("Something went wrong")
                    return
                }
                
                guard resp._success else {
                    self.showErrorMessage(resp._message)
                    return
                }
                self.showSuccessMessage(resp._message)
            })
        }))
        self.present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let object = self.savedCards[indexPath.row]
        return object._isDefault ? 100 : 140
    }
}

extension CheckoutViewController : SavedCardsTableViewCellDelegate {
    
    func didTapSetDefaultCard(_ cell: SavedCardsTableViewCell, for card: TokenizedCard) {
        
        let alert = UIAlertController.init(title: "", message: "Do you want to set this Card as Default?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive , handler: { _ in
            
            self.showLoadingView(self)
            
            self.requestProxy.requestService()?.setDefaultCardTokenized(cardId : card._id) { baseResponse in
                self.hideLoadingView()
                guard let resp = baseResponse else {
                    self.showSnackMessage("Something went wrong")
                    return
                }
                
                guard resp._success else {
                    self.showErrorMessage(resp._message)
                    return
                }
                self.showSuccessMessage(resp._message)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true)
    }
    
    func didTapDeleteSavedCard(_ cell: SavedCardsTableViewCell, for card: TokenizedCard) {
        
        let alert = UIAlertController.init(title: "", message: "Do you want to Delete this Card?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive , handler: { _ in
            
            self.showLoadingView(self)
            
            self.requestProxy.requestService()?.deleteTokenizedPaymentCard(id: card._id) { baseResponse in
                self.hideLoadingView()
                guard let resp = baseResponse else { return }
                
                guard resp._success else {
                    self.showErrorMessage(resp._message)
                    return
                }
                self.showSuccessMessage(resp._message)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true)
    }
}

// MARK: - REQUESTS DELEGATE

//extension CheckoutViewController: RequestsDelegate {
//
//    func requestStarted(request: RequestType) {
//        if request  == .getChannelList ||
//            request == .getProcessTokenizedPayment  {
//            showLoadingView(self)
//        }
//    }
//
//    func requestFinished(request: RequestType, result: ResponseResult) {
//        hideLoadingView()
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
//            switch result {
//            case .Success(_):
//                break
//            case .Failure(let errorType):
//                switch errorType {
//                case .Exception(let exc):
//                    if showUserExceptions {
//                        self.showErrorMessage(exc)
//                    }
//                    break
//                case .AlamofireError(let err):
//                    if showAlamofireErrors {
//                        self.showSnackMessage(err.localizedDescription)
//                    }
//                    break
//                case .Runtime(_):
//                    break
//                }
//            }
//        }
//    }
//}

// MARK: - PRIVATE FUNCTIONS

extension CheckoutViewController {
    
    private func openWebView(with url: URL?) {
        let vc = self.getStoryboardView(WebViewController.self)
        vc.webPageUrl = url
        vc.parentView = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func pushToConfirm(_ response: BaseResponse) {
        let vc = self.getStoryboardView(ConfirmRefillWalletViewController.self)
        vc.object = response
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func sendTransferQRCodePayment(_ code: String, validateObject: ValidateMerchantQRCode) {
        guard let sessionID = validateObject.sessionID,
              let uuid = validateObject.UUID,
              let qrData = validateObject.qrCodeData else {
            return
        }
        self.requestProxy.requestService()?.transferQRCodePayment(pinCode: code, qrData: qrData, sessionID: sessionID, uuid: uuid) { (status, response) in
            guard status else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                //                self.closeView(true, data: response?.message ?? "Transfer Confirmed Successfully")
            }
        }
    }
    
}
