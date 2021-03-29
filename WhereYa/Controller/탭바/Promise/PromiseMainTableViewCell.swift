//
//  PromiseMainTableViewCell.swift
//  WhereYa
//
//  Created by 홍진석 on 2021/03/30.
//

import UIKit

class PromiseMainTableViewCell: UITableViewCell {

    @IBOutlet weak var promiseNameLabel: UILabel!
    @IBOutlet weak var promiseMemoLabel: UILabel!
    @IBOutlet weak var promiseMemberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
