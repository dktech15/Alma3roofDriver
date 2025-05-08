//
//	HistoryResponse.swift
//
//	Create by MacPro3 on 12/9/2018
//	Copyright © 2018. All rights reserved.


import Foundation

struct HistoryResponse : Codable {
    
    var success : Bool = false
    var trips : [HistoryTrip] = []
    
    
    enum CodingKeys: String, CodingKey {
        case success = "success"
        case trips = "trips"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success) ?? false
        trips = try values.decodeIfPresent([HistoryTrip].self, forKey: .trips) ?? []
    }
    
    
}
