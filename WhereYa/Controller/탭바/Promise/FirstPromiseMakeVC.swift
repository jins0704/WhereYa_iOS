//
//  FirstPromiseMakeVC.swift
//  WhereYa
//
//  Created by 홍진석 on 2021/03/31.
//

import UIKit
import FSCalendar

class FirstPromiseMakeVC: UIViewController {
    var selectedDate : String?
    var selectedTime : String?
    var selectPlace : String?
    var isFoldered = false
    
    var calendar = FSCalendar()
    var detailView = UIView()
    var dateLabel = UILabel()
    var memo = UITextView()
    var searchPlaceBtn = UIButton()
    var searchFriend = UIButton()
    
    @IBOutlet var textviewDoneBtn: UIButton!
    @IBOutlet var folderableBtn: UIButton!
    @IBOutlet var promiseNameTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
       
        promiseNameTextField.setLeftPaddingPoints(5)
        promiseNameTextField.underlineTextField("약속이름을 작성하세요")
        promiseNameTextField.clearButtonMode = .whileEditing
        promiseNameTextField.delegate = self
        calendar.delegate = self
        calendar.dataSource = self
        memo.delegate = self
        
        view.addSubview(calendar)
        view.addSubview(detailView)
        detailView.addSubview(memo)
        detailView.addSubview(dateLabel)
        detailView.addSubview(searchPlaceBtn)
        detailView.addSubview(searchFriend)
        
        detailViewSetting()
        viewSetting()
    }
    // MARK: - IBAction
    @IBAction func backBtnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func folderableBtnClicked(_ sender: Any) {
        view.addSubview(calendar)
        detailView.removeFromSuperview()
        view.addSubview(detailView)
        viewSetting()
        folderableBtn.isHidden = true
        view.reloadInputViews()
    }
    @IBAction func textviewEditDone(_ sender: Any) {
        textviewDoneBtn.isHidden = true
        self.memo.resignFirstResponder()
    }
    @IBAction func nextBtnClicked(_ sender: Any) {
    }

    func viewSetting(){
        textviewDoneBtn.isHidden = true
        
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
        
        detailView.translatesAutoresizingMaskIntoConstraints = false
        detailView.topAnchor.constraint(equalTo: calendar.bottomAnchor, constant: 10).isActive = true
        detailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        detailView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true

        detailView.heightAnchor.constraint(equalToConstant: 300).isActive = true

        folderableBtn.tintColor = UIColor.gray
        folderableBtn.isHidden = true
        
        detailView.isHidden = true
    }
    
    func detailViewSetting(){
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.topAnchor.constraint(equalTo: detailView.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: detailView.safeAreaLayoutGuide.leadingAnchor).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: detailView.safeAreaLayoutGuide.trailingAnchor).isActive = true

        memo.translatesAutoresizingMaskIntoConstraints = false
        memo.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 30).isActive = true
        memo.leadingAnchor.constraint(equalTo: dateLabel.safeAreaLayoutGuide.leadingAnchor).isActive = true
        memo.trailingAnchor.constraint(equalTo: dateLabel.safeAreaLayoutGuide.trailingAnchor).isActive = true
        memo.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        memo.layer.borderWidth = 0.5
        memo.layer.borderColor = UIColor.gray.cgColor
        memo.layer.cornerRadius = 5
        memo.text = "약속 메모"
        memo.textColor = UIColor.lightGray
        memo.font = UIFont.systemFont(ofSize: 15)
        
        searchPlaceBtn.translatesAutoresizingMaskIntoConstraints = false
        searchPlaceBtn.topAnchor.constraint(equalTo: memo.bottomAnchor, constant: 20).isActive = true
        searchPlaceBtn.leadingAnchor.constraint(equalTo: dateLabel.safeAreaLayoutGuide.leadingAnchor).isActive = true
        searchPlaceBtn.trailingAnchor.constraint(equalTo: dateLabel.safeAreaLayoutGuide.trailingAnchor).isActive = true
        searchPlaceBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        searchPlaceBtn.setTitle("만날 장소 찾기", for: .normal)
        searchPlaceBtn.titleLabel?.textAlignment = .center
        searchPlaceBtn.backgroundColor = #colorLiteral(red: 0.6078431373, green: 0.7333333333, blue: 0.7843137255, alpha: 1)
        searchPlaceBtn.addTarget(self, action: #selector(self.placeBtnClicked), for: .touchUpInside)
        searchFriend.translatesAutoresizingMaskIntoConstraints = false
        searchFriend.topAnchor.constraint(equalTo: searchPlaceBtn.bottomAnchor, constant: 20).isActive = true
        searchFriend.leadingAnchor.constraint(equalTo: dateLabel.safeAreaLayoutGuide.leadingAnchor).isActive = true
        searchFriend.trailingAnchor.constraint(equalTo: dateLabel.safeAreaLayoutGuide.trailingAnchor).isActive = true
        searchFriend.heightAnchor.constraint(equalToConstant: 50).isActive = true
        searchFriend.setTitle("만날 친구 찾기", for: .normal)
        searchFriend.titleLabel?.textAlignment = .center
        searchFriend.backgroundColor = #colorLiteral(red: 0.6078431373, green: 0.7333333333, blue: 0.7843137255, alpha: 1)
    }
    
    @IBAction func placeBtnClicked(){
        let nextVC = storyboard?.instantiateViewController(identifier: "SearchPlaceVC") as! SearchPlaceVC
        
        nextVC.modalTransitionStyle = .coverVertical
        nextVC.modalPresentationStyle = .fullScreen
        nextVC.popupDelegate = self
        self.present(nextVC, animated: true, completion: nil)
    }
}

extension FirstPromiseMakeVC : FSCalendarDelegate, FSCalendarDataSource{
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        
        if let timePopUp = storyboard?.instantiateViewController(identifier: "TimePopUpVC") as? TimePopUpVC {
            timePopUp.modalPresentationStyle = .overCurrentContext
            timePopUp.modalTransitionStyle = .crossDissolve //스르르 사라지는 스타일

            timePopUp.popupDelegate = self
            self.present(timePopUp, animated: true, completion: nil)
        }

        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let stringDate = df.string(from: date)
        selectedDate = stringDate
        self.dateLabel.text = " \(selectedDate ?? " ") , \(selectedTime ?? " ")"

        return true
    }
    
}
extension FirstPromiseMakeVC : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
extension FirstPromiseMakeVC : UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        self.textviewDoneBtn.isHidden = false
    }
    
}

extension FirstPromiseMakeVC : PopUpDelegate{
    func cellClicked(data: String) {
        selectPlace = data
        self.searchPlaceBtn.setTitle("만남장소 : \(selectPlace ?? " ")", for: .normal)
    }
    
    func doneBtnClicked(data: String) {
        self.selectedTime = data
        self.dateLabel.text = " \(selectedDate ?? " ") , \(selectedTime ?? " ")"
//        self.memo.text = "약속 메모(주의 : 날짜를 재설정하면 사라져요)"
//        self.memo.textColor = UIColor.lightGray
        calendar.removeFromSuperview()
        self.detailView.topAnchor.constraint(equalTo: self.folderableBtn.bottomAnchor, constant: 10).isActive = true
        self.folderableBtn.isHidden = false
        self.detailView.isHidden = false
        self.view.reloadInputViews()

    }
}
