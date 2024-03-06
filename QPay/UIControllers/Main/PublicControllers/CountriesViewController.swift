//
//  CountriesViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/11/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class CountriesViewController: ViewController {
    
    @IBOutlet weak var countriesTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var countries = [Country]()
    var searchCountries = [Country]()
    
    var isSearching = false
    
    var delegate: CountryDelegate?
    
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
        
        if let lastController = self.presentingViewController?.children.last {
            
            self.dispatchGroup.enter()
            
            if lastController is AddBankAccountViewController {
                self.requestProxy.requestService()?.countriesList { (status, list) in
                    let arr = list ?? []
                    self.countries = arr
                    
                    self.dispatchGroup.leave()
                }
                
            } else if lastController is InternationalTopupViewController {
                self.requestProxy.requestService()?.estoreTopupCountryList { (status, countryList) in
                    if status {
                        let myCountries = countryList ?? []
                        self.countries = myCountries
                        
                        self.dispatchGroup.leave()
                    }
                }
            }
            
            self.dispatchGroup.notify(queue: .main, execute: {
                self.countriesTableView.reloadData()
            })
        }
    }
}

extension CountriesViewController {
    
    func setupView() {
        self.countriesTableView.delegate = self
        self.countriesTableView.dataSource = self
        self.searchBar.delegate = self
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension CountriesViewController {
    
    @IBAction func dismissAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}

// MARK: - REQUESTS DELEGATE

//extension CountriesViewController: RequestsDelegate {
//    
//    func requestStarted(request: RequestType) {
//        if request == .countriesList {
//            showLoadingView(self)
//        }
//    }
//    
//    func requestFinished(request: RequestType, result: ResponseResult) {
//        hideLoadingView()
//        
//        switch result {
//        case .Success(_):
//            break
//            
//        case .Failure(let errorType):
//            switch errorType {
//            case .Exception(let exc):
//                if showUserExceptions {
//                    self.showErrorMessage(exc)
//                }
//                break
//            case .AlamofireError(let err):
//                if showAlamofireErrors {
//                    self.showSnackMessage(err.localizedDescription)
//                }
//                break
//            case .Runtime(_):
//                break
//            }
//        }
//    }
//}

// MARK: - SEARCH BAR DELEGATE

extension CountriesViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text!.isEmpty {
            isSearching = false
            
        }else {
            let sText = searchText.lowercased()
            self.searchCountries = self.countries.filter({ (country) -> Bool in
                
                if let name = country.name {
                    return name.lowercased().contains(sText)
                }
                return false
            })
            
            isSearching = true
        }

        self.countriesTableView.reloadData()
    }
}

// MARK: - TABLE VIEW DELEGATE

extension CountriesViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearching {
            return self.searchCountries.count
        }else {
            return self.countries.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.CountryTableViewCell.rawValue, for: indexPath) as! CountryTableViewCell
        
        let country: Country
        
        if isSearching {
            country = self.searchCountries[indexPath.row]
        }else {
            country = self.countries[indexPath.row]
        }
        
        cell.setupData(country)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let country: Country
        
        if isSearching {
            country = self.searchCountries[indexPath.row]
        }else {
            country = self.countries[indexPath.row]
        }
        
        self.delegate?.countrySelected(country)
        self.dismiss(animated: true)
    }
}
