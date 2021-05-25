//
//  MyPageSettingVC.swift
//  WhereYa
//
//  Created by 홍진석 on 2021/03/17.
//

import UIKit

class MyPageSettingVC: UIViewController {

    @IBOutlet weak var alarmAgreeSwitch: UISwitch!
    @IBOutlet weak var locationAgreeSwitch: UISwitch!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        alarmAgreeSwitch.onTintColor = UIColor.subpink
        locationAgreeSwitch.onTintColor = UIColor.subpink
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutBtnClicked(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: "로그아웃하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "확인", style: .destructive) { (_) in
            let user = UserDefaults.standard
            user.removeObject(forKey:"user_id")
            user.removeObject(forKey: "token")
            user.removeObject(forKey: "user_nickname")
            user.removeObject(forKey: "user.profile")
            user.synchronize()
            
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let basetMainVC = storyboard.instantiateViewController(identifier:"MainInitVC")

            basetMainVC.modalPresentationStyle = .fullScreen
            self.present(basetMainVC , animated: true, completion: nil)
        })
        
        self.present(alert, animated: false)
        
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
