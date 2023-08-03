//
//  LibraryTableViewCell.swift
//  QPay
//
//  Created by Dev. Mohmd on 10/26/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit
import Combine
import Kingfisher

protocol LibraryTableViewCellDelegate: AnyObject {
    func didTapShare           (_ cell: LibraryTableViewCell, for string: String, with section: LibrarySection)
    func didTapEdit            (_ cell: LibraryTableViewCell, for data: Any, with section: LibrarySection)
    func didTapDeleteSavedCard (_ cell : LibraryTableViewCell ,for card: TokenizedCard )
    func didTapSetDefaultCard  (_ cell : LibraryTableViewCell ,for card: TokenizedCard )
}

class LibraryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerViewDesign: ViewDesign!
    @IBOutlet weak var libraryImageView: UIImageView!
    @IBOutlet weak var libraryNameLabel: UILabel!
    @IBOutlet weak var libraryDescriptionLabel: UILabel!
    
    @IBOutlet weak var libraryReminderImageView: UIImageView!
    
    @IBOutlet weak var savedCardsStackView : UIStackView!
    @IBOutlet weak var otherStackView      : UIStackView!
    @IBOutlet weak var defaultImageView    : UIImageView!
    
    
    
    private var creditCardFontSize: CGFloat = 12
    private var sfFontSize: CGFloat = 14
    
    var section: LibrarySection?
    
    weak var delegate: LibraryTableViewCellDelegate?
    
    // MARK: - LIBRARY CARD
    
    var card: LibraryCard? {
        didSet {
            self.libraryDescriptionLabel.font = .creditCard(self.creditCardFontSize)
            
            self.libraryNameLabel.text = card?.name ?? ""
            if let number = card?.number {
                self.libraryDescriptionLabel.text = self.cardNumberEncrypt(number)
            }
            
            if let cardType = card?._cardType,
               let type = CardType(rawValue: cardType) {
                switch type {
                case .Visa:
                    self.libraryImageView.image = .ic_visa_logo_card
                    break
                case .Master:
                    self.libraryImageView.image = .ic_mastercard_my_library
                    break
                case .Diners:
                    self.libraryImageView.image = .ic_diners_club_my_library
                    break
                case .Maestro:
                    self.libraryImageView.image = .ic_maestro_my_library
                    break
                case .American, .JCB:
                    self.libraryImageView.image = .none
                    break
                }
            }
            
            if let expiryReminder = card?.reminderType,
               let expiryDateString = card?.expiryDate,
               let reminder = ExpiryReminder.getObjectByNumber(expiryReminder),
               let expiryDate = expiryDateString.formatToDate("MM/yy") {
                
                self.checkExpiryDate(expiryDate, reminder: reminder)
            }
        }
    }
    
    // MARK: - LOYALTY CARD
    
    var loyaltyCard: Loyalty? {
        didSet {
            self.libraryDescriptionLabel.font = .creditCard(self.creditCardFontSize)
            
            self.libraryNameLabel.text = loyaltyCard?.name ?? ""
            if let number = loyaltyCard?.number {
                self.libraryDescriptionLabel.text = self.cardNumberEncrypt(number)
            }
            
            if let expiryReminder = loyaltyCard?.reminderType,
               let expiryDateString = loyaltyCard?.expiryDate,
               let reminder = ExpiryReminder.getObjectByNumber(expiryReminder),
               let expiryDate = expiryDateString.server2StringToDate() {
                
                self.checkExpiryDate(expiryDate, reminder: reminder)
            }
            
            if let frontImage = loyaltyCard?.frontSideImageLocation {
                self.setImage(with: frontImage)
            }
        }
    }
    
    // MARK: - BANK
    
    var bank: Bank? {
        didSet {
            self.libraryDescriptionLabel.font = .creditCard(self.creditCardFontSize)
            
            self.libraryNameLabel.text = bank?.name ?? ""
            if let number = bank?.accountNumber {
                self.libraryDescriptionLabel.text = self.cardNumberEncrypt(number)
            }
            
            if let imageLoc = bank?.imageLocation {
                self.setImage(with: imageLoc)
            }
            self.libraryReminderImageView.image = .none
        }
    }
    
    // MARK: - PASSPORT
    
    var passport: Passport? {
        didSet {
            self.libraryDescriptionLabel.font = .modeNine(self.sfFontSize)
            
            self.libraryNameLabel.text = passport?.surName ?? ""
            if let number = passport?.number {
                self.libraryDescriptionLabel.text = number
            }
            
            if let expiryReminder = passport?.reminderType,
               let expiryDateString = passport?.dateOfExpiry,
               let reminder = ExpiryReminder.getObjectByNumber(expiryReminder),
               let expiryDate = expiryDateString.server2StringToDate() {
                
                self.checkExpiryDate(expiryDate, reminder: reminder)
            }
            
            if let imageLoc = passport?.imageLocation {
                self.setImage(with: imageLoc)
            }
        }
    }
    
    // MARK: - ID CARD
    
    var idCard: IDCard? {
        didSet {
            self.libraryDescriptionLabel.font = .creditCard(self.creditCardFontSize)
            
            self.libraryNameLabel.text = idCard?.name ?? ""
            if let number = idCard?.number {
                self.libraryDescriptionLabel.text = self.idNumberEncrypt(number)
            }
            
            if let expiryReminder = idCard?.reminderType,
               let expiryDateString = idCard?.dateofExpiry,
               let reminder = ExpiryReminder.getObjectByNumber(expiryReminder),
               let expiryDate = expiryDateString.server2StringToDate() {
                
                self.checkExpiryDate(expiryDate, reminder: reminder)
            }
            
            if let frontImage = idCard?.frontSideImageLocation {
                self.setImage(with: frontImage)
            }
        }
    }
    
    // MARK: - DRIVING LICENSE CARD
    
    var drivingLicense: DrivingLicense? {
        didSet {
            self.libraryDescriptionLabel.font = .creditCard(self.creditCardFontSize)
            
            self.libraryNameLabel.text = drivingLicense?.name ?? ""
            if let number = drivingLicense?.number {
                self.libraryDescriptionLabel.text = self.idNumberEncrypt(number)
            }
            
            if let expiryReminder = drivingLicense?.reminderType,
               let expiryDateString = drivingLicense?.validity,
               let reminder = ExpiryReminder.getObjectByNumber(expiryReminder),
               let expiryDate = expiryDateString.server2StringToDate() {
                
                self.checkExpiryDate(expiryDate, reminder: reminder)
            }
            
            if let frontImage = drivingLicense?.frontSideImageLocation {
                self.setImage(with: frontImage)
            }
        }
    }
    
    // MARK: - DOCUMENT
    
    var document: Document? {
        didSet {
            self.libraryDescriptionLabel.font = .sfDisplay(self.sfFontSize)
            
            self.libraryNameLabel.text = document?.name ?? ""
            self.libraryDescriptionLabel.text = document?.type ?? ""
            
            if let location = document?.location {
                self.setImage(with: location)
            }
            self.libraryReminderImageView.image = .none
        }
    }
    
    // MARK: - SAVEDCARDS
    
    var savedCard: TokenizedCard? {
        didSet {
            self.libraryDescriptionLabel.font = .creditCard(self.creditCardFontSize)
            self.libraryNameLabel.text = savedCard?._cardType
            if let number = savedCard?._cardNumber {
                self.libraryDescriptionLabel.text = self.cardNumberEncrypt(number)
            }
            self.otherStackView.isHidden      = true
            self.savedCardsStackView.isHidden = false
            
            self.libraryImageView.image = UIImage.credit_inactive
            
            guard let bool = savedCard?._isDefault else { return }
            self.defaultImageView.isHidden  = !bool
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.containerViewDesign.setViewCorners([.topLeft, .bottomLeft])
        self.libraryDescriptionLabel.adjustsFontSizeToFitWidth = true
        self.libraryDescriptionLabel.minimumScaleFactor = 0.7
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.libraryImageView.image = .none
    }
    
    // MARK: - ACTIONS
    
    @IBAction func shareAction(_ sender: UIButton) {
        /*
         Name on card : #######
         Card Number : ##########
         CVV: ####
         */
        
        guard let section = self.section else { return }
        
        var shareString: String = ""
        
        switch section {
        case .Empty:
            break
        case .Cards:
            if let cd = self.card {
                shareString = """
                        Name on card : \(cd.name ?? "")\n
                        Card Number : \(cd.number ?? "")\n
                        CVV : \(cd.cvv ?? "")
                        """
                
            } else if let loyalty = self.loyaltyCard {
                shareString = """
                        Name on card : \(loyalty.cardName ?? "")\n
                        Loyalty Number : \(loyalty.number ?? "")\n
                        """
                if let dateString = loyalty.expiryDate,
                   let date = dateString.server2StringToDate() {
                    shareString += "Expiry Date : \(date.formatDate(libraryFieldsDateFormat))"
                }
            }
            break
            
        case .Bank:
            if let bnk = self.bank  {
                shareString = """
                        Bank Name : \(bnk.name ?? "")\n
                        Account Name : \(bnk.accountName ?? "")\n
                        Account Number : \(bnk.accountNumber ?? "")\n
                        Swift Code : \(bnk.swiftCode ?? "")\n
                        IBAN : \(bnk.iban ?? "")
                        """
            }
            break
            
        case .ID:
            if let card = self.idCard {
                shareString = """
                        Card Name : \(card.name ?? "")\n
                        Card Number : \(card.number ?? "")\n
                        Nationality : \(card.nationality ?? "")\n
                        """
                if let dateString = card.dateofExpiry,
                   let date = dateString.server2StringToDate() {
                    shareString += "Expiry Date : \(date.formatDate(libraryFieldsDateFormat))"
                }
                
            } else if let license = self.drivingLicense {
                shareString = """
                        License Name : \(license.name ?? "")\n
                        License Number : \(license.number ?? "")\n
                        Nationality : \(license.nationality ?? "")\n
                        """
                if let dateString = license.validity,
                   let date = dateString.server2StringToDate() {
                    shareString += "Expiry Date : \(date.formatDate(libraryFieldsDateFormat))"
                }
            }
            break
            
        case .Passport:
            if let pass = self.passport {
                shareString = """
                        Sur Name : \(pass.surName ?? "")\n
                        Passport Number : \(pass.number ?? "")\n
                        Place Of Issue : \(pass.placeOfIssue ?? "")\n
                        """
                if let dateString = pass.dateOfExpiry,
                   let date = dateString.server2StringToDate() {
                    shareString += "Expiry Date : \(date.formatDate(libraryFieldsDateFormat))"
                }
            }
            break
            
        case .Documents:
            if let doc = self.document {
                shareString = """
                        Document Name : \(doc.name ?? "")\n
                        Document URL : \(doc.location ?? "")
                        """
            }
            break
        }
        
        guard shareString.isNotEmpty else { return }
        self.delegate?.didTapShare(self, for: shareString, with: section)
    }
    
    @IBAction func deleteSavedCardAction(_ sender: UIButton) {
        if let saveCard = self.savedCard {
            self.delegate?.didTapDeleteSavedCard(self, for: saveCard)
        }
    }
    
    @IBAction func defaultSavedCardAction(_ sender: UIButton) {
        if let saveCard = self.savedCard {
            self.delegate?.didTapSetDefaultCard(self, for: saveCard)
        }
    }
    
    @IBAction func editAction(_ sender: UIButton) {
        
        guard let section = self.section else { return }
        
        switch section {
        case .Empty:
            break
        case .Cards:
            if let libCard = self.card {
                self.delegate?.didTapEdit(self, for: libCard, with: section)
                
            }else if let loyaltyCard = self.loyaltyCard {
                self.delegate?.didTapEdit(self, for: loyaltyCard, with: section)
            }
            break
            
        case .Bank:
            guard let bnk = self.bank else { return }
            self.delegate?.didTapEdit(self, for: bnk, with: section)
            break
            
        case .ID:
            if let card = self.idCard {
                self.delegate?.didTapEdit(self, for: card, with: section)
                
            }else if let license = self.drivingLicense {
                self.delegate?.didTapEdit(self, for: license, with: section)
            }
            break
            
        case .Passport:
            guard let passport = self.passport else { return }
            self.delegate?.didTapEdit(self, for: passport, with: section)
            break
            
        case .Documents:
            guard let doc = self.document else { return }
            self.delegate?.didTapEdit(self, for: doc, with: section)
            break
        }
    }
    
    // MARK: - CHECK EXPIRY DATE
    
    private func checkExpiryDate(_ expiryDate: Date, reminder: ExpiryReminder) {
        
        switch reminder {
        case .Before1Month:
            let correctExpireDate = expiryDate.toLocalTime()
            let todayDate = Date().toLocalTime()
            let differenceSeconds = correctExpireDate.timeIntervalSince1970 - todayDate.timeIntervalSince1970
            let differenceDays: TimeInterval = (differenceSeconds / .day)
            self.setExpiredDate(differenceDays <= 30)
            break
            
        case .Before15Days:
            let correctExpireDate = expiryDate.toLocalTime()
            let todayDate = Date().toLocalTime()
            let differenceSeconds = correctExpireDate.timeIntervalSince1970 - todayDate.timeIntervalSince1970
            let differenceDays: TimeInterval = (differenceSeconds / .day)
            self.setExpiredDate(differenceDays <= 15)
            break
            
        case .Before1Week:
            let correctExpireDate = expiryDate.toLocalTime()
            let todayDate = Date().toLocalTime()
            let differenceSeconds = correctExpireDate.timeIntervalSinceNow -  todayDate.timeIntervalSinceNow
            let differenceDays: TimeInterval = (differenceSeconds / .day)
            self.setExpiredDate(differenceDays <= 7)
            break
        }
    }
    
    private func setImage(with urlString: String) {
        guard let url = URL(string: urlString.correctUrlString()) else { return }
        self.libraryImageView.kf.setImage(with: url)
//            let scale = UIScreen.main.scale // Will be 2.0 on 6/7/8 and 3.0 on 6+/7+/8+ or later
//            let thumbnailSize = CGSize(width: 200 * scale, height: 200 * scale) // Thumbnail will bounds to (200,200) points
//            self.libraryImageView.sd_setImage(with: url, placeholderImage: nil, context: [.imageThumbnailPixelSize :                                                                                             thumbnailSize])
//            self.libraryImageView.sd_setImage(with: url, placeholderImage: nil, options: .fromCacheOnly, context: nil)
    }
    
    private func setExpiredDate(_ status: Bool) {
        self.libraryReminderImageView.image = status ? #imageLiteral(resourceName: "ic_red_clock_my_library") : #imageLiteral(resourceName: "ic_black_clock_my_library")
    }
    
    private func cardNumberEncrypt(_ number: String) -> String {
        let last = number.suffix(4)
        return "**** **** **** \(last)"
    }
    
    private func passportNumberEncrypt(_ number: String) -> String {
        let last = number.suffix(2)
        return "****** \(last)"
    }
    
    private func idNumberEncrypt(_ number: String) -> String {
        let last = number.suffix(4)
        return "**** **** \(last)"
    }
}
