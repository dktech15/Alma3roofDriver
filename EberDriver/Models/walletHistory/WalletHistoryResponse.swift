//
//	RootClass.swift
//
//	Create by Elluminati on 30/10/2017
//	Copyright © 2017 Elluminati. All rights reserved.

import Foundation

struct WalletHistoryResponse : Codable {
    
    var message : String = ""
    var success : Bool = false
    var walletHistory : [WalletHistoryItem] = []
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case success = "success"
        case walletHistory = "wallet_history"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? ""
        success = try values.decodeIfPresent(Bool.self, forKey: .success) ?? false
        walletHistory = try values.decodeIfPresent([WalletHistoryItem].self, forKey: .walletHistory) ?? []
    }
}
