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
            
                guard let result = list as? ResponsePromiseList else { return }
                
                self.promiseList = result.promiseList!
                
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
        pastTV.separatorStyle = .none
        pastTV.register(UINib(nibName: PromiseMainTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: PromiseMainTableViewCell.identifier)
    }
    // MARK: - IBAction
    @IBAction func closeBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension PastPromiseVC : UITableViewDelegate{
    func updateLateFriends(_ list : [User])-> String{
        var lateUsers : String = ""
        for friend in list{
            if friend.check == false{
                if(friend.nickname == list[list.count-1].nickname){//마지막 사람
                    lateUsers.append((friend.nickname!))}
                else{lateUsers.append("\(friend.nickname!), ")}
            }
        }
        
        return lateUsers
    }
}

extension PastPromiseVC : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return promiseList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : PromiseMainTableViewCell = tableView.dequeueReusableCell(withIdentifier: PromiseMainTableViewCell.identifier, for: indexPath) as! PromiseMainTableViewCell
        
        let promise = promiseList[indexPath.row]
        let lateFriends : String = updateLateFriends(promise.touchdownList ?? [])
    
        cell.setData(promise.name ?? "", lateFriends, promise.date ?? "")
        cell.setPastCell()
        
        return cell
    }
}
