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
    
    func getPlace(searchInput: String, completion: @escaping (NetworkResult<Any>) -> Void){
        let query : String = "\(APIConstants.placeURL)?analyze_type=similar&page=1&size=10&query=\(searchInput)"

        let encodedQuery : String = query.addingPercentEncoding(withAllowedCharacters: NSMutableCharacterSet.urlQueryAllowed)!
        let queryURL : URL = URL(string: encodedQuery)!
        print(queryURL)
        let header: HTTPHeaders = ["Authorization" : "KakaoAK 41d57fc001acd4351d105785b7787be1"]
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
                
                guard let value =  response.value else{
                    return
                }

                if statusCode <= 300{
      
                    let decoder = JSONDecoder()
         
                    guard let result = try? decoder.decode(PlaceResponse.self, from: value) else {return}
         
                    completion(.success(result.documents))
                }
                else{
                    guard let statusCode =  response.response?.statusCode else { return }
                    print(statusCode)
                    completion(.requestErr(NetworkInfo.BAD_REQUEST))
                    
                }

            case .failure: completion(.networkFail)
    
            }
        }
    }
}
    
        
