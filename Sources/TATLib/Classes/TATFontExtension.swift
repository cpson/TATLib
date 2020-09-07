//
//  TATFontExtension.swift
//  TATLib
//
//  Created by 손창빈 on 2020/06/17.
//

import UIKit

public enum FontFamily: String {
    case AppleSDGothicNeoThin = "AppleSDGothicNeo-Thin"
    case AppleSDGothicNeoLight = "AppleSDGothicNeo-Light"
    case AppleSDGothicNeoRegular = "AppleSDGothicNeo-Regular"
    case AppleSDGothicNeoBold = "AppleSDGothicNeo-Bold"
    case AppleSDGothicNeoSemiBold = "AppleSDGothicNeo-SemiBold"
    case AppleSDGothicNeoUltraLight = "AppleSDGothicNeo-UltraLight"
    case AppleSDGothicNeoMedium = "AppleSDGothicNeo-Medium"
}

public extension UIFont {
    static func getFont(_ familyName: FontFamily,_ size: CGFloat) -> UIFont {
        return UIFont(name: familyName.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    @objc class func mySystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: FontFamily.AppleSDGothicNeoRegular.rawValue, size: size)!
    }

    @objc class func myBoldSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: FontFamily.AppleSDGothicNeoBold.rawValue, size: size)!
    }

    @objc convenience init(myCoder aDecoder: NSCoder) {
        guard
            let fontDescriptor = aDecoder.decodeObject(forKey: "UIFontDescriptor") as? UIFontDescriptor,
            let fontAttribute = fontDescriptor.fontAttributes[.nsctFontUIUsage] as? String else {
                self.init(myCoder: aDecoder)
                return
        }

        var fontName = ""
        switch fontAttribute {
        case "CTFontRegularUsage":
            fontName = FontFamily.AppleSDGothicNeoRegular.rawValue
        case "CTFontEmphasizedUsage", "CTFontBoldUsage":
            fontName = FontFamily.AppleSDGothicNeoBold.rawValue
        default:
            fontName = FontFamily.AppleSDGothicNeoMedium.rawValue
        }
        self.init(name: fontName, size: fontDescriptor.pointSize)!
    }

    class func overrideInitialize() {
        guard self == UIFont.self else { return }

        if let systemFontMethod = class_getClassMethod(self, #selector(systemFont(ofSize:))),
            let mySystemFontMethod = class_getClassMethod(self, #selector(mySystemFont(ofSize:))) {
            method_exchangeImplementations(systemFontMethod, mySystemFontMethod)
        }

        if let boldSystemFontMethod = class_getClassMethod(self, #selector(boldSystemFont(ofSize:))),
            let myBoldSystemFontMethod = class_getClassMethod(self, #selector(myBoldSystemFont(ofSize:))) {
            method_exchangeImplementations(boldSystemFontMethod, myBoldSystemFontMethod)
        }

        if let initCoderMethod = class_getInstanceMethod(self, #selector(UIFontDescriptor.init(coder:))), // Trick to get over the lack of UIFont.init(coder:))
            let myInitCoderMethod = class_getInstanceMethod(self, #selector(UIFont.init(myCoder:))) {
            method_exchangeImplementations(initCoderMethod, myInitCoderMethod)
        }
    }
}

public extension UIFontDescriptor.AttributeName {
    static let nsctFontUIUsage = UIFontDescriptor.AttributeName(rawValue: "NSCTFontUIUsageAttribute")
}
