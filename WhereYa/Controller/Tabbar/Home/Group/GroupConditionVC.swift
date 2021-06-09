//
//  GroupConditionVC.swift
//  WhereYa
//
//  Created by 홍진석 on 2021/06/06.
//

import UIKit

class GroupConditionVC: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var conditionTV: UITableView!
        
    private let sections: [String] = ["도착", "오는 중"]
    private var arrivedFriends : [UserLocation] = []
    private var commingFriends : [UserLocation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setTableView()

    }
    
    func setUI(){
        titleLabel.font = UIFont.myBoldSystemFont(ofSize: 23)
        titleLabel.textColor = .mainBlueColor
    }
    
    func setTableView(){
        conditionTV.delegate = self
        conditionTV.dataSource = self
        conditionTV.separatorStyle = .none
        conditionTV.register(UINib(nibName: ConditionTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ConditionTableViewCell.identifier)
    }

    @IBAction func downBtnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension GroupConditionVC : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return sections[section]
    }
    
}
extension GroupConditionVC : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section{
        case 0:
            return self.arrivedFriends.count
        case 1:
            return self.commingFriends.count
            
        default: return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ConditionTableViewCell.identifier, for: indexPath) as! ConditionTableViewCell
        
        var usingArray : [UserLocation] = []
        var shadowColor : CGColor?
        switch indexPath.section{
        case 0 :
            usingArray = self.arrivedFriends
            shadowColor = UIColor.green.cgColor
        case 1 :
            usingArray = self.commingFriends
            shadowColor = UIColor.darkPink85.cgColor
        default: break
        }
        
        cell.setData(nickname: usingArray[indexPath.row].name!, img: usingArray[indexPath.row].characterImg!)
        cell.innerView.layer.shadowColor = shadowColor
        
        return cell
    }
}

extension GroupConditionVC : dataDelegate{
    func hiddenUI(hidden: Bool) {}
    
    func sendPromise(_ promise: Promise) {}
    
    func sendUserLocation(_ userlocations: [UserLocation]){
       
        for user in userlocations{
        
            if !(user.touchdown ?? false){
                commingFriends.append(user)
            }
            else{arrivedFriends.append(user)}
        }
        
    }
    
    
}
