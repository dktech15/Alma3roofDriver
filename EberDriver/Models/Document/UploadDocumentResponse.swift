
import Foundation


struct UploadDocumentResponse : Codable
{

        
        var documentPicture : String = ""
        var expiredDate : String = ""
        var isDocumentUploaded : Int  = 0
        var isDocumentsExpired : Bool = false
        var isUploaded : Int = 0
        var message : String = ""
        var success : Bool = false
        var uniqueCode : String = ""
        
        
        enum CodingKeys: String, CodingKey {
            case documentPicture = "document_picture"
            case expiredDate = "expired_date"
            case isDocumentUploaded = "is_document_uploaded"
            case isDocumentsExpired = "is_documents_expired"
            case isUploaded = "is_uploaded"
            case message = "message"
            case success = "success"
            case uniqueCode = "unique_code"
        }
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            documentPicture = try values.decodeIfPresent(String.self, forKey: .documentPicture) ?? ""
            expiredDate = try values.decodeIfPresent(String.self, forKey: .expiredDate) ?? ""
            isDocumentUploaded = try values.decodeIfPresent(Int.self, forKey: .isDocumentUploaded) ?? 0
            
            
            isDocumentsExpired = try values.decodeIfPresent(Bool.self, forKey: .isDocumentsExpired) ?? false
            isUploaded = try values.decodeIfPresent(Int.self, forKey: .isUploaded) ?? 0
            message = try values.decodeIfPresent(String.self, forKey: .message) ?? ""
            success = try values.decodeIfPresent(Bool.self, forKey: .success) ?? false
            uniqueCode = try values.decodeIfPresent(String.self, forKey: .uniqueCode) ?? ""
        }
}


