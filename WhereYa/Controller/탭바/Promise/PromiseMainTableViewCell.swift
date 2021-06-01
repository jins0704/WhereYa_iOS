//
//  PromiseMainTableViewCell.swift
//  WhereYa
//
//  Created by 홍진석 on 2021/04/13.
//

import UIKit

class PromiseMainTableViewCell: UITableViewCell {

    @IBOutlet var innerView: UIView!
    @IBOutlet var promiseName: UILabel!
    @IBOutlet var promisePlace: UILabel!
    @IBOutlet var promiseTime: UILabel!
    
    var promiseAddress : String?
    var promiseMemo : String?
    var promiseFriend : [String?] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        innerView.layer.cornerRadius = 20
        innerView.layer.borderWidth = 0.1
        innerView.layer.borderColor = #colorLiteral(red: 0.5650870204, green: 0.6334136128, blue: 0.6995031834, alpha: 1)
        innerView.backgroundColor = .white
        promiseTime.font = UIFont.myMediumSystemFont(ofSize: 13)
        promisePlace.font = UIFont.myMediumSystemFont(ofSize: 13)
        promiseName.font = UIFont.myRegularSystemFont(ofSize: 16)
        innerView.layer.shadowColor = UIColor.mainBlueColor.cgColor
        innerView.layer.shadowOffset = CGSize(width: 1, height: 2)
        innerView.layer.shadowRadius = 15
        innerView.layer.shadowOpacity = 0.2
        innerView.layer.masksToBounds = false

        self.layer.shadowPath = UIBezierPath(roundedRect:self.contentView.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
