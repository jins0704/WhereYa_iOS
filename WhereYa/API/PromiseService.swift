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
        
        requestPostData(url: url, httpmethod: .post, parameters: parameter, header: header) {(completionData) in

            completion(completionData)
        }
    }
    
    func getEvents(completion: @escaping (NetworkResult<Any>) -> Void){

        let url : String = APIConstants.promiseCheckEvents

        requestGetData(url: url, httpmethod: .get,header: header, decodeType: ResponseCalendarEvents.self) {(completionData) in
            completion(completionData)
        }
    }
    
    func getPromiseList(_ selectedDate: String, completion: @escaping (NetworkResult<Any>) -> Void){
        let url : String = APIConstants.promiseList + selectedDate
        
        requestGetData(url: url, httpmethod: .get, header: header, decodeType: ResponsePromiseList.self) {(completionData) in
            completion(completionData)
        }
    }
    
    func getMainPromise(completion: @escaping (NetworkResult<Any>) -> Void){
        let url : String = APIConstants.mainPromiseURL

        requestGetData(url: url, httpmethod: .get, header: header, decodeType: MainNoticePromise.self) {(completionData) in
            
            completion(completionData)
        }
    }
    
    func getPastPromiseList(completion: @escaping (NetworkResult<Any>) -> Void){
        let url : String = APIConstants.pastPromiseList
        
        requestGetData(url: url, httpmethod: .get, header: header, decodeType: ResponsePromiseList.self) {(completionData) in
            
            completion(completionData)
        }

    }
    
    func judgeStatus<T : Codable>(by statusCode : Int, _ data : Data, _ decodeType : T.Type) -> NetworkResult<Any>{
        let decoder = JSONDecoder()
        
        guard let decodedData = try? decoder.decode(decodeType, from: data)
        else{return .serverErr}
        switch statusCode {
        case 200: return .success(decodedData)
        case 400: return .requestErr(NetworkInfo.NO_DATA)
        case 500: return .serverErr
        default: return .networkFail
        }
    }
    
    func requestGetData<T : Codable> (url : String, httpmethod : HTTPMethod, header : HTTPHeaders, decodeType : T.Type,completion: @escaping (NetworkResult<Any>) -> Void){

        let dataRequest = AF.request(url,
                                     method: httpmethod,
                                     encoding: JSONEncoding.default,
                                     headers: header).validate(statusCode: 200...500)
        
        dataRequest.responseData { response in
            switch response.result{
            
            case .success :
                guard let statusCode =  response.response?.statusCode else { return }
                guard let value =  response.value else{return}
                
                let networkResult = self.judgeStatus(by : statusCode, value, decodeType)

                completion(networkResult)
            
            case .failure:
                completion(.serverErr)
            }
        }
    }
    
    func requestPostData(url : String, httpmethod : HTTPMethod, parameters : Parameters, header : HTTPHeaders, completion: @escaping (NetworkResult<Any>) -> Void){

        let dataRequest = AF.request(url,
                                     method: httpmethod,
                                     parameters: parameters,
                                     encoding: JSONEncoding.default,
                                     headers: header).validate(statusCode: 200...500)
        
        dataRequest.responseData { response in
            switch response.result{
            
            case .success :
                guard let statusCode =  response.response?.statusCode else { return }
                if statusCode <= 300{completion(.success(NetworkInfo.SUCCESS))}
                else {completion(.requestErr(NetworkInfo.BAD_REQUEST))}
            
            case .failure:
                completion(.serverErr)
            }
        }
    }
}
