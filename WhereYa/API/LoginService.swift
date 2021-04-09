//
//  LoginService.swift
//  GOGO
//
//  Created by 홍진석 on 2021/02/24.
//

import Foundation
import Alamofire

struct LoginService {
    
    static let shared = LoginService()
    
    private func makeParameter(_ id: String, _ pwd: String) -> Parameters {
        return ["userId": id, "password": pwd]
    }
    
    func login(_ id : String, _ pwd : String , completion : @escaping(NetworkResult<Any>) -> Void ){
        
        let header : HTTPHeaders = [NetworkHeaderKey.CONTENT_TYPE.rawValue: APIConstants.APPLICATION_JSON]
        
        let dataRequest = AF.request(APIConstants.signinURL,
                                     method: .post,
                                     parameters: makeParameter(id, pwd),
                                     encoding: JSONEncoding.default,
                                     headers: header).validate(statusCode: 200...500)
        
        dataRequest.responseData { response in
            switch response.result{
            //네트워크 성공시
            case .success :
                guard let statusCode =  response.response?.statusCode else { return }
                guard let value =  response.value else{return}
                
                print(statusCode)
                
                if statusCode <= 300{
                    let decoder = JSONDecoder()
                    
                    guard let decodedData = try? decoder.decode(Token.self, from: value) else {return}
                    
                    print(decodedData)
                    
                    let tokenData = decodedData
                    
                    completion(.success(tokenData))
                }
                else{completion(.requestErr(NetworkInfo.BAD_REQUEST))}
                
            //네트워크 실패
            case .failure: completion(.networkFail)
            }
        }
    }
}
