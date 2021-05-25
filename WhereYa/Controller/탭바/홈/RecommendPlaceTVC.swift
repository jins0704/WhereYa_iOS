//
//  RecommendPlaceTVC.swift
//  WhereYa
//
//  Created by 홍진석 on 2021/05/26.
//

import UIKit

class RecommendPlaceTVC: UITableViewCell {

    static let identifier = "RecommendPlaceTVC"
    
    @IBOutlet var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLabel.text = "근처 추천 스팟"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
