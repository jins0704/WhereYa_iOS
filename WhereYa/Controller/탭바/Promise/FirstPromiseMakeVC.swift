//
//  FirstPromiseMakeVC.swift
//  WhereYa
//
//  Created by 홍진석 on 2021/03/31.
//

import UIKit
import FSCalendar

class FirstPromiseMakeVC: UIViewController {
    
    var calendar = FSCalendar()
    var memo = UITextView()
    var isFoldered = false

    @IBOutlet var folderableBtn: UIButton!
    @IBOutlet var promiseNameTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
       
        promiseNameTextField.setLeftPaddingPoints(5)
        promiseNameTextField.underlineTextField("약속이름을 작성하세요")
        promiseNameTextField.clearButtonMode = .whileEditing
        
        calendar.delegate = self
        calendar.dataSource = self
        memo.delegate = self
        view.addSubview(calendar)
        view.addSubview(memo)
        
        UISetting()
      
    }
    // MARK: - IBAction
    @IBAction func backBtnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func folderableBtnClicked(_ sender: Any) {
        view.addSubview(calendar)
        memo.removeFromSuperview()
        view.addSubview(memo)
        UISetting()
        folderableBtn.isHidden = true
        view.reloadInputViews()
    }
    @IBAction func nextBtnClicked(_ sender: Any) {
        print("?")
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "SecondPromiseMakeVC") as? SecondPromiseMakeVC else{return}
     
        self.navigationController?.pushViewController(nextVC, animated: true)
    }

    func UISetting(){
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.topAnchor.constraint(equalTo: folderableBtn.bottomAnchor, constant: 0).isActive = true
        calendar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        calendar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true

        calendar.heightAnchor.constraint(equalToConstant: 400).isActive = true

     
        calendar.headerHeight = 90
        calendar.appearance.headerDateFormat = "YYYY. M"
        calendar.appearance.headerTitleColor = .mainBlueColor
        calendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 24)
        calendar.locale = Locale(identifier: "ko_KR")
        
        calendar.appearance.weekdayTextColor = UIColor.black
        calendar.appearance.titleWeekendColor = UIColor.darkPink85
        calendar.appearance.todayColor = UIColor.systemGray4
        calendar.appearance.selectionColor = #colorLiteral(red: 0.6078431373, green: 0.7333333333, blue: 0.7843137255, alpha: 1)
        
        memo.translatesAutoresizingMaskIntoConstraints = false
        memo.topAnchor.constraint(equalTo: calendar.bottomAnchor, constant: 10).isActive = true
        memo.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        memo.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true

        memo.heightAnchor.constraint(equalToConstant: 70).isActive = true
        memo.layer.borderWidth = 0.5
        memo.layer.borderColor = UIColor.gray.cgColor
        memo.layer.cornerRadius = 5
        memo.isHidden = true
        memo.text = "약속 메모"
        memo.textColor = UIColor.lightGray
        memo.font = UIFont.systemFont(ofSize: 15)
        
        folderableBtn.tintColor = UIColor.gray
        folderableBtn.isHidden = true
        
    }
}

extension FirstPromiseMakeVC : FSCalendarDelegate, FSCalendarDataSource{
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
            self.memo.isHidden = false
            self.memo.text = "약속 메모(주의 : 날짜를 재설정하면 사라져요)"
            self.memo.textColor = UIColor.lightGray
            calendar.removeFromSuperview()
            self.memo.topAnchor.constraint(equalTo: self.folderableBtn.bottomAnchor, constant: 10).isActive = true
            self.folderableBtn.isHidden = false
            self.view.reloadInputViews()
        })
//        memo.isHidden = false
//        memo.text = "약속 메모(주의 : 날짜를 재설정하면 사라져요)"
//        memo.textColor = UIColor.lightGray
//        calendar.removeFromSuperview()
//        memo.topAnchor.constraint(equalTo: folderableBtn.bottomAnchor, constant: 10).isActive = true
//        folderableBtn.isHidden = false
//        view.reloadInputViews()
        
        return true
    }
}

extension FirstPromiseMakeVC : UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
}
