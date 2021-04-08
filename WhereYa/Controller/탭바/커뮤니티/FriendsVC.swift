//
//  CommunityVC.swift
//  GOGO
//
//  Created by 홍진석 on 2021/03/09.
//

import UIKit
import Kingfisher

class FriendsVC: UIViewController, PopUpDelegate {
    

    private let cellIdentifier : String = "friendsMainTableViewCell"
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
        
        friendsSearchBar.autocapitalizationType = .none
        
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
 
        Normal_Friends.removeAll()
        Bookmark_Friends.removeAll()
        AllList.removeAll()
        
        FriendService.shared.getFriendsList { data in
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
    // MARK: - popupdelegate
    func doneBtnClicked(data: String) {
        if data == "okay"{
            getFriendsList()
        }
        
    }
    func friendClicked(friends: [String]) {}
    func placeClicked(place: Place) {}
    
    // MARK: - IBAction
    @IBAction func addFriend(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "친구 추가", message: "친구의 닉네임을 입력하세요", preferredStyle: .alert)
        
        let insertBtn = UIAlertAction(title: "확인", style: .default) { (insert) in
            if let nickname = alert.textFields?[0].text{
                FriendService.shared.addFriend(friendNickname: nickname) { (data) in
                    print(data)
                    ActivityIndicator.shared.activityIndicator.stopAnimating()
                    
                    switch data{
                    
                    case .success(let message) :
                        self.getFriendsList()
                        print(message)
                        
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
        }
        
        let cancelBtn = UIAlertAction(title: "취소", style: .cancel) { (cancel) in
        }
        
        alert.addTextField()
        alert.addAction(insertBtn)
        alert.addAction(cancelBtn)
        
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - TableViewDelegate, TableViewDataSource
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
        
        cell.selectionStyle = .none
        cell.checkBtn.isHidden = true
        
        var img : URL?
        var usingArray : [Friend] = []
        
        if isFiltering {
            if let imageString = self.AllList[indexPath.row].profileImg ,let image = URL(string: imageString){
                img = image
            }
            
            cell.profileNickname.text = self.filterList[indexPath.row].nickname
        }
        else{
            switch indexPath.section{
            case 0 :
                usingArray = self.myProfile
            case 1 :
                usingArray = self.Bookmark_Friends
            case 2 :
                usingArray = self.Normal_Friends
            default: break
            }
            if let imageString = usingArray[indexPath.row].profileImg ,let image = URL(string: imageString){
                img = image
            }
            cell.profileNickname.text = usingArray[indexPath.row].nickname
        }
        
        cell.profileImage.kf.indicatorType = .activity
        cell.profileImage.kf.setImage(with: img)
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var usingArray : [Friend] = []
        switch indexPath.section{
        case 0 :
            usingArray = self.myProfile
        case 1 :
            usingArray = self.Bookmark_Friends
        case 2 :
            usingArray = self.Normal_Friends
        default: break
        }
        
        if !isFiltering && indexPath.section != 0{
            
            let storyboard = UIStoryboard.init(name: "FriendSettingPopUp", bundle: nil)
           
            let popUpVC = storyboard.instantiateViewController(identifier: "FriendSettingPopUpVC") as! FriendSettingPopUpVC
           
            popUpVC.modalPresentationStyle = .overCurrentContext
            popUpVC.modalTransitionStyle = .crossDissolve
            
            popUpVC.popupDelegate = self
            
            if let fNickname = usingArray[indexPath.row].nickname{
                popUpVC.detailNickname = fNickname
            }
            if let fImg = usingArray[indexPath.row].profileImg{
                popUpVC.detailImg = fImg
            }
            if let fStar = usingArray[indexPath.row].star{
                popUpVC.detailStar = fStar
            }
            
            self.present(popUpVC, animated: true) {
            }
        }
    }
}

// MARK: - SearchBarDelegate
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
            }
            self.friendsTableView.reloadData()
        }
    }
}
