//
//  UpdateGenderViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 04/12/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit

class UpdateGenderViewController: ViewController {
    
    @IBOutlet weak var containerViewDesign: ViewDesign!
    
    @IBOutlet weak var maleCheckBox: CheckBox!
    
    @IBOutlet weak var femaleCheckBox: CheckBox!
    
    var updateViewElement: UpdateViewElement?
    
    private var selectedGender: Profile.Gender = .Male {
        willSet {
            self.selectGender(newValue)
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
    }
}

extension UpdateGenderViewController {
    
    func setupView() {
        self.containerViewDesign.cornerRadius = self.containerViewDesign.width / 16
        
        [
            self.maleCheckBox,
            self.femaleCheckBox,
        ].forEach({
            $0?.checkmarkColor = .black
            $0?.borderStyle = .rounded
            $0?.borderWidth = 2
            $0?.style = .circle
            $0?.tintColor = .mLight_Gray
            $0?.checkedBorderColor = .mLight_Gray
        })
        
        self.maleCheckBox.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(self.didSelectMale(_:)))
        )
        
        self.femaleCheckBox.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(self.didSelectFemale(_:)))
        )
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension UpdateGenderViewController {
    
    @objc
    private func didSelectMale(_ sender: CheckBox) {
        self.selectedGender = .Male
    }
    
    @objc
    private func didSelectFemale(_ sender: CheckBox) {
        self.selectedGender = .Female
    }
    
    @IBAction func maleAction(_ sender: UIButton) {
        self.selectedGender = .Male
    }
    
    @IBAction func femaleAction(_ sender: UIButton) {
        self.selectedGender = .Female
    }
    
    @IBAction func closeAction(_ sender: UIButton) {
        self.closeView(false)
    }
    
    @IBAction func proceedAction(_ sender: UIButton) {
        self.requestProxy.requestService()?.updateGender(self.selectedGender, { status, response in
            guard status else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                self.closeView(true, data: response?.message ?? "")
            }
        })
    }
}

// MARK: - REQUESTS DELEGATE

extension UpdateGenderViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .updateGender {
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

// MARK: - CUSTOM FUNCTIONS

extension UpdateGenderViewController {
    
    private func selectGender(_ gender: Profile.Gender) {
        self.maleCheckBox.isChecked = gender == .Male
        self.femaleCheckBox.isChecked = gender == .Female
        
        switch gender {
        case .Male:
            break
        case .Female:
            break
        }
    }
    
    private func closeView(_ status: Bool, data: Any? = nil) {
        self.dismiss(animated: true) {
            self.updateViewElement?.elementUpdated(fromSourceView: self, status: status, data: data)
        }
    }
}
