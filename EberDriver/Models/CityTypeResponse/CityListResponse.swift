//
//	RootClass.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct CityListResponse : Codable {

	let cityDetail : CityDetail?
	let citytypes : [Citytype]?
	var currency : String = ""
	let message : String?
	let paymentGateway : [PaymentGateway]?
	let serverTime : String?
	let success : Bool?


	enum CodingKeys: String, CodingKey {
		case cityDetail = "city_detail"
		case citytypes = "citytypes"
		case currency = "currency"
		case message = "message"
		case paymentGateway = "payment_gateway"
		case serverTime = "server_time"
		case success = "success"
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		cityDetail = try values.decodeIfPresent(CityDetail.self, forKey: .cityDetail)
		citytypes = try values.decodeIfPresent([Citytype].self, forKey: .citytypes)

		currency = try values.decodeIfPresent(String.self, forKey: .currency) ?? ""
		message = try values.decodeIfPresent(String.self, forKey: .message)
		paymentGateway = try values.decodeIfPresent([PaymentGateway].self, forKey: .paymentGateway)
		serverTime = try values.decodeIfPresent(String.self, forKey: .serverTime)
		success = try values.decodeIfPresent(Bool.self, forKey: .success)
	}


}
