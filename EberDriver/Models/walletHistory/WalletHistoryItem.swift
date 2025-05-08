//
//	WalletHistory.swift
//
//	Create by Elluminati on 30/10/2017
//	Copyright © 2017 Elluminati. All rights reserved.

import Foundation

struct WalletHistoryItem : Codable {
    
    var v : Int = 0
    var id : String = ""
    var addedWallet : Double = 0.0
    var countryId : String =  ""
    var createdAt : String =  ""
    var currentRate : Double = 0.0
    var fromAmount : Double = 0.0
    var fromCurrencyCode : String =  ""
    var toCurrencyCode : String =  ""
    var totalWalletAmount : Double = 0.0
    var uniqueId : Int = 0
    var updatedAt : String =  ""
    var userId : String =  ""
    var userType : Int = 0
    var userUniqueId : Int = 0
    var walletAmount : Double = 0.0
    var walletCommentId : Int = 0
    var walletDescription : String =  ""
    var walletStatus : Int = 0
    
    enum CodingKeys: String, CodingKey {
        case v = "__v"
        case id = "_id"
        case addedWallet = "added_wallet"
        case countryId = "country_id"
        case createdAt = "created_at"
        case currentRate = "current_rate"
        case fromAmount = "from_amount"
        case fromCurrencyCode = "from_currency_code"
        case toCurrencyCode = "to_currency_code"
        case totalWalletAmount = "total_wallet_amount"
        case uniqueId = "unique_id"
        case updatedAt = "updated_at"
        case userId = "user_id"
        case userType = "user_type"
        case userUniqueId = "user_unique_id"
        case walletAmount = "wallet_amount"
        case walletCommentId = "wallet_comment_id"
        case walletDescription = "wallet_description"
        case walletStatus = "wallet_status"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        v = try values.decodeIfPresent(Int.self, forKey: .v) ?? 0
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? ""
        addedWallet = try values.decodeIfPresent(Double.self, forKey: .addedWallet) ?? 0.0
        countryId = try values.decodeIfPresent(String.self, forKey: .countryId) ?? ""
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt) ?? ""
        currentRate = try values.decodeIfPresent(Double.self, forKey: .currentRate) ?? 0.0
        fromAmount = try values.decodeIfPresent(Double.self, forKey: .fromAmount) ?? 0.0
        fromCurrencyCode = try values.decodeIfPresent(String.self, forKey: .fromCurrencyCode) ?? ""
        toCurrencyCode = try values.decodeIfPresent(String.self, forKey: .toCurrencyCode) ?? ""
        totalWalletAmount = try values.decodeIfPresent(Double.self, forKey: .totalWalletAmount) ?? 0.0
        uniqueId = try values.decodeIfPresent(Int.self, forKey: .uniqueId) ?? 0
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt) ?? ""
        userId = try values.decodeIfPresent(String.self, forKey: .userId) ?? ""
        userType = try values.decodeIfPresent(Int.self, forKey: .userType) ?? 0
        userUniqueId = try values.decodeIfPresent(Int.self, forKey: .userUniqueId) ?? 0
        walletAmount = try values.decodeIfPresent(Double.self, forKey: .walletAmount) ?? 0.0
        walletCommentId = try values.decodeIfPresent(Int.self, forKey: .walletCommentId) ?? 0
        walletDescription = try values.decodeIfPresent(String.self, forKey: .walletDescription) ?? ""
        walletStatus = try values.decodeIfPresent(Int.self, forKey: .walletStatus) ?? 0
    }
}

struct WalletStatus {
    static let ADD_WALLET_AMOUNT = 1;
    static let ORDER_REFUND_AMOUNT = 3;
    static let ORDER_PROFIT_AMOUNT = 5;
    static let REMOVE_WALLET_AMOUNT = 2;
    static let ORDER_CHARGE_AMOUNT = 4;
    static let ORDER_CANCELLATION_CHARGE_AMOUNT = 6;
    static let REQUEST_CHARGE_AMOUNT = 8;
}

