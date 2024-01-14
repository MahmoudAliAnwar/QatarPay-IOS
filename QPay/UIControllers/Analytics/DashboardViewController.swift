//
//  DashboardViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/10/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit
import Charts

class DashboardViewController: MainController {
    
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var dailyBottomView: UIView!
    @IBOutlet weak var weeklyBottomView: UIView!
    @IBOutlet weak var monthlyBottomView: UIView!
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var kahramaaLabel: UILabel!
    @IBOutlet weak var qatarCoolLabel: UILabel!
    @IBOutlet weak var toCollectLabel: UILabel!
    @IBOutlet weak var outStandingLabel: UILabel!
    
    @IBOutlet weak var dashboardTableView: UITableView!
    @IBOutlet weak var holderStackView: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet var collectionOfViews: [UIView]!{
        didSet{
            collectionOfViews.forEach({
                $0.layer.cornerRadius = $0.width / 2
                $0.clipsToBounds = true
            })
        }
    }
    @IBOutlet weak var widthOfYAxisConstrain: NSLayoutConstraint!
    
    var serviceCategories = [ServiceCategory]()
    var chart: DashboardChart?
    var range: Range!
    
    private enum BillType: String {
        case Phone = "Phone Bills"
        case Qatar = "Qatar Cool"
        case Kahrama = "Kahrama"
    }
    
     enum Range {
        case Daily
        case Weekly
        case Monthly
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        localized()
        setupData()
        fetchData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
}

extension DashboardViewController {
    
    func setupView() {
//        self.requestProxy.requestService()?.delegate = self
        
        self.setChartView()
        self.dashboardTableView.dataSource = self
        self.dashboardTableView.delegate = self
        
        self.changeStatusBarBG(color: .clear)
        self.collectionView.registerNib(XAxisViewCell.self)
    }
    
    func localized() {
    }
    
    func setupData() {
        self.profileRequest()
        self.dashboardChartRequest()
        self.dashboardDataRequest()
        self.dispatchGroup.notify(queue: .main) {
            self.hideLoadingView()
            self.setChartDataDaily()
            self.dashboardTableView.reloadData()
        }

    }
    
    func fetchData() {
    }
    
    func getNameShowInXAxisView(index: Int) -> String?  {
        switch range{
        case .Daily:
            return self.chart?.dailyData?[index].day
        case .Weekly:
            return self.chart?.weeklyData?[index].week
        case .Monthly:
            guard  let month = self.chart?.monthlyData?[index].month else {return nil}
            let start = month.index(month.startIndex, offsetBy: 0)
            let end = month.index(month.startIndex, offsetBy: 2)
            let range = start...end
            return String(month[range])
       
        case .none:
            return nil
        }
        
    }
    func getNumberOfCell() -> Int {
        switch range{
        case .Daily:
            return self.chart?.dailyData?.count ?? 0
        case .Weekly:
            return self.chart?.weeklyData?.count ?? 0
        case .Monthly:
            return self.chart?.monthlyData?.count ?? 0
        case .none:
            return 0
        }
        
    }
}

// MARK: - ACTIONS

extension DashboardViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func dailyAction(_ sender: UIButton) {
        self.setChartDataDaily()
    }
    
    @IBAction func weeklyAction(_ sender: UIButton) {
        self.setChartDataWeekly()
    }
    
    @IBAction func monthlyAction(_ sender: UIButton) {
        self.setChartDataMonthly()
    }
    
    @IBAction func shopAction(_ sender: UIButton) {
        
//        self.requestProxy.requestService()?.delegate = self
        
        self.showLoadingView(self)
        
        self.requestProxy.requestService()?.getShopList ( weakify { strong, myShops in
            self.hideLoadingView()
            let shops = myShops ?? []
            
            if shops.isEmpty {
                let vc = self.getStoryboardView(CreateShopViewController.self)
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else {
                let vc = strong.getStoryboardView(MyShopsViewController.self)
                vc.shops = shops
                vc.shopsAll = shops
                vc.isFromDashboard = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        })
    }
    
    @IBAction func invoiceAction(_ sender: UIButton) {
//        let vc = self.getStoryboardView(InvoicesViewController.self)
//        self.navigationController?.pushViewController(vc, animated: true)
        
        let vc = self.getStoryboardView(InvoiceLoginViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - CollectionViewDataSoucre and Delegate

extension DashboardViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getNumberOfCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(XAxisViewCell.self, for: indexPath)
        
        cell.config(title: getNameShowInXAxisView(index: indexPath.item))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionSize = collectionView.height
        var minsWidth: CGFloat!
        switch range  {
        case .Daily:
            minsWidth = 60
        case .Weekly:
            minsWidth = 0
        case .Monthly:
            minsWidth = 80
            
        case .none:
            break
        }
        let collectionWidth = self.collectionView.width - minsWidth
        return CGSize(width: (collectionWidth / CGFloat(getNumberOfCell())), height: collectionSize)
      
        
    }
}



// MARK: - TABLE VIEW DELEGATE

extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.serviceCategories.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(DashboardTableViewCell.self, for: indexPath)
        cell.cellIndexPath = indexPath
        cell.delegate = self

        let object = self.serviceCategories[indexPath.row]
        
    
        switch indexPath.row {
        case 0:
            cell.setupData(object, backgroundImage: "servicebg_head" , leftViewColor: UIColor(hexString: "#020C18"), title: object.categoryName ?? "")
        default:
            cell.setupData(object,  backgroundImage: "service_bar", leftViewColor: UIColor(hexString: "#400125"), title: object.categoryName ?? "")
        }
       
        
        return cell
    }
}

// MARK: - DASHBOARD CELL DELEGATE

extension DashboardViewController: DashboardTableViewCellDelegate {
    
    func didTapService(with service: Service, for cellRow: Int, parentRow: Int) {
        
        guard let serviceID = service.id else { return }
        
        guard let parentCell = DashboardCells(rawValue: parentRow) else { return }
        
        switch parentCell {
        case .DueToPayCells:
            guard let utilitesCell = DueToPayCells(rawValue: serviceID) else { return }
            
            switch utilitesCell {
                
            case .PhoneBills:
                let vc = self.getStoryboardView(PhoneBillsViewController.self)
                self.navigationController?.pushViewController(vc, animated: true)
                break
                
            case .Kahramaa:
                let vc = self.getStoryboardView(KahramaaBillsViewController.self)
                self.navigationController?.pushViewController(vc, animated: true)
                break
                
            case .QatarCool:
                let vc = self.getStoryboardView(QatarCoolViewController.self)
                self.navigationController?.pushViewController(vc, animated: true)
                break
                
            case .PearlServices:
                break
                
            case .Stocks:
                let vc = self.getStoryboardView(StocksHomeViewController.self)
                self.navigationController?.pushViewController(vc, animated: true)
                break
            }
            break
            
        case .Transports:
            guard let transportsCell = TransportsCells(rawValue: serviceID) else { return }
            
            switch transportsCell {
            case .Parkings:
                let vc = self.getStoryboardView(ParkingsViewController.self)
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case .DohaMetro:
                let vc = self.getStoryboardView(MetroRailCardsViewController.self)
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case .Limousine:
                let coordinator = BaseInfoCoordinator(navigationController: self.navigationController!,
                                                       configuration: .limousineShared)
                
                let vc = self.getStoryboardView(BaseInfoViewController.self)
                vc.coordinator = coordinator
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case .Taxi:
                let vc = self.getStoryboardView(KarwaTaxiMapViewController.self)
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case .Bus:
                let vc = self.getStoryboardView(KarwaBusCardDetailsViewController.self)
                self.navigationController?.pushViewController(vc, animated: true)
                break
            }
            break
            
        case .E_Shops:
            guard let eshopCell = EShopCells(rawValue: serviceID) else { return }
            switch eshopCell {
            case .Topup:
                let vc = self.getStoryboardView(EStoreTopupViewController.self)
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case .Gift_Cards:
                let vc = self.getStoryboardView(GiftStoresViewController.self)
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case .Instashop:
//                let vc = self.getStoryboardView(MyBookTabBarController.self)
//                self.navigationController?.pushViewController(vc, animated: true)
                break
            case .Coupons:
                let vc = self.getStoryboardView(CouponsViewController.self)
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case .Woqoody:
                break
            case .Kulud_Pharmacy:
                guard let user = self.userProfile.getUser() else { return }
                self.createAccountRequest(user: user, weakify { strong, response in
                    guard let id = response?._id else { return }
                    
                    strong.loginRequest(userID: id, token: user._access_token) {  response2 in
                        guard let loginResponse = response2 else { return }
                        self.userProfile.kuludToken = loginResponse._token
                        let vc = HomeSceneConfigurator.configure()
                        strong.navigationController?.pushViewController(vc, animated: true)
                    }
                })
                break
            }
            break
            
        case .Information:
            guard let informationCell = InformationCells(rawValue: serviceID) else { return }
             switch informationCell {
          
//            case .Violations:
//                break
//            case .Wire:
//                break
//            case .Laundry:
//                break
                 
            case .ChildCare:
                 let coordinator = BaseInfoCoordinator(navigationController: self.navigationController!,
                                                       configuration: .childCareShared
                 )
                 let vc = self.getStoryboardView(BaseInfoViewController.self)
                 vc.coordinator = coordinator
                 self.navigationController?.pushViewController(vc, animated: true)
                 break
                
            case .QatarStayIN:
                 let coordinator = BaseInfoCoordinator(navigationController: self.navigationController!,
                                                       configuration: .hotelShared
                 )
                 let vc = self.getStoryboardView(BaseInfoViewController.self)
                 vc.coordinator = coordinator
                 self.navigationController?.pushViewController(vc, animated: true)
                 break
                
            case .DineInAndOut:
                 let coordinator = BaseInfoCoordinator(navigationController: self.navigationController!,
                                                       configuration: .dineShared
                 )
                 let vc = self.getStoryboardView(BaseInfoViewController.self)
                 vc.coordinator = coordinator
                 self.navigationController?.pushViewController(vc, animated: true)
                 break
                
            case .Insurances:
                 let coordinator = BaseInfoCoordinator(navigationController: self.navigationController!,
                                                       configuration: .insurancesShared
                 )
                 let vc = self.getStoryboardView(BaseInfoViewController.self)
                 vc.coordinator = coordinator
                 self.navigationController?.pushViewController(vc, animated: true)
                 break
                
            case .MedicalCenter:
                 let coordinator = BaseInfoCoordinator(navigationController: self.navigationController!,
                                                       configuration: .medicalCenterShared
                 )
                 let vc = self.getStoryboardView(BaseInfoViewController.self)
                 vc.coordinator = coordinator
                 self.navigationController?.pushViewController(vc, animated: true)
                 break
                
            case .QatarSchools:
                 let coordinator = BaseInfoCoordinator(navigationController: self.navigationController!,
                                                       configuration: .qaterSchoolsShared
                 )
                 let vc = self.getStoryboardView(BaseInfoViewController.self)
                 vc.coordinator = coordinator
                 self.navigationController?.pushViewController(vc, animated: true)
                 break
                
            case .CV:
                let vc = self.getStoryboardView(ShowCVDetailsViewController.self)
                self.navigationController?.pushViewController(vc, animated: true)
                break
                
            case .JobHunt:
                let vc = self.getStoryboardView(JobHuntHomeViewController.self)
                self.navigationController?.pushViewController(vc, animated: true)
                break
            }
            break
            
        case .Charity:
            guard let charityCell = CharityCells(rawValue: serviceID) else { return }
            
            switch charityCell {
            case .Awqaf:
                let vc = self.getStoryboardView(AwqafViewController.self)
                vc.id = serviceID
                self.navigationController?.pushViewController(vc, animated: true)
            case .QatarCharity:
                let vc = self.getStoryboardView(QatarCharityViewController.self)
                vc.id = serviceID
                self.navigationController?.pushViewController(vc, animated: true)
            case .EidCharity:
                let vc = self.getStoryboardView(EidCharityViewController.self)
                vc.id = serviceID
                self.navigationController?.pushViewController(vc, animated: true)
            case .RedCrescent:
                let vc = self.getStoryboardView(QatarRedViewController.self)
                vc.id = serviceID
                self.navigationController?.pushViewController(vc, animated: true)
            }
            break
        }
    }
}

// MARK: - REQUESTS DELEGATE

//extension DashboardViewController: RequestsDelegate {
//
//    func requestStarted(request: RequestType) {
////        if request == .dashboardData ||
//        if  request == .getShopList ||
//            request == .getMetroCards {
//            showLoadingView(self)
//        }
//    }
//
//    func requestFinished(request: RequestType, result: ResponseResult) {
////        hideLoadingView()
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
//            switch result {
//            case .Success(_):
//                break
//            case .Failure(let errorType):
//                switch errorType {
//                case .Exception(let exc):
//                    if showUserExceptions {
//                        self.showErrorMessage(exc)
//                    }
//                    break
//                case .AlamofireError(let err):
//                    if showAlamofireErrors {
//                        self.showSnackMessage(err.localizedDescription)
//                    }
//                    break
//                case .Runtime(_):
//                    break
//                }
//            }
//        }
//    }
//}

// MARK: - Chart View Delegate

extension DashboardViewController: ChartViewDelegate {

    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
//        print(entry)
    }
}

// MARK: - PRIVATE FUNCTIONS

extension DashboardViewController {
    
    private func createAccountRequest(user: User, _ completion: @escaping CallObjectBack<CreateAccountResponse>) {
        self.showLoadingView(self)
        
        let request = AccountBuilder.create(CreateAccountModel(user: user))
        
        Network.shared.request(request: request) { (result: KuludResult<ApiResponse<CreateAccountResponse>>) in
            switch result {
            case .success(let response):
                completion(response.responseObject)
                break
            case .failure(let error):
                self.hideLoadingView(error.localizedDescription)
                completion(nil)
                break
            }
        }
    }
    
    private func loginRequest(userID: String, token: String, _ completion: @escaping CallObjectBack<LoginResponse>) {
        let loginRequest = AccountBuilder.login(LoginModel(userID: userID, token: token))
        
        Network.shared.request(request: loginRequest) { (result: KuludResult<ApiResponse<LoginResponse>>) in
            switch result {
            case .success(let loginResponse):
                self.hideLoadingView()
                DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                    completion(loginResponse.responseObject)
                }
                break
            case .failure(let error):
                self.hideLoadingView(error.localizedDescription)
                completion(nil)
                break
            }
        }
    }
    
    private func setChartDataRange(_ range: Range) {
        self.dailyBottomView.isHidden = range != .Daily
        self.weeklyBottomView.isHidden = range != .Weekly
        self.monthlyBottomView.isHidden = range != .Monthly
    }
    
    private func dashboardChartRequest() {
        self.dispatchGroup.enter()
        
        self.requestProxy.requestService()?.dashboardChartData ( weakify { strong, dashboardChart in
            self.dispatchGroup.leave()
            guard let chart = dashboardChart else { return }
            
            self.chart = chart
        })
        
    }
    
    private func profileRequest() {
        
        self.showLoadingView(self)
        self.dispatchGroup.enter()
        
        self.requestProxy.requestService()?.getUserProfile ( weakify { strong, myProfile in
            self.dispatchGroup.leave()
            guard let profile = myProfile else { return }
            
            self.emailLabel.text = profile._email
            
            let userName = "\(profile._fullName) \(profile._lastName)"
            self.nameLabel.text = userName
            
            guard let imgUrl = profile.imageURL else { return }
            imgUrl.getImageFromURLString { (status, image) in
                guard status else { return }
                self.userImageView.image = image
            }
        })
    }
    
    private func dashboardDataRequest() {
        
        self.dispatchGroup.enter()
        
        self.requestProxy.requestService()?.dashboardData ( weakify { strong, myDashboard in
            strong.dispatchGroup.leave()
            guard let dashboard = myDashboard else { return }
            
            strong.serviceCategories = dashboard.categories ?? []
            
            if let toCollect = dashboard.totalCollected {
                strong.toCollectLabel.text = toCollect.formatNumber()
            }
            
            if let outStanding = dashboard.totalOutstanding {
                strong.outStandingLabel.text = outStanding.formatNumber()
            }
            
            for bill in dashboard.bills ?? [] {
                guard let name = bill.name, let amm = bill.amount,
                      let billType = BillType(rawValue: name) else {
                    continue
                }
                switch billType {
                case .Phone:
                    strong.phoneLabel.text = amm.formatNumber()
                case .Qatar:
                    strong.qatarCoolLabel.text = amm.formatNumber()
                case .Kahrama:
                    strong.kahramaaLabel.text = amm.formatNumber()
                }
            } // End Bills Check
            
        }) // End Request
        
    }
    
    private func setChartView() {
        self.chartView.rightAxis.enabled = false
        self.chartView.legend.enabled = false
        self.chartView.xAxis.enabled = false
        self.chartView.backgroundColor = .clear
        self.chartView.doubleTapToZoomEnabled = false
        self.chartView.animate(yAxisDuration: 2, easingOption: .easeInOutBounce)
        
//        let legend = self.chartView.legend
//        legend.textColor = .white
//        legend.wordWrapEnabled = false
//        legend.font = UIFont.systemFont(ofSize: 12)
//        
        
        let yAxis = self.chartView.leftAxis
        yAxis.labelFont = .systemFont(ofSize: 10)
        yAxis.setLabelCount(11, force: true)
        yAxis.labelTextColor =  .mYellow
        yAxis.axisLineColor = .clear
        yAxis.labelPosition = .outsideChart
        yAxis.drawGridLinesEnabled = false
        yAxis.valueFormatter = CustomYAxisLabelFormatter()
        yAxis.spaceBottom = 2
        yAxis.axisMinimum = 0
        
       
        
//        
//        let xAxis = self.chartView.xAxis
//        xAxis.labelFont = .boldSystemFont(ofSize: 8)
//        xAxis.labelTextColor = .white
//        xAxis.axisLineColor = .clear
//        xAxis.labelPosition = .bottom
//        xAxis.drawGridLinesEnabled = false
        
        
        self.chartView.delegate = self
    }
    
    private func setChartDataDaily() {
        self.setChartDataRange(.Daily)
        self.range = .Daily
        guard let dailyData = self.chart?.dailyData else { return }
        
        let xAxis = self.chartView.xAxis
        xAxis.setLabelCount(dailyData.count, force: false)
        xAxis.valueFormatter = DaysXAxisLabelFormatter()
        
        let chartServices = ChartDataService.allCases
        var dataSets = [LineChartDataSet]()
        
        chartServices.forEach { (chartService) in
            var yValues = [ChartDataEntry]()
            
            var count = 0
            dailyData.forEach { (daily) in
                
                for service in daily.services ?? [] {
                    guard service.name == chartService.rawValue,
                          let amount = service.amount else {
                        continue
                    }
                    yValues.append(.init(x: Double(count), y: amount))
                    count += 1
                }
            }
            
            let set = LineChartDataSet(entries: yValues, label: chartService.rawValue)
            dataSets.append(self.setChartDataSetStyle(set, dataService: chartService))
        }
        self.setChartData(dataSets)
    }
    
    private func setChartDataWeekly() {
        self.setChartDataRange(.Weekly)
        self.range = .Weekly
        guard let weeklyData = self.chart?.weeklyData else { return }
        
        let xAxis = self.chartView.xAxis
        xAxis.setLabelCount(weeklyData.count, force: false)
        xAxis.valueFormatter = WeeksXAxisLabelFormatter()
        
        let chartServices = ChartDataService.allCases
        var dataSets = [LineChartDataSet]()
        
        chartServices.forEach { (chartService) in
            var yValues = [ChartDataEntry]()
            
            var count = 0
            for weekly in weeklyData {
                guard let services = weekly.services, let week = weekly.week else { continue }
                
                for (_, service) in services.enumerated() {
                    guard service.name == chartService.rawValue, let week = Double(week) else { continue }
                    yValues.append(ChartDataEntry(x: week, y: service.amount ?? 0.0))
                    count += 1
                }
            }
            
            let set = LineChartDataSet(entries: yValues, label: chartService.rawValue)
            dataSets.append(self.setChartDataSetStyle(set, dataService: chartService))
        }
        self.setChartData(dataSets)
    }
    
    private func setChartDataMonthly() {
        self.setChartDataRange(.Monthly)
        self.range = .Monthly
        guard let monthlyData = self.chart?.monthlyData else { return }
        
        let xAxis = self.chartView.xAxis
        xAxis.setLabelCount(monthlyData.count, force: false)
        xAxis.valueFormatter = MonthsXAxisLabelFormatter()
        
        let chartServices = ChartDataService.allCases
        var dataSets = [LineChartDataSet]()
        
        chartServices.forEach { (chartService) in
            var yValues = [ChartDataEntry]()
            
            var count = 1
            for monthly in monthlyData {
                guard let services = monthly.services else { continue }
                
                for (_, service) in services.enumerated() {
                    guard service.name == chartService.rawValue, let amount = service.amount else { continue }
                    yValues.append(ChartDataEntry(x: Double(count), y: amount))
                    count += 1
                }
            }
            
            let set = LineChartDataSet(entries: yValues, label: chartService.rawValue)
            dataSets.append(self.setChartDataSetStyle(set, dataService: chartService))
        }
        self.setChartData(dataSets)
    }
    
    private func setChartDataSetStyle(_ set: LineChartDataSet, dataService: ChartDataService) -> LineChartDataSet {
        
        set.mode = .cubicBezier
        set.fill = ColorFill(cgColor: UIColor.clear.cgColor)
        set.fillAlpha = 0.3
        set.form = .circle
        set.formSize = 5
        set.drawFilledEnabled = true
        set.drawCirclesEnabled = false
        set.lineWidth = 2
        set.highlightEnabled = false
        
        
        switch dataService {
        case .Shopping:
            set.setColor(.mChart_Shopping)
        case .Charity:
            set.setColor(.mChart_Charity)
        case .Bills:
            set.setColor(.mChart_Bills)
        case .E_Shops:
            set.setColor(.mChart_E_Shops)
        case .Transport:
            set.setColor(.mChart_Transport)
        case .Wallet:
            set.setColor(.mChart_Wallet)
        }
        return set
    }
    
    private func setChartData(_ dataSets: [LineChartDataSet]) {
        let data = LineChartData(dataSets: dataSets)
        data.setDrawValues(false)
        self.chartView.data = data
        self.holderStackView.isHidden = false
        self.widthOfYAxisConstrain.constant = self.chartView.leftAxis.requiredSize().width
        self.collectionView.reloadData()
    }
}

/*
 Category Due to Pay
 Service Phone Bills
 Service Kahrama
 Service Qatar Cool
 Service Pearl Services
 
 Category Transports
 Service Taxi
 Service BUS
 Service Doha Metro
 Service Parkings
 Service Limousine
 
 Category E-Shops
 Service Top-Up
 Service Gift Cards
 Service Theaters
 Service Coupons
 Service Shafaf
 
 Category Information
 Service Stocks
 Service Violations
 Service Wire Transfer
 Service Laundry
 
 Category Charity
 Service Awqaf
 Service Qatar Charity
 Service Eid Charity
 Service Red Crescent
 
 Category DtOne
 */

fileprivate enum DashboardCells: Int, CaseIterable {
    case DueToPayCells = 0
    case Transports
    case E_Shops
    case Information
    case Charity
}

fileprivate enum DueToPayCells: Int, CaseIterable {
    case PhoneBills = 1
    case Kahramaa
    case QatarCool
    case Stocks = 28
    case PearlServices
}

fileprivate enum TransportsCells: Int, CaseIterable {
    case Parkings = 5
    case DohaMetro
    case Limousine
    case Taxi
    case Bus
}

fileprivate enum EShopCells: Int, CaseIterable {
    case Topup = 10
    case Gift_Cards
    case Instashop
    case Coupons
    case Woqoody
    case Kulud_Pharmacy = 27
}

fileprivate enum InformationCells: Int, CaseIterable {
//    case Stocks = 15
//    case Violations
//    case Wire
//    case Laundry
    case ChildCare = 18
    case QatarStayIN = 31
    case DineInAndOut
    case Insurances
    case MedicalCenter
    case QatarSchools
    case CV
    case JobHunt
}

fileprivate enum CharityCells: Int, CaseIterable {
    case Awqaf = 19
    case QatarCharity
    case EidCharity
    case RedCrescent
}

fileprivate enum ChartDataService: String, CaseIterable {
    case Shopping
    case Bills
    case Wallet
    case E_Shops = "E-Shops"
    case Charity
    case Transport
}

fileprivate class CustomYAxisLabelFormatter: AxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return "\(value.formatNumber()) QAR"
    }
}

fileprivate class DaysXAxisLabelFormatter: AxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
        let number = ceil(value)
        let intVal = Int(number)
        
        if let day = Day(rawValue: intVal) {
            return day.description
        }
        return ""
    }
}

fileprivate class WeeksXAxisLabelFormatter: AxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
        let intVal = Int(value)
        return intVal.description
    }
}

fileprivate class MonthsXAxisLabelFormatter: AxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let intVal = Int(value)
        if let month = Month(rawValue: intVal) {
            return month.description
        }
        return ""
    }
}

//    var yValues = [ChartDataEntry]()
//        ChartDataEntry(x: 0.0, y: 10.0),
//        ChartDataEntry(x: 1.0, y: 6.0),
//        ChartDataEntry(x: 2.0, y: 10.0),
//        ChartDataEntry(x: 3.0, y: 99.0),
//        ChartDataEntry(x: 4.0, y: 44.0),
//        ChartDataEntry(x: 5.0, y: 5.0),
//        ChartDataEntry(x: 6.0, y: 10.0),
//        ChartDataEntry(x: 7.0, y: 1.0),
//        ChartDataEntry(x: 8.0, y: 66.0),
//        ChartDataEntry(x: 9.0, y: 10.0)
//    ]
    
/* Dashboard Data Response ...
 {
 "Balance": 15.0000,
 "BannersList": [
    {
     "BannerID": 1,
     "BannerLocation": "https://www.noqoodypay.com/images/1.jpg"
     },
     {
     "BannerID": 2,
     "BannerLocation": "https://www.noqoodypay.com/images/2.jpg"
     },
     {
     "BannerID": 3,
     "BannerLocation": "https://www.noqoodypay.com/images/3.jpg"
    }
    ],
 "CurrentBills": null,
     "ServiceList": [
     {
     "CategoryID": 1,
     "CategoryName": "Due to Pay",
     "ServiceList": [
     {
     "ServiceID": 1,
     "ServiceName": "Phone Bills",
     "ImageLocation": "http://www.noqoodypal.com/api/uploads/services/phone-billsnew.png",
     "Count": 65
     },
     {
     "ServiceID": 2,
     "ServiceName": "Kahrama",
     "ImageLocation": "http://www.noqoodypal.com/api/uploads/services/electricitynew.png",
     "Count": 62
     },
     {
     "ServiceID": 3,
     "ServiceName": "Qatar Cool",
     "ImageLocation": "http://www.noqoodypal.com/api/uploads/services/QatarCool.png",
     "Count": 54
     },
     {
     "ServiceID": 4,
     "ServiceName": "Pearl Services",
     "ImageLocation": "http://www.noqoodypal.com/api/uploads/services/pearlTVnew.png",
     "Count": 28
     }
     ]
     },
     {
     "CategoryID": 2,
     "CategoryName": "Transports",
     "ServiceList": [
     {
     "ServiceID": 8,
     "ServiceName": "Taxi",
     "ImageLocation": "http://www.noqoodypal.com/api/uploads/services/taxi.png",
     "Count": 0
     },
     {
     "ServiceID": 9,
     "ServiceName": "BUS",
     "ImageLocation": "http://www.noqoodypal.com/api/uploads/services/qbusnew.png",
     "Count": 0
     },
     {
     "ServiceID": 6,
     "ServiceName": "Doha Metro",
     "ImageLocation": "http://www.noqoodypal.com/api/uploads/services/metro.png",
     "Count": 0
     },
     {
     "ServiceID": 5,
     "ServiceName": "Parkings",
     "ImageLocation": "http://www.noqoodypal.com/api/uploads/services/qparkingnew.png",
     "Count": 0
     },
     {
     "ServiceID": 7,
     "ServiceName": "Limousine",
     "ImageLocation": "http://www.noqoodypal.com/api/uploads/services/icon-limo.png",
     "Count": 0
     }
     ]
     },
     {
     "CategoryID": 3,
     "CategoryName": "E-Shops",
     "ServiceList": [
     {
     "ServiceID": 10,
     "ServiceName": "Top-Up",
     "ImageLocation": "http://www.noqoodypal.com/api/uploads/services/mobiletopupnew.png",
     "Count": 0
     },
     {
     "ServiceID": 11,
     "ServiceName": "Gift Cards",
     "ImageLocation": "http://www.noqoodypal.com/api/uploads/services/iplayinnew.png",
     "Count": 0
     },
     {
     "ServiceID": 12,
     "ServiceName": "Theaters",
     "ImageLocation": "http://www.noqoodypal.com/api/uploads/services/theaters.png",
     "Count": 0
     },
     {
     "ServiceID": 13,
     "ServiceName": "Coupons",
     "ImageLocation": "http://www.noqoodypal.com/api/uploads/services/icon-coupon.png",
     "Count": 0
     },
     {
     "ServiceID": 14,
     "ServiceName": "Shafaf",
     "ImageLocation": "http://www.noqoodypal.com/api/uploads/services/gasnew.png",
     "Count": 0
     }
     ]
     },
     {
     "CategoryID": 4,
     "CategoryName": "Information",
     "ServiceList": [
     {
     "ServiceID": 15,
     "ServiceName": "Stocks",
     "ImageLocation": "http://www.noqoodypal.com/api/uploads/services/icon-stocks.png",
     "Count": 0
     },
     {
     "ServiceID": 16,
     "ServiceName": "Violations",
     "ImageLocation": "http://www.noqoodypal.com/api/uploads/services/icon-violation.png",
     "Count": 0
     },
     {
     "ServiceID": 17,
     "ServiceName": "Wire Transfer",
     "ImageLocation": "http://www.noqoodypal.com/api/uploads/services/icon-transfers.png",
     "Count": 0
     },
     {
     "ServiceID": 18,
     "ServiceName": "Laundry",
     "ImageLocation": "http://www.noqoodypal.com/api/uploads/services/icon-laundry.png",
     "Count": 0
     }
     ]
     },
     {
     "CategoryID": 5,
     "CategoryName": "Charity",
     "ServiceList": [
     {
     "ServiceID": 19,
     "ServiceName": "Awqaf",
     "ImageLocation": "http://www.noqoodypal.com/api/uploads/services/awqaf.png",
     "Count": 0
     },
     {
     "ServiceID": 20,
     "ServiceName": "Qatar Charity",
     "ImageLocation": "http://www.noqoodypal.com/api/uploads/services/QatarCharity.png",
     "Count": 0
     },
     {
     "ServiceID": 21,
     "ServiceName": "Eid Charity",
     "ImageLocation": "http://www.noqoodypal.com/api/uploads/services/EidCharity.png",
     "Count": 0
     },
     {
     "ServiceID": 22,
     "ServiceName": "Red Crescent",
     "ImageLocation": "http://www.noqoodypal.com/api/uploads/services/RedCrecent.png",
     "Count": 0
     }
     ]
     },
     {
     "CategoryID": 7,
     "CategoryName": "DtOne",
     "ServiceList": []
     }
     ],
     "BillDetails": [
     {
     "Name": "Phone Bills",
     "ID": 1,
     "Amount": 90.398023738711200
     },
     {
     "Name": "Qatar Cool",
     "ID": 3,
     "Amount": 47.515577472520800
     },
     {
     "Name": "Kahrama",
     "ID": 2,
     "Amount": 93.927965589765400
     }
     ],
 "TotalCollected": 100.0,
 "TotalOutstanding": 231.841566800997400,
 "success": true,
 "code": "OK",
 "message": "",
 "errors": []
 }
 */
