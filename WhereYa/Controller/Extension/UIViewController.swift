//
//  File.swift
//  WhereYa
//
//  Created by 홍진석 on 2021/04/19.
//

import Foundation
extension UIViewController{
    func swipDownDismiss(){
        let dismissGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeDismiss(_:)))
        dismissGesture.direction = .down
    
        self.view.addGestureRecognizer(dismissGesture)
        self.view.isUserInteractionEnabled = true
    }
    
    func swipRightDismiss(){
        let dismissGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipePop(_:)))
        dismissGesture.direction = .right
    
        self.view.addGestureRecognizer(dismissGesture)
        self.view.isUserInteractionEnabled = true
    }
 
    
    @objc func swipeDismiss(_ gesture: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func swipePop(_ gesture: UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
}
