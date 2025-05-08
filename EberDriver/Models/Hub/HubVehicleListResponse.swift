//
//  HubVehicleListResponse.swift
//  EberDriver
//
//  Created by elluminati on 16/08/23.
//  Copyright © 2023 Elluminati. All rights reserved.
//

import Foundation

struct HubVehicleListResponse : Codable {
    let success : Bool?
    let vehicle_list : [VehicleDetail]?
    let hub : Hub?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case vehicle_list = "vehicle_list"
        case hub = "hub"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        vehicle_list = try? values.decodeIfPresent([VehicleDetail].self, forKey: .vehicle_list) ?? []
        hub = try values.decodeIfPresent(Hub.self, forKey: .hub)
    }

    
}

struct Hub : Codable {
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
