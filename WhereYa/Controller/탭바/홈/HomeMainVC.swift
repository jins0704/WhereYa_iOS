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
    
    var restaurants : [Place] = []
    var cafes : [Place] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getNearCafeData()
        getNearFoodData()
        setUI()
        setTableView()
        
    }
    
    // MARK: - UISetting
    func setUI(){
        promiseName.text = "동창회 약속"
        alarmLabel.text = "30분 남았어요\n판교역으로 6시까지 가야해요"
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
            case .requestErr(_) : print("requeestErr")
            case .serverErr:
                print(".serverErr")
                return
            case .networkFail:
                print("network_error")
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
                
            case .requestErr(_) : print("requeestErr")
            case .serverErr:
                print(".serverErr")
                return
            case .networkFail:
                print("network_error")
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
        return 2
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

