//
//  PaypalHelper.swift
//  Eber
//
//  Created by Mayur on 27/06/23.
//  Copyright © 2023 Elluminati. All rights reserved.
//

import Foundation
import PayPalCheckout

protocol PaypalHelperDelegate: AnyObject {
    func paymentSucess(capture: PaypalCaptureResponse)
    func paymentCancel()
}

class PaypalHelper: NSObject {
    
    private var currrencyCode: String = ""
    private var amount: String = ""
    var delegate : PaypalHelperDelegate?
    
    init(currrencyCode: String, amount: String) {
        super.init()
        self.currrencyCode = currrencyCode
        self.amount = amount
        configurePayPalCheckoutForWallet()
    }
    
    private func configurePayPalCheckoutForWallet() {
        
        let environmentPaypal: PayPalCheckout.Environment = {
            if preferenceHelper.getPaypalEnvironment().lowercased() == "live" {
                return .live
            }
            return .sandbox
        }()
        
        let config = CheckoutConfig(clientID: preferenceHelper.getPaypalClientId(), environment: environmentPaypal)
        Checkout.set(config: config)
        
        Checkout.start { action in
            let walletCurrencyCode = CurrencyCode.currencyCode(from: self.currrencyCode)
            let amount = PurchaseUnit.Amount(currencyCode: walletCurrencyCode ?? .usd, value: self.amount)
            let purchaseUnit = PurchaseUnit(amount: amount)
            let order = OrderRequest(intent: .capture, purchaseUnits: [purchaseUnit])
            action.create(order: order)
        } onApprove: { approval in
            approval.actions.capture { response, error in
                if let response = response, response.data.id != "" {
                    var payerid = ""
                    if let value = response.data.orderData["payer"] as? [String:Any] {
                        if let idValue = value["payer_id"] as? String {
                            payerid = idValue
                        }
                    }
                    let capture = PaypalCaptureResponse.init(paymentId: response.data.id, amount: self.amount, payerId: payerid)
                    self.delegate?.paymentSucess(capture: capture)
                }
            }
        } onCancel: {
            Utility.hideLoading()
            self.delegate?.paymentCancel()
        } onError: { err in
            print(err)
        }
    }
}

struct PaypalCaptureResponse {
    var paymentId: String
    var amount: String
    var payerId: String
}
