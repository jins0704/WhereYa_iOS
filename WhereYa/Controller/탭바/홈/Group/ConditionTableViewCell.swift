//
//  ConditionTableViewCell.swift
//  WhereYa
//
//  Created by 홍진석 on 2021/06/07.
//

import UIKit

class ConditionTableViewCell: UITableViewCell {
    static let identifier = "ConditionTableViewCell"
    
    @IBOutlet var innerView: UIView!
    @IBOutlet var characterImage: UIImageView!
    @IBOutlet var nickname: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        innerView.layer.cornerRadius = 20
        innerView.layer.borderWidth = 0.1
        innerView.layer.borderColor = #colorLiteral(red: 0.5650870204, green: 0.6334136128, blue: 0.6995031834, alpha: 1)
        innerView.backgroundColor = .white
        innerView.layer.shadowOffset = CGSize(width: 1, height: 2)
        innerView.layer.shadowRadius = 15
        innerView.layer.shadowOpacity = 0.2
        innerView.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect:self.contentView.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(nickname : String, img : String){
        self.nickname.text = nickname
        self.characterImage.image = UIImage(named: img)
    }
}
