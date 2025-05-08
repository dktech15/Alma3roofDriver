
import Foundation
 
struct  CountriesResponse :Codable {
    var country : [Country] = []
    var message : String = "0"
    var success : Bool = false
    
    
    enum CodingKeys: String, CodingKey {
        case country = "country_list"
        case message = "message"
        case success = "success"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        country = try values.decodeIfPresent([Country].self, forKey: .country) ?? []
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? "0"
        success = try values.decodeIfPresent(Bool.self, forKey: .success) ?? false
    }
	
}
