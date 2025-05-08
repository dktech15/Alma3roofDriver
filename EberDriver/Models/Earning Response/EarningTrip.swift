//
//	OrderTotal.swift
//
//	Create by Elluminati on 28/6/2017
//	Copyright © 2017 Elluminati. All rights reserved.


import Foundation

struct EarningTrip : Codable {
    
    var payToProvider : Double = 0.0
    var paymentMode : Int = 0
    var providerHaveCash : Double = 0.0
    var providerIncomeSetInWallet : Double = 0.0
    var providerServiceFees : Double = 0.0
    var total : Double = 0.0
    var uniqueId : Int = 0
    
    enum CodingKeys: String, CodingKey {
        case payToProvider = "pay_to_provider"
        case paymentMode = "payment_mode"
        case providerHaveCash = "provider_have_cash"
        case providerIncomeSetInWallet = "provider_income_set_in_wallet"
        case providerServiceFees = "provider_service_fees"
        case total = "total"
        case uniqueId = "unique_id"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        payToProvider = try values.decodeIfPresent(Double.self, forKey: .payToProvider) ?? 0.0
        paymentMode = try values.decodeIfPresent(Int.self, forKey: .paymentMode) ?? 0
        providerHaveCash = try values.decodeIfPresent(Double.self, forKey: .providerHaveCash) ?? 0.0
        providerIncomeSetInWallet = try values.decodeIfPresent(Double.self, forKey: .providerIncomeSetInWallet) ?? 0.0
        providerServiceFees = try values.decodeIfPresent(Double.self, forKey: .providerServiceFees) ?? 0.0
        total = try values.decodeIfPresent(Double.self, forKey: .total) ?? 0.0
        uniqueId = try values.decodeIfPresent(Int.self, forKey: .uniqueId) ?? 0
    }
}
