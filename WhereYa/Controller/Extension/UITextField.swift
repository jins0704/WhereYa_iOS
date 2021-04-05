//
//  Textfield.swift
//  WhereYa
//
//  Created by 홍진석 on 2021/04/05.
//

import Foundation
import UIKit

extension UITextField{
    func underlineTextField(_ placeholder : String){
            self.borderStyle = .none
            self.returnKeyType = .done
            self.textColor = UIColor.lightGray
            self.font = UIFont.systemFont(ofSize: 18)
            self.placeholder = placeholder //placeholder 달기
            
            let border = CALayer()
            
            border.frame = CGRect(x: 0, y: self.frame.size.height+15, width: self.frame.width-50, height: 1)
            border.backgroundColor = UIColor.lightGray.cgColor
         
            self.layer.addSublayer((border))
        }
    
    func setLeftPaddingPoints(_ amount:CGFloat){ //왼쪽에 여백 주기
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
 
    func setRightPaddingPoints(_ amount:CGFloat) { //오른쪽에 여백 주기
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
