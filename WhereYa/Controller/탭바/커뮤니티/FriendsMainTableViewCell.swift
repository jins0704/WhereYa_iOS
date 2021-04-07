//
//  FriendMainTableViewCell.swift
//  WhereYa
//
//  Created by 홍진석 on 2021/04/08.
//
import UIKit

class FriendsMainTableViewCell: UITableViewCell {
    
    var delegate : CellDelegate?
    
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet weak var profileNickname: UILabel!
    @IBOutlet var checkBtn: UIButton!
    
    
    @IBAction func checkBtnClicked(_ sender: Any) {
        guard let nickname = profileNickname.text else{return}
        
        if checkBtn.tintColor == UIColor.mainBlueColor{
            delegate?.cellChecked(nickname,false)
        }
        else{
            delegate?.cellChecked(nickname,true)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.layer.borderWidth = 1
        profileImage.clipsToBounds = true
        profileImage.layer.borderColor = UIColor.clear.cgColor
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: true)
    }
    
}
