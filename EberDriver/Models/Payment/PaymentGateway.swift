//
//	PaymentGateway.swift
//
//	Create by MacPro3 on 14/9/2018
//	Copyright © 2018. All rights reserved.


import Foundation

struct PaymentGateway : Codable {
    
    var id : Int = 0
    var name : String = ""
    var is_add_card : Bool!

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case is_add_card = "is_add_card"

    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id) ?? 0
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        is_add_card = try values.decodeIfPresent(Bool.self, forKey: .is_add_card) ?? false

    }
    
    init(fromDictionary dictionary: [String:Any]){
        id = (dictionary["id"] as? Int) ?? 0
        name = (dictionary["name"] as? String) ?? ""
        is_add_card = (dictionary["is_add_card"] as? Bool) ?? false

    }
}
