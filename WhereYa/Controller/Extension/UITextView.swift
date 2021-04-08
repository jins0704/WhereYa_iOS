//
//  UITextView.swift
//  WhereYa
//
//  Created by 홍진석 on 2021/04/08.
//

import Foundation

extension UITextView{
    @IBInspectable var doneAccessory : Bool{
        get {
            return self.doneAccessory
        }
        set (hasDone){
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard(){
        let doneToolbar : UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done : UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(){
        self.resignFirstResponder()
    }
}
