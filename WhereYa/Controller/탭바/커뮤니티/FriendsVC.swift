//
//  CommunityVC.swift
//  GOGO
//
//  Created by 홍진석 on 2021/03/09.
//

import UIKit

class FriendsVC: UIViewController {
    let cellIdentifier : String = "communityMainTableViewCell"
    
    private let freeItems: [String] = ["자유롭게 물어봐요1", "자유롭게 물어봐요2", "자유롭게 물어봐요3", "자유롭게 물어봐요4", "자유롭게 물어봐요5", "자유롭게 물어봐요6"]
    private let foodtems: [String] = ["밥친구구해요1", "밥친구구해요2", "밥친구구해요3", "밥친구구해요4"]
    private let qnaItems: [String] = ["궁금해요1", "궁금해요2", "궁금해요3", "궁금해요4"]
    
    private let sections: [String] = ["자유게시판", "밥친구게시판", "QnA 게시판"]

    @IBOutlet weak var friendsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        friendsTableView.delegate = self
        friendsTableView.dataSource = self
        
        friendsTableView.register(UINib(nibName: "CommunityMainTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    

    
    // MARK: - Navigation

}
extension FriendsVC : UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        switch section{
        
        case 0:
            
            return self.freeItems.count
            
        case 1:
            
            return self.foodtems.count
        
        case 2:
            return self.qnaItems.count
            
        default:
            
            return 0
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : FriendsMainTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! FriendsMainTableViewCell
        
        var text : String?
        
        if indexPath.section == 0{
            text = self.freeItems[indexPath.row]
        }
        else if indexPath.section == 1{
            text = self.foodtems[indexPath.row]
        }
        else{
            text = self.qnaItems[indexPath.row]
        }
            
        cell.label.text = text

        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return sections[section]
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
       
        return 3
   
    }
}
