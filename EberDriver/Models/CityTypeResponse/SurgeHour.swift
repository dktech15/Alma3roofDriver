//
//	SurgeHour.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct SurgeHour : Codable {

	
	var dayTime : [DayTime] = []
	var isSurge : Bool = false
	var day : String = ""


	enum CodingKeys: String, CodingKey {
		case dayTime = "day_time"
		case isSurge = "is_surge"
		case day = "day"
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		dayTime = try values.decodeIfPresent([DayTime].self, forKey: .dayTime) ?? []
		isSurge = try values.decodeIfPresent(Bool.self, forKey: .isSurge) ?? false
		day = try values.decodeIfPresent(String.self, forKey: .day) ?? ""
	}


}


class DayTime : Codable{
    
    var endTime : String!
    var multiplier : String!
    var startTime : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    enum CodingKeys: String, CodingKey {
        case endTime = "end_time"
        case multiplier = "multiplier"
        case startTime = "start_time"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        endTime = try values.decodeIfPresent(String.self, forKey: .endTime) ?? ""
        if let value = try? values.decodeIfPresent(String.self, forKey: .multiplier) {
            multiplier = value
        } else if let value = try? values.decodeIfPresent(Double.self, forKey: .multiplier) {
            multiplier = "\(value)"
        } else if let value = try? values.decodeIfPresent(Int.self, forKey: .multiplier) {
            multiplier = "\(value)"
        } else  {
            multiplier = ""
        }
       
        startTime = try values.decodeIfPresent(String.self, forKey: .startTime) ?? ""
    }
    
    init(fromDictionary dictionary: [String:Any]){
        endTime = dictionary["end_time"] as? String
        if let value = dictionary["multiplier"] as? String {
            multiplier = value
        } else if let value = dictionary["multiplier"] as? Double {
            multiplier = "\(value)"
        } else if let value = dictionary["multiplier"] as? Int {
            multiplier = "\(value)"
        }
        
        startTime = dictionary["start_time"] as? String
    }
    
    
}
