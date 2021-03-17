//
//  User.swift
//  GOGO
//
//  Created by 홍진석 on 2021/02/26.
//

import Foundation

class User : Codable{
  
    var userId : String?
    var password : String?
    var nickname : String?
    var gender : String?
    var brithday : String?
    
    init(_ userId : String, _ password : String, _ nickname : String, _ gender : String, _ birthday : String){
        self.userId = userId
        self.password = password
        self.nickname = nickname
        self.gender = gender
        self.brithday = birthday
    }
}
