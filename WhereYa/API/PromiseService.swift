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
    let decoder = JSONDecoder()
    let header: HTTPHeaders = [NetworkHeaderKey.CONTENT_TYPE.rawValue: APIConstants.APPLICATION_JSON,
                               NetworkHeaderKey.auth.rawValue: UserDefaults.standard.string(forKey: "token")?.auth ?? ""]
    
    func makePromise(promise: Promise, completion: @escaping (NetworkResult<Any>) -> Void){
     
        let parameter : Parameters = ["name" : promise.name ?? " ",
                                      "memo" : promise.memo ?? " ",
                                      "date" : promise.date ?? " ",
                                      "time" : promise.time ?? " ",
                                      "destination" :[
                                        "address_name" : promise.destination?.address_name ?? " ",
                                        "place_name" : promise.destination?.place_name ?? " ",
                                        "x" : promise.destination?.x ?? " ",
                                        "y" : promise.destination?.y ?? " "
                                        ],
                                      "friends" : promise.friends!]
     
        let url : String = APIConstants.promiseMakeURL
        let dataRequest = AF.request(url,
                                     method: .post,
                                     parameters: parameter,
                                     encoding: JSONEncoding.default,
                                     headers: header).validate(statusCode: 200...500)
        
        dataRequest.responseData { response in
            switch response.result{

            case .success :
                guard let statusCode =  response.response?.statusCode else { return }
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
         
                if statusCode <= 300{
                    do {
                        let result = try decoder.decode(ResponseCalendarEvents.self, from: value)
                        completion(.success(result.datesWithEvent ?? []))
                    } catch {completion(.requestErr(NetworkInfo.NO_DATA))}
                    
                }
                else{completion(.requestErr(NetworkInfo.BAD_REQUEST))}
 
            case .failure: completion(.networkFail)
    
            }
        }
    }
    
    func getPromiseList(_ selectedDate: String, completion: @escaping (NetworkResult<Any>) -> Void){
        let url : String = APIConstants.promiseList + selectedDate
        
        print(url)
        
        let dataRequest = AF.request(url,
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
                        let result = try decoder.decode(ResponsePromiseList.self, from: value)
                        
                        completion(.success(result.promiseList))
                        
                    } catch {completion(.requestErr(NetworkInfo.NO_DATA))}
                }
                else{completion(.requestErr(NetworkInfo.BAD_REQUEST))}
 
            case .failure: completion(.networkFail)
    
            }
        }
    }
    
    func getMainPromise(completion: @escaping (NetworkResult<Any>) -> Void){
        let url : String = APIConstants.mainPromiseURL

        let dataRequest = AF.request(url,
                                     method: .get,
                                     encoding: JSONEncoding.default,
                                     headers: header).validate(statusCode: 200...500)
        
        dataRequest.responseData { response in
            switch response.result{

            case .success :
                guard let statusCode =  response.response?.statusCode, let value =  response.value else{return}
         
                if statusCode <= 300{
                    do {
                        let result = try decoder.decode(MainNoticePromise.self, from: value)
                
                        completion(.success(result))
                        
                    } catch {completion(.requestErr(NetworkInfo.NO_DATA))}
                }
                else{completion(.requestErr(NetworkInfo.BAD_REQUEST))}
 
            case .failure: completion(.networkFail)
    
            }
        }
    }
}
