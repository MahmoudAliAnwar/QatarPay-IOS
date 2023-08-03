//
//  ParkingsLocationViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 26/01/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit

class ParkingsLocationViewController: ParkingsController {
    
    @IBOutlet weak var parkingsCollectionView: UICollectionView!

    var parkings = [Parking]()
    
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
        
        //self.changeStatusBarBG(color: .mParkings_Dark_Red)
        
        self.requestProxy.requestService()?.delegate = self
        
        self.dispatchGroup.enter()
        
        self.requestProxy.requestService()?.getParkingsList { (parkings) in
            self.parkings = parkings ?? []
            self.dispatchGroup.leave()
        }
    
        self.dispatchGroup.notify(queue: .main) {
            self.parkingsCollectionView.reloadData()
        }
    }
}

extension ParkingsLocationViewController {
    
    func setupView() {
        self.parkingsCollectionView.delegate = self
        self.parkingsCollectionView.dataSource = self
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension ParkingsLocationViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - COLLECTION VIEW DELEGATE

extension ParkingsLocationViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.parkings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueCell(ParkingCollectionViewCell.self, for: indexPath)
        
        let object = self.parkings[indexPath.row]
        cell.parking = object
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.getStoryboardView(PayYourParkingViewController.self)
        vc.parking = self.parkings[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //let viewWidth = self.view.width
        return .init(width: collectionView.width, height: 90)
    }
}

// MARK: - REQUESTS DELEGATE

extension ParkingsLocationViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .getParkingsList {
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

extension ParkingsLocationViewController {
    
}
