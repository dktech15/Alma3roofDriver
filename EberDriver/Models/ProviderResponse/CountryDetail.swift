//
//	CountryDetail.swift
//
//	Create by MacPro3 on 10/9/2018
//	Copyright © 2018. All rights reserved.


import Foundation

struct CountryDetail : Codable {
    
    var isReferral : Bool = false
    
    enum CodingKeys: String, CodingKey {
        case isReferral = "is_referral"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        isReferral = try values.decodeIfPresent(Bool.self, forKey: .isReferral) ?? false
    }
    
    init() {
        isReferral = false
    }
}



