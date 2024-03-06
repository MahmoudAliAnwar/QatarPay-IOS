//
//  AddQatarCoolCardViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/5/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit
import DropDown

class AddQatarCoolCardViewController: QatarCoolController {
    
    @IBOutlet weak var groupListButton: UIButton!
    
    @IBOutlet weak var qatarCoolNumberTextField: UITextField!
    @IBOutlet weak var qatarCoolNumberErrorImageView: UIImageView!
    
    @IBOutlet weak var qidTextField: UITextField!
    @IBOutlet weak var qidErrorImageView: UIImageView!
    
    @IBOutlet weak var ownerTextField: UITextField!
    @IBOutlet weak var ownerErrorImageView: UIImageView!
    
    private var groupDropDown = DropDown()
    
    private var groups = [Group]()
    private var groupName: String?
    
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
        
        self.fetchGroupData()
    }
}

extension AddQatarCoolCardViewController {
    
    func setupView() {
        self.setupGroupDropDown()
        
        self.qatarCoolNumberTextField.delegate = self
        self.qidTextField.delegate = self
        self.ownerTextField.delegate = self
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension AddQatarCoolCardViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func groupDropDownAction(_ sender: UIButton) {
        if self.groupDropDown.dataSource.isEmpty {
            self.showSnackMessage("You don't have groups yet\nClick Create Group to add one")
        }else {
            self.groupDropDown.show()
        }
    }
    
    @IBAction func createGroupAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(CreateQatarCoolGroupViewController.self)
        vc.updateViewDelegate = self
        self.present(vc, animated: true)
    }
    
    @IBAction func addNumberAction(_ sender: UIButton) {
        if self.groupDropDown.selectedItem == nil {
            self.showSnackMessage("Please, select group to continue")
            
        }else if self.qatarCoolNumberTextField.text!.isEmpty {
            self.showHideQatarCoolNumberError()
            
        }else if self.qidTextField.text!.isEmpty {
            self.showHideQatarCoolNumberError(action: .hide)
            self.showHideQIDError()
            
        }else if self.ownerTextField.text!.isEmpty {
            self.showHideQatarCoolNumberError(action: .hide)
            self.showHideQIDError(action: .hide)
            self.showHideOwnerError()
            
        }else {
            self.showHideQatarCoolNumberError(action: .hide)
            self.showHideQIDError(action: .hide)
            self.showHideOwnerError(action: .hide)
            
            guard let group = self.groupName,
                  let number = self.qatarCoolNumberTextField.text, number.isNotEmpty,
                  let qid = self.qidTextField.text, qid.isNotEmpty,
                  let owner = self.ownerTextField.text, owner.isNotEmpty else {
                return
            }
            
            guard qid.count == self.qidMaxDigit else {
                self.showSnackMessage("QID should be \(self.qidMaxDigit) digits")
                return
            }
            
            let selectedGroup = self.groups.filter({ $0.name!.contains(group) }).first
            
            guard let gId = selectedGroup?.id else { return }
            self.requestProxy.requestService()?.addQatarCoolToGroup(groupID: gId, qatarCoolNumber: number, QID: qid, subscriberName: owner) { (status, response) in
                guard status else { return }
            }
        }
    }
    
    @IBAction func editDeleteGroupAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(QatarCoolEditDeleteGroupViewController.self)
        vc.groups = self.groups
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - REQUESTS DELEGATE

extension AddQatarCoolCardViewController: RequestsDelegate {

    func requestStarted(request: RequestType) {
        if request == .addQatarCoolToGroup {
            showLoadingView(self)
        }
    }

    func requestFinished(request: RequestType, result: ResponseResult) {
        hideLoadingView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
            switch result {
            case .Success(let data):
                if request == .addQatarCoolToGroup {
                    if let response = data as? BaseResponse {
                        self.showSuccessMessage(response.message ?? "Number Added Successfully")
                        self.navigationController?.popViewController(animated: true)
                    }
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

extension AddQatarCoolCardViewController: UpdateViewElement {
    
    func elementUpdated(fromSourceView view: UIViewController, status: Bool, data: Any?) {
        
        if view is CreateQatarCoolGroupViewController {
            self.viewWillAppear(true)
        }
    }
}

// MARK: - TEXT FIELD DELEGATE

extension AddQatarCoolCardViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        
        if textField == self.qatarCoolNumberTextField {
            return count <= 100
            
        }else if textField == self.qidTextField {
            return count <= self.qidMaxDigit
            
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.qatarCoolNumberTextField {
            self.qidTextField.becomeFirstResponder()
            
        } else if textField == self.qidTextField {
            self.ownerTextField.becomeFirstResponder()
            
        } else if textField == self.ownerTextField {
            self.view.endEditing(true)
        }
        return true
    }
}

// MARK: - PRIVATE FUNCTIONS

extension AddQatarCoolCardViewController {
    
    private func showHideQatarCoolNumberError(action: ViewErrorsAction = .show) {
        
        switch action {
        case .hide:
            self.qatarCoolNumberErrorImageView.image = .none
        case .show:
            self.qatarCoolNumberErrorImageView.image = #imageLiteral(resourceName: "ic_error_circle")
        }
    }
    
    private func showHideQIDError(action: ViewErrorsAction = .show) {
        
        switch action {
        case .hide:
            self.qidErrorImageView.image = .none
        case .show:
            self.qidErrorImageView.image = #imageLiteral(resourceName: "ic_error_circle")
        }
    }
    
    private func showHideOwnerError(action: ViewErrorsAction = .show) {
        
        switch action {
        case .hide:
            self.ownerErrorImageView.image = .none
        case .show:
            self.ownerErrorImageView.image = #imageLiteral(resourceName: "ic_error_circle")
        }
    }

    private func setupGroupDropDown() {
        self.configureDropDownAppearance(self.groupDropDown, dropBtn: self.groupListButton)
        
        self.groupDropDown.selectionAction = { [weak self] (index, item) in
            self?.groupListButton.setTitle(item, for: .normal)
            self?.groupName = item
        }
    }
    
    private func fetchGroupData() {
        
        var names = [String]()
        
        self.dispatchGroup.enter()
        self.requestProxy.requestService()?.getQatarCoolUserGroups { (status, phoneGroups) in
            let groups = phoneGroups ?? []
            
            groups.forEach { (group) in
                self.groups = groups
                if let name = group.name {
                    names.append(name)
                }
            }
            self.dispatchGroup.leave()
        }
        
        self.dispatchGroup.notify(queue: .main, execute: {
            self.groupDropDown.dataSource = names
            self.groupDropDown.reloadAllComponents()
        })
    }
    
    private func configureDropDownAppearance(_ dropDown: DropDown, dropBtn: UIButton) {
        let appearance = DropDown.appearance()
        
        dropDown.anchorView = dropBtn
        
        dropDown.bottomOffset = CGPoint(x: 0, y: dropBtn.bounds.height)
        dropDown.direction = .bottom
        dropDown.dismissMode = .onTap
        
        appearance.cellHeight = dropBtn.bounds.height
        appearance.backgroundColor = UIColor(white: 1, alpha: 1)
        appearance.selectionBackgroundColor = UIColor(red: 0.6494, green: 0.8155, blue: 1.0, alpha: 0.2)
        appearance.separatorColor = UIColor(white: 0.7, alpha: 0.8)
        appearance.cornerRadius = 10
        appearance.shadowColor = UIColor(white: 0.6, alpha: 1)
        appearance.shadowOpacity = 0.8
        appearance.shadowRadius = 25
        appearance.animationduration = 0.25
        appearance.textColor = appBackgroundColor
    }
}
