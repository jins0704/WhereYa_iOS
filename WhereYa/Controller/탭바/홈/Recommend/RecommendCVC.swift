//
//  RecommendCVC.swift
//  WhereYa
//
//  Created by 홍진석 on 2021/05/26.
//

import UIKit

class RecommendCVC: UICollectionViewCell {
    
    static let identifier = "RecommendCVC"
    @IBOutlet var placeImg: UIImageView!
    @IBOutlet var placeName: UILabel!
    @IBOutlet var placePhone: UILabel!
    @IBOutlet var placeDistance: UILabel!
    @IBOutlet var placeURL: UILabel!
    
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 10
        //self.backgroundColor = UIColor.mainBlueColor

        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 0)
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 0.3
        self.layer.masksToBounds = false

        self.layer.shadowPath = UIBezierPath(roundedRect:self.contentView.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath

        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(_ name : String, _ phone: String, _ distance : String, _ url : String){
        self.placeName.text = name
        self.placePhone.text = "전화번호 : \(phone)"
        self.placeDistance.text = "거리 : \(distance)m"
        self.placeURL.text = "추후 링크 추가"
    }

}
