//
//  PromiseMainVC.swift
//  WhereYa
//
//  Created by 홍진석 on 2021/03/30.
//

import UIKit

class PromiseMainVC: UIViewController {

    let Promises: [String] = ["1","2","3","4"]
    let cellIdentifier : String = "promiseMainTableViewCell"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = false

        navigationController?.navigationBar.isHidden = true
    }
    

    @IBAction func promiseBtnClicked(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "PromiseMake", bundle: nil)
        let firstVC = storyboard.instantiateViewController(identifier:"PromiseMakeNavigationVC")  as! PromiseMakeNavigationVC
        
        firstVC.modalTransitionStyle = .coverVertical
        firstVC.modalPresentationStyle = .fullScreen
        self.present(firstVC, animated: true, completion: nil)
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
