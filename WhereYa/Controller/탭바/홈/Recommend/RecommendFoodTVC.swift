//
//  RecommendFoodTVC.swift
//  WhereYa
//
//  Created by 홍진석 on 2021/05/26.
//

import UIKit

class RecommendFoodTVC: UITableViewCell {
    
    static let identifier = "RecommendFoodTVC"
    var currentIdx : CGFloat = 0.0
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
    
        titleLabel.text = "약속장소와 가까운 음식점"
        titleLabel.font = UIFont.myMediumSystemFont(ofSize: 17)
        CollectionViewSetting()
    }
    
    
    func CollectionViewSetting(){
        recommendCV.dataSource = self
        recommendCV.delegate = self
        
        recommendCV.register(UINib(nibName: RecommendCVC.identifier, bundle: nil), forCellWithReuseIdentifier: RecommendCVC.identifier)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension RecommendFoodTVC : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        
        let cellWidth = width * (300/375)
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

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if let cv = scrollView as? UICollectionView {
            
            let layout = cv.collectionViewLayout as! UICollectionViewFlowLayout
            let cellWidth = layout.itemSize.width + layout.minimumLineSpacing
            
            var offset = targetContentOffset.pointee
            let idx = round((offset.x + cv.contentInset.left) / cellWidth)
            
            if idx > currentIdx {
                currentIdx += 1
            } else if idx < currentIdx {
                if currentIdx != 0 {
                    currentIdx -= 1
                }
            }
            
            offset = CGPoint(x: currentIdx * cellWidth - cv.contentInset.left, y: 0)
            
            targetContentOffset.pointee = offset
        }
    }
}

extension RecommendFoodTVC : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendCVC.identifier, for: indexPath) as? RecommendCVC else {return UICollectionViewCell()}

        cell.setData( list[indexPath.row].place_name!,  list[indexPath.row].phone!, list[indexPath.row].distance!,  list[indexPath.row].place_url!)
        cell.placeImg.image = UIImage(named: FoodImage.selectImage(name: list[indexPath.row].place_name!, index: indexPath.row))
        
        return cell
    }
    
}
