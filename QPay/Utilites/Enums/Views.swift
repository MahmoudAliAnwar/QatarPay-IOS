//
//  Views.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/3/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit

enum Views: String, CaseIterable {
    
    /// My Splash
    case MySplashViewController
    
    /// Loading View
    case LoadingViewController
    
    /// Web View
    case WebViewController
    
    /// Success Message View
    case SuccessMessageViewController
    /// Error Message View
    case ErrorMessageViewController
    
    // Auth Views
    case SignInViewController
    case SignUpViewController
    case TouchIDViewController
    case CreateAccountViewController
    case SignatureViewController
    case QIDViewController
    case ForgotPasswordViewController
    case ConfirmForgetPasswordViewController
    
    /// Home Views
    case HomeViewController
    case SettingsViewController
    case PersonalInfoViewController
    case ResetPinViewController
    case RefillWalletViewController
    case TransactionsViewController
    case NotificationsViewController
    case RemovePaymentRequestViewController
    case LoginAndSecurityViewController
    case MyCardsAndBanksViewController
    case PayViewController
    case RequestMoneyViewController
    case MoneyTransferViewController
    case BeneficiariesViewController
    case AddBeneficiaryViewController
    case BeneficiaryInformationViewController
    case BeneficiaryComingSoonViewController
    case AddCardOrBankViewController
    case NoqoodyCodeViewController
    case TransferViewController
    case SelectBeneficiaryPopupViewController
    case MyCardsViewController
    case CardDetailsViewController
    case CheckoutViewController
    case UploadPassportViewController
    case UploadQIDViewController
    case UpdateEmailViewController
    case UpdateMobileViewController
    case UpdatePhotoViewController
    case PassportViewController
    case ViewQIDViewController
    case UpdateAddressViewController
    case TopUpAccountSettingsViewController
    case CreditCardAccountViewController
    case DebitCardAccountViewController
    case OoredooAccountViewController
    case VodafoneAccountViewController
    case EditBalanceViewController
    case EditSavedTopupViewController
    case SelectTopupAccountViewController
    case PaymentAccountViewController
    case NotificationsSettingsViewController
    
    /// My Library
    case PayViaCashViewController
    case AddBankAccountViewController
    case AddDocumentViewController
    case AddPinViewController
    case ChangePinViewController
    case AddPaymentCardViewController
    case AddIDCardViewController
    case PassportDetailsViewController
    case DocumentsViewController
    case DocumentDetailsViewController
    case IDLicenseDetailsViewController
    case LoyaltyCardViewController
    case ConfirmLibraryPinViewController
    case MyLibraryViewController
    case AddPassportViewController
    
    case CardRecognizerViewController
    case QRScannerViewController
    case PassportScannerViewController
    case ContactsUsViewController
    case CountriesViewController
    case SelectDataViewController
    case ConfirmPaymentRequestViewController
    case ConfirmPhoneNumberViewController
    case ConfirmPinCodeViewController
    case ConfirmQRCodePayViewController
    case ConfirmTransferViewController
    case AboutAppViewController
    case PrivacyPolicyViewController
    
    /// E-STORE
    case CreateShopViewController
    case UploadShopLogoViewController
    case UploadShopBannerViewController
    case MyShopsViewController
    case ShopProfileViewController
    case MyProductsViewController
    case PublicProductsViewController
    case AddProductViewController
    case InvoicesViewController
    case InvoicesFilterViewController
    case CreateInvoiceViewController
    case CreateInvoice2ViewController
    case SendOrderViewController
    case PreviewOrderViewController
    case MyOrdersViewController
    case OrderDetailsViewController
    
    case RefillKarwaBusCardViewController
    case KarwaBusViewController
    case AddKarwaBusCardViewController
    case KarwaBusCardDetailsViewController
    
    case KahramaaBillsViewController
    case AddKahramaaNumberViewController
    case CreateKahramaaGroupViewController
    case PayOnTheGoKahramaaViewController
    
    case RefillMetroCardViewController
    case MetroRailViewController
    case AddTravelCardViewController
    case FaresAndTravelCardsViewController
    case AddMetroRailCardViewController
    
    case QatarCoolViewController
    case CreateQatarCoolGroupViewController
    case AddQatarCoolCardViewController
    case PayOnTheGoQatarCoolViewController
    
    case AddPhoneBillsCardViewController
    case PhoneBillsViewController
    case CreatePhoneBillsGroupViewController
    case PayOnTheGoPhoneBillsViewController
    case QMobileViewController
    case PhoneOoredooViewController
    case PhoneVodafoneViewController
    
    case EStoreTopupViewController
    case InternationalTopupViewController
    case SelectTopupAmountViewController
    
    case GiftStoresViewController
    case GiftDenominationsViewController
    case GiftCardPurchaseViewController
    
    case LimousineViewController
    
    case ParkingsViewController
    case ParkingsLocationViewController
    case ParkingsPaymentViewController
    case PayYourParkingViewController
    
    case StocksViewController
    case StocksDetailsViewController
    
    case AwqafViewController
    case AwqafCartViewController
    
    case EidCharityViewController
    case EidCartViewController

    case QatarCharityViewController
    case QatarCharityCartViewController
    
    case QatarRedViewController
    case QatarRedCartViewController
    case QatarRedTabsViewController
    
    case KarwaTaxiMapViewController
    case PickUpLocationViewController
    case RequestCarViewController
    case KarwaTaxiSearchPlacesViewController
    case PayTripViewController
    case DropOffLocationViewController
    
    case MyBookTabBarController
    case MyBookViewController
    case MyBookNotificationsViewController
    case MyBookProfileViewController
    case MyBookOutletsViewController
    case MyBookFavouritesViewController
    case MyBookStoresViewController
    case MyBookStoreViewController
    
    public var storyboardView: UIViewController {
        return UIStoryboard.view(view: self)
    }
}
