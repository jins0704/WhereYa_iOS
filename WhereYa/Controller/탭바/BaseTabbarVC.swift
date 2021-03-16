//
//  BaseTabbarVC.swift
//  GOGO
//
//  Created by 홍진석 on 2021/03/05.
//

import UIKit

class BaseTabbarVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //탭바 위쪽 테두리
//        let topLine = CALayer()
//        topLine.frame = CGRect(x: 0.0, y: 0.0, width: mainTabbar.frame.width-4, height: 4.0)
//        topLine.backgroundColor = UIColor.aquaMarine.cgColor
//        mainTabbar.layer.addSublayer(topLine)

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UITabBar.appearance().unselectedItemTintColor =  UIColor.lightGray
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
