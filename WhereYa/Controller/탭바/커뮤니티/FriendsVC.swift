//
//  CommunityVC.swift
//  GOGO
//
//  Created by 홍진석 on 2021/03/09.
//

import UIKit
import Kingfisher

class FriendsVC: UIViewController {
   
    let cellIdentifier : String = "friendsMainTableViewCell"
    var isFiltering : Bool = false
    private var AllList : [Friend] = []
    private var filterList : [Friend] = []
    private var myProfile : [Friend] = []
    private var Bookmark_Friends: [Friend] = []
    private var Normal_Friends: [Friend] = []
    
    private let sections: [String] = ["내 프로필","즐겨찾기", "친구목록"]

    @IBOutlet weak var friendsTableView: UITableView!
    @IBOutlet weak var friendsSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getFriendsList()
        
        friendsTableView.delegate = self
        friendsTableView.dataSource = self
        friendsTableView.separatorStyle = .none
        
        friendsSearchBar.delegate = self
        friendsSearchBar.placeholder = "친구 닉네임 검색"
        //friendsTableView.cellLayoutMarginsFollowReadableWidth = false
        //friendsTableView.separatorInset.left = 0
  
        friendsTableView.register(UINib(nibName: "FriendsMainTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadMyProfile()
    }
    
    func loadMyProfile(){
        myProfile.removeAll()
        
        guard let myImage = UserDefaults.standard.string(forKey: UserKey.IMAGE) else {return }
        let myNickname = UserDefaults.standard.string(forKey: UserKey.NICKNAME)

        let mine = Friend(profileImg : myImage, nickname: myNickname ?? "", star: false)
        myProfile.append(mine)

        self.friendsTableView.reloadData()
    }
    
    func getFriendsList(){
        ProfileService.shared.getFriendsList { data in
            switch data{
            case .success(let friendData) :
                guard let friendData = friendData as? [Friend] else { return }
                for friend in friendData{
                    self.AllList.append(friend)
                    if friend.star == false{
                        self.Normal_Friends.append(friend)
                    }
                    else{
                        self.Bookmark_Friends.append(friend)
                    }
                }
               
                DispatchQueue.main.async {
                    self.friendsTableView.reloadData()
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
    
    // MARK: - Navigation

}
extension FriendsVC : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering{
            return filterList.count
        }
        else{
            switch section{
            
            case 0:
                return self.myProfile.count
            case 1:
                print(Bookmark_Friends.count)
                return self.Bookmark_Friends.count
            case 2:
                return self.Normal_Friends.count
                
            default:
                
                return 0
                
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : FriendsMainTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! FriendsMainTableViewCell
        
        var nick : String?
        var img : URL?
        
        if isFiltering {
            cell.profileNickname.text = filterList[indexPath.row].nickname
        }
        else{
            if indexPath.section == 0{
                if let imageString = self.myProfile[indexPath.row].profileImg ,let image = URL(string: imageString){
                    img = image
                }
                nick = self.myProfile[indexPath.row].nickname
            }
            else if indexPath.section == 1{
                if let imageString = self.Bookmark_Friends[indexPath.row].profileImg ,let image = URL(string: imageString){
                    img = image
                }
                nick = self.Bookmark_Friends[indexPath.row].nickname
            }
            else{
                if let imageString = self.Normal_Friends[indexPath.row].profileImg ,let image = URL(string: imageString){
                    img = image
                }
                nick = self.Normal_Friends[indexPath.row].nickname
            }
            
            cell.profileImage.kf.indicatorType = .activity
            cell.profileImage.kf.setImage(with: img)
            cell.profileNickname.text = nick
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if isFiltering {
            return "검색목록"
        }
        else{
            return sections[section]
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isFiltering{
            return 1
        }
        else{
            return 3
        }
    }
    

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}

extension FriendsVC : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
      
        friendsTableView.reloadData()
        friendsSearchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchtext = self.friendsSearchBar.text{
            if searchtext.count == 0{
                isFiltering = false
            }
            else{
                isFiltering = true
                
                //let predicate = NSPredicate(format: "title Contains[cd] %@", searchbar.text!)
                        //let request : NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
                        //request.predicate = predicate
                        //let descriptor = NSSortDescriptor(key: "title", ascending: true)
                        //request.sortDescriptors = [descriptor]
                        
                filterList = []
                for friend in AllList{
                    if let nickname = friend.nickname{
                        if nickname.contains(searchText){
                            filterList.append(friend)
                        }
                    }
                }
            
                self.friendsTableView.reloadData()
            }
        }
    }
}
