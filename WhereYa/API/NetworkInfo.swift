//
//  NetworkInfo.swift
//  WhereYa
//
//  Created by 홍진석 on 2021/03/18.
//

import Foundation

extension String {
    var auth: String {
        return "Bears " + self
    }
}

enum NetworkHeaderKey: String {
    case auth = "Authorization"
}

struct NetworkInfo {
    static var networkHeader: [String: String] {
        return [NetworkHeaderKey.auth.rawValue: ""]
    }
}
