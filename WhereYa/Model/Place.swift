//
//  Place.swift
//  WhereYa
//
//  Created by 홍진석 on 2021/04/01.
//

import Foundation

struct PlaceResponse : Codable{
    let meta : PlaceMeta
    let documents : [Place]
}
struct PlaceMeta : Codable{
    var total_count : Int?
    var pageable_count : Int?
    var is_end : Bool?
    var same_name : RegionInfo?
}

public struct RegionInfo : Codable{
    var region : [String]?
    var keyword : String?
    var selected_region : String?
    
}
public struct Place : Codable{
    var id : String?
    var place_name : String?
    var category_name : String?
    var category_group_code : String?
    var category_group_name : String?
    var phone : String?
    var address_name : String?
    var road_address_name : String?
    var x : String?
    var y : String?
    var place_url : String?
    var distance : String?
}
