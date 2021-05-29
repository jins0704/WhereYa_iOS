//
//  PlaceService.swift
//  WhereYa
//
//  Created by 홍진석 on 2021/04/01.
//

import Foundation
import Alamofire

struct PlaceService {
    
    static let shared = PlaceService()
    
    let header: HTTPHeaders = ["Authorization" : APIConstants.RestApiKey]
    func getPlace(searchInput: String, completion: @escaping (NetworkResult<Any>) -> Void){
        let query : String = "\(APIConstants.placeURL)?analyze_type=similar&page=1&size=10&query=\(searchInput)"
        let encodedQuery : String = query.addingPercentEncoding(withAllowedCharacters: NSMutableCharacterSet.urlQueryAllowed)!
        let queryURL : URL = URL(string: encodedQuery)!
        
        let dataRequest = AF.request(queryURL,
                                     method: .get,
                                     encoding: JSONEncoding.default,
                                     headers: header).validate(statusCode: 200...500)
        dataRequest.responseData { response in
            switch response.result{
            //네트워크 성공시
            case .success :
                guard let statusCode =  response.response?.statusCode else { return }
                print(statusCode)
                
                guard let value =  response.value else{return}
                
                if statusCode <= 300{
                
                    let networkResult = self.judgeStatus(by : statusCode, value)
                    completion(networkResult)
                }
                
            case .failure: completion(.networkFail)
            }
        }
    }
    
    func getNearPlace(categoryCode: String, completion: @escaping (NetworkResult<Any>) -> Void){
        
        let query : String = "\(APIConstants.categoryURL)?category_group_code=\(categoryCode)&sort=accuracy&page=1&x=\(DEFAULT_POSITION.longitude)&y=\(DEFAULT_POSITION.latitude)&radius=500"
    
        let encodedQuery : String = query.addingPercentEncoding(withAllowedCharacters: NSMutableCharacterSet.urlQueryAllowed)!
        let queryURL : URL = URL(string: encodedQuery)!

        let dataRequest = AF.request(queryURL,
                                     method: .get,
                                     encoding: JSONEncoding.default,
                                     headers: header).validate(statusCode: 200...500)
        
        dataRequest.responseData { response in
            switch response.result{
            //네트워크 성공시
            case .success :
                guard let statusCode =  response.response?.statusCode else { return }
                print(statusCode)
                
                guard let value =  response.value else{return}
                
                if statusCode <= 300{
            
                    let networkResult = self.judgeStatus(by : statusCode, value)
                    completion(networkResult)
                }
                
            case .failure: completion(.networkFail)
            }
        }
    }
    
    private func judgeStatus(by statusCode : Int, _ data : Data) -> NetworkResult<Any>{
        let decoder = JSONDecoder()
        
        guard let decodedData = try? decoder.decode(PlaceResponse.self, from: data)
        else{return .serverErr}
    
        switch statusCode {
        case 200: return .success(decodedData.documents)
        case 400: return .requestErr("")
        case 500: return .serverErr
        default: return .networkFail
        }
    }
}


