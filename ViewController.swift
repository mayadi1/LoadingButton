//
//  ViewController.swift
//  LoadingButton
//
//  Created by david on 6/14/16.
//  Copyright © 2016 david. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var button: LoadingButton!
  
  var toggle: Bool = true

  override func viewDidLoad() {
    super.viewDidLoad()
    
//    button.disablesUponSuccess = true
    button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    button.setTitle("button", forState: .Normal)
    
    button.setAction { (sender) in
      self.buttonWasTapped(sender)
    }
  }
  
  func buttonWasTapped(sender: LoadingButton) {
    toggle = !toggle
    performAfterDelay(2) { 
      sender.didFinishOperation(self.toggle, whenAnimationFinishes: nil)
//      if self.toggle {
//        self.doLoginAnimation()
//      }
    }
  }
  
  func doLoginAnimation() {
    let view = UIView(frame: self.button.frame)
    view.backgroundColor = self.button.backgroundColor
    view.layer.cornerRadius = view.frame.size.width / 2
    self.view.addSubview(view)
    
    self.button.layer.zPosition = 99
    view.layer.zPosition = self.button.layer.zPosition - 1
    
    performAfterDelay(1) { 
      UIView.animateWithDuration(1) {
        view.layer.zPosition = self.button.layer.zPosition + 1
        view.transform = CGAffineTransformMakeScale(99, 99)
        
        self.performAfterDelay(1.0, action: {
          self.button.alpha = 0
          UIView.animateWithDuration(0.5, animations: {
            self.button.alpha = 1
            view.alpha = 0
            view.backgroundColor = UIColor.whiteColor()
            }, completion: { (_) in
              view.removeFromSuperview()
          })
        })
      }
    }
  }
}

