//
//  Extensions.swift
//  LoadingButton
//
//  Created by david on 6/15/16.
//  Copyright © 2016 david. All rights reserved.
//

import Foundation

extension UIView {
  func addShadow() {
    if layer.shadowOpacity == 0 {
      layer.masksToBounds = false
      
      layer.shadowOpacity = 0.5
      layer.shadowRadius = 2
      
      layer.shadowOffset = CGSize(width: 0, height: 2)
      layer.shadowColor = UIColor.grayColor().CGColor
    }
  }
}

extension NSObject {
  func performAfterDelay(delay: Double, action:() -> Void) {
    dispatch_after(
      dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))),
      dispatch_get_main_queue()) { () -> Void in
        action()
    }
  }
}