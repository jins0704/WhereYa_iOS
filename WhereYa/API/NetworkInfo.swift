//
//  NetworkInfo.swift
//  WhereYa
//
//  Created by 홍진석 on 2021/03/18.
//

import Foundation

extension String {
    var auth: String {
        return "Bearer " + self
    }
}

enum NetworkHeaderKey: String {
    case auth = "Authorization"
    case CONTENT_TYPE = "Content-Type"
}

struct NetworkInfo {
    static var networkHeader: [String: String] {
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        return [NetworkHeaderKey.auth.rawValue: token.auth]
    }
    static var networkHeader2: [String: String] {
        return [NetworkHeaderKey.CONTENT_TYPE.rawValue: "application/json"]
    }
    
    static let NO_DATA = "No Data"
    static let BAD_REQUEST = "Bad Request"
    static let SUCCESS = "success"
    static let SERVER_FAIL = "Server Fail"
    static let NETWORK_FAIL = "Network Fail"
}
