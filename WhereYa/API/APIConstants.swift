//
//  APIConstants.swift
//  GOGO
//
//  Created by 홍진석 on 2021/02/24.
//

import Foundation

struct APIConstants{
    static let BASE_URL = "http://ec2-15-165-205-7.ap-northeast-2.compute.amazonaws.com"
    
    //계정
    static let signinURL = APIConstants.BASE_URL + "/user/login"
    static let signupURL = APIConstants.BASE_URL + "/user"
    static let checkIdURL = APIConstants.BASE_URL + "/user/check/userId"
    static let checkNicknameURL = APIConstants.BASE_URL + "/user/check/nickname"
    
    //프로필이미지
    static let profileUpdateURL = APIConstants.BASE_URL + "/user/upload/img"
    static let profileGetURL = APIConstants.BASE_URL + "/user"
}
