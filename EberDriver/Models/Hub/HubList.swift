//
//  HubList.swift
//  EberDriver
//
//  Created by elluminati on 17/08/23.
//  Copyright © 2023 Elluminati. All rights reserved.
//

import Foundation

struct HubListResponse : Codable {
    let success : Bool?
    let hubs : [Hubs]?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case hubs = "hubs"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        hubs = try values.decodeIfPresent([Hubs].self, forKey: .hubs)
    }
}

struct Hubs : Codable {
    let _id : String?
    let name : String?
    let address : String?
    let location : [Double]?
    let kmlzone : [[Double]]?

    enum CodingKeys: String, CodingKey {

        case _id = "_id"
        case name = "name"
        case address = "address"
        case location = "location"
        case kmlzone = "kmlzone"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        location = try values.decodeIfPresent([Double].self, forKey: .location)
        kmlzone = try values.decodeIfPresent([[Double]].self, forKey: .kmlzone)
    }

}
