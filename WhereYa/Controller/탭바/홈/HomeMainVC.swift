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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UISetting()
        
    }
    
    func UISetting(){
        promiseName.text = "동창회 약속"
        alarmLabel.text = "30분 남았어요\n판교역으로 6시까지 가야해요"
    }
    @IBAction func roomBtnClicked(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "GroupRoom", bundle: nil)
        let nextVC = storyboard.instantiateViewController(identifier:"GroupRoomVC")  as! GroupRoomVC

        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true, completion: nil)
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
