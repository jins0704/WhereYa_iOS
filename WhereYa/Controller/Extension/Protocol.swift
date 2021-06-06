//
//  protocol.swift
//  WhereYa
//
//  Created by 홍진석 on 2021/03/26.
//

import Foundation

protocol popupDelegate{
    func doneBtnClicked(data : String)
    func placeClicked(place : Place)
    func friendClicked(friends : [String])
}

protocol cellDelegate {
    func cellChecked(_ nickname : String, _ changeBool : Bool)
}


protocol dataDelegate{
    func hiddenUI(hidden : Bool)
    func sendPromise(_ promise : Promise)
    func sendUserLocation(_ userlocations : [UserLocation])
}
