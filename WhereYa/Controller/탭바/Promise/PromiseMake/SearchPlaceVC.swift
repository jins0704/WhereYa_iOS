//
//  SecondPromiseMakeVC.swift
//  WhereYa
//
//  Created by 홍진석 on 2021/03/31.
//

import UIKit

class SearchPlaceVC: UIViewController, MTMapViewDelegate{
    
    var popupDelegate : PopUpDelegate?
    var placeName : String?
    
    private var placeList : [Place] = []
    private let cellIdentifier : String = "placeSearchTableViewCell"
    
    @IBOutlet var placeSearchTextField: UITextField!
    @IBOutlet var placeSearchTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
        
        placeSearchTextField.returnKeyType = .search
        
        placeSearchTableView.delegate = self
        placeSearchTableView.dataSource = self
        
        placeSearchTableView.register(UINib(nibName: "PlaceSearchTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
    }
    @IBAction func backBtnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func placeSearchBtnClicked(_ sender: Any) {
        if let searchInput : String = placeSearchTextField.text{
            print(searchInput)
            PlaceService.shared.getPlace(searchInput: searchInput) { (data) in
                
                ActivityIndicator.shared.activityIndicator.stopAnimating()
                
                switch data{
                
                case .success(let result) :
                 
                    if let places = result as? [Place]{
                        self.placeList = places
                    }
                    self.placeSearchTableView.reloadData()
                    
                case .requestErr(let message):
                    print(message)
                    return
                    
                case .serverErr:
                    print("serverErr")
                    return
                    
                case .networkFail:
                    print("networkFail")
                    return
                    
                }
            }
        }
        self.view.endEditing(true)
    }
    

}
extension SearchPlaceVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : PlaceSearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PlaceSearchTableViewCell
        
        cell.mainLabel.text = placeList[indexPath.row].place_name
        cell.subLabel.text = placeList[indexPath.row].address_name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        if let cell = tableView.cellForRow(at: indexPath) as?
            PlaceSearchTableViewCell{
            
            let selectedPlace : Place = Place(cell.mainLabel.text ?? "", cell.subLabel.text ?? "", cell.longitudeX ?? "", cell.latitudeY ?? "")
            
            popupDelegate?.placeClicked(place: selectedPlace)
            print("전달")
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension SearchPlaceVC : UIGestureRecognizerDelegate{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
         self.view.endEditing(true)
   }
}
