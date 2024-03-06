//
//  KarwaTaxiMapViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 04/02/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit
import FloatingPanel
import MapKit

class KarwaTaxiMapViewController: KarwaTaxiController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var menuButton: UIButton!
    
    lazy var pickupFloatingPanel: FloatingPanelController = {
        let panel = FloatingPanelController()
        
        panel.view.layer.shadowColor = UIColor.darkGray.cgColor
        panel.view.layer.shadowOffset = .init(width: 0, height: -14)
        panel.view.layer.shadowOpacity = 0.2
        panel.view.layer.shadowRadius = 10
        panel.setAppearanceForPhone(20.0)
        panel.contentMode = .fitToBounds
        
        return panel
    }()
    
    lazy var requestCarFloatingPanel: FloatingPanelController = {
        let panel = FloatingPanelController()
        
        panel.view.layer.shadowColor = UIColor.darkGray.cgColor
        panel.view.layer.shadowOffset = .init(width: 0, height: -14)
        panel.view.layer.shadowOpacity = 0.2
        panel.view.layer.shadowRadius = 10
        panel.setAppearanceForPhone(20.0)
        panel.contentMode = .fitToBounds
        
        return panel
    }()
    
    lazy var pickUpLocationViewController: PickUpLocationViewController = {
        return self.getStoryboardView(PickUpLocationViewController.self)
    }()
    
    lazy var requestCarViewController: RequestCarViewController = {
        return self.getStoryboardView(RequestCarViewController.self)
    }()
    
    lazy var tripView: TaxiTripView = {
        let view = TaxiTripView()
        return view
    }()
    
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
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.pickUpLocationViewController.destinationSearchBar.delegate = self
        self.pickUpLocationViewController.destinationsTableView.alpha = 0
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let tripViewHeight: CGFloat = 40
        self.tripView.frame = CGRect(x: 0, y: self.requestCarViewController.view.height - tripViewHeight, width: self.view.width, height: tripViewHeight)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
}

extension KarwaTaxiMapViewController {
    
    func setupView() {
        self.pickupFloatingPanel.delegate = self
        self.pickupFloatingPanel.set(contentViewController: self.pickUpLocationViewController)
        self.pickupFloatingPanel.addPanel(toParent: self)
        self.pickupFloatingPanel.track(scrollView: self.pickUpLocationViewController.destinationsTableView)
        
        self.pickUpLocationViewController.delegate = self
        
        self.requestCarFloatingPanel.delegate = self
        self.requestCarFloatingPanel.set(contentViewController: self.requestCarViewController)
        
        self.requestCarViewController.delegate = self
        
        self.menuButton.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.didTapMenuButton(_:))))
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension KarwaTaxiMapViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - FLOATING PANEL DELEGATE

extension KarwaTaxiMapViewController: FloatingPanelControllerDelegate, UIGestureRecognizerDelegate {
    
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout {
        switch newCollection.verticalSizeClass {
        case .compact:
            break
        case.regular:
            break
        default:
            break
        }
        
        let appearance = vc.surfaceView.appearance
        appearance.borderWidth = 0.0
        appearance.borderColor = nil
        vc.surfaceView.appearance = appearance
        return FloatingPanelBottomLayout()
    }
    
    func floatingPanelDidMove(_ vc: FloatingPanelController) {
//        let loc = vc.surfaceLocation
        
//        if vc == self.pickupFloatingPanel {
//            if vc.isAttracting == false {
//                let minY = vc.surfaceLocation(for: .full).y - 6.0
//                let maxY = vc.surfaceLocation(for: .tip).y + 6.0
//                vc.surfaceLocation = CGPoint(x: loc.x, y: min(max(loc.y, minY), maxY))
//            }
//
//            let tipY = vc.surfaceLocation(for: .tip).y
//            if loc.y > tipY - 44.0 {
//                let progress = max(0.0, min((tipY  - loc.y) / 44.0, 1.0))
//                self.pickUpLocationViewController.destinationsTableView.alpha = progress
//            } else {
//                self.pickUpLocationViewController.destinationsTableView.alpha = 1.0
//            }
//
//        } else {
//        }
    }
    
    func floatingPanelWillBeginDragging(_ vc: FloatingPanelController) {
        if vc == self.requestCarFloatingPanel {
            if vc.state == .full {
                self.pickUpLocationViewController.destinationSearchBar.showsCancelButton = false
                self.pickUpLocationViewController.destinationSearchBar.resignFirstResponder()
            }
            self.tripView.isHidden = true
        }
    }
    
    func floatingPanelWillEndDragging(_ vc: FloatingPanelController, withVelocity velocity: CGPoint, targetState: UnsafeMutablePointer<FloatingPanelState>) {
        
//        if targetState.pointee == .tip {
//            vc.contentMode = .static
//        }
        
        if vc == self.requestCarFloatingPanel {
            let tipY = vc.surfaceLocation(for: .tip).y
            if vc.surfaceLocation.y > tipY {
                self.hideRequestCarFlotingView()
            }
            
        } else {
            if targetState.pointee != .full {
            }
        }
    }
    
    func floatingPanelDidEndAttracting(_ fpc: FloatingPanelController) {
        fpc.contentMode = .fitToBounds
    }
}

// MARK: - PICKUP CONTROLLER DELEGATE

extension KarwaTaxiMapViewController: PickUpLocationViewControllerDelegate {
    
    func didTapPickupLocationButton(_ location: String) {
        let vc = self.getStoryboardView(DropOffLocationViewController.self)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    func didTapSavePlacesCollectionCell(_ place: KarwaPlace) {
        let vc = self.getStoryboardView(PayTripViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - REQUEST CAR CONTROLLER DELEGATE

extension KarwaTaxiMapViewController: RequestCarViewControllerDelegate {
    
    func didTapPromoButton() {
        
    }
    
    func didTapCashButton() {
        
    }
    
    func didTapScheduleButton() {
        
    }
    
    func didTapRequestKarwaButton() {
        
    }
    
    func didTapCarCell(with model: KarwaTaxiCar) {
        print(model._name)
    }
}

// MARK: - SEARCH BAR DELEGATE

extension KarwaTaxiMapViewController: UISearchBarDelegate {
    
    func activate(searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
//        self.pickUpLocationViewController.showHeader(animated: true)
        self.pickUpLocationViewController.destinationsTableView.alpha = 1.0
//        detailVC.dismiss(animated: true, completion: nil)
    }
    
    func deactivate(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
//        self.pickUpLocationViewController.hideHeader(animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        deactivate(searchBar: searchBar)
        UIView.animate(withDuration: 0.25) {
            self.pickupFloatingPanel.move(to: .half, animated: false)
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        activate(searchBar: searchBar)
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.pickupFloatingPanel.move(to: .full, animated: false)
        }
    }
}

// MARK: - CUSTOM FUNCTIONS

extension KarwaTaxiMapViewController {
    
    @objc private func didTapMenuButton(_ gesture: UITapGestureRecognizer) {
        self.showRequestCarFlotingView()
        
//        print("Request controller Height: \(self.requestCarViewController.view.height)") 441.0
//        print("Request floating Height: \(self.requestCarFloatingPanel.view.height)") 896.0
    }
    
    private func showRequestCarFlotingView() {
//        self.pickupFloatingPanel.dismiss(animated: true)
        self.requestCarFloatingPanel.addPanel(toParent: self)
        self.view.addSubview(self.tripView)
        self.tripView.isHidden = false
    }
    
    private func hideRequestCarFlotingView() {
        self.requestCarFloatingPanel.dismiss(animated: true) {
            self.tripView.removeFromSuperview()
        }
    }
}
