//
//  FriendService.swift
//  WhereYa
//
//  Created by 홍진석 on 2021/03/24.
//

import Foundation
import Alamofire

struct FriendService{
    
    static let shared = FriendService()
    
    let token = UserDefaults.standard.string(forKey: "token") ?? ""
    
    func getFriendsList(completion: @escaping (NetworkResult<Any>) -> Void){
        let header: HTTPHeaders = [NetworkHeaderKey.CONTENT_TYPE.rawValue: APIConstants.APPLICATION_JSON,
                                   NetworkHeaderKey.auth.rawValue: token.auth]
        
        let dataRequest = AF.request(APIConstants.friendsListURL,
                                     method: .get,
                                     encoding: JSONEncoding.default,
                                     headers: header).validate(statusCode: 200...500)
        
        dataRequest.responseData { response in
            switch response.result{
            case .success :
                guard let statusCode =  response.response?.statusCode else { return }
                guard let value =  response.value else{return}
                
                if statusCode <= 300{
                    
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(FriendResponse.self, from: value)
                        
                        completion(.success(result.friends))
                        
                    } catch {
                        print(error.localizedDescription)
                        completion(.requestErr("No Data"))
                    }
                }
                else{
                    completion(.requestErr("bad request123"))
                }
                
            //네트워크 실패
            case .failure: completion(.networkFail)
    
            }
        }
    }
    
//    private func makeParameter(_ friendNickName : String) -> Parameters {
//        return ["friendNickname": friendNickName]
//    }

    func addFriend(friendNickname: String, completion: @escaping (NetworkResult<Any>) -> Void){
        
        let header: HTTPHeaders = [NetworkHeaderKey.CONTENT_TYPE.rawValue: APIConstants.APPLICATION_JSON,
                                   NetworkHeaderKey.auth.rawValue: token.auth]
        let url : String = APIConstants.addFriendURL + friendNickname
    
        let dataRequest = AF.request(url,
                                     method: .post,
                                     encoding: JSONEncoding.default,
                                     headers: header).validate(statusCode: 200...500)
        
        dataRequest.responseData { response in
            switch response.result{
            //네트워크 성공시
            case .success :
                guard let statusCode =  response.response?.statusCode else { return }
                
                print(statusCode)
    
                if statusCode <= 300{
           
                    completion(.success("success"))
                }
                else{
                    completion(.requestErr("bad request"))
                }
                
            //네트워크 실패
            case .failure: completion(.networkFail)
    
            }
        }
    }
    
    func removeFriend(friendNickname: String, completion: @escaping (NetworkResult<Any>) -> Void){
        
        let header: HTTPHeaders = [NetworkHeaderKey.CONTENT_TYPE.rawValue: APIConstants.APPLICATION_JSON,
                                   NetworkHeaderKey.auth.rawValue: token.auth]
        let url : String = APIConstants.addFriendURL + friendNickname
        let dataRequest = AF.request(url,
                                     method: .delete,
                                     encoding: JSONEncoding.default,
                                     headers: header).validate(statusCode: 200...500)
        
        dataRequest.responseData { response in
            switch response.result{
            //네트워크 성공시
            case .success :
                guard let statusCode =  response.response?.statusCode else { return }
                
                print(statusCode)
        
                if statusCode <= 300{
           
                    completion(.success("success"))
                }
                else{
                    completion(.requestErr("bad request"))
                }
                
            //네트워크 실패
            case .failure: completion(.networkFail)
    
            }
        }
    }
}
