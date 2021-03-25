//
//  FriendSettingPopUpVC.swift
//  WhereYa
//
//  Created by 홍진석 on 2021/03/25.
//

import UIKit

class FriendSettingPopUpVC: UIViewController {

    @IBOutlet weak var popupView: UIView!
    
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
        
        popupView.layer.borderWidth = 1
        popupView.layer.borderColor = UIColor.black.cgColor
        popupView.layer.cornerRadius = 20
        starLabel.textColor = UIColor.mainBlueColor
        deleteLabel.textColor = UIColor.darkPink85
     
    }
    
    @IBAction func starBtnClicked(_ sender: Any) {
        if isStarClicked == true{
            isStarClicked = false
        }
        else{
            isStarClicked = true
        }
        animated(btn: starBtn, state : isStarClicked, imageName : "star", color:  UIColor.mainBlueColor)
        
        successAlert(message: "즐겨찾기에 추가되었습니다.")
    }
    
    @IBAction func deleteBtnClicked(_ sender: Any) {
        if isDeleteClicked == true{
            isDeleteClicked = false
        }
        else{
            isDeleteClicked = true
        }
        animated(btn : deleteBtn, state : isDeleteClicked, imageName : "trash", color: UIColor.darkPink85)
        
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
      
        let doneMessage = UIAlertAction(title: "확인", style: .default, handler: nil)

        alert.addAction(doneMessage)

        present(alert, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func doneBtnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
