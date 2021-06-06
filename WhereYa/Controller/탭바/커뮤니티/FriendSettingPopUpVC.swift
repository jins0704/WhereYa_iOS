//
//  FriendSettingPopUpVC.swift
//  WhereYa
//
//  Created by 홍진석 on 2021/03/25.
//

import UIKit

class FriendSettingPopUpVC: UIViewController{
          
    var popupDelegate : popupDelegate?
    
    var detailNickname : String?
    var detailImg : String?
    var detailStar : Bool?
    
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var starBtn: UIButton!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    var isDeleteClicked : Bool = false
    var isStarClicked : Bool = false
    
    @IBOutlet weak var starLabel: UILabel!
    @IBOutlet weak var deleteLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.swipDownDismiss()
        if let nickname = detailNickname{
            nicknameLabel.text = nickname
        }
        if let img = detailImg, let image = URL(string: img){
            print("ok")
            profileImage.kf.indicatorType = .activity
            profileImage.kf.setImage(with: image)
        }
        
        if let star = detailStar{
            if star == true{
                isStarClicked = true
            }
            let activatedImage = UIImage(systemName: "star.fill")?.withTintColor(UIColor.mainBlueColor).withRenderingMode(.alwaysOriginal)
            let normalImage =  UIImage(systemName: "star")?.withTintColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)).withRenderingMode(.alwaysOriginal)
            self.starBtn.setImage(isStarClicked ? activatedImage : normalImage, for: .normal)
        }
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.layer.borderWidth = 1
        profileImage.clipsToBounds = true
        profileImage.layer.borderColor = UIColor.clear.cgColor
        
        
        starLabel.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        deleteLabel.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    }
    
    @IBAction func starBtnClicked(_ sender: Any) {
        var msg = ""
        
        if isStarClicked == true{
            isStarClicked = false
            msg = "즐겨찾기에 해제되었습니다"
            
        }
        else{
            isStarClicked = true
            msg = "즐겨찾기에 추가되었습니다"
        }
        print(isStarClicked)
        animated(btn: starBtn, state : isStarClicked, imageName : "star", color:  UIColor.mainBlueColor)
        
        FriendService.shared.bookmarkFriend(friendNickname: self.nicknameLabel.text!) { (data) in
            ActivityIndicator.shared.activityIndicator.stopAnimating()
            
            switch data{
            
            case .success( _) :
                let okay = "okay"
                self.popupDelegate?.doneBtnClicked(data: okay)
                
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
        
        
        successAlert(message: msg)
    }
    
    @IBAction func deleteBtnClicked(_ sender: Any) {
        if isDeleteClicked == true{
            isDeleteClicked = false
        }
        else{
            isDeleteClicked = true
        }
        animated(btn : deleteBtn, state : isDeleteClicked, imageName : "trash", color: UIColor.darkPink85)
        
        FriendService.shared.removeFriend(friendNickname: self.nicknameLabel.text!) { (data) in
            
            ActivityIndicator.shared.activityIndicator.stopAnimating()
            
            switch data{
            
            case .success( _) :
                let okay = "okay"
                print("변경 완료")
                self.popupDelegate?.doneBtnClicked(data: okay)
                
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

        successAlert(message: "삭제가 완료되었습니다.")
    }
    
    
    func animated(btn : UIButton, state : Bool, imageName : String, color : UIColor){
        let activatedImage = UIImage(systemName: imageName + ".fill")?.withTintColor(color).withRenderingMode(.alwaysOriginal)
        let normalImage =  UIImage(systemName: imageName)?.withTintColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)).withRenderingMode(.alwaysOriginal)
        
        
        UIView.animate(withDuration: 0.1) {
            //작아지는 애니메이션
            btn.transform = btn.transform.scaledBy(x: 0.5, y: 0.5)
            btn.setImage(state ? activatedImage : normalImage, for: .normal)
            
        } completion: { _ in
            
            //원래대로 돌아오기
            UIView.animate(withDuration: 0.1) {
                btn.transform = CGAffineTransform.identity
            }
        }
        print(state)
    }
    func successAlert(message : String){
        let alert =  UIAlertController(title: "", message: message, preferredStyle: .alert)
      
        let doneMessage = UIAlertAction(title: "확인", style: .default){ (_) in
            self.dismiss(animated: true, completion: nil)
        }

        alert.addAction(doneMessage)

        present(alert, animated: true, completion: nil)
        
    
    }
    
    @IBAction func doneProfileBtnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
