//
//  ResultsSearchJobHuntViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 29/05/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import UIKit

class ResultsSearchJobHuntViewController: ViewController {
    
    @IBOutlet weak var mView      : UIView!
    
    @IBOutlet weak var titleLabel : UILabel!
    
    @IBOutlet weak var tableView  : UITableView!
    
    @IBOutlet weak var addButton  : ButtonDesign!
    
    @IBOutlet weak var emptyLabel: UILabel!
    
    var jobList           = [JobHunterList]()
    var employerList      = [EmployerList]()
    var type : _Type      = .jobSeekerSearch
    
    enum _Type  {
        case jobSeekerSearch
        case myJobSeekerList
        case vacaniceSearch
        case myVacaniceList
        
    }
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.requestProxy.requestService()?.delegate = self

        switch type {
        case .jobSeekerSearch:
            break
            
        case .myJobSeekerList:
            self.requestProxy.requestService()?.getMyJobHuntList( { respons in
                guard let resp = respons else {
                    return
                }
                guard resp._list.isNotEmpty else {
                    self.emptyLabel.isHidden = resp._list.isNotEmpty
                    return
                }
                self.jobList = resp._list
                self.tableView.reloadData()
            })
            break
            
        case .vacaniceSearch:
            break
            
        case .myVacaniceList:
            self.requestProxy.requestService()?.getMyEmployerList({ respons in
                guard let resp = respons else {
                    return
                }
                guard resp.isNotEmpty else {
                    self.emptyLabel.isHidden = resp.isNotEmpty
                    return
                }
                self.employerList  = resp
                self.tableView.reloadData()
            })
            break
        }
    }
}

extension ResultsSearchJobHuntViewController {
    func setupView() {

        self.tableView.delegate   = self
        self.tableView.dataSource = self
        self.tableView.registerNib(ResultSearchJobHuntTableCell.self)

        
        switch type {
        case .jobSeekerSearch:
            self.mView.backgroundColor = .mStocks_Label_Blue
            self.titleLabel.text       = "JOB SEEKER"
            self.addButton.isHidden = true
            break
            
        case .vacaniceSearch:
            self.mView.backgroundColor  = .mBook_Green
            self.titleLabel.text        = "VACANCIES"
            self.addButton.isHidden = true
            break
            
        case .myJobSeekerList:
            self.addButton.backgroundColor = .mStocks_Label_Blue
            self.titleLabel.text = "MY JOB LIST"
            break
            
        case .myVacaniceList:
            self.mView.backgroundColor  = .mBook_Green
            self.addButton.backgroundColor = .mBook_Green
            self.titleLabel.text           = "MY VACANCY LIST"
            break
        }
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    
    }
}

// MARK: - Action

extension ResultsSearchJobHuntViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addAction(_ sender: UIButton) {
        switch type {
        case .jobSeekerSearch:
            break
            
        case .myJobSeekerList:
            let vc = self.getStoryboardView(EditAddMyJobtViewController.self)
            self.navigationController?.pushViewController(vc, animated: true)
            break
            
        case .vacaniceSearch:
            break
            
        case .myVacaniceList:
            let vc = self.getStoryboardView(EditAddMyVacancyViewController.self.self)
            self.navigationController?.pushViewController(vc, animated: true)
            break
        }
    }
}

// MARK: - TABLE VIEW DELEGATE

extension ResultsSearchJobHuntViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch type {
        case .jobSeekerSearch , .myJobSeekerList : return self.jobList.count
        case .vacaniceSearch , .myVacaniceList   : return self.employerList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(ResultSearchJobHuntTableCell.self, for: indexPath)
        switch type {
        case .jobSeekerSearch , .myJobSeekerList:
            let object = self.jobList[indexPath.row]
            cell.objectJob = object
            return cell
            
        case .vacaniceSearch , .myVacaniceList:
            let object = self.employerList[indexPath.row]
            cell.objectEmployer = object
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch type {
        case .jobSeekerSearch:
            let object   = self.jobList[indexPath.row]
            let vc       = self.getStoryboardView(JobseekerPersonalDetalsViewController.self)
            vc.jobDetails = object
            vc.status    = .fromSearch
            self.navigationController?.pushViewController(vc, animated: true)
            break
            
        case .myJobSeekerList:
            let object    = self.jobList[indexPath.row]
            let vc        = self.getStoryboardView(JobseekerPersonalDetalsViewController.self)
            vc.jobDetails = object
            vc.status     = .myList
            self.navigationController?.pushViewController(vc, animated: true)
            break
            
        case .vacaniceSearch:
            let object = self.employerList[indexPath.row]
            let vc = self.getStoryboardView(VacancPersonalDetalsViewController.self)
            vc.detalsEmployer = object
            vc.status    = .fromSearch
            self.navigationController?.pushViewController(vc, animated: true)
            break
            
        case .myVacaniceList:
            let object = self.employerList[indexPath.row]
            let vc = self.getStoryboardView(VacancPersonalDetalsViewController.self)
            vc.detalsEmployer = object
            vc.status    = .myList
            self.navigationController?.pushViewController(vc, animated: true)
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

// MARK: - Requests Delegate

extension ResultsSearchJobHuntViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .getMyJobHuntList ||
            request == .getMyEmployerList
        {
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
                if request == .getMyJobHuntList ||
                    request == .getMyEmployerList {
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
}
