//
//  HomeMainVC.swift
//  WhereYa
//
//  Created by 홍진석 on 2021/05/25.
//

import UIKit

class HomeMainVC: UIViewController {

    @IBOutlet var backgroundView: UIView!
    @IBOutlet var promiseName: UILabel!
    @IBOutlet var alarmLabel: UILabel!
    @IBOutlet var roomBtn: UIButton!
    @IBOutlet var recommendTV: UITableView!
    @IBOutlet var recommendMaidnView: UIView!
    
    let refreshContol = UIRefreshControl()
    var restaurants : [Place] = []
    var cafes : [Place] = []
    var mainNoticePromise : MainNoticePromise?
    var promiseDelegate : dataDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMainData()
        setUI()
        setTableView()
        setTimer()
    }
    
    // MARK: - UISetting
    func setUI(){
        self.promiseName.font = UIFont.myBoldSystemFont(ofSize: 26)
        self.alarmLabel.font = UIFont.myMediumSystemFont(ofSize: 20)
        self.backgroundView.backgroundColor = .mainBlueColor
        self.recommendMaidnView.layer.cornerRadius = 10
        self.recommendMaidnView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
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
            self.getMainData()
            refresh.endRefreshing()
        }
    }
    @IBAction func roomBtnClicked(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "GroupRoom", bundle: nil)
        let nextVC = storyboard.instantiateViewController(identifier: GroupRoomVC.identifier)  as! GroupRoomVC

        if let promise = mainNoticePromise?.promise{
            self.promiseDelegate = nextVC
            promiseDelegate?.sendPromise(promise)
        }
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true, completion: nil)
    }
 
    // MARK: - getNearCafeData
    
    func getNearCafeData(_ promise : MainNoticePromise){
        ActivityIndicator.shared.activityIndicator.startAnimating()
        
        let x = Double((mainNoticePromise?.promise?.destination?.x ?? "0"))
        let y = Double((mainNoticePromise?.promise?.destination?.y ?? "0"))
        
        PlaceService.shared.getNearPlace(longitude : x ?? 0, latitude : y ?? 0, categoryCode: PlaceCategoryInfo.cafe.rawValue) { (result) in
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
    func getNearFoodData(_ promise : MainNoticePromise){
        ActivityIndicator.shared.activityIndicator.startAnimating()
        
        let x = Double((promise.promise?.destination?.x ?? "0"))
        let y = Double((promise.promise?.destination?.y ?? "0"))
        
        PlaceService.shared.getNearPlace(longitude : x ?? 0, latitude : y ?? 0, categoryCode: PlaceCategoryInfo.food.rawValue) { [self] (result) in
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
    func getMainData(){
        ActivityIndicator.shared.activityIndicator.startAnimating()
        
        
        PromiseService.shared.getMainPromise{ (result) in
            ActivityIndicator.shared.activityIndicator.stopAnimating()
            
            switch result{
        
            case .success(let data) :
                if let promise = data as? MainNoticePromise{
                    self.mainNoticePromise = promise
                    self.setMainLabel()
                    self.getNearCafeData(promise)
                    self.getNearFoodData(promise)
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
        if let mpromise = self.mainNoticePromise?.promise, let mtime = self.mainNoticePromise?.lefttime{
            self.promiseName.text = mpromise.name
            self.alarmLabel.text = "약속까지 \(self.setTimeLabel(mtime.day ?? 0, mtime.hour ?? 0, mtime.minute ?? 0))남았어요!\n\(mpromise.destination?.place_name ?? " ")으로 가야해요."
        }
    }
    
    //약속 시간 텍스트 설정
    func setTimeLabel(_ day : Int, _ hour : Int, _ minute : Int) -> String{
        if(day == 0){
            if(hour > 0){return "\(hour)시간 \(minute)분"}
            else{return "\(minute)분"}
        }
        else{return "\(day)일"}
    }
    
    func setTimer(){
        let timeSelector : Selector = #selector(self.updateTime)
        
        Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: timeSelector, userInfo: nil, repeats: true)
    }
    
    @objc func updateTime(){
        if let hour = self.mainNoticePromise?.lefttime?.hour, let minute = self.mainNoticePromise?.lefttime?.minute{
            if(minute > 0){self.mainNoticePromise?.lefttime?.minute! -= 1}
            else{
                if(hour > 0){
                    self.mainNoticePromise?.lefttime?.hour!-=1
                    self.mainNoticePromise?.lefttime?.hour = 59
                }
                else{
                    self.mainNoticePromise?.lefttime?.hour = 0
                    self.mainNoticePromise?.lefttime?.minute = 0
                }
            }
            self.setMainLabel()
        }
    }
    
    @IBAction func makePromise(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "PromiseMake", bundle: nil)
        let firstVC = storyboard.instantiateViewController(identifier:"PromiseMakeNavigationVC")  as! PromiseMakeNavigationVC
        
        firstVC.modalTransitionStyle = .coverVertical
        firstVC.modalPresentationStyle = .fullScreen
        self.present(firstVC, animated: true, completion: nil)
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

