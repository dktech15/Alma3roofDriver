//
//	ProviderAnalyticDaily.swift
//
//	Create by Elluminati on 28/6/2017
//	Copyright © 2017 Elluminati. All rights reserved.

import Foundation

struct EarningProviderDailyAnalytic : Codable {
    
    var v : Int = 0
    var id : String = ""
    var accepted : Int = 0
    var acceptionRatio : Double = 0.0
    var cancellationRatio : Double = 0.0
    var cancelled : Int = 0
    var completed : Int = 0
    var completedRatio : Double = 0.0
    var createdAt : String = ""
    var dateServerTimezone : String = ""
    var dateTag : String = ""
    var notAnswered : Int = 0
    var providerId : String = ""
    var received : Int = 0
    var rejected : Int = 0
    var rejectionRatio : Double = 0.0
    var totalOnlineTime : Int = 0
    var uniqueId : Int = 0
    var updatedAt : String = ""
    
    enum CodingKeys: String, CodingKey {
        case v = "__v"
        case id = "_id"
        case accepted = "accepted"
        case acceptionRatio = "acception_ratio"
        case cancellationRatio = "cancellation_ratio"
        case cancelled = "cancelled"
        case completed = "completed"
        case completedRatio = "completed_ratio"
        case createdAt = "created_at"
        case dateServerTimezone = "date_server_timezone"
        case dateTag = "date_tag"
        case notAnswered = "not_answered"
        case providerId = "provider_id"
        case received = "received"
        case rejected = "rejected"
        case rejectionRatio = "rejection_ratio"
        case totalOnlineTime = "total_online_time"
        case uniqueId = "unique_id"
        case updatedAt = "updated_at"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        v = try values.decodeIfPresent(Int.self, forKey: .v) ?? 0
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? ""
        accepted = try values.decodeIfPresent(Int.self, forKey: .accepted) ?? 0
        acceptionRatio = try values.decodeIfPresent(Double.self, forKey: .acceptionRatio) ?? 0.0
        cancellationRatio = try values.decodeIfPresent(Double.self, forKey: .cancellationRatio) ?? 0.0
        cancelled = try values.decodeIfPresent(Int.self, forKey: .cancelled) ?? 0
        completed = try values.decodeIfPresent(Int.self, forKey: .completed) ?? 0
        completedRatio = try values.decodeIfPresent(Double.self, forKey: .completedRatio) ?? 0.0
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt) ?? ""
        dateServerTimezone = try values.decodeIfPresent(String.self, forKey: .dateServerTimezone) ?? ""
        dateTag = try values.decodeIfPresent(String.self, forKey: .dateTag) ?? ""
        notAnswered = try values.decodeIfPresent(Int.self, forKey: .notAnswered) ?? 0
        providerId = try values.decodeIfPresent(String.self, forKey: .providerId) ?? ""
        received = try values.decodeIfPresent(Int.self, forKey: .received) ?? 0
        rejected = try values.decodeIfPresent(Int.self, forKey: .rejected) ?? 0
        rejectionRatio = try values.decodeIfPresent(Double.self, forKey: .rejectionRatio) ?? 0.0
        totalOnlineTime = try values.decodeIfPresent(Int.self, forKey: .totalOnlineTime) ?? 0
        uniqueId = try values.decodeIfPresent(Int.self, forKey: .uniqueId) ?? 0
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt) ?? ""
    }
}
