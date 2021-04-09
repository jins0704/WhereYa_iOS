//
//  APIConstants.swift
//  GOGO
//
//  Created by 홍진석 on 2021/02/24.
//

import Foundation

struct APIConstants{
    
    static let MULTIPART = "multipart/form-data"
    static let APPLICATION_JSON =  "application/json"
    static let BASE_URL = "http://ec2-15-165-205-7.ap-northeast-2.compute.amazonaws.com"
    
    //계정
    static let signinURL = APIConstants.BASE_URL + "/user/login"
    static let signupURL = APIConstants.BASE_URL + "/user"
    static let checkIdURL = APIConstants.BASE_URL + "/user/check/userId"
    static let checkNicknameURL = APIConstants.BASE_URL + "/user/check/nickname"
    
    //프로필이미지
    static let profileUpdateURL = APIConstants.BASE_URL + "/user/upload/img"
    static let profileGetURL = APIConstants.BASE_URL + "/user"
    
    //친구목록 조회
    static let friendsListURL = APIConstants.BASE_URL + "/friend"
    //친구목록 추가
    static let addFriendURL = APIConstants.BASE_URL + "/friend/"
    //즐겨찾기 추가
    static let bookmarkFriendURL = APIConstants.BASE_URL + "/friend/bookmark/"
    
    //약속 캘린더 확인
    static let promiseCheckEvents = APIConstants.BASE_URL + "/promise/checkDate"
    //약속 추가
    static let promiseMakeURL = APIConstants.BASE_URL + "/promise"
    
    //지도 검색
    static let placeURL = "https://dapi.kakao.com/v2/local/search/keyword.json"
    
    static let RestApiKey = "//"
}
