

import Foundation
struct RedeemHistoryResponse : Codable {
	let walletHistory : [RedeemHistory]?
    let driver_redeem_point_value : Int?
    let total_redeem_point : Int?
    let success : Bool?
    let driver_minimum_point_require_for_withdrawal : Int?

	enum CodingKeys: String, CodingKey {

        case walletHistory = "wallet_history"
        case driver_redeem_point_value = "driver_redeem_point_value"
        case total_redeem_point = "total_redeem_point"
        case success = "success"
        case driver_minimum_point_require_for_withdrawal = "user_minimum_point_require_for_withdrawal"
	}

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        walletHistory = try values.decodeIfPresent([RedeemHistory].self, forKey: .walletHistory)
        driver_redeem_point_value = try values.decodeIfPresent(Int.self, forKey: .driver_redeem_point_value)
        total_redeem_point = try values.decodeIfPresent(Int.self, forKey: .total_redeem_point)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        driver_minimum_point_require_for_withdrawal = try values.decodeIfPresent(Int.self, forKey: .driver_minimum_point_require_for_withdrawal)
    }

}
