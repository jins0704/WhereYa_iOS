//
//  FirstPromiseMakeVC.swift
//  WhereYa
//
//  Created by 홍진석 on 2021/03/31.
//

import UIKit
import FSCalendar
import Toast_Swift

class FirstPromiseMakeVC: UIViewController {
    var selectedDate : String?
    var selectedTime : String?
    var selectPlace : String?
    var isFoldered = false
    
    var calendar = FSCalendar()
    var detailView = UIView()
    var dateLabel = UILabel()
    var memo = UITextView()
    
    var searchFriendBtn = UIButton()
    var searchPlaceBtn = UIButton()
    
    var promise : Promise = Promise()
    
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
        
        detailViewSetting()
        viewSetting()
    }
    // MARK: - IBAction
    @IBAction func backBtnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func completeBtnClicked(_ sender: Any) {
        if promise.name?.count == 0 || promise.time == nil || promise.date == nil || promise.friends == nil || promise.destination == nil{
            self.view.makeToast("약속 조건을 채워주세요", duration: 0.5, position: .center)
        }
        else{
            PromiseService.shared.makePromise(promise: promise) { (data) in
                switch data{
                case .success(let message) :
                    print(message )
                    self.dismiss(animated: true, completion: nil)
                case .requestErr(let message):
                    print(message)
                    return
                case .serverErr:
                    print("serverErr")
                    return
                    
                case .networkFail:
                    print("networkFail")
                    return
                }
            }
        }
        
    }
    
    @IBAction func folderableBtnClicked(_ sender: Any) {
        view.addSubview(calendar)
        detailView.removeFromSuperview()
        view.addSubview(detailView)
        viewSetting()
        folderableBtn.isHidden = true
        view.reloadInputViews()
    }

    func viewSetting(){
        
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

        detailView.heightAnchor.constraint(equalToConstant: 400).isActive = true

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
        memo.addDoneButtonOnKeyboard()
        
        detailView.addSubview(searchPlaceBtn)
        searchPlaceBtn.translatesAutoresizingMaskIntoConstraints = false
        searchPlaceBtn.topAnchor.constraint(equalTo: memo.bottomAnchor, constant: 20).isActive = true
        searchPlaceBtn.leadingAnchor.constraint(equalTo: dateLabel.safeAreaLayoutGuide.leadingAnchor).isActive = true
        searchPlaceBtn.trailingAnchor.constraint(equalTo: dateLabel.safeAreaLayoutGuide.trailingAnchor).isActive = true
        searchPlaceBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        searchPlaceBtn.setTitle("만날 장소 찾기", for: .normal)
        searchPlaceBtn.titleLabel?.textAlignment = .center
        searchPlaceBtn.backgroundColor = #colorLiteral(red: 0.6078431373, green: 0.7333333333, blue: 0.7843137255, alpha: 1)
        searchPlaceBtn.addTarget(self, action: #selector(self.placeBtnClicked), for: .touchUpInside)
        
        detailView.addSubview(searchFriendBtn)
        searchFriendBtn.translatesAutoresizingMaskIntoConstraints = false
        searchFriendBtn.topAnchor.constraint(equalTo: searchPlaceBtn.bottomAnchor, constant: 20).isActive = true
        searchFriendBtn.leadingAnchor.constraint(equalTo: dateLabel.safeAreaLayoutGuide.leadingAnchor).isActive = true
        searchFriendBtn.trailingAnchor.constraint(equalTo: dateLabel.safeAreaLayoutGuide.trailingAnchor).isActive = true
        searchFriendBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        searchFriendBtn.setTitle("만날 친구 찾기", for: .normal)
        searchFriendBtn.titleLabel?.textAlignment = .center
        searchFriendBtn.backgroundColor = #colorLiteral(red: 0.6078431373, green: 0.7333333333, blue: 0.7843137255, alpha: 1)
        searchFriendBtn.addTarget(self, action: #selector(self.friendBtnClicked), for: .touchUpInside)

    }
    
    @IBAction func placeBtnClicked(){
        print("searchplace")
        let placeVC = storyboard?.instantiateViewController(identifier: "SearchPlaceVC") as! SearchPlaceVC
        
        placeVC.modalTransitionStyle = .coverVertical
        placeVC.modalPresentationStyle = .fullScreen
        placeVC.popupDelegate = self
        self.present(placeVC, animated: true, completion: nil)
    }
    
    
    @IBAction func friendBtnClicked(){
        print("searchfriend")
        let friendVC = storyboard?.instantiateViewController(identifier: "SearchFriendVC") as! SearchFriendVC
        
        friendVC.modalTransitionStyle = .coverVertical
        friendVC.modalPresentationStyle = .fullScreen
        friendVC.popupDelegate = self
        self.present(friendVC, animated: true, completion: nil)
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
        self.promise.name = promiseNameTextField.text
        textField.resignFirstResponder()
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
    func textViewDidEndEditing(_ textView: UITextView) {
        promise.memo = self.memo.text
    }
    
}

extension FirstPromiseMakeVC : PopUpDelegate{
    func friendClicked(friends: [String]) {
        promise.friends = friends
        self.searchFriendBtn.setTitle("친구 : \(friends[0]) 외 \(friends.count-1)명", for: .normal)
    }
    
    func placeClicked(place: Place) {
        promise.destination = place
        self.searchPlaceBtn.setTitle("장소 : \(place.place_name ?? " ")", for: .normal)
        
    }
    
    func doneBtnClicked(data: String) {
        self.selectedTime = data
        self.dateLabel.text = "시간 : \(selectedDate ?? " ") , \(selectedTime ?? " ")"
       
        promise.date = selectedDate
        promise.time = selectedTime
        
//        self.memo.text = "약속 메모(주의 : 날짜를 재설정하면 사라져요)"
//        self.memo.textColor = UIColor.lightGray
        calendar.removeFromSuperview()
        self.detailView.topAnchor.constraint(equalTo: self.folderableBtn.bottomAnchor, constant: 10).isActive = true
        self.folderableBtn.isHidden = false
        self.detailView.isHidden = false
        self.view.reloadInputViews()

    }
}
