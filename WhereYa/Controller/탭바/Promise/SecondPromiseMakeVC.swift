//
//  SecondPromiseMakeVC.swift
//  WhereYa
//
//  Created by 홍진석 on 2021/03/31.
//

import UIKit

class SecondPromiseMakeVC: UIViewController, MTMapViewDelegate {
    
    var name : String?
    var memo : String?
    
    private var placeList : [Place] = []
    private let cellIdentifier : String = "placeSearchTableViewCell"
    
    @IBOutlet var placeSearchTextField: UITextField!
    @IBOutlet var placeSearchTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
        
        placeSearchTableView.delegate = self
        placeSearchTableView.dataSource = self
        
        placeSearchTableView.register(UINib(nibName: "PlaceSearchTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
    }
    @IBAction func backBtnClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func placeSearchBtnClicked(_ sender: Any) {
        if let searchInput : String = placeSearchTextField.text{
            print(searchInput)
            PlaceService.shared.getPlace(searchInput: searchInput) { (data) in
                
                ActivityIndicator.shared.activityIndicator.stopAnimating()
                
                switch data{
                
                case .success(let result) :
                    print(result)
                    if let places = result as? [Place]{
                        self.placeList = places
                        print("asd")
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
    /*
     
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension SecondPromiseMakeVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : PlaceSearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PlaceSearchTableViewCell
        
        cell.selectionStyle = .none
        
        cell.mainLabel.text = placeList[indexPath.row].place_name
        cell.subLabel.text = placeList[indexPath.row].address_name
        print(placeList[indexPath.row].x)
        print(placeList[indexPath.row].y)
        
        return cell
    }
}

extension SecondPromiseMakeVC : UIGestureRecognizerDelegate{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
         self.view.endEditing(true)
   }
}
