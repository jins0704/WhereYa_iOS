//
//  CommunityVC.swift
//  GOGO
//
//  Created by 홍진석 on 2021/03/09.
//

import UIKit

class FriendsVC: UIViewController {
   
    let user = UserDefaults.standard
    let cellIdentifier : String = "friendsMainTableViewCell"
    var isFiltering : Bool = false
    
    private var filterList : [Friend] = []
    private var myProfile : [Friend] = []
    private var Bookmark_Friends: [Friend] = []
    private var Normal_Friends: [Friend] = []
    
    private let sections: [String] = ["내 프로필","즐겨찾기", "친구목록"]

    @IBOutlet weak var friendsTableView: UITableView!
    @IBOutlet weak var friendsSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        friendsTableView.delegate = self
        friendsTableView.dataSource = self
        friendsTableView.separatorStyle = .none
        
        friendsSearchBar.delegate = self
        friendsSearchBar.placeholder = "친구 닉네임 검색"
        //friendsTableView.cellLayoutMarginsFollowReadableWidth = false
        //friendsTableView.separatorInset.left = 0
        
        loadList()
        
        friendsTableView.register(UINib(nibName: "FriendsMainTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        ProfileService.shared.getFriendsList { data in
            switch data{
            case .success(let friendData) :
                guard let friendData = friendData as? [Friend] else { return }
                for friend in friendData{
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
    
    func loadList(){
        guard let myImage = user.string(forKey: UserKey.IMAGE) else {return }
        let myNickname = user.string(forKey: UserKey.NICKNAME)
        let mine = Friend(profileImg : myImage, nickname: myNickname ?? "", star: false)
        myProfile.append(mine)
        print(mine)
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
        var img : String?
        
        if isFiltering {
            cell.profileNickname.text = filterList[indexPath.row].nickname
        }
        else{
            if indexPath.section == 0{
                img = self.myProfile[indexPath.row].profileImg
                nick = self.myProfile[indexPath.row].nickname
            }
            else if indexPath.section == 1{
                img = self.Bookmark_Friends[indexPath.row].profileImg
                nick = self.Bookmark_Friends[indexPath.row].nickname
            }
            else{
                img = self.Normal_Friends[indexPath.row].profileImg
                nick = self.Normal_Friends[indexPath.row].nickname
            }
            
            if let url = URL(string: img ?? "https://gogoeverybodyy.s3.ap-northeast-2.amazonaws.com/static/8E5176DA-9CB1-4B21-9B62-EE7FDB289549.jpeg"){
                do{
                    let urldata = try Data(contentsOf: url)
                    cell.profileImage.image = UIImage(data: urldata)
                }catch{
                    print("data error")
                    print(error)
                }
            }
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
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    
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
}
