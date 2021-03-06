//
//  ProfileData.swift
//  WhereYa
//
//  Created by 홍진석 on 2021/03/22.
//

import Foundation


struct ResponseFriend : Codable{
    let friends : [Friend]
}
class Friend : Codable{
    
    var profileImg : String?
    var nickname : String?
    var star : Bool?
    var promiseCheck : Bool?
    
    init(profileImg : String, nickname : String, star : Bool) {
        self.profileImg = profileImg
        self.nickname = nickname
        self.star = star
    }
    
}
