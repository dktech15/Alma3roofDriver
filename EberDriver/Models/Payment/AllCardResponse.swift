//
//    AllCardResponse.swift
//
//    Create by MacPro3 on 14/9/2018
//    Copyright © 2018. All rights reserved.


import Foundation

struct AllCardResponse : Codable {
    
    var card : [Card] = []
  //  var isUseWallet : Int!
    var message : String = ""
    var paymentGateway : [PaymentGateway] = []
    var success : Bool = false
    var wallet : Double = 0.0
    var walletCurrencyCode : String = ""
    var payment_gateway_type : Int = 0

    enum CodingKeys: String, CodingKey {
        case card = "card"
        case message = "message"
        case paymentGateway = "payment_gateway"
        case success = "success"
        case wallet = "wallet"
        case walletCurrencyCode = "wallet_currency_code"
        case payment_gateway_type = "payment_gateway_type"


      //  case isUseWallet = "is_use_wallet"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        card = try values.decodeIfPresent([Card].self, forKey: .card) ?? []
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? ""
        paymentGateway = try values.decodeIfPresent([PaymentGateway].self, forKey: .paymentGateway) ?? []
        success = try values.decodeIfPresent(Bool.self, forKey: .success) ?? false
            wallet =  try values.decodeIfPresent(Double.self, forKey: .wallet) ?? 0.0
        walletCurrencyCode =  try values.decodeIfPresent(String.self, forKey: .walletCurrencyCode) ?? ""
        payment_gateway_type =  try values.decodeIfPresent(Int.self, forKey: .payment_gateway_type) ?? 0

       // isUseWallet = try values.decodeIfPresent(Int.self, forKey: .wallet) ?? 0
    }
    init() {
        }
}

struct WalletResponse : Codable {
    
    var message : String = ""
    var success : Bool = false
    var wallet : Double = 0.0
    var walletCurrencyCode : String = ""
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case success = "success"
        case wallet = "wallet"
        case walletCurrencyCode = "wallet_currency_code"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? ""
        success = try values.decodeIfPresent(Bool.self, forKey: .success) ?? false
        wallet = try values.decodeIfPresent(Double.self, forKey: .wallet) ?? 0.0
        walletCurrencyCode = try values.decodeIfPresent(String.self, forKey: .walletCurrencyCode) ?? ""
    }
}
