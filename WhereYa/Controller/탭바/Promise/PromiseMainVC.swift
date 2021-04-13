//
//  PromiseMainVC.swift
//  WhereYa
//
//  Created by 홍진석 on 2021/03/30.
//

import UIKit
import FSCalendar

class PromiseMainVC: UIViewController {

    @IBOutlet var wholeView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var topCalendarView: UIView!
    @IBOutlet var promiseMainTableView: UITableView!
    
    let Promises: [String] = ["1","2","3","4"]
    let cellIdentifier : String = "PromiseMainTableViewCell"
    var promiseList : [Promise] = []
    var calendar = FSCalendar()
    
    var datesWithEvent : [String]?

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
        
        promiseMainTableView.delegate = self
        promiseMainTableView.dataSource = self
        promiseMainTableView.register(UINib(nibName: "PromiseMainTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        viewSetting()
        
        navigationController?.navigationBar.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        PromiseService.shared.getEvents { (data) in
            switch data{
            case .success(let eventData) :
                
                guard let events = eventData as? [String] else { return }
                
                self.datesWithEvent = events
                
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
    func viewSetting(){
        let border = CALayer()
        border.frame = CGRect(x: 0, y: topCalendarView.frame.size.height, width: topCalendarView.frame.width, height: 1)
        border.backgroundColor = UIColor.lightGray.cgColor
        

        topCalendarView.layer.addSublayer((border))
        
        promiseMainTableView.separatorStyle = .none
        
        calendar.appearance.eventSelectionColor = #colorLiteral(red: 0.6359217763, green: 0.8041787744, blue: 0.7479131818, alpha: 1)
        calendar.appearance.eventDefaultColor = UIColor.blue
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0).isActive = true
        calendar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        calendar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true

        calendar.heightAnchor.constraint(equalToConstant: 350).isActive = true
        
        calendar.headerHeight = 90
        calendar.appearance.headerDateFormat = "YY년 M월"
        calendar.appearance.headerTitleColor = .mainBlueColor
        calendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 24)
        calendar.locale = Locale(identifier: "ko_KR")
        
        calendar.appearance.weekdayTextColor = UIColor.black
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
}

// MARK: - FSCalendar
extension PromiseMainVC : FSCalendarDelegate, FSCalendarDataSource{
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let promiseData = df.string(from: date)
        
        PromiseService.shared.getPromiseList(promiseData) { (data) in
            switch data{
            case .success(let list) :
                
                guard let list = list as? [Promise] else { return }
                
                self.promiseList = list
                
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
        let dateString = self.dateFormatter2.string(from: date)
        if let events = datesWithEvent{
            if events.contains(dateString) {
                    return 1
                }
        }
        return 0
    }
}

extension PromiseMainVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return promiseList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : PromiseMainTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PromiseMainTableViewCell
        
        let promise = promiseList[indexPath.row]
        cell.promiseName.text = promise.name
        cell.promiseTime.text = promise.time
        cell.promisePlace.text = promise.destination?.place_name

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
