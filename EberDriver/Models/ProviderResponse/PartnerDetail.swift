//
//	PartnerDetail.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct PartnerDetail : Codable {

	var wallet : Double = 0.0

	enum CodingKeys: String, CodingKey {
		case wallet = "wallet"
	}
    
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		wallet = try values.decodeIfPresent(Double.self, forKey: .wallet) ?? 0.0
	}

    init() {}
}
