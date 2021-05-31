//
//  HomeMainVC.swift
//  WhereYa
//
//  Created by 홍진석 on 2021/05/25.
//

import UIKit

class HomeMainVC: UIViewController {

    @IBOutlet var promiseName: UILabel!
    @IBOutlet var alarmLabel: UILabel!
    @IBOutlet var roomBtn: UIButton!
    @IBOutlet var recommendTV: UITableView!
    @IBOutlet var recommendMaidnView: UIView!
    
    let refreshContol = UIRefreshControl()
    var restaurants : [Place] = []
    var cafes : [Place] = []
    var mainLeftDay : Int = 0
    var mainLeftHour : Int = 0
    var mainLeftMinute : Int = 0
    var mainName : String = " "
    var mainPlaceName : String = " "
    var mainPlaceTime : String = " "
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getNearCafeData()
        getNearFoodData()
        getMainPromiseData()
        setUI()
        setTableView()
        setTimer()
    }
    
    // MARK: - UISetting
    func setUI(){
        roomBtn.layer.cornerRadius = 10
        promiseName.text = "동창회 약속"
        recommendMaidnView.backgroundColor = UIColor.mainBlueColor
    }
    
    // MARK: - TableViewSetting
    
    func setTableView(){
        recommendTV.delegate = self
        recommendTV.dataSource = self
        
        recommendTV.register(UINib(nibName: RecommendFoodTVC.identifier, bundle: nil), forCellReuseIdentifier: RecommendFoodTVC.identifier)
        recommendTV.register(UINib(nibName: RecommendCafeTVC.identifier, bundle: nil), forCellReuseIdentifier: RecommendCafeTVC.identifier)

        recommendTV.separatorStyle = .none
        recommendTV.rowHeight = UITableView.automaticDimension
        recommendTV.tableFooterView = UIView()
        
        refreshContol.addTarget(self, action: #selector(refreshTable(refresh:)), for: .valueChanged)
        
        refreshContol.tintColor = .mainBlueColor
        //refreshContol.attributedTitle = NSAttributedString(string: "임의 이름")
        
        recommendTV.refreshControl = refreshContol
    }
    
    @objc func refreshTable(refresh: UIRefreshControl){
        print("refresh")
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
            
            self.recommendTV.reloadData()
            self.getMainPromiseData()
            refresh.endRefreshing()
        }
    }
    @IBAction func roomBtnClicked(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "GroupRoom", bundle: nil)
        let nextVC = storyboard.instantiateViewController(identifier: GroupRoomVC.identifier)  as! GroupRoomVC

        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true, completion: nil)
    }
 
    // MARK: - getNearCafeData
    
    func getNearCafeData(){
        ActivityIndicator.shared.activityIndicator.startAnimating()
        
        PlaceService.shared.getNearPlace(categoryCode: PlaceCategoryInfo.cafe.rawValue) { (result) in
            ActivityIndicator.shared.activityIndicator.stopAnimating()
            
            switch result{
            
            case .success(let data) :
                if let places = data as? [Place]{
                    self.updatePlaces(from: places,PlaceCategoryInfo.cafe.rawValue)
                }
            case .requestErr(_) : print(NetworkInfo.BAD_REQUEST)
            case .serverErr:
                print(NetworkInfo.SERVER_FAIL)
                return
            case .networkFail:
                print(NetworkInfo.NETWORK_FAIL)
                return
            }
        }
    }
    // MARK: - getNearRestaurantsData
    func getNearFoodData(){
        ActivityIndicator.shared.activityIndicator.startAnimating()
        
        
        PlaceService.shared.getNearPlace(categoryCode: PlaceCategoryInfo.food.rawValue) { [self] (result) in
            ActivityIndicator.shared.activityIndicator.stopAnimating()
            
            switch result{
        
            case .success(let data) :
                if let places = data as? [Place]{
                    self.updatePlaces(from: places,PlaceCategoryInfo.food.rawValue)
                }
                
            case .requestErr(_) : print(NetworkInfo.BAD_REQUEST)
            case .serverErr:
                print(NetworkInfo.SERVER_FAIL)
                return
            case .networkFail:
                print(NetworkInfo.NETWORK_FAIL)
                return
            }
        }
    }
    
    // MARK: - updatePlaces
    func updatePlaces(from data : [Place], _ rawvalue : String){
        switch rawvalue{
        case PlaceCategoryInfo.cafe.rawValue:
            self.cafes = data
        case PlaceCategoryInfo.food.rawValue:
            self.restaurants = data
        default:
            break
        }
        self.recommendTV.reloadData()
    }
    
    // MARK: - getMainPromiseData
    func getMainPromiseData(){
        ActivityIndicator.shared.activityIndicator.startAnimating()
        
        
        PromiseService.shared.getMainPromise{ (result) in
            ActivityIndicator.shared.activityIndicator.stopAnimating()
            
            switch result{
        
            case .success(let data) :
                if let promise = data as? MainNoticePromise{
                    self.mainLeftDay = promise.lefttime?.day ?? 0
                    self.mainLeftHour = promise.lefttime?.hour ?? 0
                    self.mainLeftMinute = promise.lefttime?.minute ?? 0
                    self.mainName = promise.promise!.name!
                    self.mainPlaceName = promise.promise?.destination?.place_name! ?? " "
                    self.mainPlaceTime = promise.promise!.time!
                    
                    self.setMainLabel()
                }
                
            case .requestErr(_) : print(NetworkInfo.BAD_REQUEST)
            case .serverErr:
                print(NetworkInfo.SERVER_FAIL)
                return
            case .networkFail:
                print(NetworkInfo.NETWORK_FAIL)
                return
            }
        }
    }
    
    func setMainLabel(){
        self.promiseName.text = self.mainName
        self.alarmLabel.text = "약속까지 \(self.setTimeLabel(self.mainLeftDay, self.mainLeftHour, self.mainLeftMinute))남았어요\n\(self.mainPlaceName)으로 \(self.mainPlaceTime)까지 가야해요"
    }
    
    //약속 시간 텍스트 설정
    func setTimeLabel(_ day : Int, _ hour : Int, _ minute : Int) -> String{
        if(day == 0){
            if(hour > 0){
                return "\(hour)시간 \(minute)분"
            }
            else{return "\(minute)분"}
        }
        else{
            return "\(day)일"
        }
    }
    
    func setTimer(){
        let timeSelector : Selector = #selector(self.updateTime)
        
        Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: timeSelector, userInfo: nil, repeats: true)
    }
    
    @objc func updateTime(){
        if(mainLeftMinute > 0){mainLeftMinute -= 1}
        else{
            if(mainLeftHour > 0){
                mainLeftHour-=1
                mainLeftMinute = 59
            }
            else{
                mainLeftHour = 0
                mainLeftMinute = 0
            }
        }
        self.setMainLabel()
    }
}


// MARK: - TableView
extension HomeMainVC : UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let width = UIScreen.main.bounds.width

        switch indexPath.row{
        case 0: return width * (270/375)
        case 1: return width * (270/375)
        default: return 0
        }
    }
}
extension HomeMainVC : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RecommendPlaceType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row{
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: RecommendFoodTVC.identifier, for: indexPath) as! RecommendFoodTVC
            cell.list = restaurants
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: RecommendCafeTVC.identifier, for: indexPath) as! RecommendCafeTVC
            cell.list = cafes
            return cell
            
        default :
            return UITableViewCell()
        }
    }
}

