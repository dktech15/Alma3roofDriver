
import Foundation
struct ProviderDocument : Codable {
    
    var v : Int = 0
    var  id : String = ""
    var  createdAt : String = ""
    var  documentId : String = ""
    var  documentPicture : String = ""
    var  expiredDate : String = ""
    var  isDocumentExpired : Bool = false
    var  isExpiredDate : Bool = false
    var  isUniqueCode : Bool = false
    var  isUploaded : Int = 0
    var  name :  String = ""
    var  option :  Int = 0
    var  providerId : String = ""
    var  uniqueCode : String = ""
    var  updatedAt : String = ""
    
    
    enum CodingKeys: String, CodingKey {
        case v = "__v"
        case id = "_id"
        case createdAt = "created_at"
        case documentId = "document_id"
        case documentPicture = "document_picture"
        case expiredDate = "expired_date"
        case isDocumentExpired = "is_document_expired"
        case isExpiredDate = "is_expired_date"
        case isUniqueCode = "is_unique_code"
        case isUploaded = "is_uploaded"
        case name = "name"
        case option = "option"
        case providerId = "provider_id"
        case uniqueCode = "unique_code"
        case updatedAt = "updated_at"
    }
    
    init(from decoder: Decoder) throws {
        let  values = try decoder.container(keyedBy: CodingKeys.self)
        v = try values.decodeIfPresent(Int.self, forKey: .v) ?? 0
        id = try values.decodeIfPresent(String.self, forKey: .id)  ?? ""
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)  ?? ""
        documentId = try values.decodeIfPresent(String.self, forKey: .documentId)  ?? ""
        documentPicture = try values.decodeIfPresent(String.self, forKey: .documentPicture)  ?? ""
        expiredDate = try values.decodeIfPresent(String.self, forKey: .expiredDate)  ?? ""
        isDocumentExpired = try values.decodeIfPresent(Bool.self, forKey: .isDocumentExpired) ?? false
        isExpiredDate = try values.decodeIfPresent(Bool.self, forKey: .isExpiredDate) ?? false
        isUniqueCode = try values.decodeIfPresent(Bool.self, forKey: .isUniqueCode) ?? false
        isUploaded = try values.decodeIfPresent(Int.self, forKey: .isUploaded) ?? 0
        name = try values.decodeIfPresent(String.self, forKey: .name)  ?? ""
        option = try values.decodeIfPresent(Int.self, forKey: .option) ?? 0
        providerId = try values.decodeIfPresent(String.self, forKey: .providerId)  ?? ""
        uniqueCode = try values.decodeIfPresent(String.self, forKey: .uniqueCode)  ?? ""
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)  ?? ""
    }
    
    init() {}
}


