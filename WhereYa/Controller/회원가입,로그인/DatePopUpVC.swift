//
//  DataPopUpVC.swift
//  GOGO
//
//  Created by 홍진석 on 2021/02/26.
//

import UIKit

class DatePopUpVC: baseVC {

    var popupDelegate : PopUpDelegate?
    var birthdate : String?
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.maximumDate = Date()
        popUpView.layer.cornerRadius = 20
    }
    @IBAction func backgroundClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneBtnClicked(_ sender: Any) {
        if let birthdate = birthdate{
            
            self.dismiss(animated: true, completion: nil)
            popupDelegate?.doneBtnClicked(data: birthdate)
        }
    }
    
    @IBAction func selectBirth(_ sender: UIDatePicker) {
        let datePickerView = sender
        let formatter : DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        birthdate = formatter.string(from: datePickerView.date)
        print("\(birthdate ?? "") popvc ")
    }
    
}
