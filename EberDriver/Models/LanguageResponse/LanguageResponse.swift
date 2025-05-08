//
//	Card.swift
//
//	Create by MacPro3 on 15/9/2018
//	Copyright © 2018. All rights reserved.



import Foundation

struct LanguageResponse : Codable {
    
    var languages : [Language] = []
    var message : String = ""
    var success : Bool = false
    
    
    enum CodingKeys: String, CodingKey {
        case languages = "languages"
        case message = "message"
        case success = "success"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        languages = try values.decodeIfPresent([Language].self, forKey: .languages) ?? []
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? ""
        success = try values.decodeIfPresent(Bool.self, forKey: .success) ?? false
        
    }
    
    
}
