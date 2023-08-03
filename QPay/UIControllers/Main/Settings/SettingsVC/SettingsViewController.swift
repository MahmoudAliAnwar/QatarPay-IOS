//
//  SettingsViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/5/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

enum SettingsItems: String, CaseIterable {
    
    case personalInfo = "Personal Information"
    case address = "Address"
    case loginAndSecurity = "Login & Security"
    case inviteFriends = "Invite Friends"
    case contactUs = "Contact Us"
    case logout = "Logout"
    
    var icon: UIImage {
        get {
            switch self {
            case .personalInfo: return .ic_person_settings
            case .address: return .ic_address_settings
            case .loginAndSecurity: return .ic_lock_settings
            case .inviteFriends: return .ic_invite_settings
            case .contactUs: return .ic_contact_us_settings
            case .logout: return .ic_logout_settings
            }
        }
    }
}

struct SettingsModel {
    let image: UIImage
    let title: String
    let completion: voidCompletion
}

class SettingsViewController: MainController {
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var accountStatusLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var qrCodeImageView: UIImageView!
    
    @IBOutlet weak var settingsTableView: UITableView!
    
    private var items = [SettingsModel]()
    
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
        
        self.requestProxy.requestService()?.getQRCode ( weakify { strong, qrCodeString in
            guard let string = qrCodeString else { return }
            let image = string.convertBase64StringToImage()
            self.qrCodeImageView.image = image
        })
        
        self.requestProxy.requestService()?.getUserProfile ( weakify { strong, myProfile in
            guard let profile = myProfile else { return }
            
            self.emailLabel.text = profile._email
            self.nameLabel.text = "\(profile._fullName) \(profile._lastName)"
            
            if let status = profile._userStatusObject {
                var color: UIColor
                
                switch status {
                case .new: color = .systemOrange
                case .active: color = .systemGreen
                case .porhibited: color = .systemRed
                }
                
                let baseAttributedString = NSAttributedString(string: "Account Status : ", attributes: [
                    .foregroundColor : UIColor.white
                ])
                let attributedString = NSMutableAttributedString(attributedString: baseAttributedString)
                
                attributedString.append(NSAttributedString(string: profile._userStatus, attributes: [
                    .foregroundColor : color
                ]))
                
                self.accountStatusLabel.attributedText = attributedString
            }
            
            guard let imgUrl = profile.imageURL else { return }
            imgUrl.getImageFromURLString { (status, image) in
                guard status == true,
                      let img = image else {
                    return
                }
                self.userImageView.image = img
            }
        })
    }
}

extension SettingsViewController {
    
    func setupView() {
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
        self.items = SettingsItems.allCases.compactMap({ model in
            return SettingsModel(image: model.icon,
                                 title: model.rawValue) {
                switch model {
                case .personalInfo:
                    let vc = self.getStoryboardView(PersonalInfoViewController.self)
                    self.navigationController?.pushViewController(vc, animated: true)
                    break
                case .address:
                    let vc = self.getStoryboardView(AddressesViewController.self)
                    self.navigationController?.pushViewController(vc, animated: true)
                    break
                case .loginAndSecurity:
                    let vc = self.getStoryboardView(LoginAndSecurityViewController.self)
                    self.navigationController?.pushViewController(vc, animated: true)
                    break
                case .inviteFriends:
                    let url = "https://apps.apple.com/us/app/qatar-pay-pro/id1556624460"
                    self.openShareDialog(sender: self.view, data: [url])
                    break
                case .contactUs:
                    let vc = self.getStoryboardView(ContactsUsViewController.self)
                    self.navigationController?.pushViewController(vc, animated: true)
                    break
                case .logout:
                    self.userProfile.logout()
                    let vc = self.getStoryboardView(MySplashViewController.self)
                    self.navigationController?.setViewControllers([vc], animated: true)
                    break
                }
            }
        })
    }
}

// MARK: - ACTIONS

extension SettingsViewController {
    
    @IBAction func profileAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(PersonalInfoViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func QRCodeAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(NoqoodyCodeViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - REQUESTS DELEGATE

extension SettingsViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
//        showLoadingView(self)
    }
    
    func requestFinished(request: RequestType, result: ResponseResult) {
//        hideLoadingView()
        
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

// MARK: - TABLE VIEW DELEGATE

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(SettingsTableViewCell.self, for: indexPath)
        
        let item = items[indexPath.row]
        cell.setupData(item: item)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        item.completion()
    }
}
