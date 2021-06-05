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
    static let BASE_URL = "http://ec2-3-34-48-38.ap-northeast-2.compute.amazonaws.com"
    static let SOCKET_URL = "ws://ec2-3-34-48-38.ap-northeast-2.compute.amazonaws.com/ws"
    
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
    
    //메인 최신 약속 조회
    static let mainPromiseURL = APIConstants.BASE_URL + "/promise/proximate"
    //약속일정 조회
    static let promiseCheckEvents = APIConstants.BASE_URL + "/promise/checkDate"
    //약속목록 조회
    static let promiseList = APIConstants.BASE_URL + "/promise/date/"
    //약속 추가
    static let promiseMakeURL = APIConstants.BASE_URL + "/promise"
    //지난 약속 조회
    static let pastPromiseList = APIConstants.BASE_URL + "/promise/passed"
    
    //지도 검색
    static let placeURL = "https://dapi.kakao.com/v2/local/search/keyword.json"
    
    static let RestApiKey = "KakaoAK 41d57fc001acd4351d105785b7787be1"
    //카테고리 검색
    static let categoryURL = "https://dapi.kakao.com/v2/local/search/category.json"
}
