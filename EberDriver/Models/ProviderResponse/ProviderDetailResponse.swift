//
//	RootClass.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct ProviderDetailResponse : Codable {
    
    var isVehicleDocumentUploaded : Bool = false
    var message : String = "0"
    var partnerDetail : PartnerDetail = PartnerDetail.init()
    var provider : Provider = Provider.init()
    var success : Bool = false
    var typeDetails : TypeDetail = TypeDetail.init()
    var phoneNumberLength:Int = 12
    var phoneNumberMinLength:Int = 8
    var scheduleTripCount:Int = 0
    
    enum CodingKeys: String, CodingKey {
        case isVehicleDocumentUploaded = "is_vehicle_document_uploaded"
        case message = "message"
        case partnerDetail = "partner_detail"
        case provider = "provider"
        case success = "success"
        case typeDetails = "type_details"
        case phoneNumberMinLength = "phone_number_min_length"
        case phoneNumberLength = "phone_number_length"
        case scheduleTripCount = "schedule_trip_count"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        isVehicleDocumentUploaded = try values.decodeIfPresent(Bool.self, forKey: .isVehicleDocumentUploaded) ?? false
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? "0"
        partnerDetail = try values.decodeIfPresent(PartnerDetail.self, forKey: .partnerDetail) ?? PartnerDetail.init()
        provider = try values.decodeIfPresent(Provider.self, forKey: .provider) ?? Provider.init()
        success = try values.decodeIfPresent(Bool.self, forKey: .success) ?? false
        typeDetails = try values.decodeIfPresent(TypeDetail.self, forKey: .typeDetails) ?? TypeDetail.init()
        phoneNumberLength = try values.decodeIfPresent(Int.self, forKey: .phoneNumberLength) ?? 12
        phoneNumberMinLength = try values.decodeIfPresent(Int.self, forKey: .phoneNumberMinLength) ?? 8
        scheduleTripCount = try values.decodeIfPresent(Int.self, forKey: .scheduleTripCount) ?? 0
    }
    
    init() {}
}
