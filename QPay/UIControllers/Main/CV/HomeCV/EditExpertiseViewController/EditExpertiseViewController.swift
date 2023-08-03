//
//  EditExpertiseViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 09/05/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import UIKit
import DropDown

class EditExpertiseViewController: ViewController {
    
    @IBOutlet weak var industryAreaLabel   :UILabel!
    
    @IBOutlet weak var professionAreaLabel :UILabel!
    
    @IBOutlet weak var graduateLabel       :UILabel!
    
    @IBOutlet weak var salaryLabel         :UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        localized()
        setupData()
        fetchData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}

extension EditExpertiseViewController {
    
    func setupView() {
        self.requestProxy.requestService()?.delegate = self
    }
    
    func localized() {
    }
    
    func setupData() {
        guard let cv = self.userProfile.cv else { return }
        self.industryAreaLabel.text    = cv._industry_Area
        self.professionAreaLabel.text  = cv._profession_Area
        self.graduateLabel.text        = cv._graduate
        self.salaryLabel.text          = cv._salaryExpect
    }
    
    func fetchData() {
    }
}

extension EditExpertiseViewController {
    
    @IBAction func backAction(_ sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doneAction(_ sender : UIButton){
        guard let user  = self.userProfile.getUser(),
              var cv    = self.userProfile.cv else {
            return
        }
        
        cv.industry_Area    = self.industryAreaLabel.text
        cv.profession_Area  = self.professionAreaLabel.text
        cv.graduate         = self.graduateLabel.text
        cv.salaryExpect     = self.salaryLabel.text
        
        self.requestProxy.requestService()?.addUpdateCV(cv: cv, { response in
            guard let resp = response else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                self.showSuccessMessage(resp._message)
            }
        })
    }
    
    
    @IBAction func selectIndustryAreaAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(SelectDataViewController.self)
        vc.onSelect = {[weak self] (selectedString) in
            guard let self = self else { return }
            self.industryAreaLabel.text = selectedString
            
        }
        vc.list = Constant.industry
        self.present(vc, animated: true)
    }
    
    @IBAction func selectProfessionAreaAaction(_ sender: UIButton) {
        let vc = self.getStoryboardView(SelectDataViewController.self)
        vc.onSelect = {[weak self] (selectedString) in
            guard let self = self else { return }
            self.professionAreaLabel.text = selectedString
            
        }
        vc.list = Constant.profession
        self.present(vc, animated: true)
    }
    
    @IBAction func selectGraduateAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(SelectDataViewController.self)
        vc.onSelect = {[weak self] (selectedString) in
            guard let self = self else { return }
            self.graduateLabel.text = selectedString
            
        }
        vc.list = Constant.graduate
        self.present(vc, animated: true)
    }
    
    @IBAction func selectSalaryAction(_ sender: UIButton) {
        
        let vc = self.getStoryboardView(SelectDataViewController.self)
        vc.onSelect = {[weak self] (selectedString) in
            guard let self = self else { return }
            self.salaryLabel.text = selectedString
            
        }
        vc.list = Constant.expectedSalary
        self.present(vc, animated: true)
    }
}

// MARK: - REQUESTS DELEGATE

extension EditExpertiseViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .addUpdateCV {
            showLoadingView(self)
        }
    }
    
    func requestFinished(request: RequestType, result: ResponseResult) {
        self.hideLoadingView()
        
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

extension EditExpertiseViewController {
    
}
