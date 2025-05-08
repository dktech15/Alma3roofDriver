//
//	ProviderDetail.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct VehicleListResponse : Codable {

    var message : String = "0"
    var errorCode : String = "0"
    var success : Bool = false
    var vehicleList : [VehicleDetail] = []
    enum CodingKeys: String, CodingKey {
        
        case message = "message"
        case vehicleList = "vehicle_list"
        case success = "success"
         case errorCode = "error_code"
        
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? "0"
        vehicleList = try values.decodeIfPresent([VehicleDetail].self, forKey: .vehicleList) ?? []
        errorCode = try values.decodeIfPresent(String.self, forKey: .errorCode) ?? "0"
        
        success = try values.decodeIfPresent(Bool.self, forKey: .success) ?? false
        
    }
}



