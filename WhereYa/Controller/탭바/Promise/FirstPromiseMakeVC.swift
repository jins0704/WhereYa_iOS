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

        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
    }
    // MARK: - IBAction
    @IBAction func backBtnClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextBtnClicked(_ sender: Any) {
        performSegue(withIdentifier: "promisemake", sender: nil)
    }
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let next : SecondPromiseMakeVC = segue.destination as? SecondPromiseMakeVC else{return}
     
        next.name = promiseNameTextField.text
        next.memo = promiseMemoTextView.text
    }
}
