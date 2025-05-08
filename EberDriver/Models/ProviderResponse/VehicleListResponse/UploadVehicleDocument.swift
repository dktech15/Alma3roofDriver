//
//	ProviderDetail.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct UploadVehicleDocumentResponse : Codable
{
    
    
    var message : String = ""
    var success : Bool = false
    var documentDetail: ProviderDocument?
    
    
    
    enum CodingKeys: String, CodingKey {
        case documentDetail = "document_detail"
        case message = "message"
        case success = "success"
        
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? ""
        success = try values.decodeIfPresent(Bool.self, forKey: .success) ?? false
        documentDetail = try values.decodeIfPresent(ProviderDocument.self, forKey: .documentDetail)
    }
}



