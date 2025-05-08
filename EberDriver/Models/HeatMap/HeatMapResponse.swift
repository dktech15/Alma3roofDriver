//
//	HeatMapResponse.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct HeatMapResponse : Codable {

    var pickupLocations : [HeatMapPickupLocation] = []
	var success : Bool = false


	enum CodingKeys: String, CodingKey {
		case pickupLocations = "pickup_locations"
		case success = "success"
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		pickupLocations = try values.decodeIfPresent([HeatMapPickupLocation].self, forKey: .pickupLocations) ?? []
		success = try values.decodeIfPresent(Bool.self, forKey: .success) ?? false
	}


}
