//
//  protocol.swift
//  WhereYa
//
//  Created by 홍진석 on 2021/03/26.
//

import Foundation

protocol PopUpDelegate{
    func doneBtnClicked(data : String)
    func cellClicked(data : String)
}

protocol CellDelegate {
    func cellChecked(_ nickname : String, _ changeBool : Bool)
}
