//
//  ResponseModel.swift
//  Cabtown
//
//  Created by Elluminati on 22/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import Foundation

struct ResponseModel : Codable {

    var errorCode : String = "0"
    var message : String = "0"
    var success : Bool = false
    
    
    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case message = "message"
        case success = "success"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        errorCode = try values.decodeIfPresent(String.self, forKey: .errorCode) ?? "0"
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? "0"
        success = try values.decodeIfPresent(Bool.self, forKey: .success) ?? false
    }
  
}
