//
//  RefillKarwaBusCardViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/4/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class RefillKarwaBusCardViewController: KarwaBusController {
    
    @IBOutlet weak var cardImageViewDesign: ImageViewDesign!
    @IBOutlet weak var cardBalanceLabel: UILabel!
    @IBOutlet weak var cardNumberLabel: UILabel!

    @IBOutlet weak var amountCollectionView: UICollectionView!
    @IBOutlet weak var amountTextField: UITextField!
    
    @IBOutlet weak var dropDownView: UIView!
    @IBOutlet weak var dropDownTableView: UITableView!
    @IBOutlet weak var dropDownViewLayoutConstraint: NSLayoutConstraint!
    
    var amounts = [Amount]()
    var actions = [KarwaBusAction]()
    var card: KarwaBusCard?
    
    private var selectedIndex: IndexPath!
    private var popupStatus: PopupStatus = .Hide
    
    enum DropDownActions: String, CaseIterable {
        case Delete
    }
    
    struct KarwaBusAction {
        let title: String
        let completion: voidCompletion
    }
    
    private enum PopupStatus {
        case Show
        case Hide
        
        public mutating func toggle() {
            switch self {
            case .Show:
                self = .Hide
            case .Hide:
                self = .Show
            }
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if self.popupStatus == .Show {
            self.showHidePopupView()
        }
    }
}

extension RefillKarwaBusCardViewController {
    
    func setupView() {
        self.cardImageViewDesign.cornerRadius = self.cardImageViewDesign.height / 12
        self.amountTextField.delegate = self
        
        self.dropDownTableView.delegate = self
        self.dropDownTableView.dataSource = self
        
        self.dropDownTableView.tableFooterView = UIView()
        
        self.amountCollectionView.registerNib(AmmountCollectionViewCell.self)
        
        self.amountTextField.addTarget(self, action: #selector(self.textFieldChanged(textField:)), for: .editingChanged)
    }
    
    func localized() {
    }
    
    func setupData() {
        self.amounts = [10,15,20,25,30,35,40,45,50].compactMap({ return Amount(payment: $0) })
        self.selectedIndex = IndexPath(row: 0, section: 0)
        
        self.actions = DropDownActions.allCases.compactMap({ (action) -> KarwaBusAction in
            return KarwaBusAction(title: action.rawValue) {
                guard let id = self.card?.id else { return }
                
                switch action {
                case .Delete:
                    self.requestProxy.requestService()?.deleteKarwaBusCard(cardID: id, completion: { (status, response) in
                        guard status == true else { return }
                        
                        self.navigationController?.popViewController(animated: true)
                        self.showSuccessMessage(response?.message)
                    })
                    break
                }
            }
        })
    }
    
    func fetchData() {
        guard let cd = self.card else { return }
        
        self.cardBalanceLabel.text = "QAR \(cd._balance.formatNumber())"
        self.cardNumberLabel.text = cd._number
        
        guard let imagePath = cd.thumbnail else { return }
        self.cardImageViewDesign.kf.setImage(with: URL(string: imagePath.correctUrlString()), placeholder: UIImage.ic_karwa_card)
    }
}

// MARK: - ACTIONS

extension RefillKarwaBusCardViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func dropDownMenuAction(_ sender: UIButton) {
        self.showHidePopupView()
    }
    
    @IBAction func proceedAction(_ sender: UIButton) {
        guard let cd = self.card,
              let textFieldAmount = self.amountTextField.text else {
            return
        }
        
        var amount: Double = -1
        
        if textFieldAmount.isEmpty {
            amount = self.amounts[self.selectedIndex.row].payment
        }else {
            if let amm = Double(textFieldAmount) {
                amount = amm
            }
        }
        
        guard amount > 0 else { return }
        
        self.requestProxy.requestService()?.initiateKarwaBus(cardNumber: cd._number, mobile: cd._mobile, amount: amount, completion: { (status, transfer) in
            
            guard status == true,
                  let trans = transfer else {
                return
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                let vc = self.getStoryboardView(ConfirmPinCodeViewController.self)
                vc.updateViewElementDelegate = self
                vc.data = trans
                self.present(vc, animated: true)
            }
        })
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - UPDATE VIEW ELEMENTS DELEGATE

extension RefillKarwaBusCardViewController: UpdateViewElement {
    
    func elementUpdated(fromSourceView view: UIViewController, status: Bool, data: Any?) {
        guard view is ConfirmPinCodeViewController else { return }
        self.viewWillAppear(true)
        
        guard status == true,
              let message = data as? String else {
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.navigationController?.popViewController(animated: true)
            self.showSuccessMessage(message)
        }
    }
}

// MARK: - REQUESTS DELEGATE

extension RefillKarwaBusCardViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .initiateKarwaBus ||
            request == .deleteKarwaBusCard {
            showLoadingView(self)
        }
    }
    
    func requestFinished(request: RequestType, result: ResponseResult) {
        hideLoadingView()
        
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
                    self.showErrorMessage(err.localizedDescription)
                }
                break
            case .Runtime(_):
                break
            }
        }
    }
}

// MARK: - COLLECTION VIEW DELEGATE

extension RefillKarwaBusCardViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return amounts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(AmmountCollectionViewCell.self, for: indexPath)
        
        let ammount = amounts[indexPath.row]
        cell.setupData(ammount: ammount)
        
        cell.radioButton.isChecked = selectedIndex == indexPath
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath
        self.amountTextField.text?.removeAll()
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.height*1.2, height: collectionView.height)
    }
}

// MARK: - TABLE VIEW DELEGATE

extension RefillKarwaBusCardViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.actions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(KarwaBusDropDownTableViewCell.self, for: indexPath)
        
        let object = self.actions[indexPath.row]
        cell.actionTitle = object.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let action = self.actions[indexPath.row]
        action.completion()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.dropDownViewLayoutConstraint.constant = (cell.height*CGFloat(DropDownActions.allCases.count))
    }
}

// MARK: - TEXT FIELD DELEGATE

extension RefillKarwaBusCardViewController: UITextFieldDelegate {
    
    @objc func textFieldChanged(textField: UITextField) {
        
        if let text = textField.text, text.isNotEmpty {
            selectedIndex = IndexPath(row: -1, section: 0)
        }else {
            selectedIndex = IndexPath(row: 0, section: 0)
        }
        self.amountCollectionView.reloadData()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let textFieldText = textField.text,
              let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= ammountFieldsMaxLength
    }
}

// MARK: - CUSTOM FUNCTIONS

extension RefillKarwaBusCardViewController {
    
    private func showHidePopupView() {
        self.popupStatus.toggle()
        
        switch self.popupStatus {
        case .Show:
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                self.dropDownView.isHidden = false
                
            }) { (_) in
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                    self.dropDownView.alpha = 1
                })
            }
            
        case .Hide:
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.dropDownView.alpha = 0
            }) { (_) in
                self.dropDownView.isHidden = true
            }
        }
    }
    
}

final class KarwaBusDropDownTableViewCell: UITableViewCell {
    
    @IBOutlet weak var actionLabel: UILabel!

    var actionTitle: String! {
        didSet {
            self.actionLabel.text = self.actionTitle
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
}
