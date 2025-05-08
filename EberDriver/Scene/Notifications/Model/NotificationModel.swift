//
//  NotificationModel.swift
//  EberDriver
//
//  Created by Rohit on 08/08/23.
//  Copyright © 2023 Elluminati. All rights reserved.
//
typealias JSONType = [String: Any]

protocol JSONParsable {
    init?(json: JSONType?)
}


import Foundation
struct Notitifcations{
    var message : String?
    var created_at  : String?
    var _id : String?
    var user_id  : String?
    var device_type  : String?
    var unique_id  : Int?
    var updated_at  : String?
    var username  : String?
    var __v  : Int?
    var email  : String?
    var country  : String?
    var user_type  : Int?
}

extension Notitifcations : JSONParsable{
    init?(json: JSONType?) {
        self.message = json?["message"] as? String ?? ""
        self.created_at = json?["created_at"] as? String ?? ""
        self._id = json?["_id"] as? String ?? ""
        self.user_id = json?["user_id"] as? String ?? ""
        self.device_type = json?["device_type"]  as? String ?? ""
        self.unique_id = json?["unique_id"] as? Int ?? 0
        self.updated_at = json?["updated_at"] as? String ?? ""
        self.username = json?["username"] as? String ?? ""
        self.__v = json?["__v"] as? Int ?? 0
        self.email = json?["email"] as? String ?? ""
        self.country = json?["country"] as? String ?? ""
        self.user_type = json?["user_type"] as? Int ?? 0
    }
}
