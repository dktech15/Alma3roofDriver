//
//	VehicleDetail.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct VehicleDetailResponse : Codable {
    
    var documentList : [ProviderDocument] = []
    var success : Bool = false
    var vehicleDetail : VehicleDetail = VehicleDetail.init()
    
    
    enum CodingKeys: String, CodingKey {
        case documentList = "document_list"
        case success = "success"
        case vehicleDetail = "vehicle_detail"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        documentList = try values.decodeIfPresent([ProviderDocument].self, forKey: .documentList) ?? []
        success = try values.decodeIfPresent(Bool.self, forKey: .success) ?? false
        vehicleDetail = try values.decodeIfPresent(VehicleDetail.self, forKey: .vehicleDetail) ?? VehicleDetail.init()
    }
    
    
}
