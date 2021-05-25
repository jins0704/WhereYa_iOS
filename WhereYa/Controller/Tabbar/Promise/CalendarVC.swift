//
//  CalendarVC.swift
//  WhereYa
//
//  Created by 홍진석 on 2021/04/05.
//

import UIKit
import FSCalendar
class CalendarVC: UIViewController {

    @IBOutlet var calendarView: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        calendarView.delegate = self
        calendarView.dataSource = self
        
        CalendarSetting()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - IBAction
    @IBAction func backBtnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func leftCalendarMove(_ sender: Any) {
        print("aa")
        let cal = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = -1
        self.calendarView.currentPage = cal.date(byAdding: dateComponents, to: self.calendarView.currentPage)!
        self.calendarView.setCurrentPage(self.calendarView.currentPage, animated: true)
    }
    
    @IBAction func rightCalendarMove(_ sender: Any) {
        let cal = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = 1
        self.calendarView.currentPage = cal.date(byAdding: dateComponents, to: self.calendarView.currentPage)!
        self.calendarView.setCurrentPage(self.calendarView.currentPage, animated: true)
    }
    
    
    
    // MARK: - func
    func CalendarSetting(){
 
        calendarView.headerHeight = 50
        calendarView.appearance.headerDateFormat = "YYYY. M"
        calendarView.appearance.headerTitleColor = .black
        calendarView.appearance.headerTitleFont = UIFont.systemFont(ofSize: 24)
        calendarView.appearance.headerMinimumDissolvedAlpha = 0.0
        calendarView.locale = Locale(identifier: "ko_KR")
    }
}

extension CalendarVC : FSCalendarDelegate, FSCalendarDataSource{
    
}
