//
//  CommunityMainTableViewCell.swift
//  GOGO
//
//  Created by 홍진석 on 2021/03/13.
//

import UIKit

class FriendsMainTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileNickname: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.layer.borderWidth = 1
        profileImage.clipsToBounds = true
        profileImage.layer.borderColor = UIColor.clear.cgColor
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
