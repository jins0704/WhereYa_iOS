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
        
        let parameter : Parameters = ["promise" : promise]
        
        let dataRequest = AF.request(url,
                                     method: .post,
                                     parameters: parameter,
                                     encoding: JSONEncoding.default,
                                     headers: header).validate(statusCode: 200...500)
        
        dataRequest.responseData { response in
            switch response.result{

            case .success :
                guard let statusCode =  response.response?.statusCode else { return }
                
                print(statusCode)
    
                if statusCode <= 300{  completion(.success(NetworkInfo.SUCCESS))}
                else{completion(.requestErr(NetworkInfo.BAD_REQUEST))}
 
            case .failure: completion(.networkFail)
    
            }
        }
    }
    
    func getEvents(completion: @escaping (NetworkResult<Any>) -> Void){
        
        let url : String = APIConstants.promiseCheckEvents
        
        let dataRequest = AF.request(url,
                                     method: .get,
                                     encoding: JSONEncoding.default,
                                     headers: header).validate(statusCode: 200...500)
        
        dataRequest.responseData { response in
            switch response.result{

            case .success :
                guard let statusCode =  response.response?.statusCode else { return }
                guard let value =  response.value else{return}
                
                print(statusCode)
    
                if statusCode <= 300{
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(ResponseCalendarEvents.self, from: value)
                        
                        completion(.success(result.datesWithEvent ?? []))
                        
                    } catch {
                        print(error.localizedDescription)
                        completion(.requestErr(NetworkInfo.NO_DATA))
                    }
                    
                }
                else{completion(.requestErr(NetworkInfo.BAD_REQUEST))}
 
            case .failure: completion(.networkFail)
    
            }
        }
    }
}
