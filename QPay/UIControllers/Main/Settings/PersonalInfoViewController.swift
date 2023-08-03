//
//  PersonalInfoViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/5/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class PersonalInfoViewController: MainController {

    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var optionsTableView: UITableView!
    
    var models = [Model]()
    
    struct Model {
        let option: Option
        var value: String
        var description: String?
        var action: voidCompletion
    }
    
    enum Option: Equatable {
        case Email(Bool)
        case Mobile(Bool)
        case Pin
        case QID(Bool)
        case Passport(Bool)
        case Gender
        case Nationality
        
        var title: String {
            get {
                switch self {
                case .Email(_): return "Email Address"
                case .Mobile(_): return "Mobile Number"
                case .Pin: return "Pin Number"
                case .QID(_): return "QID"
                case .Passport(_): return "Passport"
                case .Gender: return "Gender"
                case .Nationality: return "Nationality"
                }
            }
        }
    }
    
    private var updateClosure: UpdateClosure?
    
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
        
        self.dispatchGroup.enter()
        
        self.requestProxy.requestService()?.getUserProfile ( weakify { strong, myProfile in
            guard let prof = myProfile else { return }
            
            strong.models.removeAll()
            
            strong.models.append(Model(option: .Email(prof._emailVerified), value: prof._email, action: { [weak self] in
                guard let self = self else { return }
                
                guard !prof._emailVerified else {
                    self.showErrorMessage("Can't update your email, because it is verified")
                    return
                }
                let vc = self.getStoryboardView(EmailVerificationViewController.self)
                vc.updateViewElementDelegate = self
                self.present(vc, animated: true)
            }))
            
            strong.models.append(Model(option: .Mobile(prof._phoneNumberConfirmed), value: prof._mobile, action: { [weak self] in
                guard let self = self else { return }
                
                guard !prof._phoneNumberConfirmed else {
                    let vc = self.getStoryboardView(UpdateMobileViewController.self)
                    vc.updateViewElementDelegate = self
                    self.present(vc, animated: true)
                    return
                }
                
                guard let mobile = prof.mobile else { return }
                
                guard mobile == "00" else {
                    self.showConfirmation(message: "Do you want to verify mobile ?") {
                        self.generatePhoneTokenRequest(mobile: mobile)
                    }
                    return
                }
                
                self.showQIDMobileView()
            }))
            
            strong.models.append(Model(option: .Pin, value: "****", action: { [weak self] in
                guard let self = self else { return }
                
                guard !prof._pinEnabled else {
                    let vc = self.getStoryboardView(ResetPinViewController.self)
                    vc.updateViewElement = self
                    self.present(vc, animated: true)
                    return
                }
                
                if prof.phoneNumberConfirmed == true {
                    let vc = self.getStoryboardView(ResetPinViewController.self)
                    vc.updateViewElement = self
                    vc.isNewUser = true
                    self.present(vc, animated: true)
                    
                }else {
                    guard let mobile = prof.mobile else { return }
                    
                    guard mobile == "00" else {
                        self.showConfirmation(message: "Please Verify Mobile Number First, Do you want Verify Mobile Number ?") {
                            self.generatePhoneTokenRequest(mobile: mobile)
                        }
                        return
                    }
                    self.showQIDMobileView()
                }
            }))
            
            strong.models.append(Model(option: .QID(prof._qidVerified), value: prof._qidNumber, action: { [weak self] in
                guard let self = self else { return }
                
                let vc = self.getStoryboardView(UploadQIDViewController.self)
                self.navigationController?.pushViewController(vc, animated: true)
            }))
            
            strong.models.append(Model(option: .Passport(prof._passportVerified), value: prof._passportNumber, action: { [weak self] in
                guard let self = self else { return }
                
                let vc = self.getStoryboardView(PassportViewController.self)
                self.navigationController?.pushViewController(vc, animated: true)
            }))
            
            strong.models.append(Model(option: .Gender, value: prof._genderString, action: { [weak self] in
                guard let self = self else { return }
                
                let vc = self.getStoryboardView(UpdateGenderViewController.self)
                vc.updateViewElement = self
                self.present(vc, animated: true)
            }))
            
            strong.models.append(Model(option: .Nationality, value: prof._nationality, action: {
//                guard let self = self else { return }
            }))
            
            guard let imgUrl = prof.imageURL else { return }
            
            imgUrl.getImageFromURLString { (status, image) in
                guard status else { return }
                strong.userImageView.image = image
            }
            
            strong.dispatchGroup.leave()
        })
        
        self.dispatchGroup.notify(queue: .main) {
            self.optionsTableView.reloadData()
        }
    }
}

extension PersonalInfoViewController {
    
    func setupView() {
        self.optionsTableView.delegate = self
        self.optionsTableView.dataSource = self
        self.optionsTableView.tableFooterView = UIView()
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension PersonalInfoViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func topupAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(TopUpAccountSettingsViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func changePhotoAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(UpdatePhotoViewController.self)
        vc.updateViewElementDelegate = self
        self.present(vc, animated: true)
    }
}

// MARK: - TABLE VIEW DELEGATE

extension PersonalInfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(PersonalInfoTableViewCell.self, for: indexPath)
        
        let object = self.models[indexPath.row]
        cell.model = object
        
        return cell
    }
}

// MARK: - REQUESTS DELEGATE

extension PersonalInfoViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .generatePhoneToken
            || request == .getUserProfile {
            showLoadingView(self)
        }
    }
    
    func requestFinished(request: RequestType, result: ResponseResult) {
        hideLoadingView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
            switch result {
            case .Success(_):
                guard let closure = self.updateClosure else { return }
                if closure.isSuccess {
                    self.showSuccessMessage(closure.message)
                    self.updateClosure = nil
                }
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

// MARK: - UPDATE VIEW ELEMENT DELEGATE

extension PersonalInfoViewController: UpdateViewElement {
    
    func elementUpdated(fromSourceView view: UIViewController, status: Bool, data: Any?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
            self.viewWillAppear(true)
            guard status == true,
                  let message = data as? String else {
                return
            }
            
            guard view is UpdateMobileViewController ||
                    view is UpdateEmailViewController ||
                    view is ResetPinViewController ||
                    view is UpdatePhotoViewController  ||
                    view is EmailVerificationViewController else {
                return
            }
            self.updateClosure = (status, message)
        }
    }
}

// MARK: - PRIVATE FUNCTIONS

extension PersonalInfoViewController {
    
    private func showQIDMobileView() {
        let vc = self.getStoryboardView(QIDMobileViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func generatePhoneTokenRequest(mobile: String) {
        
        self.requestProxy.requestService()?.generatePhoneToken(phone: mobile) { (status, response) in
            guard status else { return }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                let vc = self.getStoryboardView(ConfirmPhoneNumberViewController.self)
                vc.updateViewElement = self
                self.present(vc, animated: true)
            }
        }
    }
}
