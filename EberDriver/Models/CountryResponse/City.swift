
import Foundation

struct City : Codable
{
    
   
    var id : String = ""
    var cityname : String = ""
    var fullCityname : String = ""
    enum CodingKeys: String, CodingKey {
        
        case id = "_id"
        case cityname = "cityname"
        case fullCityname = "full_cityname"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? ""
        cityname = try values.decodeIfPresent(String.self, forKey: .cityname) ?? ""
        fullCityname = try values.decodeIfPresent(String.self, forKey: .fullCityname) ?? ""
    }

}

