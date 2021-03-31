//
//  SecondPromiseMakeVC.swift
//  WhereYa
//
//  Created by 홍진석 on 2021/03/31.
//

import UIKit

class SecondPromiseMakeVC: UIViewController, MTMapViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
        
        
    }
    @IBAction func backBtnClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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
