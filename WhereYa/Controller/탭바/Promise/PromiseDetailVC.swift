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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
