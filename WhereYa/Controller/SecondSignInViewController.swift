//
//  SecondSignInViewController.swift
//  GOGO
//
//  Created by 홍진석 on 2021/02/17.
//

import UIKit

class SecondSignInVC: CommonViewController {

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var year_BirthTextField: UITextField!
    @IBOutlet weak var month_BirthTextField: UITextField!
    @IBOutlet weak var date_BirthTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        textFieldLayer(year_BirthTextField)
        textFieldLayer(month_BirthTextField)
        textFieldLayer(date_BirthTextField)
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
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
