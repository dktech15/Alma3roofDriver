//
//  ProviderSingleton.swift
//  Cabtown
//
//  Created by Elluminati on 02/03/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import Foundation
import CoreLocation
/**
 * Created by Jaydeep on 13-Feb-17.
 */

public class ProviderSingleton: NSObject {
    
    static let shared = ProviderSingleton()
    
    var settingResponse:AppSettingResponse? = nil
    
    var currentCountryPhoneCode:String = "";
    var currentCountry:String = ""
    var currentCountryCode:String = ""
    
    var arrForCountries:[CountryList] = CountryList.modelsFromDictionaryArray()

    
    public weak var timerUpdateLocation: Timer? = nil
    public weak var timerForWaitingTime: Timer? = nil
    public weak var timerForTotalTripTime: Timer? = nil
    public weak var timerForAcceptRejectTrip: Timer? = nil
    
    /*Trip Data*/
    var tripStaus:TripStatusResponse = TripStatusResponse.init()
    var provider:ProviderDetail = ProviderDetail.init()
    var tripUser:UserDetail = UserDetail(dics: [:])
    var nearTripUser:UserDetail = UserDetail(dics: [:])
    var tripId:String = ""
    var arrRideShareTrips:[TripsRespons] = []
    var isTripEnd:Int = 0
    var nearTripId: String = ""
    var nearIsTripEnd:Int = 0
    var isProviderStatus: Int = 0
    var nearIsProviderStatus: Int = 0
    var currentVehicle:VehicleDetail = VehicleDetail.init()
    var isCardModeAvailable:Int = 0
    var isCashModeAvailable:Int = 0
    var isApplePayModeAvailable:Bool = false
    var serverTime:String = ""
    var currency:String = ""
    var timeZone:String = TimeZone.current.identifier
    
    var timeLeftToRespondTrip:Int = 60
    var nearTimeLeftToRespondTrip:Int = 60
    var nearTimeLeftToRespondTrip2:Int = 60
    var currentCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: 0.0, longitude: 0.0)
    var bearing:Double = 0.0
    var pickupCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: 0.0, longitude: 0.0)
    var destinationCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: 0.0, longitude: 0.0)
    var isAutoTransfer: Bool = true
    
    var arrTripIds = [String]()
    
    private override init() {}
    
    func clear() {
        clearTripData()
        clearUserData()
        provider =  ProviderDetail.init()
        tripUser = UserDetail(dics: [:])
        self.nearTripUser = UserDetail(dics: [:])
        currentVehicle = VehicleDetail.init()
    }
    
    func clearTripData() {
        tripStaus =  TripStatusResponse.init()
        tripId = ""
        self.nearTripId = ""
        isTripEnd = 0
        self.nearIsTripEnd = 0
        self.tripUser = UserDetail(dics: [:])
        self.nearTripUser = UserDetail(dics: [:])
        self.timerForTotalTripTime?.invalidate()
        self.timerForTotalTripTime = nil
    }
    
    func clearUserData() {
      self.provider = ProviderDetail.init()
    }
    
    func setPickupLocation(latitude:Double,longitude:Double,address:String) {
        if address.isEmpty() || latitude == 0.0 || longitude == 0.0 {
            //Utility.showToast(message: "VALIDATION_MSG_INVALID_LOCATION".localized)
        }else {
          self.pickupCoordinate = CLLocationCoordinate2D.init(latitude: latitude, longitude: longitude)
        }
    }
    
    func setDestinationLocation(latitude:Double,longitude:Double,address:String) {
        if address.isEmpty() || latitude == 0.0 || longitude == 0.0 {
           // Utility.showToast(message: "VALIDATION_MSG_INVALID_LOCATION".localized)
        }else {
            self.destinationCoordinate = CLLocationCoordinate2D.init(latitude: latitude, longitude: longitude)
        }
    }
    
    func clearPickupAddress() {
         self.pickupCoordinate = CLLocationCoordinate2D.init(latitude: 0.0, longitude: 0.0)
    }
    func clearDestinationAddress() {
         self.destinationCoordinate = CLLocationCoordinate2D.init(latitude: 0.0, longitude: 0.0)
    }
    
    func stopSoundTimer() {
        if ProviderSingleton.shared.timerUpdateLocation != nil {
            ProviderSingleton.shared.timerUpdateLocation?.invalidate()
            ProviderSingleton.shared.timerUpdateLocation = nil
        }
        if ProviderSingleton.shared.timerForAcceptRejectTrip != nil {
            ProviderSingleton.shared.timerForAcceptRejectTrip?.invalidate()
            ProviderSingleton.shared.timerForAcceptRejectTrip = nil
        }
    }
}

public class CurrencyHelper {
    static let shared = CurrencyHelper()
    public var myLocale:Locale = Locale.current
    public var currencyCode:String = "$"
    private init() {}
}
