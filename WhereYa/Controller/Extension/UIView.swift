//
//  File.swift
//  WhereYa
//
//  Created by 홍진석 on 2021/04/19.
//

import Foundation
extension UIViewController{
    func swipDownDismiss(){
        let dismissGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeDown(_:)))
        dismissGesture.direction = .down
    
        self.view.addGestureRecognizer(dismissGesture)
        self.view.isUserInteractionEnabled = true
    }
    
    @objc func swipeDown(_ gesture: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
}
