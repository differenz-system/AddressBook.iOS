//
//  Extensions.swift
//  AddressBook
//
//  Created by DifferenzSystem PVT. LTD. on 01/21/21.
//  Copyright © 2021 DifferenzSystem PVT. LTD. All rights reserved.
//

import Foundation
import UIKit


//Mark: - UITextField's Extension
extension UITextField {
    
    /**
     This property is used to check textfiled is empry or not.
     */
    public var isEmpty: Bool {
        get {
            if (self.text ?? "").isEmpty {
                return true
            }
            return false
        }
    } 
    
    /**
     This method is used to check email is valid or not.
        - Returns: Return boolean value to indicate email is valid or not
     */
    func isValidEmailField() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9-]+\\.[A-Za-z]{1,}(\\.[A-Za-z]{1,}){0,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self.text)
    }
    
    /**
     This method is used to set attributed placeholder of textfiled.
        - Parameter color: Color of placeholder text
     */
    func setAttributedPlaceHolder(with color: UIColor) {
        let attributedText = NSAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : color])
        self.attributedPlaceholder = attributedText
    }
}

//Mark: - UIView's Extension
extension UIView {
    
    /**
     This property is used to set corener radius of UIView.
     */
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
        set {
            self.layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var shadowColor: UIColor {
        get {
            return UIColor(cgColor: self.layer.shadowColor!)
        }
        set {
            self.layer.shadowColor = newValue.cgColor
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        get {
            return self.layer.shadowOpacity
        }
        set {
            self.layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get {
            return self.layer.shadowOffset
        }
        set {
            self.layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return self.layer.shadowRadius
        }
        set {
            self.layer.shadowRadius = newValue
        }
    }
    
    func roundBottomCorners(radius: CGFloat) {
        if #available(iOS 11.0, *) {
            self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            self.layer.cornerRadius = radius
        } else {
            let rectShape = CAShapeLayer()
            rectShape.bounds = self.frame
            rectShape.position = self.center
            rectShape.path = UIBezierPath(roundedRect: self.bounds,    byRoundingCorners: [.bottomLeft , .bottomRight], cornerRadii: CGSize(width: 20, height: 20)).cgPath
            self.layer.mask = rectShape
        }
    }
    
    
    func roundedBorder(){
        self.layer.cornerRadius = 25       
        let shadowView = UIView()
        shadowView.frame = self.bounds
        shadowView.backgroundColor = UIColor.clear
        shadowView.layer.shadowColor = UIColor.navigationBarBGColor.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 3, height: 3)
        shadowView.layer.shadowOpacity = 0.7
        shadowView.layer.shadowRadius = 4.0
        self.addSubview(shadowView)
    }
    
    func roundedBorderWithShadow() {
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1.0
        self.layer.masksToBounds = true
       
        let shadowView = UIView()
        shadowView.frame = self.bounds
        shadowView.backgroundColor = UIColor.clear
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 3, height: 3)
        shadowView.layer.shadowOpacity = 0.7
        shadowView.layer.shadowRadius = 4.0
        self.addSubview(shadowView)
    }
    func applyGradient() {
        removeGradient()
        let colors = [Constant.AppColor.gradiantColorOne.cgColor, Constant.AppColor.gradiantColorTwo.cgColor]
        let layer = CAGradientLayer()
        layer.name = "Gradient"
        layer.colors = colors
        layer.frame = self.bounds
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 0) //CGPoint(x: 0, y: 1)
        layer.locations = [0.0, 1.0]
        self.layer.addSublayer(layer)
        if self is UIButton, let label = (self as! UIButton).titleLabel {
            self.bringSubviewToFront(label)
        }
    }
    
    func removeGradient() {
        layer.sublayers?.forEach {
            if $0.name == "Gradient" {
                $0.removeFromSuperlayer()
            }
        }
    }
}

//Mark: - String's Extension
extension String {
    
    /**
     This method is used to set attributed placeholder of textfiled.
        - Parameters:
            - range: Range of string
            - string: String that needs to replace in range
     */
    func replacingCharacters(in range: NSRange, with string: String) -> String {
        let newRange = self.index(self.startIndex, offsetBy: range.lowerBound)..<self.index(self.startIndex, offsetBy: range.upperBound)
        return self.replacingCharacters(in: newRange, with: string)
    }
}

//Mark: - UINavigationBar's Extension
extension UINavigationBar {
    
    /**
     This method is used to set title attributes of navigtaion bar.
     */
    func setDafaultAppNavigationTitleAttributes() {
        titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.navigationTitleColor,
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 19, weight: UIFont.Weight.semibold)]
    }
    
}

//Mark: - UIColor's Extension
extension UIColor {
    static let navigationBarBGColor = #colorLiteral(red: 0, green: 0.5690457821, blue: 0.5746168494, alpha: 1)
    static let navigationTitleColor = #colorLiteral(red: 1, green: 0.968627451, blue: 0.968627451, alpha: 1)
}
