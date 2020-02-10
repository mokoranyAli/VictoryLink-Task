//
//  UIViewController + ActivityIndicator.swift
//  Get Photos By Location
//
//  Created by Mohamed Korany Ali on 2/9/20.
//  Copyright © 2020 Mohamed Korany Ali. All rights reserved.
//

import Foundation
import UIKit


extension UIViewController {
    func showActivityIndicator() {
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        activityIndicator.backgroundColor = UIColor.lightGray
        activityIndicator.layer.cornerRadius = 6
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        
        
        activityIndicator.style = .large
        activityIndicator.startAnimating()
      

        activityIndicator.tag = 100 // 100 for example

        // before adding it, you need to check if it is already has been added:
        for subview in view.subviews {
            if subview.tag == 100 {
                print("already added")
                return
            }
        }

        
        view.addSubview(activityIndicator)
    }

    func hideActivityIndicator() {
        let activityIndicator = view.viewWithTag(100) as? UIActivityIndicatorView
        activityIndicator?.stopAnimating()

        // I think you forgot to remove it?
        activityIndicator?.removeFromSuperview()

        //UIApplication.shared.endIgnoringInteractionEvents()
    }
}
