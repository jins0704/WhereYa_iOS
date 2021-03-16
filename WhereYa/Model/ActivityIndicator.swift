//
//  ActivityIndicator.swift
//  GOGO
//
//  Created by 홍진석 on 2021/03/03.
//

import Foundation
import UIKit

class ActivityIndicator{
    
    static let shared = ActivityIndicator()
    
    var activityIndicator: UIActivityIndicatorView = {
       
        let activityIndicator = UIActivityIndicatorView()
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        
        let window =  UIApplication.shared.windows.first{$0.isKeyWindow}!
           
        activityIndicator.center = window.center
        window.addSubview(activityIndicator)
        
        return activityIndicator
    }()
}
