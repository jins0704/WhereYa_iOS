//
//  ThirdPromiseMakeVC.swift
//  WhereYa
//
//  Created by 홍진석 on 2021/04/02.
//

import UIKit

class SecondPromiseMakeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func findPlaceBtn(_ sender: Any) {

    }

    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
