//
//  protocol.swift
//  WhereYa
//
//  Created by 홍진석 on 2021/03/26.
//

import Foundation

protocol PopUpDelegate{
    func doneBtnClicked(data : String)
    func placeClicked(place : Place)
    func friendClicked(friends : [String])
}

protocol CellDelegate {
    func cellChecked(_ nickname : String, _ changeBool : Bool)
}


protocol PromiseDelegate{
    func hiddenUI(hidden : Bool)
    func sendPromise(_ promise : Promise)
}
