//
//  SignInService.swift
//  GOGO
//
//  Created by 홍진석 on 2021/02/25.
//

import Foundation
import Alamofire

struct SignUpService {
    
    static let shared = SignUpService()
    
    private func makeParameter(_ userInput: String, _ funcName : String) -> Parameters {
        switch funcName {
        case "checkID" :
            return ["userId": userInput]
        case "checkNickname" :
            return ["nickname": userInput]
        default:
            return [:]
        }
    }
    
    let header : HTTPHeaders = [NetworkHeaderKey.CONTENT_TYPE.rawValue: APIConstants.APPLICATION_JSON]
    
    func signUp(_ user : User, completion : @escaping(NetworkResult<Any>) -> Void ){
        
        let parameter : Parameters = ["userId" : user.userId ?? "a",
                         "password" : user.password ?? "a",
                         "nickname" : user.nickname ?? "a",
                         "gender" : user.gender ?? "a",
                         "birthday" : user.brithday ?? "a"]
        
        let dataRequest = AF.request(APIConstants.signupURL,
                                     method: .post,
                                     parameters: parameter,
                                     encoding: JSONEncoding.default,
                                     headers: header).validate(statusCode: 200...500)
        
        
        dataRequest.responseData { response in
            switch response.result{
            
            case .success :
                guard let statusCode =  response.response?.statusCode else { return }

                print(statusCode)
                
                if statusCode <= 300{
                    completion(.success(NetworkInfo.SUCCESS))
                }
                else{
                    completion(.requestErr(NetworkInfo.BAD_REQUEST))
                }
          
            case .failure: completion(.networkFail)
                
            }
        }
        
    }
    //2. 아이디 중복 확인
    //3. 닉네임 중복 확인
    func checkData(_ userInput : String, _ paraType : String, completion : @escaping(NetworkResult<Any>) -> Void ){
       
        let dataKorean : String?
        let url : URLConvertible?
        let body : Parameters?
        
        switch paraType {
       
        case "id":
            body = ["userId": userInput]
            dataKorean = "아이디"
            url = APIConstants.checkIdURL
            
        case "nickname":
            body = ["nickname": userInput]
            dataKorean = "닉네임"
            url = APIConstants.checkNicknameURL
            
        default:
            body = [:]
            dataKorean = ""
            url = ""
        }
        
        let dataRequest = AF.request(url!,
                                     method: .post,
                                     parameters: body,
                                     encoding: JSONEncoding.default,
                                     headers: header).validate(statusCode: 200...500)
        
        dataRequest.responseData {response in
            switch response.result{
            
            //400 사용가능한 아이디, 200 중복아이디
            case .success :
                guard let statusCode =  response.response?.statusCode else { return }

                if statusCode <= 300{completion(.success(dataKorean!))}
                else{completion(.requestErr(dataKorean!))}
                
            case .failure : completion(.networkFail)
            }
        }
    }
}
