//
//  ApplePayHelper.swift
//  Eber
//
//  Created by Mayur on 30/06/23.
//  Copyright © 2023 Elluminati. All rights reserved.
//

import Foundation
import PassKit

protocol StripeApplePayHelperDelegate: AnyObject {
    func didComplete()
    func didFailed(err: String)
}

class ApplePayButton: NSObject {
    func addApplePayInVw(inVw: UIView, target: Any, action: Selector) {
        let applePayButton: PKPaymentButton = PKPaymentButton(paymentButtonType: .plain, paymentButtonStyle: .whiteOutline)
        applePayButton.addTarget(target, action: action, for: .touchUpInside)
        applePayButton.translatesAutoresizingMaskIntoConstraints = false
        let height = NSLayoutConstraint(item: applePayButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 45)
        height.isActive = true
        applePayButton.addConstraint(height)
        print(applePayButton)
        if let stkView = inVw as? UIStackView {
            stkView.insertArrangedSubview(applePayButton, at: 0)
        } else {
            inVw.addSubview(applePayButton)
        }
    }
    
    @objc func handleApplePay() {
        
    }
}


class StripeApplePayHelper: NSObject {
 
    var amount: Double = 0
    var currencyCode: String = ""
    var country: String = ""
    var applePayClientSecret = ""
    
    var delegate: StripeApplePayHelperDelegate?
    
    class func setStripApple() -> Bool {
        return false
    }
    
    class func isApplePayAvailable() -> Bool {
//        StripeAPI.defaultPublishableKey = preferenceHelper.getStripeKey()
        return false
    }
    
    init(model: ApplePayHelperModel) {
//        StripeAPI.defaultPublishableKey = preferenceHelper.getStripeKey()
        //StripeAPI.additionalEnabledApplePayNetworks = [.visa, .masterCard , .amex , .discover]
        self.amount = model.amount
        self.currencyCode = model.currencyCode
        self.country = model.country
        self.applePayClientSecret = model.applePayClientSecret
    }
    
    func openApplePayDialog() {
        let merchantIdentifier = applePayMerchantId
//        let paymentRequest = StripeAPI.paymentRequest(withMerchantIdentifier: merchantIdentifier, country: self.country, currency: self.currencyCode)
//        //let paymentRequest = StripeAPI.paymentRequest(withMerchantIdentifier: merchantIdentifier, country: "AU", currency: "AUD")
//        
//        paymentRequest.paymentSummaryItems = [
//            PKPaymentSummaryItem(label: "Eber".localized, amount: NSDecimalNumber(string: amount.toString(places: 2)))
//        ]
//        
//        if let applePayContext = STPApplePayContext(paymentRequest: paymentRequest, delegate: self) {
//            applePayContext.presentApplePay {
//                Utility.hideLoading()
//            }
//        } else {
//            Utility.hideLoading()
//            delegate?.didFailed(err: "Unable to make Apple Pay transaction.")
//        }
    }
}

//extension StripeApplePayHelper: ApplePayContextDelegate {
//    
//    func applePayContext(_ context: StripeApplePay.STPApplePayContext, didCreatePaymentMethod paymentMethod: StripeCore.StripeAPI.PaymentMethod, paymentInformation: PKPayment, completion: @escaping StripeApplePay.STPIntentClientSecretCompletionBlock) {
//        completion(applePayClientSecret, nil)
//    }
//    
//    func applePayContext(_ context: StripeApplePay.STPApplePayContext, didCompleteWith status: StripeApplePay.STPApplePayContext.PaymentStatus, error: Error?) {
//    
//        print(error?.localizedDescription ?? "")
//        switch status {
//        case .success:
//            delegate?.didComplete()
//            break
//        case .error:
//            delegate?.didFailed(err: error?.localizedDescription ?? "")
//            break
//        case .userCancellation:
//            delegate?.didFailed(err: error?.localizedDescription ?? "")
//            break
//        }
//    }
//}

struct ApplePayHelperModel {
    var amount: Double
    var currencyCode: String
    var country: String
    var applePayClientSecret: String
}
