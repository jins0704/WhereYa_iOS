//
//  UIView.swift
//  WhereYa
//
//  Created by 홍진석 on 2021/06/06.
//

import Foundation
import UIKit

extension UIView{
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
