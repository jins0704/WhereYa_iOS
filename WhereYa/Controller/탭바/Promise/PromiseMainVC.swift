//
//  PromiseMainVC.swift
//  WhereYa
//
//  Created by 홍진석 on 2021/03/30.
//

import UIKit
import FSCalendar

class PromiseMainVC: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var topCalendarView: UIView!
    
    let Promises: [String] = ["1","2","3","4"]
    let cellIdentifier : String = "promiseMainTableViewCell"
    
    var calendar = FSCalendar()
    
    var datesWithEvent = ["2021-04-03", "2021-04-06", "2021-04-12", "2021-04-25","2021-04-08", "2021-04-16", "2021-04-20", "2021-04-28"]

    fileprivate lazy var dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        calendar.delegate = self
        calendar.dataSource = self
        topCalendarView.addSubview(calendar)
        calendar.appearance.eventSelectionColor = UIColor.red
        calendar.appearance.eventDefaultColor = #colorLiteral(red: 0.6359217763, green: 0.8041787744, blue: 0.7479131818, alpha: 1)
        viewSetting()
        
        navigationController?.navigationBar.isHidden = true
    }
    

    @IBAction func promiseBtnClicked(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "PromiseMake", bundle: nil)
        let firstVC = storyboard.instantiateViewController(identifier:"PromiseMakeNavigationVC")  as! PromiseMakeNavigationVC
        
        firstVC.modalTransitionStyle = .coverVertical
        firstVC.modalPresentationStyle = .fullScreen
        self.present(firstVC, animated: true, completion: nil)
    }
    // MARK: - func
    func viewSetting(){
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0).isActive = true
        calendar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        calendar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true

        calendar.heightAnchor.constraint(equalToConstant: 350).isActive = true
        
        calendar.headerHeight = 90
        calendar.appearance.headerDateFormat = "YYYY. M"
        calendar.appearance.headerTitleColor = .mainBlueColor
        calendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 24)
        calendar.locale = Locale(identifier: "ko_KR")
        
        calendar.appearance.weekdayTextColor = UIColor.black
        calendar.appearance.titleWeekendColor = UIColor.darkPink85
        calendar.appearance.todayColor = UIColor.systemGray4
        calendar.appearance.selectionColor = #colorLiteral(red: 0.6078431373, green: 0.7333333333, blue: 0.7843137255, alpha: 1)
    }
   
}

// MARK: - FSCalendar
extension PromiseMainVC : FSCalendarDelegate, FSCalendarDataSource{
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        print(calendar.adjustMonthPosition())
        return true
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateString = self.dateFormatter2.string(from: date)

            if self.datesWithEvent.contains(dateString) {
                return 1
            }
        return 0
    }
}
