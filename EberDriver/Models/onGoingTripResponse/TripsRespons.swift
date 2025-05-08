//
//	CreateTripRespose.swift
//
//	Create by MacPro3 on 29/9/2018
//	Copyright © 2018. All rights reserved.


import Foundation

struct TripsRespons : Codable {
    
    var destinationLocation : [Double] = [0.0,0.0]
    var destinationAddress : String = ""
    var isTripEnd : Int = 0
    var message : String = ""
    var sourceLocation : [Double] = [0.0,0.0]
    var sourceAddress : String = ""
    var success : Bool = false
    var timeLeftToRespondsTrip : Int = 60
    var tripId : String = ""
    var isProviderStatus: Int = 0
    var is_provider_accepted: Int = 0
    var user : UserDetail = UserDetail.init(dics: [:])
    var unique_id: Int = 0
    var bids: [Bids] = []
    
    enum CodingKeys: String, CodingKey {
        case destinationLocation = "destinationLocation"
        case destinationAddress = "destination_address"
        case isTripEnd = "is_trip_end"
        case message = "message"
        case sourceLocation = "sourceLocation"
        case sourceAddress = "source_address"
        case success = "success"
        case timeLeftToRespondsTrip = "time_left_to_responds_trip"
        case tripId = "trip_id"
        case user = "user"
        case isProviderStatus = "is_provider_status"
        case is_provider_accepted = "is_provider_accepted"
        case unique_id = "unique_id"
        case bids = "bids"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            destinationLocation = try values.decodeIfPresent([Double].self, forKey: .destinationLocation) ?? [0.0,0.0]
        }catch {
            destinationLocation = [0.0,0.0]
        }
        destinationAddress = try values.decodeIfPresent(String.self, forKey: .destinationAddress) ?? ""
        isTripEnd = try values.decodeIfPresent(Int.self, forKey: .isTripEnd) ?? 0
        isProviderStatus = try values.decodeIfPresent(Int.self, forKey: .isProviderStatus) ?? 0
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? ""
        sourceLocation = try values.decodeIfPresent([Double].self, forKey: .sourceLocation) ?? [0.0,0.0]
        sourceAddress = try values.decodeIfPresent(String.self, forKey: .sourceAddress) ?? ""
        success = try values.decodeIfPresent(Bool.self, forKey: .success) ?? false
        timeLeftToRespondsTrip = try values.decodeIfPresent(Int.self, forKey: .timeLeftToRespondsTrip) ?? 60
        tripId = try values.decodeIfPresent(String.self, forKey: .tripId) ?? ""
        is_provider_accepted = try values.decodeIfPresent(Int.self, forKey: .tripId) ?? 0
        user = try values.decodeIfPresent(UserDetail.self, forKey: .user) ?? UserDetail.init(dics: [:])
        unique_id = try values.decodeIfPresent(Int.self, forKey: .user) ?? 0
        bids = try values.decodeIfPresent([Bids].self, forKey: .bids) ?? []
    }
    
    init(dics: [String:Any]) {
        destinationLocation = dics["destinationLocation"] as? [Double] ?? [0.0,0.0]
        destinationAddress = dics["destination_address"] as? String ?? ""
        isTripEnd = dics["is_trip_end"] as? Int ?? 0
        isProviderStatus = dics["is_provider_status"] as? Int ?? 0
        message = dics["message"] as? String ?? ""
        sourceLocation = dics["sourceLocation"] as? [Double] ?? [0.0,0.0]
        sourceAddress = dics["source_address"] as? String ?? ""
        success = dics["success"] as? Bool ?? false
        timeLeftToRespondsTrip = dics["time_left_to_responds_trip"] as? Int ?? 60
        tripId = dics["trip_id"] as? String ?? ""
        is_provider_accepted = dics["is_provider_accepted"] as? Int ?? 0
        if let value = dics["user"] as? [String:Any] {
            user = UserDetail(dics: value)
        }
        unique_id = dics["unique_id"] as? Int ?? 0
        if let value = dics["bids"] as? [[String:Any]] {
            bids.removeAll()
            for dics in value {
                bids.append(Bids(dics: dics))
            }
        }
    }
    
    init() {}
}

struct GetTrips : Codable {
    
    var trip_detail : [String] = []
    var bids: [Bids] = []
    
    enum CodingKeys: String, CodingKey {
        case trip_detail = "trip_detail"
        case bids = "bids"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        trip_detail = try values.decodeIfPresent([String].self, forKey: .trip_detail) ?? []
        bids = try values.decodeIfPresent([Bids].self, forKey: .bids) ?? []
    }
    
    init() {}
}

struct Bids : Codable {
    let trip_id : String?
    let unique_id : Int?
    let first_name : String?
    let last_name : String?
    let picture : String?
    let currency : String?
    let bid_price : Double?
    let ask_bid_price : Double?
    let bid_at : String?
    let status : Int?
    let bid_end_at: String?
    let rate: Double?

    enum CodingKeys: String, CodingKey {

        case trip_id = "trip_id"
        case unique_id = "unique_id"
        case first_name = "first_name"
        case last_name = "last_name"
        case picture = "picture"
        case currency = "currency"
        case bid_price = "bid_price"
        case ask_bid_price = "ask_bid_price"
        case bid_at = "bid_at"
        case status = "status"
        case bid_end_at = "bid_end_at"
        case rate = "rate"
    }
    
    init(dics: [String:Any]) {
        trip_id = dics["trip_id"] as? String ?? ""
        unique_id = dics["unique_id"] as? Int ?? 0
        first_name = dics["first_name"] as? String ?? ""
        last_name = dics["last_name"] as? String ?? ""
        picture = dics["picture"] as? String ?? ""
        currency = dics["currency"] as? String ?? ""
        bid_price = dics["bid_price"] as? Double ?? 0
        ask_bid_price = dics["ask_bid_price"] as? Double ?? 0
        bid_at = dics["bid_at"] as? String ?? ""
        status = dics["status"] as? Int ?? 0
        bid_end_at = dics["bid_end_at"] as? String ?? ""
        rate = dics["rate"] as? Double ?? 0
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        trip_id = try values.decodeIfPresent(String.self, forKey: .trip_id)
        unique_id = try values.decodeIfPresent(Int.self, forKey: .unique_id)
        first_name = try values.decodeIfPresent(String.self, forKey: .first_name)
        last_name = try values.decodeIfPresent(String.self, forKey: .last_name)
        picture = try values.decodeIfPresent(String.self, forKey: .picture)
        currency = try values.decodeIfPresent(String.self, forKey: .currency)
        bid_price = try values.decodeIfPresent(Double.self, forKey: .bid_price)
        ask_bid_price = try values.decodeIfPresent(Double.self, forKey: .ask_bid_price)
        bid_at = try values.decodeIfPresent(String.self, forKey: .bid_at)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        bid_end_at = try values.decodeIfPresent(String.self, forKey: .bid_end_at)
        rate = try values.decodeIfPresent(Double.self, forKey: .rate)
    }

}
