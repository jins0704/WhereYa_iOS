//
//  FoodImage.swift
//  WhereYa
//
//  Created by 홍진석 on 2021/06/01.
//

import Foundation

struct FoodImage{
    static let images : [String] = ["food1","food2","food3","food4","food5","food6"]
    
    enum menu : String{
        case DDUCK = "dduck"
        case BRITTO = "buritto"
        case MARA = "mara"
        case DONKA = "donka"
        case MANDU = "mandu"
        case CHOBAB = "chobab"
        case BUNSIC = "bunsic"
        case MEONOK = "meonok"
        case GALBI = "sutbulgalbi"
        case PASTA = "italianpasta"
        case BANZUM = "banzum"
        case PIZZA = "pizza"
        case HAMBURGER = "hamburger"
        case ZZUGGUMI = "zzuggumi"
        case GUK = "guk"
        case ZZIGAE = "zzigae"
        case NOIMAGE = "noimage"
        case BABSANG = "babsang"
        case BAKERY = "bakery"
        case CALGUKSU = "calguksu"
        case CHICKEN = "chicken"
        case HANWOO = "hanwoo"
        case STEAK = "steak"
        case TACO = "taco"
    }
    
    static func selectImage(name : String, index : Int) -> String{
        if name.contains("떡볶이"){return menu.DDUCK.rawValue}
        else if name.contains("리또"){return menu.BRITTO.rawValue}
        else if name.contains("마라"){return menu.MARA.rawValue}
        else if name.contains("까스") || name.contains("카츠") || name.contains("까츠"){return menu.DONKA.rawValue}
        else if name.contains("만두"){return menu.MANDU.rawValue}
        else if name.contains("초밥"){return menu.CHOBAB.rawValue}
        else if name.contains("분식") || name.contains("김밥"){return menu.BUNSIC.rawValue}
        else if name.contains("면옥") || name.contains("냉면"){return menu.MEONOK.rawValue}
        else if name.contains("숯불") || name.contains("갈비"){return menu.GALBI.rawValue}
        else if name.contains("이탈리") || name.contains("파스타"){return menu.PASTA.rawValue}
        else if name.contains("반점") || name.contains("중국") || name.contains("짬뽕"){return menu.BANZUM.rawValue}
        else if name.contains("피자"){return menu.PIZZA.rawValue}
        else if name.contains("버거"){return menu.HAMBURGER.rawValue}
        else if name.contains("쭈꾸미"){return menu.ZZUGGUMI.rawValue}
        else if name.contains("칼국수"){return menu.CALGUKSU.rawValue}
        else if name.contains("국") || name.contains("순대"){return menu.GUK.rawValue}
        else if name.contains("찌개") || name.contains("김치"){return menu.ZZIGAE.rawValue}
        else if name.contains("밥상") || name.contains("밥"){return menu.BABSANG.rawValue}
        else if name.contains("베이커리") || name.contains("카페") {return menu.BAKERY.rawValue}
        else if name.contains("한우") || name.contains("고기") {return menu.HANWOO.rawValue}
        else if name.contains("치킨") || name.contains("통닭") {return menu.CHICKEN.rawValue}
        else if name.contains("스테이크"){return menu.STEAK.rawValue}
        else if name.contains("타코"){return menu.TACO.rawValue}
        else{return FoodImage.images[index%6]}
    }
}
