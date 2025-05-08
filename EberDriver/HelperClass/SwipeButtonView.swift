//
//  DrawView.swift
//  DrawButton
//
//  Created by ktrkathir on 26/01/19.
//  Copyright © 2019 ktrkathir. All rights reserved.
//

import UIKit

/// DrawSwitchView
@IBDesignable class SwipeButtonView: UIView {
    
    /// Radius of background view
    @IBInspectable var radius: CGFloat = 10.0
    
    /// Background hint view
    @IBInspectable var hint: String = ""
    
    /// drag image
    @IBInspectable var image: UIImage?
    
    /// state
    private var isSuccess: Bool = false
    
    /// Completion handler
    private var completionHandler: ((_ isSuccess: Bool) -> ())?
    
    public var hintLabel: UILabel = UILabel()
        
    public var swipeImageView: UIImageView = UIImageView()
    
    public var xOrigin:CGFloat = 0
    
    public var startColor:UIColor = UIColor.black
    public var endColor:UIColor = UIColor.gray
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initSetUp()
        setUp()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSetUp()
        setUp()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        
        setUp()
    }
    
    private func initSetUp() {
        self.addSubview(hintLabel)
        self.addSubview(swipeImageView)
        self.bringSubviewToFront(hintLabel)
        self.bringSubviewToFront(swipeImageView)
        
        swipeImageView.frame = CGRect(x: 5, y: 5, width: frame.height - 10, height: frame.height - 10)
        swipeImageView.backgroundColor = .white//UIColor(red: 123/255, green: 123/255, blue: 123/255, alpha: 1.0)
        
        hintLabel.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        hintLabel.textColor = UIColor.white
        hintLabel.textAlignment = .center
        hintLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        swipeImageView.layer.cornerRadius = (frame.height - 10) / 2
        swipeImageView.layer.borderColor = UIColor.clear.cgColor
        swipeImageView.layer.borderWidth = 5
        swipeImageView.contentMode = .center
        swipeImageView.isUserInteractionEnabled = true
        
        
        self.reset()
    }
    
    private func setUp() {
        hintLabel.text = hint
        swipeImageView.image = image
        self.backgroundColor = .themeButtonBackgroundColor
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        if let touch = touches.first, swipeImageView == touch.view {
            let touchedPosition = touch.location(in: self)
            
            let alpha = (1.0 -  touchedPosition.x / frame.width)
            //swipeImageView.alpha = alpha
            hintLabel.alpha = alpha
            
            if touchedPosition.x > (frame.height/2) {
                swipeImageView.center = CGPoint(x: touchedPosition.x, y: swipeImageView.frame.midY)
            }
            
            let distancePointRGB = getColorDiffrent()
            let colorValueR = (distancePointRGB.0 * touchedPosition.x) + CGFloat(startColor.rgb()!.0)
            let colorValueG = (distancePointRGB.1 * touchedPosition.x) + CGFloat(startColor.rgb()!.1)
            let colorValueB = (distancePointRGB.2 * touchedPosition.x) + CGFloat(startColor.rgb()!.2)
            //print("\(colorValueR)   \(colorValueG)   \(colorValueB)")
            //self.backgroundColor = UIColor(red: colorValueR/255, green: colorValueG/255, blue: colorValueB/255, alpha: 1.0)
            
            self.xOrigin = touchedPosition.x
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if let touch = touches.first, swipeImageView == touch.view {
            // let touchedPosition = touch.location(in: self)
            setToDefault()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        if let touch = touches.first, swipeImageView == touch.view {
            setToDefault()
        }
    }
    
    /// Set to default
    private func setToDefault() {
        
        if self.frame.midX > swipeImageView.center.x { // Move to initial
            UIView.animate(withDuration: 0.25, animations: {
                self.swipeImageView.frame.origin = CGPoint(x: 5, y: 5)
                self.swipeImageView.alpha = 1.0
                self.hintLabel.alpha = 1.0
            }) { (isFinished) in
                if isFinished {
                    self.isSuccess = false
                    //self.backgroundColor = self.startColor
                    if let complete = self.completionHandler {
                        complete(self.isSuccess)
                    }
                }
            }
        } else if self.frame.midX < swipeImageView.center.x { // Move to final
            let xPosi = self.frame.width - (self.swipeImageView.frame.width + 5)
            
            UIView.animate(withDuration: 0.25, animations: {
                self.swipeImageView.frame.origin = CGPoint(x: xPosi, y: 5)
                //self.swipeImageView.alpha = 0.1
                self.hintLabel.alpha = 0.5
                //self.backgroundColor = self.endColor
            }) { (isFinished) in
                if isFinished {
                    self.isSuccess = true
                    
                    if let complete = self.completionHandler {
                        complete(self.isSuccess)
                    }
                }
            }
        }
    }
    
    func reset() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            self.swipeImageView.frame.origin = CGPoint(x: 5, y: 5)
            self.swipeImageView.alpha = 1.0
            self.hintLabel.alpha = 1.0
            self.backgroundColor = self.startColor
        }
    }
    
    func getColorDiffrent() -> (CGFloat,CGFloat,CGFloat) {
        if let rgbStart = startColor.rgb(), let rgbEnd = endColor.rgb() {
                        
            let colorDiffR: CGFloat = CGFloat(rgbStart.0 - rgbEnd.0)
            let colorDiffG: CGFloat = CGFloat(rgbStart.1 - rgbEnd.1)
            let colorDiffB: CGFloat = CGFloat(rgbStart.2 - rgbEnd.2)
                        
            let distancePointR = abs(colorDiffR) / (self.frame.size.width - swipeImageView.frame.size.width)
            let distancePointG = abs(colorDiffG) / (self.frame.size.width - swipeImageView.frame.size.width)
            let distancePointB = abs(colorDiffB) / (self.frame.size.width - swipeImageView.frame.size.width)
            
            return (distancePointR,distancePointG,distancePointB)
        }
        return (0,0,0)
    }
    
    /// Handle action
    ///
    /// - Parameter completed: with completion
    public func handleAction(_ completed: @escaping((_ isSuccess: Bool) -> ()) ) {
        completionHandler = completed
    }
    
    /// Update hint value
    ///
    /// - Parameter text: by string
    public func updateHint(text: String) {
        hintLabel.text = text
        self.hint = text
    }
    
}
