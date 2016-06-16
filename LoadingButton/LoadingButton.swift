//
//  LoadingButton.swift
//  LoadingButton
//
//  Created by david on 6/14/16.
//  Copyright © 2016 david. All rights reserved.
//

import UIKit

class LoadingButton: UIButton {
  
  // MARK: - Properties
  
  // Colors
  var color = UIColor(red:0.00, green:0.65, blue:0.88, alpha:1.00)
  var successColor = UIColor.greenColor()
  var failureColor = UIColor.redColor()
  
  // Bools
  var disablesUponSuccess: Bool = false
  var isLoading: Bool = false
  var toggled: Bool = false
  
  // Title
  private var titleBuffer: String!

  /// Delay before button returns to normal
  var delay: Double = 1.5
  
  /// Animation duration
  var duration: NSTimeInterval = 0.35
  
  // Width
  var widthConstraint: NSLayoutConstraint?
  var width: CGFloat! {
    didSet { updateWidth(width) }
  }
  
  // Font
  private var buttonFont: UIFont {
    get { return UIFont(name: "Avenir-Heavy", size: fontSize)! }
  }
  
  private var fontSize: CGFloat {
    get { return titleLabel?.font?.pointSize ?? 20 }
  }
  
  // Success & failure icons
  var successIcon = String.fontAwesomeIconWithCode("fa-check")
  var failureIcon = String.fontAwesomeIconWithCode("fa-times")
  
  // Spinner
  private var spinner: MMMaterialDesignSpinner!
  
  // Action
  private var action: ((sender: LoadingButton) -> Void)?
  
  
  
  // MARK: - Methods
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    sharedInit()
    width = frame.size.width
  }
  
  /// not working
  override init(frame: CGRect) {
    super.init(frame: CGRectZero)
    sharedInit()
//    translatesAutoresizingMaskIntoConstraints = false
//    removeConstraints(constraints)
//    
//    let h = NSLayoutConstraint(
//      item: self,
//      attribute: .Height,
//      relatedBy: .Equal,
//      toItem: nil,
//      attribute: .NotAnAttribute,
//      multiplier: 1,
//      constant: frame.height
//    )
//    
//    let y = NSLayoutConstraint(
//      item: self,
//      attribute: .CenterY,
//      relatedBy: .Equal,
//      toItem: nil,
//      attribute: .NotAnAttribute,
//      multiplier: 1,
//      constant: frame.origin.y + frame.width / 2
//    )
//    
//    let x = NSLayoutConstraint(
//      item: self,
//      attribute: .CenterX,
//      relatedBy: .Equal,
//      toItem: nil,
//      attribute: .NotAnAttribute,
//      multiplier: 1,
//      constant: frame.origin.x + frame.height / 2
//    )
//    
//    addConstraint(h)
//    addConstraint(y)
//    addConstraint(x)
//    
//    width = frame.width
  }
  
  /**
   Called when any init function is called. Performs the following:
   - Adds a shadow to the button
   - Set backgroundColor with button.color
   - Set titleBuffer with current title
   - Set font with button.buttonFont
   - Finds any width constraint and sets button.widthConstraint with it
   - Sets the width constraint with the current width
   */
  private func sharedInit() {
    addShadow()
    
    backgroundColor = color
    
    titleBuffer = titleLabel?.text
    titleLabel?.font = buttonFont
    
    for constraint in self.constraints {
      if constraint.firstAttribute == .Width || constraint.secondAttribute == .Width {
        widthConstraint = constraint
      }
    }
  }
  
  /// If the spinner hasn't been added, adds it
  override func layoutSubviews() {
    if spinner == nil {
      addSpinner(toView: self)
    }
    super.layoutSubviews()
  }
  
  /// Called once when didLayoutSubviews is called. Adds a spinner with 80% the frame of the button and
  private func addSpinner(toView view: UIView) {
    spinner = MMMaterialDesignSpinner()
    view.addSubview(spinner)
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(self.spinnerTouchUpInside))
    spinner.addGestureRecognizer(tap)
    
    spinner.lineWidth = 2.5
    spinner.tintColor = UIColor.whiteColor()
    spinner.backgroundColor = UIColor.clearColor()
    spinner.translatesAutoresizingMaskIntoConstraints = false
    
    let percentage: CGFloat = 0.8
    
    let centerXConstraint = NSLayoutConstraint(item: spinner, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0)
    let centerYConstraint = NSLayoutConstraint(item: spinner, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1, constant: 0)
    
    let widthConstraint = NSLayoutConstraint(item: spinner, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: percentage, constant: 1)
    let heightConstraint = NSLayoutConstraint(item: spinner, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: percentage, constant: 1)
    
    let constraints = [
      centerXConstraint,
      centerYConstraint,
      widthConstraint,
      heightConstraint
    ]
    
    addConstraints(constraints)
  }
  
  /// Overrides to set the titleBuffer to the title (if it's not blank, the successIcon, or the failureIcon)
  override func setTitle(title: String?, forState state: UIControlState) {
    super.setTitle(title, forState: state)
    if title != "" && title != successIcon && title != failureIcon {
      self.titleBuffer = title
    }
  }
  
  /// Calls when button.width is set. Removes the current width constraint and sets the new one with the new button.width.
  private func updateWidth(width: CGFloat) {
    if let widthConstraint = self.widthConstraint {
      removeConstraint(widthConstraint)
    }
    
    widthConstraint = NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: width)
    addConstraint(widthConstraint!)
  }
  
  /// Call to set the action of the button
  func setAction(action:(sender: LoadingButton) -> Void) {
    self.action = action
  }
  
  /// Called after the user performs a 'touch up inside' gesture upon the button spinner. Animates the button into a toggled/untoggled state.
  private func doButtonAnimation() {
    
    func animationDidFinish() {
      set(enabled: !toggled)
      
      switch toggled {
      case true:
        spinner.startAnimating()
      case false:
        titleLabel?.font = buttonFont
        setTitle(titleBuffer, forState: .Normal)
      }
    }
    
    toggled = !toggled
    
    set(enabled: false)
    
    switch toggled {
    case true:
      setTitle("", forState: .Normal)
      layer.cornerRadius = frame.size.height / 2
    case false:
      spinner.stopAnimating()
      layer.cornerRadius = 0
    }
    
//    layer.masksToBounds = toggled
    
    UIView.animateWithDuration(duration, delay: 0, options: .CurveEaseInOut, animations: {
      
      // Corner radius animation
      self.layoutIfNeeded()
      
      }) { (_) in
        
        // Corner radius animation done
        self.updateWidth(self.toggled ? self.frame.size.height : self.width)
        
        UIView.animateWithDuration(self.duration, delay: 0, options: .CurveEaseInOut, animations: {
          
          // Width animation
          self.layoutIfNeeded()
          self.backgroundColor = self.color
          
        }) { (_) in
          
          animationDidFinish()
        }
    }
  }
  
  /// Called when the user performs a 'touch up inside' gesture upon the button spinner (overlayed over the button).
  @objc private func spinnerTouchUpInside() {
    if !isLoading {
      action?(sender: self)
      isLoading = true
      doButtonAnimation()
    }
  }
  
  /// Called when button starts/stops animating. Disables button when animation begins and re-enables when animation finishes (it if button.disablesUponSuccess == false)
  private func set(enabled enabled: Bool) {
    self.enabled = enabled
    spinner.userInteractionEnabled = enabled
  }
  
  /// Call this function when the button finishes the operation. Provide a boolean success/failure value and optionally provide a block to call when the button finishes its animation into a success/failure state.
  func didFinishOperation(success: Bool, whenAnimationFinishes action:(() -> Void)?) {
    
    /// Called after didFinishOperation. Animates the button back to its initial state (if button.disablesUponSuccess == false).
    func buttonShouldReturnToNormal(success: Bool) {
      switch success {
      case true:
        self.set(enabled: !self.disablesUponSuccess)
        if !self.disablesUponSuccess {
          self.doButtonAnimation()
          self.setTitle("", forState: .Normal)
        }
        
      case false:
        self.doButtonAnimation()
        self.setTitle("", forState: .Normal)
      }
    }
    
    spinner.stopAnimating()
    isLoading = false
    
    if success {
      set(enabled: !disablesUponSuccess)
    }
    
    UIView.animateWithDuration(duration, animations: {
      self.titleLabel?.font = UIFont.fontAwesomeOfSize(self.fontSize)
      let title = success ? self.successIcon : self.failureIcon
      self.setTitle(title, forState: .Normal)
      self.backgroundColor = success ? self.successColor : self.failureColor
    }) { (_) in
      
      action?()
      
      self.performAfterDelay(self.delay, action: {
        buttonShouldReturnToNormal(success)
      })
    }
  }
}