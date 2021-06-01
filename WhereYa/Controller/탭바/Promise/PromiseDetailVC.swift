//
//  PromiseDetailVC.swift
//  WhereYa
//
//  Created by 홍진석 on 2021/04/14.
//

import UIKit

class PromiseDetailVC: UIViewController{
    var mainPromise : Promise?
    var promiseName : String?
    var promisePlace : String?
    var promiseTime : String?
    var promiseAddress : String?
    var promiseMemo : String?
    var promiseFriend : [String?] = []
    @IBOutlet var downBtn: UIButton!
    var friends : String = ""
    
    var promiseDelegate : PromiseDelegate?
    
    @IBOutlet var infoView: UIView!
    @IBOutlet var deleteBtn: UIButton!
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var placeLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var friendsLabel: UILabel!
    @IBOutlet var memoTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setUI()
    }
    
    @IBAction func downBtnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
    
    func setUI(){
        self.downBtn.isHidden = true
        setLabel()
        nameLabel.font = UIFont.myBoldSystemFont(ofSize: 23)
        timeLabel.font = UIFont.myMediumSystemFont(ofSize: 15)
        placeLabel.font = UIFont.myMediumSystemFont(ofSize: 15)
        addressLabel.font = UIFont.myMediumSystemFont(ofSize: 15)
        friendsLabel.font = UIFont.myMediumSystemFont(ofSize: 15)
        
        infoView.layer.borderWidth = 0.5
        infoView.layer.cornerRadius = 10
        infoView.layer.borderColor = UIColor.gray.cgColor
        memoTextView.layer.borderWidth = 0.5
        memoTextView.layer.cornerRadius = 10
        memoTextView.layer.borderColor = UIColor.gray.cgColor
        memoTextView.isEditable = false
        memoTextView.font = UIFont.myRegularSystemFont(ofSize: 15)
        memoTextView.text = "\n\(promiseMemo ?? "")"

        for i in promiseFriend{
            if(i == promiseFriend.last){friends.append("\(i ?? " ")")}
            else{friends.append("\(i ?? " "), ")}
        }
        friendsLabel.numberOfLines = promiseFriend.count + 1
        friendsLabel.text = friends
    }
    
    func setLabel(){
        nameLabel.text = promiseName
        timeLabel.text = promiseTime
        placeLabel.text = promisePlace
        addressLabel.text = promiseAddress
    }
}

// MARK: - hiddenDelegate

extension PromiseDetailVC : PromiseDelegate{
    func sendPromise(_ promise: Promise) {
        self.promiseName = promise.name
        self.promiseTime = promise.time
        self.promiseMemo = promise.memo
        self.promisePlace = promise.destination?.place_name
        self.promiseAddress = promise.destination?.address_name
        self.promiseFriend = promise.friends ?? []
     
        DispatchQueue.main.async {
            self.setLabel()
            print("ddd")
        }
    }
    
    func hiddenUI(hidden: Bool) {
        if(hidden){
            DispatchQueue.main.async {
                self.deleteBtn.isHidden = true
                self.backBtn.isHidden = true
                self.downBtn.isHidden = false
            }
        }
    }
}
