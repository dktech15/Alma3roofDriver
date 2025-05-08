//
//	Provider.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct Provider : Codable {
    
    var v : Int = 0
    var id : String = ""
    var acceptedRequest : Int = 0
    var accountId : String = ""
    var address : String = ""
    var admintypeid : String = ""
    var appVersion : String = ""
    var bankId : String = ""
    var bearing : Double = 0.0
    var bio : String = ""
    var cancelledRequest : Int = 0
    var carModel : String = ""
    var carNumber : String = ""
    var city : String = ""
    var cityid : String = ""
    var completedRequest : Int = 0
    var country : String = ""
    var countryId : String = ""
    var countryPhoneCode : String = ""
    var createdAt : String = ""
    var deviceTimezone : String = ""
    var deviceToken : String = ""
    var deviceType : String = ""
    var deviceUniqueCode : String = ""
    var email : String = ""
    var firstName : String = ""
    var gender : String = ""
    
    var isActive : Int = 0
    var isApproved : Int = 0
    var isAvailable : Int = 0
    var isDocumentUploaded : Int = 0
    var isSendMoney: Bool = false
    var isDocumentsExpired : Bool = false
    var isPartnerApprovedByAdmin : Int = 0
    var isTrip : [String] = []
    var isVehicleDocumentUploaded : Bool = false
    var languages : [String] = []
    var lastName : String = ""
    var lastTransferedDate : String = ""
    var lastTransferredDate : String = ""
    var locationUpdatedTime : String = ""
    var loginBy : String = ""
    var password : String = ""
    var phone : String = ""
    var picture : String = ""
    var providerLocation : [Double] = [0.0,0.0]
    var providerPreviousLocation : [Double] = [0.0,0.0]
    var providerType : Int = 0
    var providerTypeId : String = ""
    var rate : Double = 0.0
    var rateCount : Int = 0
    
    var rejectedRequest : Int = 0
    var serviceType : String = ""
    var socialUniqueId : String = ""
    var startOnlineTime : String = ""
    var token : String = ""
    var totalRequest : Int = 0
    var uniqueId : Int = 0
    var updatedAt : String = ""
    var vehicleDetail : [VehicleDetail] = []
    var wallet : Double = 0.0
    var walletCurrencyCode : String = ""
    var zipcode : String = ""
    var zoneQueueNo : Int = 0
    var referralCode: String = ""
    var isReferral: Int = 0
    var countryDetail: CountryDetail!
    var alpha2: String = ""
    var zone_queue_id : String = ""
    var zone_queue_number : String = ""
    var zone_name : String = ""
    var gender_type : Int = 0
    
    enum CodingKeys: String, CodingKey {
        case v = "__v"
        case id = "_id"
        case acceptedRequest = "accepted_request"
        case accountId = "account_id"
        case address = "address"
        case admintypeid = "admintypeid"
        case appVersion = "app_version"
        case bankId = "bank_id"
        case bearing = "bearing"
        case bio = "bio"
        case cancelledRequest = "cancelled_request"
        case carModel = "car_model"
        case carNumber = "car_number"
        case city = "city"
        case cityid = "cityid"
        case completedRequest = "completed_request"
        case country = "country"
        case countryId = "country_id"
        case countryPhoneCode = "country_phone_code"
        case createdAt = "created_at"
        case deviceTimezone = "device_timezone"
        case deviceToken = "device_token"
        case deviceType = "device_type"
        case deviceUniqueCode = "device_unique_code"
        case email = "email"
        case firstName = "first_name"
        case gender = "gender"
        case isActive = "is_active"
        case isApproved = "is_approved"
        case isAvailable = "is_available"
        case isDocumentUploaded = "is_document_uploaded"
        case isSendMoney = "is_send_money_for_provider"
        case isDocumentsExpired = "is_documents_expired"
        case isPartnerApprovedByAdmin = "is_partner_approved_by_admin"
        case isTrip = "is_trip"
        case isVehicleDocumentUploaded = "is_vehicle_document_uploaded"
        case languages = "languages"
        case lastName = "last_name"
        case lastTransferedDate = "last_transfered_date"
        case lastTransferredDate = "last_transferred_date"
        case locationUpdatedTime = "location_updated_time"
        case loginBy = "login_by"
        case password = "password"
        case phone = "phone"
        case picture = "picture"
        case providerLocation = "providerLocation"
        case providerPreviousLocation = "providerPreviousLocation"
        case providerType = "provider_type"
        case providerTypeId = "provider_type_id"
        case rate = "rate"
        case rateCount = "rate_count"
        case rejectedRequest = "rejected_request"
        case serviceType = "service_type"
        case socialUniqueId = "social_unique_id"
        case startOnlineTime = "start_online_time"
        case token = "token"
        case totalRequest = "total_request"
        case uniqueId = "unique_id"
        case updatedAt = "updated_at"
        case vehicleDetail = "vehicle_detail"
        case wallet = "wallet"
        case walletCurrencyCode = "wallet_currency_code"
        case zipcode = "zipcode"
        case zoneQueueNo = "zone_queue_no"
        case referralCode = "referral_code"
        case isReferral = "is_referral"
        case countryDetail = "country_detail"
        case alpha2 = "alpha2"
        case zone_queue_id  = "zone_queue_id"
        case zone_queue_number  = "zone_queue_number"
        case zone_name  = "zone_name"
        case gender_type  = "gender_type"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        referralCode = try values.decodeIfPresent(String.self, forKey: .referralCode) ?? ""
        isReferral = try values.decodeIfPresent(Int.self, forKey: .isReferral) ?? 0
        gender_type = try values.decodeIfPresent(Int.self, forKey: .gender_type) ?? 0
        countryDetail = try values.decodeIfPresent(CountryDetail.self, forKey: .countryDetail) ?? CountryDetail.init()
        v = try values.decodeIfPresent(Int.self, forKey: .v) ?? 0
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? ""
        acceptedRequest = try values.decodeIfPresent(Int.self, forKey: .acceptedRequest) ?? 0
        accountId = try values.decodeIfPresent(String.self, forKey: .accountId) ?? ""
        address = try values.decodeIfPresent(String.self, forKey: .address) ?? ""
        admintypeid = try values.decodeIfPresent(String.self, forKey: .admintypeid) ?? ""
        appVersion = try values.decodeIfPresent(String.self, forKey: .appVersion) ?? ""
        bankId = try values.decodeIfPresent(String.self, forKey: .bankId) ?? ""
        bearing = try values.decodeIfPresent(Double.self, forKey: .bearing) ?? 0.0
        bio = try values.decodeIfPresent(String.self, forKey: .bio) ?? ""
        cancelledRequest = try values.decodeIfPresent(Int.self, forKey: .cancelledRequest) ?? 0
        carModel = try values.decodeIfPresent(String.self, forKey: .carModel) ?? ""
        carNumber = try values.decodeIfPresent(String.self, forKey: .carNumber) ?? ""
        city = try values.decodeIfPresent(String.self, forKey: .city) ?? ""
        cityid = try values.decodeIfPresent(String.self, forKey: .cityid) ?? ""
        completedRequest = try values.decodeIfPresent(Int.self, forKey: .completedRequest) ?? 0
        country = try values.decodeIfPresent(String.self, forKey: .country) ?? ""
        countryId = try values.decodeIfPresent(String.self, forKey: .countryId) ?? ""
        countryPhoneCode = try values.decodeIfPresent(String.self, forKey: .countryPhoneCode) ?? ""
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt) ?? ""
        deviceTimezone = try values.decodeIfPresent(String.self, forKey: .deviceTimezone) ?? ""
        deviceToken = try values.decodeIfPresent(String.self, forKey: .deviceToken) ?? ""
        deviceType = try values.decodeIfPresent(String.self, forKey: .deviceType) ?? ""
        deviceUniqueCode = try values.decodeIfPresent(String.self, forKey: .deviceUniqueCode) ?? ""
        email = try values.decodeIfPresent(String.self, forKey: .email) ?? ""
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName) ?? ""
        gender = try values.decodeIfPresent(String.self, forKey: .gender) ?? ""
        
        isActive = try values.decodeIfPresent(Int.self, forKey: .isActive) ?? 0
        isApproved = try values.decodeIfPresent(Int.self, forKey: .isApproved) ?? 0
        isAvailable = try values.decodeIfPresent(Int.self, forKey: .isAvailable) ?? 0
        isDocumentUploaded = try values.decodeIfPresent(Int.self, forKey: .isDocumentUploaded) ?? 0
        isSendMoney = try values.decodeIfPresent(Bool.self, forKey: .isSendMoney) ?? false
        isDocumentsExpired = try values.decodeIfPresent(Bool.self, forKey: .isDocumentsExpired) ?? false
        isPartnerApprovedByAdmin = try values.decodeIfPresent(Int.self, forKey: .isPartnerApprovedByAdmin) ?? 0
        isTrip = try values.decodeIfPresent([String].self, forKey: .isTrip) ?? []
        
        isVehicleDocumentUploaded = try values.decodeIfPresent(Bool.self, forKey: .isVehicleDocumentUploaded) ?? false
        languages = try values.decodeIfPresent([String].self, forKey: .languages) ?? []
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName) ?? ""
        lastTransferedDate = try values.decodeIfPresent(String.self, forKey: .lastTransferedDate)  ?? ""
        lastTransferredDate = try values.decodeIfPresent(String.self, forKey: .lastTransferredDate) ?? ""
        locationUpdatedTime = try values.decodeIfPresent(String.self, forKey: .locationUpdatedTime) ?? ""
        loginBy = try values.decodeIfPresent(String.self, forKey: .loginBy) ?? ""
        password = try values.decodeIfPresent(String.self, forKey: .password) ?? ""
        phone = try values.decodeIfPresent(String.self, forKey: .phone) ?? ""
        picture = try values.decodeIfPresent(String.self, forKey: .picture) ?? ""
        providerLocation = try values.decodeIfPresent([Double].self, forKey: .providerLocation) ?? [0.0,0.0]
        providerPreviousLocation = try values.decodeIfPresent([Double].self, forKey: .providerPreviousLocation) ?? [0.0,0.0]
        providerType = try values.decodeIfPresent(Int.self, forKey: .providerType) ?? 0
        providerTypeId = try values.decodeIfPresent(String.self, forKey: .providerTypeId)  ?? ""
        rate = try values.decodeIfPresent(Double.self, forKey: .rate) ?? 0.0
        rateCount = try values.decodeIfPresent(Int.self, forKey: .rateCount) ?? 0
        
        rejectedRequest = try values.decodeIfPresent(Int.self, forKey: .rejectedRequest) ?? 0
        serviceType = try values.decodeIfPresent(String.self, forKey: .serviceType) ?? ""
        socialUniqueId = try values.decodeIfPresent(String.self, forKey: .socialUniqueId) ?? ""
        startOnlineTime = try values.decodeIfPresent(String.self, forKey: .startOnlineTime) ?? ""
        token = try values.decodeIfPresent(String.self, forKey: .token) ?? ""
        totalRequest = try values.decodeIfPresent(Int.self, forKey: .totalRequest) ?? 0
        uniqueId = try values.decodeIfPresent(Int.self, forKey: .uniqueId) ?? 0
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt) ?? ""
        vehicleDetail = try values.decodeIfPresent([VehicleDetail].self, forKey: .vehicleDetail) ?? []
        
        wallet = try values.decodeIfPresent(Double.self, forKey: .wallet) ?? 0.0
        walletCurrencyCode = try values.decodeIfPresent(String.self, forKey: .walletCurrencyCode) ?? ""
        zipcode = try values.decodeIfPresent(String.self, forKey: .zipcode) ?? ""
        zoneQueueNo = try values.decodeIfPresent(Int.self, forKey: .zoneQueueNo) ?? 0
        if let value = try? values.decodeIfPresent(String.self, forKey: .alpha2) {
            alpha2 = value //must fill value only if not nil and not empty //Don't override value if nil or empty
        }
        zone_queue_id = try values.decodeIfPresent(String.self, forKey: .zone_queue_id) ?? ""
        zone_queue_number  = String(try values.decodeIfPresent(Int.self, forKey: .zone_queue_number) ?? 0)
        zone_name = try values.decodeIfPresent(String.self, forKey: .zone_name) ?? ""
    }
    
    init() {}
}
