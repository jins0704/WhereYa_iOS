//
//  PastPromiseVC.swift
//  WhereYa
//
//  Created by 홍진석 on 2021/06/02.
//

import UIKit

class PastPromiseVC: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var pastTV: UITableView!
    
    private var promiseList : [Promise] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        PromiseService.shared.getPastPromiseList { data in
            switch data{
            case .success(let list) :
                
                guard let list = list as? [Promise] else { return }
                
                self.promiseList = list
                
                DispatchQueue.main.async {
                    self.view.reloadInputViews()
                    self.pastTV.reloadData()
                }
                
            case .requestErr(_): break
            case .serverErr: break
            case .networkFail: break
            }
        }
    }

    
    // MARK: - setUI
    func setUI(){
        titleLabel.font = UIFont.myBoldSystemFont(ofSize: 23)
        titleLabel.textColor = .mainBlueColor
    }
    
    // MARK: - setTableView
    func setTableView(){
        pastTV.delegate = self
        pastTV.dataSource = self
        
        pastTV.register(UINib(nibName: PromiseMainTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: PromiseMainTableViewCell.identifier)
    }
    // MARK: - IBAction
    @IBAction func closeBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension PastPromiseVC : UITableViewDelegate{
    
}

extension PastPromiseVC : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : PromiseMainTableViewCell = tableView.dequeueReusableCell(withIdentifier: PromiseMainTableViewCell.identifier, for: indexPath) as! PromiseMainTableViewCell
        
        let promise = promiseList[indexPath.row]
        cell.setData(promise.name ?? "", promise.destination?.place_url ?? "", promise.date ?? "")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        if let cell = promiseMainTableView.cellForRow(at: indexPath) as?
//            PromiseMainTableViewCell{
//            performSegue(withIdentifier: "PromiseDetailSegue", sender: cell)
//        }
    }
    // MARK: - SeguePreapre
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "PromiseDetailSegue"{
//            guard let next = segue.destination as? PromiseDetailVC else{return}
//            guard let cell : PromiseMainTableViewCell = sender as? PromiseMainTableViewCell else{return}
//               
//            next.promiseName = cell.promiseName.text
//            next.promisePlace = cell.promisePlace.text
//            next.promiseTime = cell.promiseTime.text
//            next.promiseAddress = cell.promiseAddress
//            next.promiseMemo = cell.promiseMemo
//            next.promiseFriend = cell.promiseFriend
//        }
//    }
}
