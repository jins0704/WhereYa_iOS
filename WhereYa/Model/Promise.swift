//
//  Promise.swift
//  WhereYa
//
//  Created by 홍진석 on 2021/04/08.
//

import Foundation

struct ResponsePromiseList : Codable{
    let promiseList: [Promise]
}
struct Promise : Codable{
    var name : String?
    var date : String?
    var time : String?
    var memo : String?
    var destination : Place?
    var friends : [String]?
}
