//
//  PromiseMakeTimeVC.swift
//  WhereYa
//
//  Created by 홍진석 on 2021/04/06.
//

import UIKit

class TimePopUpVC: UIViewController {

    var popupDelegate : popupDelegate?
    var promisetime : String?
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var popupView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        datePicker.datePickerMode = .time
        datePicker.tintColor = .black
        datePicker.locale = Locale(identifier: "ko-KR")
        
        popupView.layer.cornerRadius = 20
        // Do any additional setup after loading the view.
    }
    @IBAction func backClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    
    }
    
    @IBAction func doneClicked(_ sender: Any) {
        let df = DateFormatter()
        df.dateFormat = "HH:mm"
        promisetime = df.string(from: datePicker.date)
        
        if let promisetime = promisetime{
            self.dismiss(animated: true, completion: nil)
            popupDelegate?.doneBtnClicked(data: promisetime)
        }
    }
    
}
