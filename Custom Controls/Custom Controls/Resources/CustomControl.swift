//
//  CustomControl.swift
//  Custom Controls
//
//  Created by Jake Connerly on 8/13/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import UIKit

class CustomControl: UIControl {
    
    //
    // MARK: - Properties
    //
    
    var value: Int = 1
    var starArray: Array<UILabel> = []
    
    let componentDimension: CGFloat     = 40.0
    let componentCount: Int             = 6
    let componentActiveColor: UIColor   = .black
    let componentInactiveColor: UIColor = .darkGray
    
    required init?(coder aCoder: NSCoder) {
        super.init(coder: aCoder)
        setup()
    }
    
    override var intrinsicContentSize: CGSize {
        let componentsWidth = CGFloat(componentCount) * componentDimension
        let componentsSpacing = CGFloat(componentCount + 1) * 8.0
        let width = componentsWidth + componentsSpacing
        return CGSize(width: width, height: componentDimension)
    }
    
    //
    // MARK: - Functions
    //
    
    func setup() {
        
        var spacer: CGFloat = 8.0
        
        for index in 1...componentCount {
            let label = UILabel(frame: CGRect(x: spacer, y: 0, width: componentDimension, height: componentDimension))
            spacer += 8 + componentDimension
            label.text = "★"
            label.font = .boldSystemFont(ofSize: 32.0)
            label.tag = index
            
            if index == 1 {
                label.textColor = componentActiveColor
            }else {
                label.textColor = componentInactiveColor
            }
            
            starArray.append(label)
            self.addSubview(label)
        }
    }
    
    func updateValue(at touch: UITouch) {
        let touchPoint = touch.location(in: self)
        for label in starArray {
            if label.frame.contains(touchPoint) {
                label.performFlare()
                value = label.tag
                for label in starArray {
                    if label.tag <= value{
                        label.textColor = componentActiveColor
                    } else {
                        label.textColor = componentInactiveColor
                    }
                }
            }
        }
    }
}

//
// MARK: - Extensions
//

extension CustomControl {
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        updateValue(at: touch)
        return true
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let touchPoint = touch.location(in: self)
        if bounds.contains(touchPoint) {
            updateValue(at: touch)
            sendActions(for: [.touchDragInside, .valueChanged])
        }
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        defer { super.endTracking(touch, with: event) }
        guard let touch = touch else { return }
        let touchPoint = touch.location(in: self)
        if bounds.contains(touchPoint) {
            
            sendActions(for: [.touchUpInside, .touchUpOutside, .valueChanged])
        } else {
            sendActions(for: .touchUpOutside)
        }
        value = 1
    }
    
    override func cancelTracking(with event: UIEvent?) {
        sendActions(for: .touchCancel)
    }
}

extension UIView {
    // "Flare view" animation sequence
    func performFlare() {
        func flare()   { transform = CGAffineTransform(scaleX: 1.6, y: 1.6) }
        func unflare() { transform = .identity }
        
        UIView.animate(withDuration: 0.3,
                       animations: { flare() },
                       completion: { _ in UIView.animate(withDuration: 0.1) { unflare() }})
    }
}
