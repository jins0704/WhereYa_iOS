//
//  PromiseMainTableViewCell.swift
//  WhereYa
//
//  Created by 홍진석 on 2021/04/13.
//

import UIKit

class PromiseMainTableViewCell: UITableViewCell {

    static let identifier = "PromiseMainTableViewCell"
    @IBOutlet var innerView: UIView!
    @IBOutlet var promiseName: UILabel!
    @IBOutlet var promisePlace: UILabel!
    @IBOutlet var promiseTime: UILabel!
    @IBOutlet var detailBtn: UIButton!
    @IBOutlet var firstIcon: UIImageView!
    
    var promiseAddress : String?
    var promiseMemo : String?
    var promiseFriend : [String?] = []
    
    func setData(_ name : String, _ place: String, _ time : String){
        self.promiseName.text = name
        self.promisePlace.text = place
        self.promiseTime.text = time
    }
    func setPastCell(){
        self.firstIcon.tintColor = .subpink
        self.firstIcon.image = UIImage(systemName: "person.fill.xmark")
        self.detailBtn.isHidden = true
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
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
