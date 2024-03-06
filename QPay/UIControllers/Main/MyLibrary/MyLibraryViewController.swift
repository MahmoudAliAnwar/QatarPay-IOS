//
//  MyLibraryViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 10/25/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit
import PDFReader

class MyLibraryViewController: MainController {
    
    @IBOutlet weak var tabImageView: UIImageView!
    @IBOutlet weak var tabWidth: NSLayoutConstraint!
    
    @IBOutlet weak var changePinButton: UIButton!
    @IBOutlet weak var enablePinButton: UIButton!
    
    @IBOutlet weak var emptyLibraryStackView: UIStackView!
    
    @IBOutlet weak var cardsScrollView: UIScrollView!
    
    @IBOutlet weak var savedCardsViewDesign: ViewDesign!
    @IBOutlet weak var savedCardsContainerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var creditCardViewDesign: ViewDesign!
    @IBOutlet weak var creditCardContainerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var debitCardViewDesign: ViewDesign!
    @IBOutlet weak var debitCardContainerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var loyaltyCardViewDesign: ViewDesign!
    @IBOutlet weak var loyaltyCardContainerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var bankAccountStackView: UIStackView!
    @IBOutlet weak var bankAccountViewDesign: ViewDesign!
    @IBOutlet weak var bankAccountContainerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var idLicenseScrollView: UIScrollView!
    @IBOutlet weak var idLicenseViewDesign: ViewDesign!
    @IBOutlet weak var idLicenseContainerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var drivingLicenseViewDesign: ViewDesign!
    @IBOutlet weak var drivingLicenseContainerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var passportStackView: UIStackView!
    @IBOutlet weak var passportViewDesign: ViewDesign!
    @IBOutlet weak var passportContainerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var documentsStackView: UIStackView!
    @IBOutlet weak var documentsViewDesign: ViewDesign!
    @IBOutlet weak var documentsContainerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var saverCardsTableView: UITableView!
    @IBOutlet weak var creditCardsTableView: UITableView!
    @IBOutlet weak var debitCardsTableView: UITableView!
    @IBOutlet weak var loyaltyCardsTableView: UITableView!
    @IBOutlet weak var bankAccountsTableView: UITableView!
    @IBOutlet weak var idCardsTableView: UITableView!
    @IBOutlet weak var drivingLicensesTableView: UITableView!
    @IBOutlet weak var passportsTableView: UITableView!
    @IBOutlet weak var documentsTableView: UITableView!
    
    @IBOutlet weak var savedCardsCountLabel: UILabel!
    @IBOutlet weak var creditCardsCountLabel: UILabel!
    @IBOutlet weak var debitCardsCountLabel: UILabel!
    @IBOutlet weak var loyaltyCardsCountLabel: UILabel!
    @IBOutlet weak var bankAccountsCountLabel: UILabel!
    @IBOutlet weak var idCardsCountLabel: UILabel!
    @IBOutlet weak var drivingLicensesCountLabel: UILabel!
    @IBOutlet weak var passportCountLabel: UILabel!
    @IBOutlet weak var documentsCountLabel: UILabel!
    
    var savedCards = [TokenizedCard]()
    var savedCardsDemo = [CardDemo]()
    
    var cards = [LibraryCard]()
    var loyaltyCards = [Loyalty]()
    var banks = [Bank]()
    var drivingLicenses = [DrivingLicense]()
    var idCards = [IDCard]()
    var passports = [Passport]()
    var documents = [Document]()
    
    var editActionSection: LibrarySection?
    var cardSelected: LibraryCard?
    var loyaltyCardSelected: Loyalty?
    var bankSelected: Bank?
    
    private var isViewOpened = false
    private var savedCardsViewOriginalHeight: CGFloat = 0
    private var creditCardsViewOriginalHeight: CGFloat = 0
    private var debitCardsViewOriginalHeight: CGFloat = 0
    private var loyaltyCardsViewOriginalHeight: CGFloat = 0
    private var bankViewOriginalHeight: CGFloat = 0
    private var idCardsViewOriginalHeight: CGFloat = 0
    private var drivingLicenseViewOriginalHeight: CGFloat = 0
    private var passportViewOriginalHeight: CGFloat = 0
    private var documentsViewOriginalHeight: CGFloat = 0
    
    private let tablesRowHeight: CGFloat = 100
    
    private var shareString: String?
    
    private var sectionSelected: LibrarySection = .Empty {
        willSet {
            self.setViewTabButton(newValue)
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
        
        self.requestProxy.requestService()?.delegate = self
        
        guard self.isViewOpened else {
            self.refreshViewRequest(.Cards)
            self.isViewOpened = true
            return
        }
        self.refreshViewRequest(self.sectionSelected)
        
        self.changeStatusBarBG()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.cardSelected = nil
        self.loyaltyCardSelected = nil
        self.bankSelected = nil
        self.editActionSection = nil
    }
}

extension MyLibraryViewController {
    
    func setupView() {
        self.changeStatusBarBG()
        
        self.savedCardsViewDesign.setViewCorners([.topLeft, .bottomLeft])
        self.creditCardViewDesign.setViewCorners([.topLeft, .bottomLeft])
        self.debitCardViewDesign.setViewCorners([.topLeft, .bottomLeft])
        self.loyaltyCardViewDesign.setViewCorners([.topLeft, .bottomLeft])
        self.bankAccountViewDesign.setViewCorners([.topLeft, .bottomLeft])
        self.idLicenseViewDesign.setViewCorners([.topLeft, .bottomLeft])
        self.drivingLicenseViewDesign.setViewCorners([.topLeft, .bottomLeft])
        self.passportViewDesign.setViewCorners([.topLeft, .bottomLeft])
        self.documentsViewDesign.setViewCorners([.topLeft, .bottomLeft])
        
        self.sectionSelected = .Empty
        
        self.requestProxy.requestService()?.getUserProfile ( weakify { strong, myProfile in
            guard let profile = myProfile else { return }
            
            self.changePinButton.isHidden = profile.pinEnabled == false
            self.enablePinButton.isHidden = profile.pinEnabled == true
        })
        
        self.saverCardsTableView.delegate = self
        self.saverCardsTableView.dataSource = self
        self.saverCardsTableView.isScrollEnabled = false
        
        self.creditCardsTableView.delegate = self
        self.creditCardsTableView.dataSource = self
        self.creditCardsTableView.isScrollEnabled = false
        
        self.debitCardsTableView.delegate = self
        self.debitCardsTableView.dataSource = self
        self.debitCardsTableView.isScrollEnabled = false
        
        self.loyaltyCardsTableView.delegate = self
        self.loyaltyCardsTableView.dataSource = self
        self.loyaltyCardsTableView.isScrollEnabled = false
        
        self.bankAccountsTableView.delegate = self
        self.bankAccountsTableView.dataSource = self
        
        self.idCardsTableView.delegate = self
        self.idCardsTableView.dataSource = self
        self.idCardsTableView.isScrollEnabled = false
        
        self.drivingLicensesTableView.delegate = self
        self.drivingLicensesTableView.dataSource = self
        self.drivingLicensesTableView.isScrollEnabled = false
        
        self.passportsTableView.delegate = self
        self.passportsTableView.dataSource = self
        
        self.documentsTableView.delegate = self
        self.documentsTableView.dataSource = self
        
        self.saverCardsTableView.estimatedRowHeight = self.tablesRowHeight
        self.saverCardsTableView.rowHeight = UITableView.automaticDimension
        self.savedCardsViewOriginalHeight = self.savedCardsContainerHeight.constant
        
        self.creditCardsTableView.estimatedRowHeight = self.tablesRowHeight
        self.creditCardsTableView.rowHeight = UITableView.automaticDimension
        self.creditCardsViewOriginalHeight = self.creditCardContainerHeight.constant
        
        self.debitCardsTableView.estimatedRowHeight = self.tablesRowHeight
        self.debitCardsTableView.rowHeight = UITableView.automaticDimension
        self.debitCardsViewOriginalHeight = self.debitCardContainerHeight.constant
        
        self.loyaltyCardsTableView.estimatedRowHeight = self.tablesRowHeight
        self.loyaltyCardsTableView.rowHeight = UITableView.automaticDimension
        self.loyaltyCardsViewOriginalHeight = self.loyaltyCardContainerHeight.constant
        
        self.bankAccountsTableView.estimatedRowHeight = self.tablesRowHeight
        self.bankAccountsTableView.rowHeight = UITableView.automaticDimension
        self.bankViewOriginalHeight = self.bankAccountContainerHeight.constant
        
        self.idCardsTableView.estimatedRowHeight = self.tablesRowHeight
        self.idCardsTableView.rowHeight = UITableView.automaticDimension
        self.idCardsViewOriginalHeight = self.idLicenseContainerHeight.constant
        
        self.drivingLicensesTableView.estimatedRowHeight = self.tablesRowHeight
        self.drivingLicensesTableView.rowHeight = UITableView.automaticDimension
        self.drivingLicenseViewOriginalHeight = self.drivingLicenseContainerHeight.constant
        
        self.passportsTableView.estimatedRowHeight = self.tablesRowHeight
        self.passportsTableView.rowHeight = UITableView.automaticDimension
        self.passportViewOriginalHeight = self.passportContainerHeight.constant
        
        self.documentsTableView.estimatedRowHeight = self.tablesRowHeight
        self.documentsTableView.rowHeight = UITableView.automaticDimension
        self.documentsViewOriginalHeight = self.documentsContainerHeight.constant
        
        self.saverCardsTableView.registerNib(LibraryTableViewCell.self)
        self.creditCardsTableView.registerNib(LibraryTableViewCell.self)
        self.debitCardsTableView.registerNib(LibraryTableViewCell.self)
        self.loyaltyCardsTableView.registerNib(LibraryTableViewCell.self)
        self.bankAccountsTableView.registerNib(LibraryTableViewCell.self)
        self.idCardsTableView.registerNib(LibraryTableViewCell.self)
        self.drivingLicensesTableView.registerNib(LibraryTableViewCell.self)
        self.passportsTableView.registerNib(LibraryTableViewCell.self)
        self.documentsTableView.registerNib(LibraryTableViewCell.self)
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension MyLibraryViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func changePinAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(ChangePinViewController.self)
        vc.updateViewElement = self
        self.present(vc, animated: true)
    }
    
    @IBAction func enablePinAction(_ sender: UIButton) {
        self.showConfirmation(message: "you want to enable pin now") {
            let vc = self.getStoryboardView(PersonalInfoViewController.self)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func cardsAction(_ sender: UIButton) {
        self.sectionSelected = .Cards
        self.refreshViewRequest(self.sectionSelected)
    }
    
    @IBAction func bankAction(_ sender: UIButton) {
        self.sectionSelected = .Bank
        self.refreshViewRequest(self.sectionSelected)
    }
    
    @IBAction func licenseAction(_ sender: UIButton) {
        self.sectionSelected = .ID
        self.refreshViewRequest(self.sectionSelected)
    }
    
    @IBAction func passportAction(_ sender: UIButton) {
        self.sectionSelected = .Passport
        self.refreshViewRequest(self.sectionSelected)
    }
    
    @IBAction func documentsAction(_ sender: UIButton) {
        self.sectionSelected = .Documents
        self.refreshViewRequest(self.sectionSelected)
    }
    
    @IBAction func addAction(_ sender: UIButton) {
        
        switch self.sectionSelected {
        case .Empty:
            self.pushToAddCardsView()
        case .Cards:
            self.pushToAddCardsView()
        case .Bank:
            let vc = self.getStoryboardView(AddBankAccountViewController.self)
            vc.viewType = self.sectionSelected.rawValue
            self.navigationController?.pushViewController(vc, animated: true)
        case .ID:
            let vc = self.getStoryboardView(AddIDCardViewController.self)
            vc.viewType = self.sectionSelected.rawValue
            self.navigationController?.pushViewController(vc, animated: true)
        case .Passport:
            let vc = self.getStoryboardView(AddPassportViewController.self)
            vc.viewType = self.sectionSelected.rawValue
            self.navigationController?.pushViewController(vc, animated: true)
        case .Documents:
            let vc = self.getStoryboardView(AddDocumentViewController.self)
            vc.viewType = self.sectionSelected.rawValue
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - TABLE VIEW DELEGATE

extension MyLibraryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.creditCardsTableView {
            return self.filterCardsBy(.Credit, array: self.cards).count
            
        }else if tableView == self.debitCardsTableView {
            return self.filterCardsBy(.Debit, array: self.cards).count
            
        }else if tableView == self.loyaltyCardsTableView {
            return self.loyaltyCards.count
            
        }else if tableView == self.bankAccountsTableView {
            return self.banks.count
            
        }else if tableView == self.idCardsTableView {
            return self.idCards.count
            
        }else if tableView == self.drivingLicensesTableView {
            return self.drivingLicenses.count
            
        }else if tableView == self.passportsTableView {
            return self.passports.count
            
        }else if tableView == self.documentsTableView {
            return self.documents.count
            
        }else if tableView == self.saverCardsTableView {
            return self.savedCards.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(LibraryTableViewCell.self, for: indexPath)
        cell.delegate = self
        
        if tableView == self.creditCardsTableView {
            let creditCards = self.filterCardsBy(.Credit, array: self.cards)
            cell.section = .Cards
            cell.card = creditCards[indexPath.row]
            
        }else if tableView == self.debitCardsTableView {
            let debitCards = self.filterCardsBy(.Debit, array: self.cards)
            cell.section = .Cards
            cell.card = debitCards[indexPath.row]
            
        }else if tableView == self.loyaltyCardsTableView {
            cell.section = .Cards
            cell.loyaltyCard = self.loyaltyCards[indexPath.row]
            
        }else if tableView == self.bankAccountsTableView {
            cell.section = .Bank
            cell.bank = self.banks[indexPath.row]
            
        }else if tableView == self.idCardsTableView {
            cell.section = .ID
            cell.idCard = self.idCards[indexPath.row]
            
        }else if tableView == self.drivingLicensesTableView {
            cell.section = .ID
            cell.drivingLicense = self.drivingLicenses[indexPath.row]
            
        }else if tableView == self.passportsTableView {
            cell.section = .Passport
            cell.passport = self.passports[indexPath.row]
            
        }else if tableView == self.documentsTableView {
            cell.section = .Documents
            cell.document = self.documents[indexPath.row]
        } else if tableView == self.saverCardsTableView {
            cell.section = .Cards
            cell.savedCard = self.savedCards[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == self.creditCardsTableView {
            let creditCards = self.filterCardsBy(.Credit, array: self.cards)
            let card = creditCards[indexPath.row]
            
            self.cardSelected = card
            let vc = self.getStoryboardView(ConfirmPinCodeViewController.self)
            vc.updateViewElementDelegate = self
            self.present(vc, animated: true)
            
        }else if tableView == self.debitCardsTableView {
            let debitCards = self.filterCardsBy(.Debit, array: self.cards)
            let card = debitCards[indexPath.row]
            
            self.cardSelected = card
            let vc = self.getStoryboardView(ConfirmPinCodeViewController.self)
            vc.updateViewElementDelegate = self
            self.present(vc, animated: true)
            
        }else if tableView == self.loyaltyCardsTableView {
            let card = self.loyaltyCards[indexPath.row]
            
            self.loyaltyCardSelected = card
            let vc = self.getStoryboardView(ConfirmPinCodeViewController.self)
            vc.updateViewElementDelegate = self
            self.present(vc, animated: true)
            
        }else if tableView == self.bankAccountsTableView {
            let bnk = self.banks[indexPath.row]
            self.bankSelected = bnk
            let vc = self.getStoryboardView(ConfirmPinCodeViewController.self)
            vc.updateViewElementDelegate = self
            self.present(vc, animated: true)
            
        }else if tableView == self.idCardsTableView {
            let card = self.idCards[indexPath.row]
            let vc = self.getStoryboardView(IDLicenseDetailsViewController.self)
            vc.idCard = card
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if tableView == self.drivingLicensesTableView {
            let license = self.drivingLicenses[indexPath.row]
            let vc = self.getStoryboardView(IDLicenseDetailsViewController.self)
            vc.drivingLicense = license
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if tableView == self.passportsTableView {
            let passport = self.passports[indexPath.row]
            let vc = self.getStoryboardView(PassportDetailsViewController.self)
            vc.passport = passport
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if tableView == self.documentsTableView {
            let document = self.documents[indexPath.row]
            
            guard let type = document.type,
                  let typeObject = FileType(rawValue: type) else {
                return
            }
            
            switch typeObject {
            case .Images:
                let vc = self.getStoryboardView(DocumentDetailsViewController.self)
                vc.document = document
                self.navigationController?.pushViewController(vc, animated: true)
                break
                
            case .Documents:
                guard let urlString = document.location?.correctUrlString(),
                      let urlEncoding = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                    self.showErrorMessage("Something went wrong, please try again later")
                    return
                }
                
                guard let url = URL(string: urlEncoding),
                      let pdfDoc = PDFDocument(url: url) else {
                    return
                }
                
                let vc = PDFViewController.createNew(with: pdfDoc, actionStyle: .activitySheet)
                vc.backgroundColor = .white
                vc.scrollDirection = .vertical
                self.navigationController?.navigationBar.isHidden = false
                self.navigationController?.pushViewController(vc, animated: true)
                break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tablesRowHeight
    }
}

// MARK: - LIBRARY CELL DELEGATE

extension MyLibraryViewController: LibraryTableViewCellDelegate {
  
    func didTapShare(_ cell: LibraryTableViewCell, for string: String, with section: LibrarySection) {
        switch section {
        case .Empty:
            break
        case .Cards, .Bank:
            self.shareString = string
            let vc = self.getStoryboardView(ConfirmPinCodeViewController.self)
            vc.updateViewElementDelegate = self
            self.present(vc, animated: true)
            break
        case .ID:
            self.openShareDialog(sender: self.view, data: [string])
            break
        case .Passport:
            self.openShareDialog(sender: self.view, data: [string])
            break
        case .Documents:
            self.openShareDialog(sender: self.view, data: [string])
            break
        }
    }
    
    func didTapEdit(_ cell: LibraryTableViewCell, for data: Any, with section: LibrarySection) {
        
        switch section {
        case .Empty:
            break
        case .Cards:
            if let libCard = data as? LibraryCard {
                self.editActionSection = section
                self.cardSelected = libCard
                let vc = self.getStoryboardView(ConfirmPinCodeViewController.self)
                vc.updateViewElementDelegate = self
                self.present(vc, animated: true)
                
            }else if let loyaltyCard = data as? Loyalty {
                self.editActionSection = section
                self.loyaltyCardSelected = loyaltyCard
                let vc = self.getStoryboardView(ConfirmPinCodeViewController.self)
                vc.updateViewElementDelegate = self
                self.present(vc, animated: true)
            }
            break
            
        case .Bank:
            if let bnk = data as? Bank {
                self.editActionSection = section
                self.bankSelected = bnk
                let vc = self.getStoryboardView(ConfirmPinCodeViewController.self)
                vc.updateViewElementDelegate = self
                self.present(vc, animated: true)
            }
            break
            
        case .ID:
            if let card = data as? IDCard {
                let vc = self.getStoryboardView(AddIDCardViewController.self)
                vc.idCard = card
                vc.viewType = section.rawValue
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else if let license = data as? DrivingLicense {
                let vc = self.getStoryboardView(AddIDCardViewController.self)
                vc.drivingLicense = license
                vc.viewType = section.rawValue
                self.navigationController?.pushViewController(vc, animated: true)
            }
            break
            
        case .Passport:
            if let passport = data as? Passport {
                let vc = self.getStoryboardView(AddPassportViewController.self)
                vc.passport = passport
                vc.viewType = section.rawValue
                self.navigationController?.pushViewController(vc, animated: true)
            }
            break
            
        case .Documents:
            if let doc = data as? Document {
                let vc = self.getStoryboardView(AddDocumentViewController.self)
                vc.document = doc
                vc.viewType = section.rawValue
                self.navigationController?.pushViewController(vc, animated: true)
            }
            break
        }
    }
    
    func didTapDeleteSavedCard(_ cell: LibraryTableViewCell, for card: TokenizedCard) {
    
        let alert = UIAlertController.init(title: "", message: "Do you want to Delete this Card ?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive , handler: { _ in
            
            self.requestProxy.requestService()?.deleteTokenizedPaymentCard(id: card._id, { baseResponse in
                guard let resp = baseResponse else { return }
                
                if resp._success {
                    self.navigationController?.popViewController(animated: true)
                    self.showSuccessMessage(resp._message)
                    
                } else {
                    self.showErrorMessage(resp._message)
                }
            })
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true)
    }
    
    func didTapSetDefaultCard(_ cell: LibraryTableViewCell, for card: TokenizedCard) {
        self.requestProxy.requestService()?.setDefaultCardTokenized(cardId: card._id, { response in
            guard let resp = response else { return }
            
            if resp._success {
                 self.showSuccessMessage(resp._message)
                
            } else {
                self.showErrorMessage(resp._message)
            }
        })
    }
}

// MARK: - UPDATE VIEW ELEMENTS DELEGATE

extension MyLibraryViewController: UpdateViewElement {
    
    func elementUpdated(fromSourceView view: UIViewController, status: Bool, data: Any?) {
        
        guard status else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
            
            if view is ConfirmPinCodeViewController {
                if let shareStr = self.shareString {
                    self.openShareDialog(sender: self.view, data: [shareStr])
                    
                } else {
                    switch self.sectionSelected {
                    case .Empty:
                        break
                        
                    case .Cards:
                        if let card = self.cardSelected {
                            if let editSec = self.editActionSection {
                                let vc = self.getStoryboardView(AddPaymentCardViewController.self)
                                vc.libraryCard = card
                                vc.viewType = editSec.rawValue
                                self.navigationController?.pushViewController(vc, animated: true)
                                
                            }else {
                                let vc = self.getStoryboardView(CardDetailsViewController.self)
                                vc.card = card
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                            
                        }else if let loyaltyCard = self.loyaltyCardSelected {
                            if let editSec = self.editActionSection {
                                let vc = self.getStoryboardView(AddPaymentCardViewController.self)
                                vc.loyaltyCard = loyaltyCard
                                vc.viewType = editSec.rawValue
                                self.navigationController?.pushViewController(vc, animated: true)
                                
                            }else {
                                let vc = self.getStoryboardView(LoyaltyCardViewController.self)
                                vc.card = loyaltyCard
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                        break
                        
                    case .Bank:
                        if let bnk = self.bankSelected {
                            if let editSec = self.editActionSection {
                                let vc = self.getStoryboardView(AddBankAccountViewController.self)
                                vc.bank = bnk
                                vc.viewType = editSec.rawValue
                                self.navigationController?.pushViewController(vc, animated: true)
                                
                            }else {
                                let vc = self.getStoryboardView(CardDetailsViewController.self)
                                vc.bank = bnk
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                        break
                    case .ID:
                        break
                    case .Passport:
                        break
                    case .Documents:
                        break
                    }
                }
            }
        }
    }
}

// MARK: - REQUESTS DELEGATE

extension MyLibraryViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .getLibraryPaymentCards ||
            request == .bankDetails ||
            request == .getIDCardList ||
            request == .getPassportList ||
            request == .getDocumentList {
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

// MARK: - PRIVATE FUNCTIONS

extension MyLibraryViewController {
    
    private func pushToAddCardsView() {
        let vc = self.getStoryboardView(AddPaymentCardViewController.self)
        vc.viewType = LibrarySection.Cards.rawValue
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func filterCardsBy(_ paymentType: PaymentCardType, array: [LibraryCard]) -> [LibraryCard] {
        return array.filter({ $0.paymentCardType == paymentType.rawValue })
    }
    
    private func cardsListRequest() {
        
        self.dispatchGroup.enter()
        
        self.requestProxy.requestService()?.getLibraryPaymentCards(completion: { (status, cardsDetails) in
            guard status else { return }
            
            let cardsArray = cardsDetails?.cards ?? []
            
            let creditCards = self.filterCardsBy(.Credit, array: cardsArray)
            let debitCards = self.filterCardsBy(.Debit, array: cardsArray)
            
            self.creditCardsCountLabel.text = self.getItemsCountText(creditCards.count)
            self.debitCardsCountLabel.text = self.getItemsCountText(debitCards.count)
            
            self.cards = cardsArray
            
            self.dispatchGroup.leave()
        })
        
        self.dispatchGroup.notify(queue: .main) {
            self.refreshCardsTables()
        }
    }
    
    private func saverCardsListRequest() {
        
        self.dispatchGroup.enter()
        
        
        
        self.requestProxy.requestService()?.getTokenizedCardDetails({ (savedCards) in
            guard let savedCardsArray = savedCards else {return}
        
            self.savedCardsCountLabel.text = self.getItemsCountText(savedCardsArray.count)
 
            self.savedCards = savedCardsArray
            
            self.dispatchGroup.leave()
        })
        
        self.dispatchGroup.notify(queue: .main) {
            self.refreshSavedCardsTables()
        }
    }
    
    private func loyaltyCardsListRequest() {
        
        self.dispatchGroup.enter()
        
        self.requestProxy.requestService()?.getLoyaltyList { (status, loyaltyCards) in
            guard status else { return }
            
            let cardsArray = loyaltyCards ?? []
            
            self.loyaltyCardsCountLabel.text = self.getItemsCountText(cardsArray.count)
            self.loyaltyCards = cardsArray
            
            self.dispatchGroup.leave()
        }
        
        self.dispatchGroup.notify(queue: .main) {
            self.refreshLoyaltyTable()
            let isUserHasCards = self.cards.count > 0 || self.loyaltyCards.count > 0
            self.sectionSelected = isUserHasCards ? .Cards : .Empty
        }
    }
    
    private func bankDetailsRequest() {
        
        self.dispatchGroup.enter()
        
        self.requestProxy.requestService()?.bankDetails(completion: { (status, banks) in
            guard status else { return }
            let banksArray = banks ?? []
            
            self.bankAccountsCountLabel.text = self.getItemsCountText(banksArray.count)
            self.banks = banksArray
            
            self.dispatchGroup.leave()
        })
        
        self.dispatchGroup.notify(queue: .main) {
            self.refreshBankTable()
        }
    }
    
    private func idCardsListRequest() {
        
        self.dispatchGroup.enter()
        
        self.requestProxy.requestService()?.getIDCardList { (status, licenses) in
            guard status else { return }
            let idCardsArray = licenses?.idCards ?? []
            
            self.idCardsCountLabel.text = self.getItemsCountText(idCardsArray.count)
            self.idCards = idCardsArray
            
            self.dispatchGroup.leave()
        }
        
        self.dispatchGroup.notify(queue: .main) {
            self.refreshIdentificationTable()
        }
    }
    
    private func drivingLicenseListRequest() {
        
        self.dispatchGroup.enter()
        
        self.requestProxy.requestService()?.getDrivingLicenseList { (status, licenses) in
            guard status else { return }
            let licensesArray = licenses?.drivingLicenses ?? []
            
            self.drivingLicensesCountLabel.text = self.getItemsCountText(licensesArray.count)
            self.drivingLicenses = licensesArray
            
            self.dispatchGroup.leave()
        }
        
        self.dispatchGroup.notify(queue: .main) {
            self.refreshLicenseTable()
        }
    }
    
    private func passportListRequest() {
        
        self.dispatchGroup.enter()
        
        self.requestProxy.requestService()?.getPassportList { (status, passportList) in
            guard status else { return }
            let passportsArray = passportList ?? []
            
            self.passportCountLabel.text = self.getItemsCountText(passportsArray.count)
            self.passports = passportsArray
            
            self.dispatchGroup.leave()
        }
        
        self.dispatchGroup.notify(queue: .main) {
            self.refreshPassportTable()
        }
    }
    
    private func documentListRequest() {
        
        self.dispatchGroup.enter()
        
        self.requestProxy.requestService()?.getDocumentList { (status, documentList) in
            guard status else { return }
            let documentsArray = documentList ?? []
            
            self.documentsCountLabel.text = self.getItemsCountText(documentsArray.count)
            self.documents = documentsArray
            
            self.dispatchGroup.leave()
        }
        
        self.dispatchGroup.notify(queue: .main) {
            self.refreshDocumentTable()
        }
    }
    
    private func setViewHeightByTableContent(_ tableView: UITableView, constraint: NSLayoutConstraint) {
        
        guard let tableCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) else { return }
        
        let tableHeight = tableView.contentSize.height + tableCell.frame.height
        let extraSpace: CGFloat = 30.0
        
        if tableView == self.creditCardsTableView {
            constraint.constant = tableHeight < self.creditCardsViewOriginalHeight ? self.creditCardsViewOriginalHeight : tableHeight + extraSpace
            
        }else if tableView == self.debitCardsTableView {
            constraint.constant = tableHeight < self.debitCardsViewOriginalHeight ? self.debitCardsViewOriginalHeight : tableHeight + extraSpace
            
        }else if tableView == self.loyaltyCardsTableView {
            constraint.constant = tableHeight < self.loyaltyCardsViewOriginalHeight ? self.loyaltyCardsViewOriginalHeight : tableHeight + extraSpace
            
        }else if tableView == self.bankAccountsTableView {
            constraint.constant = tableHeight < self.bankViewOriginalHeight ? self.bankViewOriginalHeight : tableHeight
            
        }else if tableView == self.idCardsTableView {
            constraint.constant = tableHeight < self.idCardsViewOriginalHeight ? self.idCardsViewOriginalHeight : tableHeight + extraSpace
        }else if tableView == self.drivingLicensesTableView {
            constraint.constant = tableHeight < self.drivingLicenseViewOriginalHeight ? self.drivingLicenseViewOriginalHeight : tableHeight
            
        }else if tableView == self.passportsTableView {
            constraint.constant = tableHeight < self.passportViewOriginalHeight ? self.passportViewOriginalHeight : tableHeight
            
        }else if tableView == self.documentsTableView {
            constraint.constant = tableHeight < self.documentsViewOriginalHeight ? self.documentsViewOriginalHeight : tableHeight
            
        } else if tableView == self.saverCardsTableView {
            constraint.constant = tableHeight < self.savedCardsViewOriginalHeight ? self.savedCardsViewOriginalHeight : tableHeight + extraSpace
        }
    }
    
    private func setViewTabButton(_ section: LibrarySection) {
        
        self.tabWidth.constant = section == .Empty ? 53 : 74
        
        self.emptyLibraryStackView.isHidden = section != .Empty
        self.cardsScrollView.isHidden = section != .Cards
        self.bankAccountStackView.isHidden = section != .Bank
        self.idLicenseScrollView.isHidden = section != .ID
        self.passportStackView.isHidden = section != .Passport
        self.documentsStackView.isHidden = section != .Documents
        
        switch section {
        case .Empty:
            self.tabImageView.image = Images.ic_empty_tab_my_library.image
            break
        case .Cards:
            self.tabImageView.image = Images.ic_cards_tab_my_library.image
            break
        case .Bank:
            self.tabImageView.image = Images.ic_bank_tab_my_library.image
            break
        case .ID:
            self.tabImageView.image = Images.ic_id_license_tab_my_library.image
            break
        case .Passport:
            self.tabImageView.image = Images.ic_passport_tab_my_library.image
            break
        case .Documents:
            self.tabImageView.image = Images.ic_documents_tab_my_library.image
            break
        }
    }
    
    private func refreshViewRequest(_ section: LibrarySection) {
        
        switch section {
        case .Empty:
            break
        case .Cards:
            /// Saved cards
            self.saverCardsListRequest()
            self.cardsListRequest()
            self.loyaltyCardsListRequest()
            break
        case .Bank:
            self.bankDetailsRequest()
            break
        case .ID:
            self.idCardsListRequest()
            self.drivingLicenseListRequest()
            break
        case .Passport:
            self.passportListRequest()
            break
        case .Documents:
            self.documentListRequest()
            break
        }
    }
    
    private func refreshCardsTables() {
        self.creditCardsTableView.reloadData()
        self.setViewHeightByTableContent(self.creditCardsTableView, constraint: self.creditCardContainerHeight)
        self.debitCardsTableView.reloadData()
        self.setViewHeightByTableContent(self.debitCardsTableView, constraint: self.debitCardContainerHeight)
    }
    
    private func refreshSavedCardsTables() {
        self.saverCardsTableView.reloadData()
        self.setViewHeightByTableContent(self.saverCardsTableView, constraint: self.savedCardsContainerHeight)
    }
    
    private func refreshLoyaltyTable() {
        self.loyaltyCardsTableView.reloadData()
        self.setViewHeightByTableContent(self.loyaltyCardsTableView, constraint: self.loyaltyCardContainerHeight)
    }
    
    private func refreshBankTable() {
        self.bankAccountsTableView.reloadData()
        self.setViewHeightByTableContent(self.bankAccountsTableView, constraint: self.bankAccountContainerHeight)
    }
    
    private func refreshIdentificationTable() {
        self.idCardsTableView.reloadData()
        self.setViewHeightByTableContent(self.idCardsTableView, constraint: self.idLicenseContainerHeight)
    }
    
    private func refreshLicenseTable() {
        self.drivingLicensesTableView.reloadData()
        self.setViewHeightByTableContent(self.drivingLicensesTableView, constraint: self.drivingLicenseContainerHeight)
    }
    
    private func refreshPassportTable() {
        self.passportsTableView.reloadData()
        self.setViewHeightByTableContent(self.passportsTableView, constraint: self.passportContainerHeight)
    }
    
    private func refreshDocumentTable() {
        self.documentsTableView.reloadData()
        self.setViewHeightByTableContent(self.documentsTableView, constraint: self.documentsContainerHeight)
    }
    
    private func getItemsCountText(_ count: Int) -> String {
        return "(\(count) items inside)"
    }
}


struct CardDemo {
    var numberCards : String?
    var typeCards   : String?
}
