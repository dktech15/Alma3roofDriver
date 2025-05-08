import Foundation


struct DocumentsResponse : Codable{
    
    var message : String = "0"
    var providerdocument : [ProviderDocument] = []
    var success : Bool  = false
    
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case providerdocument = "providerdocument"
        case success = "success"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? "0"
        providerdocument = try values.decodeIfPresent([ProviderDocument].self, forKey: .providerdocument) ?? []
        success = try values.decodeIfPresent(Bool.self, forKey: .success) ?? false
    }

    
}
