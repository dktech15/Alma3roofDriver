//
//	RootClass.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct RootClass : Codable {

	let languages : [Language]?
	let message : String?
	let success : Bool?


	enum CodingKeys: String, CodingKey {
		case languages = "languages"
		case message = "message"
		case success = "success"
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		languages = try values.decodeIfPresent([Language].self, forKey: .languages)
		message = try values.decodeIfPresent(String.self, forKey: .message)
		success = try values.decodeIfPresent(Bool.self, forKey: .success)
	}


}