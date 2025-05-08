//
//	RootClass.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct ProviderDetailResponse : Codable {

	let currentVehicle : CurrentVehicle?
	let isVehicleDocumentUploaded : Bool?
	let message : String?
	let partnerDetail : PartnerDetail?
	let provider : Provider?
	let success : Bool?
	let typeDetails : TypeDetail?


	enum CodingKeys: String, CodingKey {
		case currentVehicle
		case isVehicleDocumentUploaded = "is_vehicle_document_uploaded"
		case message = "message"
		case partnerDetail
		case provider
		case success = "success"
		case typeDetails
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		currentVehicle = try CurrentVehicle(from: decoder)
		isVehicleDocumentUploaded = try values.decodeIfPresent(Bool.self, forKey: .isVehicleDocumentUploaded)
		message = try values.decodeIfPresent(String.self, forKey: .message)
		partnerDetail = try PartnerDetail(from: decoder)
		provider = try Provider(from: decoder)
		success = try values.decodeIfPresent(Bool.self, forKey: .success)
		typeDetails = try TypeDetail(from: decoder)
	}


}
