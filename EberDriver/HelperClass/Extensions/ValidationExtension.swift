//
//  ValidationExtension.swift
//  Eber
//
//  Created by Elluminati on 03/01/21.
//  Copyright © 2021 Elluminati. All rights reserved.
//

import Foundation
import UIKit
import libPhoneNumber_iOS

typealias PhoneNumberFormat = (formatted: String,phoneCode:String,normal: String, isValid: Bool, phoneNumber: NBPhoneNumber)

//MARK: - Validation Extension
extension String
{
    func isEmpty() -> Bool {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func checkEmailValidation(isEmailVerficationNeedToCheck:Bool = true) -> (Bool, String) {
        if self.isEmpty() {
            if isEmailVerficationNeedToCheck {
                if (preferenceHelper.getIsEmailVerification()) {
                    return (false, "VALIDATION_MSG_ENTER_EMAIL".localized)
                } else {
                    return (true, "")
                }
            } else {
                return (false, "VALIDATION_MSG_ENTER_EMAIL".localized)
            }
        } else {
            if self.count < emailMinimumLength || self.count > emailMaximumLength {
                return (false, String(format: "msg_enter_valid_email_min_max_length".localized, String(emailMinimumLength), String(emailMaximumLength)))
            } else {
                let emailRegex = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|" +
                                "(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]" +
                                "{0,61}[A-Za-z0-9])?)*)))(\\.[A-Za-z]{2,})$"
                let emailTest:NSPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
                let isValid = emailTest.evaluate(with: self)
                if isValid {
                    return (true, "")
                } else {
                    return (false, "VALIDATION_MSG_INVALID_EMAIL".localized)
                }
            }
        }
    }

    func isValidMobileNumber() -> (Bool, String) {
        if self.isEmpty() {
            return (false, "VALIDATION_MSG_ENTER_PHONE_NUMBER".localized)
        } else {
            let min = preferenceHelper.getMinMobileLength()
            let max = preferenceHelper.getMaxMobileLength()
            
            if self.count < min || self.count > max {
                return (false, "VALIDATION_MSG_INVALID_PHONE_NUMBER".localized)
            } else {
                return (true, "")
            }
        }
    }

    func getPhoneNumberFormat(regionCode:String) -> PhoneNumberFormat {
//        let regionCode: String = Locale.current.regionCode ?? "US"
        let phoneUtil: NBPhoneNumberUtil = NBPhoneNumberUtil()
        var myNumber: NBPhoneNumber = NBPhoneNumber()
        var formatted: String = ""
        var normal: String = ""
        var phoneCode: String = ""
        var isValid: Bool = false

        do {
            myNumber = try phoneUtil.parse(self, defaultRegion: regionCode)
            if phoneUtil.isValidNumber(myNumber) {
                isValid = true
                formatted = try phoneUtil.format(myNumber, numberFormat: NBEPhoneNumberFormat.INTERNATIONAL)
            }
        }
        catch let error as NSError {
            debugPrint("\(#function) \(error.localizedDescription)")
        }

        formatted = formatted.replacingOccurrences(of: "(", with: "")
        formatted = formatted.replacingOccurrences(of: ")", with: "")
        formatted = formatted.replacingOccurrences(of: "-", with: " ")
        phoneCode = formatted.components(separatedBy: " ")[0]
        normal = formatted.replacingOccurrences(of: " ", with: "")

        return (formatted, phoneCode, normal, isValid, myNumber)
    }

    func checkPasswordValidation() -> (Bool, String) {
        if self.isEmpty() {
            return (false, "VALIDATION_MSG_ENTER_PASSWORD".localized)
        } else {
            if self.count < passwordMinLength || self.count > passwordMaxLength {
                return (false, String(format: "msg_enter_valid_password_min_max_length".localized, String(passwordMinLength), String(passwordMaxLength)))
            } else {
                return (true, "")
            }
        }
    }
}
