import Foundation
struct RedeemHistory : Codable {
	let total_redeem_point : Int?
	let user_unique_id : Int?
	let added_redeem_point : Int?
	let redeem_point_type : Int?
	let created_at : String?
	let _id : String?
	let user_id : String?
	let redeem_point_currency : String?
	let redeem_point_description : String?
	let unique_id : Int?
	let updated_at : String?
	let wallet_status : Int?
	let __v : Int?
	let user_type : Int?

	enum CodingKeys: String, CodingKey {

		case total_redeem_point = "total_redeem_point"
		case user_unique_id = "user_unique_id"
		case added_redeem_point = "added_redeem_point"
		case redeem_point_type = "redeem_point_type"
		case created_at = "created_at"
		case _id = "_id"
		case user_id = "user_id"
		case redeem_point_currency = "redeem_point_currency"
		case redeem_point_description = "redeem_point_description"
		case unique_id = "unique_id"
		case updated_at = "updated_at"
		case wallet_status = "wallet_status"
		case __v = "__v"
		case user_type = "user_type"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		total_redeem_point = try values.decodeIfPresent(Int.self, forKey: .total_redeem_point)
		user_unique_id = try values.decodeIfPresent(Int.self, forKey: .user_unique_id)
		added_redeem_point = try values.decodeIfPresent(Int.self, forKey: .added_redeem_point)
		redeem_point_type = try values.decodeIfPresent(Int.self, forKey: .redeem_point_type)
		created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
		_id = try values.decodeIfPresent(String.self, forKey: ._id)
		user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
		redeem_point_currency = try values.decodeIfPresent(String.self, forKey: .redeem_point_currency)
		redeem_point_description = try values.decodeIfPresent(String.self, forKey: .redeem_point_description)
		unique_id = try values.decodeIfPresent(Int.self, forKey: .unique_id)
		updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
		wallet_status = try values.decodeIfPresent(Int.self, forKey: .wallet_status)
		__v = try values.decodeIfPresent(Int.self, forKey: .__v)
		user_type = try values.decodeIfPresent(Int.self, forKey: .user_type)
	}

}
