//
//  CoffeeImage.swift
//  WhereYa
//
//  Created by 홍진석 on 2021/06/01.
//

import Foundation

struct CoffeeImage{
    static let images : [String] = ["cafe1","cafe2","cafe3","cafe4","cafe5","cafe6","cafe7","cafe8","cafe9","cafe10","cafe11","cafe12","cafe13","cafe14","cafe15"]
    
    enum brand : String{
        case ANGELINUS = "angelinus"
        case BACKDDABANG = "backddabang"
        case EDIYA = "ediya"
        case HOLLYS = "hollys"
        case MEGACOFFEE = "megacoffee"
        case PASCUCCI = "pascucci"
        case STARBUCKS = "starbucks"
        case TOMNTOMS = "tomntoms"
        case TWOSOME = "twosome"
        case BILLYANGEL = "billyangel"
        case SULBING = "sulbing"
    }
    
    static func selectImage(name : String, index : Int) -> String{
        if name.contains("엔제리너스"){return brand.ANGELINUS.rawValue}
        else if name.contains("빽다방"){return brand.BACKDDABANG.rawValue}
        else if name.contains("이디야"){return brand.EDIYA.rawValue}
        else if name.contains("할리스"){return brand.HOLLYS.rawValue}
        else if name.contains("메가커피"){return brand.MEGACOFFEE.rawValue}
        else if name.contains("파스쿠찌"){return brand.PASCUCCI.rawValue}
        else if name.contains("스타벅스"){return brand.STARBUCKS.rawValue}
        else if name.contains("탐앤탐스"){return brand.TOMNTOMS.rawValue}
        else if name.contains("투썸"){return brand.TWOSOME.rawValue}
        else if name.contains("설빙"){return brand.SULBING.rawValue}
        else if name.contains("빌리엔젤"){return brand.BILLYANGEL.rawValue}
        else{return CoffeeImage.images[index]}
    }
}
