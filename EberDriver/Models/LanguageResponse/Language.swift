//
//	Language.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct Language : Codable {

	var v : Int = 0
	var id : String = ""
	var code : String = ""
	var createdAt : String = ""
	var name : String = ""
	var uniqueId : Int = 0
	var updatedAt : String = ""
    var isSelected : Bool  = false

	enum CodingKeys: String, CodingKey {
		case v = "__v"
		case id = "_id"
		case code = "code"
		case createdAt = "created_at"
		case name = "name"
		case uniqueId = "unique_id"
		case updatedAt = "updated_at"
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		v = try values.decodeIfPresent(Int.self, forKey: .v) ?? 0
		id = try values.decodeIfPresent(String.self, forKey: .id) ?? ""
		code = try values.decodeIfPresent(String.self, forKey: .code) ?? ""
		createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt) ?? ""
		name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
		uniqueId = try values.decodeIfPresent(Int.self, forKey: .uniqueId) ?? 0
		updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt) ?? ""
	}


}
