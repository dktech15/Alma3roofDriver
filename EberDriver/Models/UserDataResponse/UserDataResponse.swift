//
//	RootClass.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct UserDataResponse : Codable {

	var success : Bool = false
    var userDetail : UserDetail = UserDetail(dics: [:])


	enum CodingKeys: String, CodingKey {
		case success = "success"
		case userDetail = "user_detail"
	}
    
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		success = try values.decodeIfPresent(Bool.self, forKey: .success) ?? false
		userDetail = try values.decodeIfPresent(UserDetail.self, forKey: .userDetail) ?? UserDetail(dics: [:])
	}
}
