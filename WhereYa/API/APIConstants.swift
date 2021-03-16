//
//  APIConstants.swift
//  GOGO
//
//  Created by 홍진석 on 2021/02/24.
//

import Foundation

struct APIConstants{
    static let BASE_URL = "http://ec2-3-34-181-223.ap-northeast-2.compute.amazonaws.com"
    
    //계정
    static let signinURL = APIConstants.BASE_URL + "/user/session"
    static let signupURL = APIConstants.BASE_URL + "/user"
    static let checkIdURL = APIConstants.BASE_URL + "/user/check/userId"
    static let checkNicknameURL = APIConstants.BASE_URL + "/user/check/nickname"
}
