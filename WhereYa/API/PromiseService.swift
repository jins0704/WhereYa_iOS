//
//  ResponsePromise.swift
//  WhereYa
//
//  Created by 홍진석 on 2021/04/08.
//

import Foundation
import Alamofire

struct PromiseService{
    static let shared = PromiseService()
 
    let header: HTTPHeaders = [NetworkHeaderKey.CONTENT_TYPE.rawValue: APIConstants.APPLICATION_JSON,
                               NetworkHeaderKey.auth.rawValue: UserDefaults.standard.string(forKey: "token")?.auth ?? ""]

    
    func makePromise(promise: Promise, completion: @escaping (NetworkResult<Any>) -> Void){
        
        let url : String = APIConstants.promiseMakeURL
    
        let dataRequest = AF.request(url,
                                     method: .post,
                                     encoding: JSONEncoding.default,
                                     headers: header).validate(statusCode: 200...500)
        
        dataRequest.responseData { response in
            switch response.result{

            case .success :
                guard let statusCode =  response.response?.statusCode else { return }
                
                print(statusCode)
    
                if statusCode <= 300{  completion(.success("success"))}
                else{completion(.requestErr("bad request"))}
 
            case .failure: completion(.networkFail)
    
            }
        }
    }
}
