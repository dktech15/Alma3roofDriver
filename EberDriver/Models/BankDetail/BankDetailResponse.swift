//
//	RootClass.swift
//
//	Create by Elluminati on 24/10/2017
//	Copyright © 2017 Elluminati. All rights reserved.


import Foundation

struct BankDetailResponse : Codable {
    
    var bankdetails : BankDetail = BankDetail.init()
    var message : String =  ""
    var success : Bool = false
    var payment_gateway_type : String =  "0"

    enum CodingKeys: String, CodingKey {
        case bankdetails  = "bankdetails"
        case message = "message"
        case success = "success"
        case payment_gateway_type = "payment_gateway_type"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        bankdetails =  try values.decodeIfPresent(BankDetail.self, forKey: .bankdetails) ?? BankDetail.init()
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? "0"
        success = try values.decodeIfPresent(Bool.self, forKey: .success) ?? false
        payment_gateway_type = try values.decodeIfPresent(String.self, forKey: .payment_gateway_type) ?? "0"

    }
}
