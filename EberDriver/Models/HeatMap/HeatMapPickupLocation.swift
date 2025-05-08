//
//	HeatMapPickupLocation.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct HeatMapPickupLocation : Codable {

	var sourceLocation : [Double] = []


	enum CodingKeys: String, CodingKey {
		case sourceLocation = "sourceLocation"
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		sourceLocation = try values.decodeIfPresent([Double].self, forKey: .sourceLocation) ?? []
	}


}
