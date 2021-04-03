//
//  FirstPromiseMakeVC.swift
//  WhereYa
//
//  Created by 홍진석 on 2021/03/31.
//

import UIKit

class FirstPromiseMakeVC: UIViewController {

    @IBOutlet var promiseNameTextField: UITextField!
    @IBOutlet var promiseMemoTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        promiseNameTextField.clearButtonMode = .whileEditing
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
    }
    // MARK: - IBAction
    @IBAction func backBtnClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextBtnClicked(_ sender: Any) {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "SecondPromiseMakeVC") as? SecondPromiseMakeVC else{return}
     
        nextVC.name = promiseNameTextField.text
        nextVC.memo = promiseMemoTextView.text
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let next : SecondPromiseMakeVC = segue.destination as? SecondPromiseMakeVC else{return}
     
        next.name = promiseNameTextField.text
        next.memo = promiseMemoTextView.text
    }
}
