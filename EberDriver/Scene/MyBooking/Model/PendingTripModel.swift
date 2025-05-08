//
//  PendingTripModel.swift
//  EberDriver
//
//  Created by Rohit on 14/08/23.
//  Copyright © 2023 Elluminati. All rights reserved.
//

import Foundation
struct PendingTrip{
    var _id : String?
    var user_first_name : String?
    var destination_addresses : [String]?
    var  unique_id : Int?
    var  is_provider_accepted : Int?
    var  provider_service_fees : Double?
    var  destination_address : String?
    var  is_schedule_trip : Bool?
    var source_address : String?
    var  user_last_name : String?
    var  trip_id : String?
}

extension PendingTrip : JSONParsable{
    init?(json: JSONType?) {
        self._id = json?["_id"] as?  String ?? ""
        self.user_first_name = json?["user_first_name"] as?  String ?? ""
        self.destination_addresses = json?["destination_addresses"] as?  [String]
        self.unique_id = json?["unique_id"] as?  Int ?? 0
        self.is_provider_accepted = json?["is_provider_accepted"] as?  Int ?? 0
        self.provider_service_fees = json?["provider_service_fees"] as?  Double ?? 0.0
        self.destination_address = json?["destination_address"] as?  String ?? ""
        self.is_schedule_trip = json?["is_schedule_trip"] as?  Bool ?? false
        self.source_address = json?["source_address"] as?  String ?? ""
        self.user_last_name = json?["user_last_name"] as?  String ?? ""
        self.trip_id = json?["trip_id"] as?  String ?? ""
    }
    
}
