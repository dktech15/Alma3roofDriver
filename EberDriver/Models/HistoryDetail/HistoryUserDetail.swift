//
//	HistoryDetailProvider.swift
//
//	Create by MacPro3 on 12/9/2018
//	Copyright © 2018. All rights reserved.


import Foundation


struct HistoryUserDetail: Codable
{

    
    var id : String = ""
    var address : String = ""
    var deviceTimezone : String = ""
    var deviceToken : String = ""
    var deviceType : String = ""
    var email : String = ""
    var firstName : String = ""
    var gender : String = ""
    var lastName : String = ""
    var phone : String = ""
    var picture : String = ""
    var rate : Double = 0.0
    var rateCount : Double = 0.0
    
    
    enum CodingKeys: String, CodingKey {
        
        case id = "_id"
        case address = "address"
        case deviceTimezone = "device_timezone"
        case deviceToken = "device_token"
        case deviceType = "device_type"
        case email = "email"
        case firstName = "first_name"
        case gender = "gender"
        case lastName = "last_name"
        case phone = "phone"
        case picture = "picture"
        case rate = "rate"
        case rateCount = "rate_count"
        
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? ""
        address = try values.decodeIfPresent(String.self, forKey: .address) ?? ""
        
        deviceTimezone = try values.decodeIfPresent(String.self, forKey: .deviceTimezone) ?? ""
        deviceToken = try values.decodeIfPresent(String.self, forKey: .deviceToken) ?? ""
        deviceType = try values.decodeIfPresent(String.self, forKey: .deviceType) ?? ""
        email = try values.decodeIfPresent(String.self, forKey: .email) ?? ""
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName) ?? ""
        gender = try values.decodeIfPresent(String.self, forKey: .gender) ?? ""
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName) ?? ""
        phone = try values.decodeIfPresent(String.self, forKey: .phone) ?? ""
        picture = try values.decodeIfPresent(String.self, forKey: .picture) ?? ""
        rate = try values.decodeIfPresent(Double.self, forKey: .rate) ?? 0.0
        rateCount = try values.decodeIfPresent(Double.self, forKey: .rateCount) ?? 0.0
        
    }

    init() {}
}
