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
    @IBOutlet var promiseFriends: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        innerView.layer.cornerRadius = 20
        innerView.layer.borderWidth = 0.5
        innerView.layer.borderColor = #colorLiteral(red: 0.5650870204, green: 0.6334136128, blue: 0.6995031834, alpha: 1)
        innerView.backgroundColor = .white
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
