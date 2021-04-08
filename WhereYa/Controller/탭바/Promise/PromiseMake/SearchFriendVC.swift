//
//  PromiseFriendVC.swift
//  WhereYa
//
//  Created by 홍진석 on 2021/04/08.
//

import UIKit

class SearchFriendVC: UIViewController {

    private let cellIdentifier : String = "friendsMainTableViewCell"
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var friendTableView: UITableView!
    @IBOutlet var selectedCollectionView: UICollectionView!
    @IBOutlet var invitedLabel: UILabel!
    @IBOutlet var friendsLabel: UILabel!
    
    var popupDelegate : PopUpDelegate?
    var isFiltering : Bool = false
    private var allList : [Friend] = []
    private var filterList : [Friend] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getFriendsList()
        
        searchBar.delegate = self
        searchBar.placeholder = "친구 닉네임 검색"
        searchBar.autocapitalizationType = .none
        
        friendTableView.delegate = self
        friendTableView.dataSource = self
        friendTableView.separatorStyle = .none
        friendTableView.register(UINib(nibName: "FriendsMainTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    // MARK: - IBAction
    @IBAction func backBtnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneBtnClicked(_ sender: Any) {
        var completeCheck = false
        var selectedFriends : [String]  = []
        
        for i in allList{
            if i.promiseCheck == true{
                selectedFriends.append(i.nickname ?? "")
                completeCheck = true
            }
        }
        if completeCheck == true{
            popupDelegate?.friendClicked(friends: selectedFriends)
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    // MARK: - func
    func getFriendsList(){
 
        allList.removeAll()
        
        FriendService.shared.getFriendsList { data in
            switch data{
            case .success(let friendData) :
                
                guard let friendData = friendData as? [Friend] else { return }
                
                for friend in friendData{
                    self.allList.append(friend)
                }
               
                DispatchQueue.main.async {
                    self.friendTableView.reloadData()
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
}

// MARK: - TableView
extension SearchFriendVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering{
            return filterList.count
        }
        
        else{
            return allList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : FriendsMainTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! FriendsMainTableViewCell
        
        cell.selectionStyle = .none
        cell.delegate = self
        var usingList : [Friend] = []
        
        var img : URL?
        
        usingList = isFiltering ? self.filterList : self.allList
     
        cell.profileNickname.text = usingList[indexPath.row].nickname
        
        if let imageString = usingList[indexPath.row].profileImg ,let image = URL(string: imageString){
            img = image
        }
        

        cell.profileImage.kf.indicatorType = .activity
        cell.profileImage.kf.setImage(with: img)
        
        if usingList[indexPath.row].promiseCheck ?? false{
            cell.checkBtn.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            cell.checkBtn.tintColor = UIColor.mainBlueColor
        }
        else{
            cell.checkBtn.setImage(UIImage(systemName: "circle"), for: .normal)
            cell.checkBtn.tintColor = UIColor.darkGray
        }
        
        return cell
    }
}

// MARK: - CellDelegate
extension SearchFriendVC : CellDelegate{
    func cellChecked(_ nickname: String, _ changeBool: Bool) {
        for friend in allList{
            if friend.nickname == nickname{
                friend.promiseCheck = changeBool
            }
        }
        self.friendTableView.reloadData()
    }
}

// MARK: - SearchBarDelegate
extension SearchFriendVC : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        friendTableView.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchtext = self.searchBar.text{
            if searchtext.count == 0{
                isFiltering = false
            }
            else{
                isFiltering = true
                
                filterList = []
                for friend in allList{
                    if let nickname = friend.nickname{
                        if nickname.contains(searchText){
                            filterList.append(friend)
                        }
                    }
                }
            }
            self.friendTableView.reloadData()
        }
    }
}
