//
//  HomeViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/4/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit
import FirebaseMessaging
import Instructions
import DropDown

class HomeViewController: MainController {
    
    @IBOutlet weak var optionsDropDownGradientView: GradientView!
    @IBOutlet weak var noqsDropDownGradientView: GradientView!
    @IBOutlet weak var unreadNotificationsLabel: UILabel!
    
    @IBOutlet weak var bottomBarCarousel: iCarousel!
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var cardImageView: UIImageView!
    
    @IBOutlet weak var qrCodeImageView: UIImageView!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var cardCodeLabel: UILabel!
    @IBOutlet weak var cardExpiryLabel: UILabel!
    @IBOutlet weak var cardUserNameLabel: UILabel!
    @IBOutlet weak var cardLoyalityPointsLabel: UILabel!
    @IBOutlet weak var cardCodeStackView: UIStackView!
    
    @IBOutlet weak var topTableView: UIView!
    @IBOutlet weak var transactionsTable: UITableView!
    @IBOutlet weak var emptyTransactionsStack: UIStackView!
    
    @IBOutlet weak var viewAllButton: UIButton!
    
    private var transactions = [Transaction]()
    private var carouselActions = [CarouselActionModel]()
    
    private let coachMarksController = CoachMarksController()
    private let cacheManager = CacheManager<[Transaction]>()
    
    private var optionsPopupStatus: PopupStatus = .Hide
    private var noqsPopupStatus: PopupStatus = .Hide
    private var presentationContext: Context = .independentWindow
    
    private enum Context {
        case independentWindow, controllerWindow, controller
    }
    
    private enum PopupStatus {
        case Show
        case Hide
        
        mutating func toggle() -> PopupStatus {
            switch self {
            case .Show:
                return .Hide
            case .Hide:
                return .Show
            }
        }
    }
    
    struct CarouselActionModel {
        let action: CarouselActions
        let completion: voidCompletion
    }
    
    enum CarouselActions: String, CaseIterable {
        case scanQR = "Scan QR"
        case parkings = "QParkin"
        case myWallet = "My Wallet"
        case vendexPay = "Vendex Pay"
        
        var icon: UIImage? {
            get {
                switch self {
                case .scanQR: return R.image.ic_scanQR()
                case .parkings: return UIImage(named: "ic_parkings_home2")
                case .myWallet: return R.image.ic_my_wallet_home()
                case .vendexPay: return R.image.ic_vendex_pay_home()
                }
            }
        }
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
        
        self.statusBarView?.isHidden = true
        
        self.requestProxy.requestService()?.delegate = self
        
        self.isUserHasTransactions(false)
        
        if let user = self.userProfile.getUser() {
            
            if let accountLevel = user.accountLevel {
                let level = accountLevel.lowercased()
                
                if level == "maroon" {
                    self.cardImageView.image = .ic_maroon_card_home
                    
                }else if level == "business" {
                    self.cardImageView.image = .ic_blue_card_home
                    
                }else if level == "vip" {
                    self.cardImageView.image = .ic_black_card_home
                }
            }
            
            if var code = user.userCode, code.isNotEmpty {
                code.insert(separator: "  ", every: 4)
                self.cardCodeLabel.text = code
            }
            
            if let balance = user.loyalityBalance {
                self.cardLoyalityPointsLabel.text = "\(balance) pts"
            }
            
            // 8/24/2025 10:13:24 AM
            if let expiry = user.qpanExpiry,
               let serverDate = expiry.formatToDate("M/dd/yyyy hh:mm:ss a") {
                self.cardExpiryLabel.text = serverDate.formatDate("MM/yy")
            }
        }
        
        self.balanceRequest()
        self.transacionsRequest()
        self.notificationsRequest()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.hideDropDownLists()
    }
}

extension HomeViewController {
    
    func setupView() {
        self.transactionsTable.delegate = self
        self.transactionsTable.dataSource = self
        
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(self.didTapContainerView(_:)))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
        
        self.bottomBarCarousel.delegate = self
        self.bottomBarCarousel.dataSource = self
        self.bottomBarCarousel.type = .rotary
        self.bottomBarCarousel.isPagingEnabled = true
        
        self.optionsDropDownGradientView.alpha = 0.0
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 100))
        self.transactionsTable.tableFooterView = footerView
        self.transactionsTable.contentInset = UIEdgeInsets(top: self.topTableView.height, left: 0, bottom: 0, right: 0)
        
        self.coachMarksController.dataSource = self
        self.coachMarksController.delegate = self
        
        self.coachMarksController.overlay.isUserInteractionEnabled = true
        self.coachMarksController.overlay.blurEffectStyle = .systemUltraThinMaterialDark
        self.coachMarksController.overlay.fadeAnimationDuration = 0.3
        self.coachMarksController.overlay.backgroundColor = .clear
        
        let skipView = CoachMarkSkipDefaultView()
        skipView.setTitle("Skip", for: .normal)
        
        self.coachMarksController.skipView = skipView
        self.coachMarksController.overlay.areTouchEventsForwarded = true
        
        self.transactionsTable.registerNib(TransactionTableViewCell.self)
        
        self.tokenRequest()
    }
    
    func localized() {
    }
    
    func setupData() {
        self.carouselActions = [
            CarouselActionModel(action: .scanQR, completion: {
                self.openQRScannerView(isVendexView: false)
            }),
            CarouselActionModel(action: .parkings, completion: {
                let vc = self.getStoryboardView(ParkingsViewController.self)
                self.navigationController?.pushViewController(vc, animated: true)
            }),
            CarouselActionModel(action: .myWallet, completion: {
                let vc = self.getStoryboardView(MoneyTransferViewController.self)
                self.navigationController?.pushViewController(vc, animated: true)
            }),
            CarouselActionModel(action: .vendexPay, completion: {
                self.openQRScannerView(isVendexView: true)
            })
        ]
        self.bottomBarCarousel.reloadData()
    }
    
    func fetchData() {
        self.requestProxy.requestService()?.getUserProfile { (myProfile) in
            guard let profile = myProfile else { return }
            self.emailLabel.text = profile._email
            
            let userName = "\(profile.fullName ?? "") \(profile.lastName ?? "")"
            self.nameLabel.text = userName
            self.cardUserNameLabel.text = userName.uppercased()
            
            guard let imgUrl = profile.imageURL else { return }
            imgUrl.getImageFromURLString { (status, image) in
                guard status else { return }
                self.userImageView.image = image
            }
        }
    }
}

// MARK: - ACTIONS

extension HomeViewController {
    
    @IBAction func myWalletAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(MoneyTransferViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func myLibraryAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(MyLibraryViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
//    @IBAction func myShopAction(_ sender: UIButton) {
//
//        self.requestProxy.requestService()?.getShopList { (myShops) in
//            let shops = myShops ?? []
//
//            if shops.isEmpty {
//                let vc = self.getStoryboardView(CreateShopViewController.self)
//                self.navigationController?.pushViewController(vc, animated: true)
//
//            }else {
//                let vc = self.getStoryboardView(MyShopsViewController.self)
//                vc.shops = shops
//                vc.shopsAll = shops
//                vc.isFromHome = true
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
//        }
//    }
    
    @IBAction func myCVAction(_ sender: UIButton) {
        
        guard let user = self.userProfile.getUser() else { return }
        self.requestProxy.requestService()?.getCVList(phoneNumber: user._mobileNumber, { (response) in
            guard let resp = response else { return }
            self.hideLoadingView()
            if resp._list.isEmpty {
                let vc = self.getStoryboardView(FirstScreenViewController.self)
                self.navigationController?.pushViewController(vc, animated: true)
                
            } else {
                
                let vc = self.getStoryboardView(ShowCVDetailsViewController.self)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        })
    }
    
    @IBAction func dashboardAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(DashboardViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func notificationAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(NotificationsViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func noqsAction(_ sender: UIButton) {
        self.showHideNoqsPopupView()
    }
    
    @IBAction func optionsDropDownAction(_ sender: UIButton) {
        self.showHideOptionsPopupView()
    }
    
    @IBAction func aboutAppAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(AboutAppViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func settigsAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(SettingsViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func contactAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(ContactsUsViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func logoutAction(_ sender: UIButton) {
        self.userProfile.logout()
        let vc = self.getStoryboardView(MySplashViewController.self)
        self.navigationController?.setViewControllers([vc], animated: true)
    }
    
    @IBAction func QRCodeAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(NoqoodyCodeViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func viewAllAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(TransactionsViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func profileAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(PersonalInfoViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UPDATE VIEW DELEGATE

extension HomeViewController: UpdateViewElement {
    
    func elementUpdated(fromSourceView view: UIViewController, status: Bool, data: Any?) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
            
            if view is QRScannerViewController {
                guard var code = data as? String else {
                    self.showErrorMessage("Something went wrong, please try again later")
                    return
                }
                
                let lastChars = code.suffix(1)
                
                if lastChars == "1" ||
                    lastChars == "2" ||
                    lastChars == "3" &&
                    code.count > 20 {
                    
                    let lastChar = code.removeLast()
                    
                    if lastChar == "1" {
                        self.validateMerchantQRCodePaymentRequest(code, lastChar: lastChar)
                        
                    } else if lastChar == "2" {
                        self.requestProxy.requestService()?.validateMerchantQR(QRCodeData: code) { (validateObject) in
                            guard var object = validateObject else {
                                return
                            }
                            object.qrCodeData = code
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                                self.openConfirmQRPayView(object, lastChar: lastChar)
                            }
                        }
                        
                    } else if lastChar == "3" {
                        self.validateMerchantQRCodeWithAmountRequest(code, lastChar: lastChar)
                    }
                    
                } else {
                    if let firstPhone = code.getCheckingResult(with: .phoneNumber).first?.phoneNumber {
                        guard let url = URL(string: "tel:\(firstPhone)"),
                              UIApplication.shared.canOpenURL(url) else {
                            return
                        }
                        UIApplication.shared.open(url, options: [:])
                        
                    } else if let firstEmail = code.getEmails().first {
                        guard let url = URL(string: "mailto:\(firstEmail)"),
                              UIApplication.shared.canOpenURL(url) else {
                            return
                        }
                        UIApplication.shared.open(url, options: [:])
                        
                    } else if let url = URL(string: code) {
                        guard UIApplication.shared.canOpenURL(url) else {
                            return
                        }
                        UIApplication.shared.open(url, options: [:])
                        
                    } else {
                        self.showErrorMessage("Invalid QR Code")
                    }
                }
                
            } else if view is ConfirmPinCodeViewController {
                guard status == true,
                      let message = data as? String else {
                    return
                }
                
                self.transacionsRequest()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                    self.showSuccessMessage(message)
                }
            }
        }
    }
    
    func elementsUpdated(fromSourceView view: UIViewController, status: Bool, data: [Any]?) {
        if view is ConfirmQRCodePayViewController {
            guard status,
                  let arrayData = data else {
                return
            }
            
            if arrayData.isNotEmpty && arrayData[0] as! Character == "1" {
                let vc = self.getStoryboardView(CheckoutViewController.self)
                vc.data = arrayData
                self.navigationController?.pushViewController(vc, animated: true)
                
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                    let vc = self.getStoryboardView(ConfirmPinCodeViewController.self)
                    vc.dataArray = arrayData
                    vc.updateViewElementDelegate = self
                    self.present(vc, animated: true)
                }
            }
        }
    }
}

// MARK: - ICAROUSEL DELEGATE

extension HomeViewController: iCarouselDelegate, iCarouselDataSource {
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return self.carouselActions.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let homeView = HomeBarCarouselView(frame: CGRect(x: 0, y: 0, width: carousel.height, height: carousel.height))
        
        homeView.tag = index
        homeView.model = self.carouselActions[index]
        
        return homeView
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == .spacing {
            return 2.2
        }
        return value
    }
    
    func carouselDidEndScrollingAnimation(_ carousel: iCarousel) {
        guard let cell = carousel.currentItemView as? HomeBarCarouselView else { return }
        cell.cellPosition = .center
        
        let after = self.carouselActions.safeNextIndex(for: carousel.currentItemIndex)
        guard let rightCell = carousel.itemView(at: after) as? HomeBarCarouselView else { return }
        rightCell.cellPosition = .right
        
        let before = self.carouselActions.safePreviousIndex(for: carousel.currentItemIndex)
        guard let leftCell = carousel.itemView(at: before) as? HomeBarCarouselView else { return }
        leftCell.cellPosition = .left
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        if index == carousel.currentItemIndex {
            self.carouselActions[index].completion()
        }
    }
}

// MARK: - TABLE DELEGATE

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(TransactionTableViewCell.self, for: indexPath)
        
        cell.parent = self
        cell.setupData(transaction: self.transactions[indexPath.row])
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let trans = self.transactions[indexPath.row]
        
        let vc = self.getStoryboardView(TransactionDetailsViewController.self)
        vc.transaction = trans
        vc.delegate = self
        self.present(vc, animated: true)
    }
}

// MARK: - TRANSACTION DETAILS DELEGATE

extension HomeViewController: TransactionDetailsViewControllerDelegate {
    
    func didTapAddBenefeciary(_ view: TransactionDetailsViewController, with transaction: Transaction) {
        guard let qpan = transaction.QPAN else { return }
        let vc = self.getStoryboardView(AddBeneficiaryViewController.self)
        vc.qpan = qpan
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - REQUESTS DELEGATE

extension HomeViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .validateMerchantQRCodePayment ||
            request == .getShopList ||
            request == .getCVList
        {
            showLoadingView(self)
        }
    }
    
    func requestFinished(request: RequestType, result: ResponseResult) {
        
        self.hideLoadingView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
            
            if request == .transactionsList {
                if self.userProfile.isFirstRun() {
                    self.coachMarksController.start(in: .window(over: self))
                    self.userProfile.changeFirstRunStatus()
                }
//                } else if !self.userProfile.isShownPopup() {
//                    self.showInformationPopup()
//                    self.userProfile.changeShownPopupStatus()
//                }
            }
            
            switch result {
            case .Success(_):
                break
            case .Failure(let errorType):
                if request == .validateMerchantQRCodePayment ||
                    request == .transactionsList {
                    switch errorType {
                    case .Exception(let exc):
                        guard exc != "401" else {
                            self.logoutView()
                            return
                        }
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
}

// MARK: - INSTRUCTIONS DELEGATE

extension HomeViewController: CoachMarksControllerDataSource, CoachMarksControllerDelegate {
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: (UIView & CoachMarkBodyView), arrowView: (UIView & CoachMarkArrowView)?) {
        
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(
            withArrow: true,
            arrowOrientation: coachMark.arrowOrientation
        )
        let nextButtonText = "Next!"
        
        switch index {
        case 0:
            coachViews.bodyView.hintLabel.text = "Your Balance Noqs"
            coachViews.bodyView.nextLabel.text = nextButtonText
        case 1:
            coachViews.bodyView.hintLabel.text = "Your QPAN Number"
            coachViews.bodyView.nextLabel.text = nextButtonText
        case 2:
            coachViews.bodyView.hintLabel.text = "Your QR Code"
            coachViews.bodyView.nextLabel.text = nextButtonText
        default:
            break
        }
        
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
        
        switch index {
        case 0:
            return coachMarksController.helper.makeCoachMark(for: self.balanceLabel)
        case 1:
            return coachMarksController.helper.makeCoachMark(for: self.cardCodeLabel)
        case 2:
            return coachMarksController.helper.makeCoachMark(for: self.qrCodeImageView)
        default:
            return coachMarksController.helper.makeCoachMark()
        }
    }
    
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 3
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, didEndShowingBySkipping skipped: Bool) {
//        if self.userProfile.isShownPopup() {
//            self.showInformationPopup()
//            self.userProfile.changeShownPopupStatus()
//        }
    }
}

// MARK: - CUSTOM FUNCTIONS

extension HomeViewController {
    
    private func validateMerchantQRCodePaymentRequest(_ code: String, lastChar: String.Element) {
        self.requestProxy.requestService()?.validateMerchantQRCodePayment(QRCodeData: code) { (validateObject) in
            guard var object = validateObject else {
                return
            }
            object.qrCodeData = code
            
            DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                self.openConfirmQRPayView(object, lastChar: lastChar)
            }
        }
    }
    
    private func validateMerchantQRCodeWithAmountRequest(_ code: String, lastChar: String.Element) {
        self.requestProxy.requestService()?.validateMerchantQRCodeWithAmount(QRCodeData: code) { (validateObject) in
            guard var object = validateObject else {
                return
            }
            object.qrCodeData = code
            
            DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                self.openConfirmQRPayView(object, lastChar: lastChar)
            }
        }
    }
    //one
    private func openConfirmQRPayView(_ object: ValidateMerchantQRCode, lastChar: Character) {
        let vc = self.getStoryboardView(ConfirmQRCodePayViewController.self)
        vc.validateObject = object
        vc.scenarioNumber = lastChar
        vc.updateViewElementDelegate = self
        self.present(vc, animated: true)
    }
    
    private func openQRScannerView(isVendexView: Bool) {
        let vc = self.getStoryboardView(QRScannerViewController.self)
        vc.updateElementDelegate = self
        vc.isVendexView = isVendexView
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapContainerView(_ gesture: UITapGestureRecognizer) {
        self.hideDropDownLists()
    }
    
    private func hideDropDownLists() {
        self.hideNoqsDropDownIfOpened()
        self.hideOptionsDropDownIfOpened()
    }
    
    private func hideOptionsDropDownIfOpened() {
        if self.optionsPopupStatus == .Show {
            self.showHideOptionsPopupView()
        }
    }
    
    private func hideNoqsDropDownIfOpened() {
        if self.noqsPopupStatus == .Show {
            self.showHideNoqsPopupView()
        }
    }
    
    private func showHideNoqsPopupView() {
        self.hideOptionsDropDownIfOpened()
        self.noqsPopupStatus = self.noqsPopupStatus.toggle()
        
        switch self.noqsPopupStatus {
        case .Show:
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                self.noqsDropDownGradientView.isHidden = false
                
            }) { (_) in
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                    self.noqsDropDownGradientView.alpha = 1
                })
            }
            
        case .Hide:
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.noqsDropDownGradientView.alpha = 0
            }) { (_) in
                self.noqsDropDownGradientView.isHidden = true
            }
        }
    }
    
    private func showHideOptionsPopupView() {
        self.hideNoqsDropDownIfOpened()
        self.optionsPopupStatus = self.optionsPopupStatus.toggle()
        
        switch self.optionsPopupStatus {
        case .Show:
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                self.optionsDropDownGradientView.isHidden = false
                
            }) { (_) in
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                    self.optionsDropDownGradientView.alpha = 1
                })
            }
            
        case .Hide:
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.optionsDropDownGradientView.alpha = 0
            }) { (_) in
                self.optionsDropDownGradientView.isHidden = true
            }
        }
    }
    
    private func balanceRequest() {
        self.requestProxy.requestService()?.getUserBalance { (status, balance) in
            guard status == true,
                  let blnc = balance else {
                return
            }
            self.balanceLabel.text = blnc.formatNumber()
        }
    }
    
    private func transacionsRequest() {
        
        self.dispatchGroup.enter()
        
        if let array = try? self.cacheManager?.storage?.object(forKey: Transaction.reuseIdentifier) {
            self.transactions = array
            self.transactionsTable.reloadData()
            self.isUserHasTransactions(self.transactions.isNotEmpty)
        }
        
        self.requestProxy.requestService()?.transactionsList ( weakify { strong, list in
            let arr = list ?? []
            
            try? strong.cacheManager?.storage?.removeObject(forKey: Transaction.reuseIdentifier)
            
            if arr.count > recentTransactionsLength {
                strong.transactions.removeAll()
                let sortedTransactions = strong.sortTransactions(arr)
                strong.saveRecentTransactionsToCache(sortedTransactions)
                
                for i in 0..<recentTransactionsLength {
                    let trans = sortedTransactions[i]
                    strong.transactions.append(trans)
                }
                
            } else {
                strong.transactions.removeAll()
                let sortedTransactions = strong.sortTransactions(arr)
                
                strong.transactions = sortedTransactions
                strong.saveRecentTransactionsToCache(sortedTransactions)
            }
            strong.dispatchGroup.leave()
        })
        
        self.dispatchGroup.notify(queue: DispatchQueue.main) {
            self.transactionsTable.reloadData()
            self.isUserHasTransactions(!self.transactions.isEmpty)
        }
    }
    
    private func saveRecentTransactionsToCache(_ sortedTransactions: [Transaction]) {
        do {
            try self.cacheManager?.storage?.setObject(sortedTransactions, forKey: Transaction.reuseIdentifier)
        } catch {
            print("\(#function) ERROR \(error.localizedDescription)")
        }
    }
    
    private func notificationsRequest() {
        
        self.requestProxy.requestService()?.getNotificationList( weakify { strong, notifications in
            let list = notifications ?? []
            let mapList = list.filter({ $0.isReadByUser == false })
            
            strong.unreadNotificationsLabel.text = mapList.count > 99 ? "99+" : "\(mapList.count)"
        })
    }
    
    private func tokenRequest() {
        Messaging.messaging().token { token, error in
            guard error == nil,
                  let token = token else {
                return
            }
            
            guard self.userProfile.isLoggedIn() == true else { return }
            self.requestProxy.requestService()?.sendDeviceToken(token, ( self.weakify { strong, object in
            }))
        }
    }
    
    private func sortTransactions(_ array: [Transaction]) -> [Transaction] {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = ServerDateFormat.Server1.rawValue
        dateFormatter.changeTimeZoneToGMT()
        
        return array.sorted { (first, second) -> Bool in
            guard let firstDate = first.date,
                  let secondDate = second.date else {
                return false
            }
            guard let firstFormatterDate = dateFormatter.date(from: firstDate),
                  let secondFormatterDate = dateFormatter.date(from: secondDate) else {
                return false
            }
            
            return firstFormatterDate.compare(secondFormatterDate) == .orderedDescending
        }
    }
    
    private func isUserHasTransactions(_ status: Bool) {
        self.emptyTransactionsStack.isHidden = status
        self.transactionsTable.isHidden = !status
        self.viewAllButton.isEnabled = status
        self.viewAllButton.setTitleColor(status ? .mLight_Red : .lightGray, for: .normal)
    }
}
