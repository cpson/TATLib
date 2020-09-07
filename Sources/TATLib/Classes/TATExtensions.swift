//
//  TATExtensions.swift
//  TATLib
//
//  Created by 손창빈 on 2020/06/17.
//

import UIKit

public extension Int {
    // 1000 -> 1,000
    func convertCommaString() -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        return formatter.string(from: NSNumber(value: self))
    }
}

public extension UIView {
    func setCardEffectWithView(_ view: UIView,
                               radius: CGFloat = 5,
                               corners: CACornerMask? = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]) {
        // content view
        self.layer.cornerRadius = radius
        if let corners = corners {
            self.layer.maskedCorners = corners
        }
       
        // shadow view
        view.backgroundColor = UIColor.clear
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 2
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOffset = CGSize(width: 1, height: 1)
    }
    
    func setGradientBackground(colors: [UIColor], isHorizontal: Bool = true) {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = colors.map({ $0.cgColor })
        var orientation = (CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 1.0))
        if isHorizontal {
            orientation = (CGPoint(x: 0.0, y: 0.5), CGPoint(x: 1.0, y: 0.5))
        }
        gradient.startPoint = orientation.0
        gradient.endPoint = orientation.1
        
        layer.insertSublayer(gradient, at: 0)
    }
    
    @discardableResult
    func setGradientUnderline(colors: [UIColor], isHorizontal: Bool = true) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 2)
        gradient.colors = colors.map({ $0.cgColor })
        var orientation = (CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 1.0))
        if isHorizontal {
            orientation = (CGPoint(x: 0.0, y: 0.5), CGPoint(x: 1.0, y: 0.5))
        }
        gradient.startPoint = orientation.0
        gradient.endPoint = orientation.1
        
        layer.insertSublayer(gradient, at: 0)
        return gradient
    }
    
    func constrainToEdges(_ subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: subview, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: subview, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
    }
}

public extension UIViewController {
    /**
     get Top View Controller
     */
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let tabController = controller as? UITabBarController {
            return topViewController(controller: tabController.selectedViewController)
        }
        if let navController = controller as? UINavigationController {
            return topViewController(controller: navController.visibleViewController)
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

public extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
    
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}

public extension String {
    func removeDash() -> String {
        return self.replacingOccurrences(of: "-", with: "")
    }
    
    func formattedNumber() -> String {
        let cleanPhoneNumber = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()

        let mask = self.count > 10 ? "XXX-XXXX-XXXX" : "XXX-XXX-XXXX"

        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    func isNumber() -> Bool {
        let regEx = "[0-9]+"
        let regTest = NSPredicate(format:"SELF MATCHES %@", regEx)
        return regTest.evaluate(with: self)
    }
    
    func validPhoneNumber() -> Bool {
        let regEx = "^01([0|1|6|7|8|9]?)-?([0-9]{3,4})-?([0-9]{4})$"
        let regTest = NSPredicate(format:"SELF MATCHES %@", regEx)
        return regTest.evaluate(with: self)
    }
    
    func convertCommaString() -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        if let value = Int(self) {
            return formatter.string(from: NSNumber(value: value))
        }
        return nil
    }
    
    fileprivate func substring(from: Int, to: Int) -> String {
        let start = index(startIndex, offsetBy: from)
        let end = index(startIndex, offsetBy: to + from)
        return String(self[start..<end])
    }
    
    fileprivate var fullRange: NSRange {
        return NSRange(location: 0, length: self.count)
    }
    
    func getLinkAddress(completion: @escaping (_ result: String?) -> Void) {
        if let regEx = try? NSRegularExpression(pattern: "(((https:\\/\\/)|(http:\\/\\/)|(www))[-a-zA-Z0-9@:%_\\+.~#?&//=]+)\\.(jpg|png|JPG|PNG)", options: []) {
            if let n = regEx.firstMatch(in: self, options: [], range: self.fullRange) {
                completion(self.substring(from: n.range.location, to: n.range.length))
            }
        } else {
            completion(nil)
        }
    }
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localized(withComment comment: String? = nil) -> String {
        return NSLocalizedString(self, comment: comment ?? "")
    }
}

public extension UITextField {
    func setPhoneNumberStyle(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let oldText = textField.text?.removeDash(), oldText.count > 10 && string != "" {
            textField.text = oldText.formattedNumber()
            return false
        }

        var inputString = string.removeDash()
        var cursorPosition = 0
        if let selectedRange = textField.selectedTextRange {
            cursorPosition = textField.offset(from: textField.beginningOfDocument, to: selectedRange.start)
        }
        
        // copy & paste 시 "-" 제거
        if var text = textField.text {
            let insertIndex = text.index(text.startIndex, offsetBy: range.location)
            text.insert(contentsOf: inputString, at: insertIndex)
            inputString = text.removeDash()
        }

        // 숫자 인지 아닌지 판단.
        if range.length == 0 && !inputString.isNumber() {
            return false
        }
        
        // 위 조건 다 거르면
        if range.length == 0 && string != "" {
            var newCursorPosition = cursorPosition + 1
            textField.text = inputString.formattedNumber()
            if textField.text?.substring(from: cursorPosition, to: 1) == "-" {
                newCursorPosition += 1
            }
            
            if let newPosition = textField.position(from: textField.beginningOfDocument, offset: newCursorPosition) {
                textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
            }
            return false
        }
        
        return true
    }
    
    func addAccessoryView(target: Any?, closeSelector: Selector? = nil, viewSelector: Selector? = nil) {
        var items = [UIBarButtonItem]()
        let bar = UIToolbar()
        let buttonTitle = "default_close".localized

//        bar.barTintColor = UIColor.mainColor
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: target, action: nil)
        items.append(flexibleSpace)
        
        if closeSelector != nil {
            let end = UIBarButtonItem(title: buttonTitle, style: .plain, target: target, action: closeSelector)
            let attributes_barItem = [NSAttributedString.Key.font: UIFont.getFont(.AppleSDGothicNeoMedium, 16),
            NSAttributedString.Key.foregroundColor: UIColor.white]
            end.setTitleTextAttributes(attributes_barItem, for: .normal)
            items.append(end)
        }
        
        let flexibleSpace2 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: target, action: nil)
        items.append(flexibleSpace2)
        
        bar.items = items
        bar.sizeToFit()
        
        self.inputAccessoryView = bar
    }
}

public extension UIDevice {
    var identifierUUID: String? {
        get { return UIDevice.current.identifierForVendor?.uuidString}
    }
}
