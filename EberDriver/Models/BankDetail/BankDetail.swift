//
//	BankDetail.swift
//
//	Create by Elluminati on 24/10/2017
//	Copyright © 2017 Elluminati. All rights reserved.


import Foundation

struct BankDetail : Codable {
    
    var accountHolderName : String = ""
    var accountHolderType : String = ""
    var accountNumber : String = ""
    var routingNumber : String = ""
    
    enum CodingKeys: String, CodingKey {
        case accountHolderName = "account_holder_name"
        case accountHolderType = "account_holder_type"
        case accountNumber = "account_number"
        case routingNumber = "routing_number"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        accountHolderName = try values.decodeIfPresent(String.self, forKey: .accountHolderName) ?? ""
        accountHolderType = try values.decodeIfPresent(String.self, forKey: .accountHolderType) ?? ""
        accountNumber = try values.decodeIfPresent(String.self, forKey: .accountNumber) ?? ""
        routingNumber = try values.decodeIfPresent(String.self, forKey: .routingNumber) ?? ""
    }
    
    init() {}
}
