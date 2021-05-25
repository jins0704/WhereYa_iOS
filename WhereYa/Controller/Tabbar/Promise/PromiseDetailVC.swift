//
//  PromiseDetailVC.swift
//  WhereYa
//
//  Created by 홍진석 on 2021/04/14.
//

import UIKit

class PromiseDetailVC: UIViewController {

    var promiseName : String?
    var promisePlace : String?
    var promiseTime : String?
    var promiseAddress : String?
    var promiseMemo : String?
    var promiseFriend : [String?] = []
    var friends : String = ""
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var placeLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var friendsLabel: UILabel!
    @IBOutlet var memoLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        viewSetting()
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteBtnClicked(_ sender: Any) {
        let alert = UIAlertController(title: "정말로 삭제하시겠습니까?" , message: " ", preferredStyle: .alert)
        
        let deleteBtn = UIAlertAction(title: "확인", style: .default) { (delete) in
           
        }
        
        let cancelBtn = UIAlertAction(title: "취소", style: .cancel) { (cancel) in
        }
        
        alert.addAction(deleteBtn)
        alert.addAction(cancelBtn)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func viewSetting(){
        nameLabel.text = promiseName
        timeLabel.text = promiseTime
        placeLabel.text = promisePlace
        addressLabel.text = promiseAddress
        
        memoLabel.layer.borderWidth = 0.5
        memoLabel.layer.borderColor = UIColor.gray.cgColor
        memoLabel.backgroundColor = .white
        memoLabel.text = promiseMemo

        for i in promiseFriend{
            friends.append("\(i ?? " ")\n")
        }
        friendsLabel.numberOfLines = promiseFriend.count + 1
        friendsLabel.text = friends
    }
    /*
    // MARK: - Navigation
    */

}
