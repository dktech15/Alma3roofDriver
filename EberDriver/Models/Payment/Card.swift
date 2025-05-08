//
//	Card.swift
//
//	Create by MacPro3 on 15/9/2018
//	Copyright © 2018. All rights reserved.


import Foundation


struct Card : Codable {
    
    var v : Int = 0
    var id : String = ""
    var cardType : String = ""
    var createdAt : String = ""
    var customerId : String = ""
    var isDefault : Int = 0
    var lastFour : String = ""
    var paymentToken : String = ""
    var type : Int = 0
    var updatedAt : String = ""
    var userId : String = ""
    var isSelectedForDelete : Bool = false
   
    enum CodingKeys: String, CodingKey {
        case v = "__v"
        case id = "_id"
        case cardType = "card_type"
        case createdAt = "created_at"
        case customerId = "customer_id"
        case isDefault = "is_default"
        case lastFour = "last_four"
        case paymentToken = "payment_token"
        case type = "type"
        case updatedAt = "updated_at"
        case userId = "user_id"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        v = try values.decodeIfPresent(Int.self, forKey: .v) ?? 0
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? ""
        cardType = try values.decodeIfPresent(String.self, forKey: .cardType) ?? ""
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt) ?? ""
        customerId = try values.decodeIfPresent(String.self, forKey: .customerId) ?? ""
        isDefault = try values.decodeIfPresent(Int.self, forKey: .isDefault) ?? 0
        lastFour = try values.decodeIfPresent(String.self, forKey: .lastFour) ?? ""
        paymentToken = try values.decodeIfPresent(String.self, forKey: .paymentToken) ?? ""
        type = try values.decodeIfPresent(Int.self, forKey: .type) ?? 0
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt) ?? ""
        userId = try values.decodeIfPresent(String.self, forKey: .userId) ?? ""
    }
    
    init() {}
}










