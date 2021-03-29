//
//  PromiseMainVC.swift
//  WhereYa
//
//  Created by 홍진석 on 2021/03/30.
//

import UIKit

class PromiseMainVC: UIViewController {

    let arr : [String] = ["1","2","3","4"]
    let cellIdentifier : String = "promiseMainTableViewCell"
    
    @IBOutlet weak var promiseTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        promiseTableView.delegate = self
        promiseTableView.dataSource = self
        promiseTableView.register(UINib(nibName: "PromiseMainTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension PromiseMainVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : PromiseMainTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PromiseMainTableViewCell
        
        cell.selectionStyle = .none
        cell.promiseMemberLabel.text = arr[indexPath.row]
        return cell
    }
    
    
}
