//
//  PromiseMainVC.swift
//  WhereYa
//
//  Created by 홍진석 on 2021/03/30.
//

import UIKit
import FSCalendar

class PromiseMainVC: UIViewController {

    @IBOutlet var mainView: UIView!
    @IBOutlet var wholeView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var topCalendarView: UIView!
    @IBOutlet var promiseMainTableView: UITableView!
    @IBOutlet var headerLabel: UILabel!
    
    let Promises: [String] = ["1","2","3","4"]

    private var promiseList : [Promise] = []
    var calendar = FSCalendar()
    private var currentPage: Date?
    private var today: Date = { return Date() }()
    
    var datesWithEvent : [String]?

    var dateToYearMonthDay: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var dateToYearMonth: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCalendar()

        topCalendarView.addSubview(calendar)
        
        promiseMainTableView.delegate = self
        promiseMainTableView.dataSource = self
        promiseMainTableView.register(UINib(nibName: PromiseMainTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: PromiseMainTableViewCell.identifier)
        setUI()
        
        navigationController?.navigationBar.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        PromiseService.shared.getEvents { (data) in
            switch data{
            case .success(let result) :
                
                guard let r = result as? ResponseCalendarEvents else{return}
                
                
                self.datesWithEvent = r.datesWithEvent
                
                DispatchQueue.main.async {
                    self.calendar.reloadData()
                }
                
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

    @IBAction func promiseBtnClicked(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "PromiseMake", bundle: nil)
        let firstVC = storyboard.instantiateViewController(identifier:"PromiseMakeNavigationVC")  as! PromiseMakeNavigationVC
        
        firstVC.modalTransitionStyle = .coverVertical
        firstVC.modalPresentationStyle = .fullScreen
        self.present(firstVC, animated: true, completion: nil)
    }
    
    // MARK: - func
    func setUI(){
        self.titleLabel.font = UIFont.myBoldSystemFont(ofSize: 25)
        self.headerLabel.font = UIFont.myMediumSystemFont(ofSize: 18)
        
        self.mainView.layer.cornerRadius = 5
        self.mainView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        let border = CALayer()
        border.frame = CGRect(x: 0, y: topCalendarView.frame.size.height, width: topCalendarView.frame.width, height: 1)
        
        border.backgroundColor = UIColor.lightGray.cgColor
        

        topCalendarView.layer.addSublayer((border))
        
        promiseMainTableView.separatorStyle = .none
        
        calendar.appearance.eventSelectionColor = #colorLiteral(red: 0.6359217763, green: 0.8041787744, blue: 0.7479131818, alpha: 1)
        calendar.appearance.eventDefaultColor = UIColor.blue
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        calendar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        calendar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true

        calendar.heightAnchor.constraint(equalToConstant: 350).isActive = true
        
        calendar.headerHeight = 90
        calendar.appearance.headerDateFormat = "yyyy년 M월"
        calendar.appearance.headerTitleColor = .mainBlueColor
        calendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 24)
        calendar.locale = Locale(identifier: "ko_KR")
        
        calendar.appearance.weekdayTextColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        calendar.appearance.todayColor = UIColor.systemGray4
        calendar.appearance.selectionColor = #colorLiteral(red: 0.6078431373, green: 0.7333333333, blue: 0.7843137255, alpha: 1)
    }
   
    // MARK: - SeguePreapre
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PromiseDetailSegue"{
            guard let next = segue.destination as? PromiseDetailVC else{return}
            guard let cell : PromiseMainTableViewCell = sender as? PromiseMainTableViewCell else{return}
               
            next.promiseName = cell.promiseName.text
            next.promisePlace = cell.promisePlace.text
            next.promiseTime = cell.promiseTime.text
            next.promiseAddress = cell.promiseAddress
            next.promiseMemo = cell.promiseMemo
            next.promiseFriend = cell.promiseFriend
        }
    }
    
    @IBAction func prevBtnTapped(_ sender: UIButton) {
        scrollCurrentPage(isPrev: true)
    }
    
    @IBAction func nextBtnTapped(_ sender: UIButton) {
        scrollCurrentPage(isPrev: false)
    }

}

// MARK: - FSCalendar
extension PromiseMainVC : FSCalendarDelegate, FSCalendarDataSource{
    private func scrollCurrentPage(isPrev: Bool) {
        let cal = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = isPrev ? -1 : 1
        self.currentPage = cal.date(byAdding: dateComponents, to: self.currentPage ?? self.today)
        self.calendar.setCurrentPage(self.currentPage!, animated: true)
    }
    
    func setCalendar() {
        calendar.delegate = self
        calendar.dataSource = self
        calendar.headerHeight = 0
        calendar.calendarHeaderView.isHidden = true
        calendar.scope = .month
        headerLabel.text = self.dateToYearMonth.string(from: calendar.currentPage)
        
    }
        

    func calendarCurrentPageDidChange(_ calendar: FSCalendar) { self.headerLabel.text = self.dateToYearMonth.string(from: calendar.currentPage)
        currentPage = calendar.currentPage
    }
    

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let promiseData = df.string(from: date)
        
        PromiseService.shared.getPromiseList(promiseData) { (data) in
            switch data{
            case .success(let result) :
                
                guard let r = result as? ResponsePromiseList else { return }
                
                self.promiseList = r.promiseList!
                
                DispatchQueue.main.async {
                    self.view.reloadInputViews()
                    self.promiseMainTableView.reloadData()
                }
                
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
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateString = self.dateToYearMonthDay.string(from: date)
        if let events = datesWithEvent{
            if events.contains(dateString) {
                    return 1
                }
        }
        return 0
    }
    
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
            switch self.dateToYearMonthDay.string(from: date) {
            case dateToYearMonthDay.string(from: Date()):
                return "오늘"
            default:
                return nil
            }
        }
}

extension PromiseMainVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return promiseList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : PromiseMainTableViewCell = tableView.dequeueReusableCell(withIdentifier: PromiseMainTableViewCell.identifier, for: indexPath) as! PromiseMainTableViewCell
        
        let promise = promiseList[indexPath.row]
        cell.promiseName.text = promise.name
        cell.promiseTime.text = promise.time
        cell.promisePlace.text = promise.destination?.place_name
        cell.promiseAddress = promise.destination?.address_name
        cell.promiseFriend = promise.friends ?? []
        cell.promiseMemo  = promise.memo
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = promiseMainTableView.cellForRow(at: indexPath) as?
            PromiseMainTableViewCell{
            performSegue(withIdentifier: "PromiseDetailSegue", sender: cell)
        }
    }
}
