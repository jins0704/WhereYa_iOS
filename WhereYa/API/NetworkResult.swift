//
//  NetworkResult.swift
//  GOGO
//
//  Created by 홍진석 on 2021/02/24.
//

import Foundation

enum NetworkResult<T> {
    
    case success(T)
    case requestErr(T)
    case serverErr
    case networkFail
    
}
