//
//	DailyEarningResponse.swift
//
//	Create by Elluminati on 28/6/2017
//	Copyright © 2017 Elluminati. All rights reserved.

import Foundation

struct EarningResponse : Codable {
    
    var currency : String = ""
    let providerDailyAnalytic : EarningProviderDailyAnalytic?
    let providerDailyEarning : EarningProviderDailyEarning?
    
    let providerWeeklyAnalytic : EarningProviderDailyAnalytic?
    let providerWeeklyEarning : EarningProviderDailyEarning?
    
    var success : Bool = false
    var trips : [EarningTrip] = []
    let tripDayTotal : EarningTripDayTotal?
    let date : EarningDate?
    
    enum CodingKeys: String, CodingKey {
        case currency = "currency"
        case providerDailyAnalytic = "provider_daily_analytic"
        case providerDailyEarning = "provider_daily_earning"
        case providerWeeklyAnalytic = "provider_weekly_analytic"
        case providerWeeklyEarning = "provider_weekly_earning"
        case success = "success"
        case trips = "trips"
        case date = "date"
        case tripDayTotal = "trip_day_total"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        currency = try values.decodeIfPresent(String.self, forKey: .currency) ?? ""
        providerDailyAnalytic = try values.decodeIfPresent(EarningProviderDailyAnalytic.self, forKey: .providerDailyAnalytic)
        providerWeeklyAnalytic = try  values.decodeIfPresent(EarningProviderDailyAnalytic.self, forKey: .providerWeeklyAnalytic)
        
        providerDailyEarning = try values.decodeIfPresent(EarningProviderDailyEarning.self, forKey: .providerDailyEarning)
        providerWeeklyEarning = try  values.decodeIfPresent(EarningProviderDailyEarning.self, forKey: .providerWeeklyEarning)
        
        success = try values.decodeIfPresent(Bool.self, forKey: .success) ?? false
        trips = try values.decodeIfPresent([EarningTrip].self, forKey: .trips) ?? []
        tripDayTotal = try values.decodeIfPresent(EarningTripDayTotal.self, forKey: .tripDayTotal)
        date = try values.decodeIfPresent(EarningDate.self, forKey: .date)
    }
}

struct EarningTripDayTotal : Codable {
    
    var id : String = ""
    var date1 : Double = 0.0
    var date2 : Double = 0.0
    var date3 : Double = 0.0
    var date4 : Double = 0.0
    var date5 : Double = 0.0
    var date6 : Double = 0.0
    var date7 : Double = 0.0
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case date1 = "date1"
        case date2 = "date2"
        case date3 = "date3"
        case date4 = "date4"
        case date5 = "date5"
        case date6 = "date6"
        case date7 = "date7"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? ""
        date1 = try values.decodeIfPresent(Double.self, forKey: .date1) ?? 0.0
        date2 = try values.decodeIfPresent(Double.self, forKey: .date2) ?? 0.0
        date3 = try values.decodeIfPresent(Double.self, forKey: .date3) ?? 0.0
        date4 = try values.decodeIfPresent(Double.self, forKey: .date4) ?? 0.0
        date5 = try values.decodeIfPresent(Double.self, forKey: .date5) ?? 0.0
        date6 = try values.decodeIfPresent(Double.self, forKey: .date6) ?? 0.0
        date7 = try values.decodeIfPresent(Double.self, forKey: .date7) ?? 0.0
    }
}

struct EarningDate : Codable {
    
    var date1 : String = ""
    var date2 : String = ""
    var date3 : String = ""
    var date4 : String = ""
    var date5 : String = ""
    var date6 : String = ""
    var date7 : String = ""
    
    enum CodingKeys: String, CodingKey {
        case date1 = "date1"
        case date2 = "date2"
        case date3 = "date3"
        case date4 = "date4"
        case date5 = "date5"
        case date6 = "date6"
        case date7 = "date7"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        date1 = try values.decodeIfPresent(String.self, forKey: .date1) ?? ""
        date2 = try values.decodeIfPresent(String.self, forKey: .date2) ?? ""
        date3 = try values.decodeIfPresent(String.self, forKey: .date3) ?? ""
        date4 = try values.decodeIfPresent(String.self, forKey: .date4) ?? ""
        date5 = try values.decodeIfPresent(String.self, forKey: .date5) ?? ""
        date6 = try values.decodeIfPresent(String.self, forKey: .date6) ?? ""
        date7 = try values.decodeIfPresent(String.self, forKey: .date7) ?? ""
    }
}


