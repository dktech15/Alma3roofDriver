//
//  StringUtility.swift
//  Cabtown
//
//  Created by Elluminati on 21/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import Foundation
import  UIKit

//Localizable Extension
extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    var localizedCapitalized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "").capitalized
    }
    
    var localizedUppercase: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "").uppercased()
    }
    
    var localizedLowercase: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "").lowercased()
    }
    
    func localizedCompare(string:String) -> Bool {
        let str1 = NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
        let str2 = NSLocalizedString(string, tableName: nil, bundle: Bundle.main, value: "", comment: "")
        
        return str1.caseInsensitiveCompare(str2) == .orderedSame
    }
    
    func localizedCaseCompare(string:String) -> Bool{
        let str1 = NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
        let str2 = NSLocalizedString(string, tableName: nil, bundle: Bundle.main, value: "", comment: "")
        return str1.compare(str2) == .orderedSame
    }
    
    var localizedWithFormat: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "").capitalized
    }
}

//Type Casting Extension
extension String {
    func toBool() -> Bool? {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return nil
        }
    }
    
    func toDouble() -> Double {
        return NumberFormat.instance.number(from: self)?.doubleValue ?? 0.0
    }
    
    func toEnglishDouble() -> Double? {
        //before you convert any languge double to english you need to ready string with that language and also decimal sperator
        //Ex. if the string is arabic double thent also the decimal must be in the arabic like ","  not "."
        let formatter: NumberFormatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = NSLocale(localeIdentifier: "EN") as Locale
        if let final = formatter.number(from: self) {
            let doubleNumber = Double(truncating: final)
            return doubleNumber
        }
        return nil
    }
    
    func toInt() -> Int {
        return NumberFormat.instance.number(from: self)?.intValue ?? 0
    }
    
    func toDate (format: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat=format
        formatter.locale = Locale.init(identifier: preferenceHelper.getLanguageCode())
        return formatter.date(from: self) ?? Date()
    }
    
    func toCall()  {
        if let url = URL(string: "tel://\(self)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            Utility.showToast(message: "Unable to call")
        }
    }

    static func secondsToMinutesSeconds (seconds : Int) -> String {
        let min = String(format: "%02d",Int((seconds % 3600) / 60))
        let sec = String(format: "%02d", Int((seconds % 3600) % 60))
        return "\(min):\(sec)"
    }
}

//MARK: - Validation Extension
extension String {
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }

    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func isNumber() -> Bool {
        let numberCharacters = CharacterSet.decimalDigits.inverted
        return !self.isEmpty() && self.rangeOfCharacter(from:numberCharacters) == nil
    }

    struct NumberFormat {
        static let instance = NumberFormatter()
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int = 2) -> Double {
        let divisor = pow(10.00, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    var clean: Double {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? (Double(String(format: "%.0f", self)) ?? self) : self
    }
    
    func toString(places:Int = 2) -> String {
        return String(format:"%."+places.description+"f", self)
    }
    
//    func toCurrencyString(currencyCode:String = ProviderSingleton.shared.provider.walletCurrencyCode) -> String {
//        var locale = Locale.current
//        if CurrencyHelper.shared.myLocale.currencyCode == currencyCode {
//            locale = CurrencyHelper.shared.myLocale
//        }else {
//            for iteratedLocale in Locale.availableIdentifiers {
//                let newLocal = Locale.init(identifier: iteratedLocale)
//                if newLocal.currencyCode == currencyCode {
//                    locale = newLocal
//                    break;
//                }
//            }
//        }
//
//        if locale.identifier.contains("_") {
//            let strings = locale.identifier.components(separatedBy: "_")
//            if strings.count > 0 {
//                let countryCode = strings[strings.count - 1]
//                locale = Locale.init(identifier: "\(arrForLanguages[preferenceHelper.getLanguage()].code)_\(countryCode)")
//            }
//        }else {
//            locale = Locale.init(identifier: "\(arrForLanguages[preferenceHelper.getLanguage()].code)_\(locale.identifier)")
//        }
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .currency
//        formatter.locale = locale
//        CurrencyHelper.shared.myLocale = locale
//        return formatter.string(from: NSNumber.init(value: self) ) ?? self.toString(places: 2);
//    }
    
    func toCurrencyString(currencyCode: String = ProviderSingleton.shared.provider.walletCurrencyCode) -> String {
        var currencyNewCode = currencyCode

        if currencyNewCode.isEmpty {
            currencyNewCode = ProviderSingleton.shared.provider.walletCurrencyCode
        }

        var locale = Locale.current
        if CurrencyHelper.shared.myLocale.currencyCode == currencyNewCode {
            locale = CurrencyHelper.shared.myLocale
        } else {
            for iteratedLocale in Locale.availableIdentifiers {
                let newLocal = Locale(identifier: iteratedLocale)
                if newLocal.currencyCode == currencyNewCode {
                    locale = newLocal
                    break
                }
            }
        }

        if locale.identifier.contains("_") {
            let strings = locale.identifier.components(separatedBy: "_")
            if strings.count > 0 {
                let countryCode = strings[strings.count - 1]
                locale = Locale(identifier: "\(arrForLanguages[preferenceHelper.getLanguage()].code)_\(countryCode)")
            }
        } else {
            locale = Locale(identifier: "\(arrForLanguages[preferenceHelper.getLanguage()].code)_\(locale.identifier)")
        }

        let formatter = NumberFormatter()
//        formatter.numberStyle = .decimal
//        formatter.minimumFractionDigits = 2
//        formatter.maximumFractionDigits = 2
//        formatter.currencyCode = currencyNewCode
//        formatter.currencySymbol = locale.currencySymbol
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.locale = locale
        
            

        CurrencyHelper.shared.myLocale = locale

         return formatter.string(from: NSNumber(value: self))?.replacingOccurrences(of: ",", with: ".") ?? self.toString(places: 2)

    }
    
    func toInt() -> Int {
        if self > Double(Int.min) && self < Double(Int.max) {
            return Int(self)
        }else {
            return 0
        }
    }
}

extension Int {
    func toString() -> String {
        return   String(self )
    }
}

