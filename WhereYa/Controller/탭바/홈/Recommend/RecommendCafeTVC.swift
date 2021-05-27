//
//  RecommendPlaceTVC.swift
//  WhereYa
//
//  Created by 홍진석 on 2021/05/26.
//

import UIKit

class RecommendCafeTVC: UITableViewCell {

    static let identifier = "RecommendCafeTVC"
    var myList : [Place] = []
    var list :[Place]{
        get {
            return myList
        }
        set(newVal){
            myList = newVal
            self.recommendCV.reloadData()
        }
    }
    @IBOutlet var recommendCV: UICollectionView!
    @IBOutlet var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = "근처 추천 카페"
        CollectionViewSetting()
        
    }
    
    func CollectionViewSetting(){
        recommendCV.dataSource = self
        recommendCV.delegate = self
        
        recommendCV.register(UINib(nibName: RecommendCVC.identifier, bundle: nil), forCellWithReuseIdentifier: RecommendCVC.identifier)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension RecommendCafeTVC : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        
        let cellWidth = width * (324/375)
        let cellHeight = cellWidth * (200/324)
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}

extension RecommendCafeTVC : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(list.count)
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendCVC.identifier, for: indexPath) as? RecommendCVC else {return UICollectionViewCell()}

        cell.setData( list[indexPath.row].place_name!,  list[indexPath.row].phone!, list[indexPath.row].distance!,  list[indexPath.row].place_url!)
        
        return cell
    }
    
}
