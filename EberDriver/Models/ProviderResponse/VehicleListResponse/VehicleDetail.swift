//
//	VehicleDetail.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct VehicleDetail : Codable {

	var  id : String = ""
	var  accessibility : [String] = []
	var  adminTypeId : String = ""
	var  color : String = ""
	var  isDocumentsExpired : Bool = false
	var  isSelected : Bool = false
	var  isDocumentsUploaded : Bool = true
	var  model : String = ""
	var  name : String = ""
	var  passingYear : String = ""
	var  plateNo : String = ""
	var  serviceType : String = ""
    var  typeImageUrl:String = ""

	enum CodingKeys: String, CodingKey {
		case id = "_id"
		case accessibility = "accessibility"
		case adminTypeId = "admin_type_id"
		case color = "color"
		case isDocumentsExpired = "is_documents_expired"
		case isSelected = "is_selected"
		case isDocumentsUploaded = "is_document_uploaded"
		case model = "model"
		case name = "name"
		case passingYear = "passing_year"
		case plateNo = "plate_no"
		case serviceType = "service_type"
        case typeImageUrl = "type_image_url"
	}
    
	init(from decoder: Decoder) throws {
		let  values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(String.self, forKey: .id) ?? ""
		accessibility = try values.decodeIfPresent([String].self, forKey: .accessibility) ?? []
		adminTypeId = try values.decodeIfPresent(String.self, forKey: .adminTypeId)  ?? ""
		color = try values.decodeIfPresent(String.self, forKey: .color)  ?? ""
		isDocumentsExpired = try values.decodeIfPresent(Bool.self, forKey: .isDocumentsExpired)  ?? false
		isSelected = try values.decodeIfPresent(Bool.self, forKey: .isSelected) ?? false
		isDocumentsUploaded = try values.decodeIfPresent(Bool.self,  forKey: .isDocumentsUploaded) ?? true
		model = try values.decodeIfPresent(String.self, forKey: .model) ?? ""
		name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
		passingYear = try values.decodeIfPresent(String.self, forKey: .passingYear)  ?? ""
		plateNo = try values.decodeIfPresent(String.self, forKey: .plateNo) ?? ""
		serviceType = try values.decodeIfPresent(String.self, forKey: .serviceType) ?? ""
        typeImageUrl = try values.decodeIfPresent(String.self, forKey: .typeImageUrl) ?? ""
	}
    
    init() {}
}
