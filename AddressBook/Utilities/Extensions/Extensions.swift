//
//  Extensions.swift
//  AddressBook
//
//  Created by mac on 2/28/18.
//  Copyright © 2018 Differenz System. All rights reserved.
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
        let attributedText = NSAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedStringKey.foregroundColor : color])
        self.attributedPlaceholder = attributedText
    }
}

//Mark: - UIView's Extension
extension UIView {
    
    /**
     This property is used to set corener radius of UIView.
     */
    
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
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
            NSAttributedStringKey.foregroundColor : UIColor.navigationTitleColor,
            NSAttributedStringKey.font : UIFont.systemFont(ofSize: 19, weight: UIFont.Weight.semibold)]
    }
}

//Mark: - UIColor's Extension
extension UIColor {
    static let navigationBarBGColor = #colorLiteral(red: 0, green: 0.5690457821, blue: 0.5746168494, alpha: 1)
    static let navigationTitleColor = #colorLiteral(red: 1, green: 0.968627451, blue: 0.968627451, alpha: 1)
}
