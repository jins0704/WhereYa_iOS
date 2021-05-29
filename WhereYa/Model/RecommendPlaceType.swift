//
//  RecommendPlaceType.swift
//  WhereYa
//
//  Created by 홍진석 on 2021/05/28.
//

import Foundation

enum RecommendPlaceType : CaseIterable{
    case cafe,food
    
    var identifier : String{
        switch self {
        case .cafe:
            return RecommendCafeTVC.identifier
        case .food:
            return RecommendFoodTVC.identifier
        }
    }
}
