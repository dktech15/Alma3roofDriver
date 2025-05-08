//
//	ProviderDetail.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct ProviderDetail : Codable {
    
    var accountId : String = ""
    var address : String = ""
    var admintypeid : String = ""
    var bankId : String = ""
    var city : String = ""
    var country : String = ""
    var countryPhoneCode : String = ""
    var email : String = ""
    var firstName : String = ""
    var isActive : Int  = 0
    var isApproved : Int  = 0
    var isAvailable : Int  = 0
    var isDocumentUploaded : Int  = 0
    var isSendMoney: Bool = false
    var isDocumentsExpired : Bool  = false
    var isPartnerApprovedByAdmin : Int  = 0
    var isVehicleDocumentUploaded : Bool  = false
    var lastName : String = ""
    var loginBy : String = ""
    var phone : String = ""
    var providerId : String = ""
    var rate : Double  = 0.0
    var rateCount : Int  = 0
    var serviceType : String = ""
    var socialUniqueId : String = ""
    var token : String = ""
    var picture : String = ""
    var languages : [String] = []
    var providerType : Int = 0
    var walletCurrencyCode : String = ""
    var referralCode: String = ""
    var isReferral: Int = 0
    var countryDetail: CountryDetail!
    var addressLocation : [Double] = []
    var isGoHome: Int = 0
    var alpha2: String = ""
    var driverRedeemPointValue: Double = 0
    var driverMinimumPointRequireForWithdrawal: Int = 0
    var totalRedeemPoint: Double = 0
   var android_provider_app_gcm_key = ""
    var gender_type : Int!
    
    enum CodingKeys: String, CodingKey {
        case gender_type = "gender_type"
        case accountId = "account_id"
        case address = "address"
        case admintypeid = "admintypeid"
        case bankId = "bank_id"
        case city = "city"
        case country = "country"
        case countryPhoneCode = "country_phone_code"
        case email = "email"
        case firstName = "first_name"
        case isActive = "is_active"
        case isApproved = "is_approved"
        case isAvailable = "is_available"
        case isDocumentUploaded = "is_document_uploaded"
        case isSendMoney = "is_send_money_for_provider"
        case isDocumentsExpired = "is_documents_expired"
        case isPartnerApprovedByAdmin = "is_partner_approved_by_admin"
        case isVehicleDocumentUploaded = "is_vehicle_document_uploaded"
        case lastName = "last_name"
        case loginBy = "login_by"
        case phone = "phone"
        case providerId = "_id"
        case rate = "rate"
        case rateCount = "rate_count"
        case serviceType = "service_type"
        case socialUniqueId = "social_unique_id"
        case token = "token"
        case picture = "picture"
        case walletCurrencyCode = "wallet_currency_code"
        case referralCode = "referral_code"
        case isReferral = "is_referral"
        case countryDetail = "country_detail"
        case addressLocation = "address_location"
        case isGoHome = "is_go_home"
        case alpha2 = "alpha2"
        case driverRedeemPointValue = "driver_redeem_point_value"
        case driverMinimumPointRequireForWithdrawal = "driver_minimum_point_require_for_withdrawal"
        case totalRedeemPoint = "total_redeem_point"
    }
    
    init(from decoder: Decoder) throws {
        let  values = try decoder.container(keyedBy: CodingKeys.self)
        accountId = try values.decodeIfPresent(String.self, forKey: .accountId) ?? ""
        address = try values.decodeIfPresent(String.self, forKey: .address) ?? ""
        referralCode = try values.decodeIfPresent(String.self, forKey: .referralCode) ?? ""
        countryDetail = try values.decodeIfPresent(CountryDetail.self, forKey: .countryDetail) ?? CountryDetail.init()
        isReferral = try values.decodeIfPresent(Int.self, forKey: .isReferral) ?? 0
        admintypeid = try values.decodeIfPresent(String.self, forKey: .admintypeid) ?? ""
        bankId = try values.decodeIfPresent(String.self, forKey: .bankId) ?? ""
        city = try values.decodeIfPresent(String.self, forKey: .city) ?? ""
        country = try values.decodeIfPresent(String.self, forKey: .country) ?? ""
        countryPhoneCode = try values.decodeIfPresent(String.self, forKey: .countryPhoneCode) ?? ""
        email = try values.decodeIfPresent(String.self, forKey: .email) ?? ""
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName) ?? ""
        isActive = try values.decodeIfPresent(Int.self, forKey: .isActive) ?? 0
        isApproved = try values.decodeIfPresent(Int.self, forKey: .isApproved) ?? 0
        gender_type = try values.decodeIfPresent(Int.self, forKey: .gender_type) ?? 0
        
        isAvailable = try values.decodeIfPresent(Int.self, forKey: .isAvailable) ?? 0
        isDocumentUploaded = try values.decodeIfPresent(Int.self, forKey: .isDocumentUploaded) ?? 0
        isSendMoney = try values.decodeIfPresent(Bool.self, forKey: .isSendMoney) ?? false
        isDocumentsExpired = try values.decodeIfPresent(Bool.self, forKey: .isDocumentsExpired) ?? false
        isPartnerApprovedByAdmin = try values.decodeIfPresent(Int.self, forKey: .isPartnerApprovedByAdmin) ?? 0
        isVehicleDocumentUploaded = try values.decodeIfPresent(Bool.self, forKey: .isVehicleDocumentUploaded) ?? false
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName) ?? ""
        loginBy = try values.decodeIfPresent(String.self, forKey: .loginBy) ?? ""
        phone = try values.decodeIfPresent(String.self, forKey: .phone) ?? ""
        providerId = try values.decodeIfPresent(String.self, forKey: .providerId) ?? ""
        rate = try values.decodeIfPresent(Double.self, forKey: .rate) ?? 0.0
        rateCount = try values.decodeIfPresent(Int.self, forKey: .rateCount) ?? 0
        serviceType = try values.decodeIfPresent(String.self, forKey: .serviceType) ?? ""
        socialUniqueId = try values.decodeIfPresent(String.self, forKey: .socialUniqueId) ?? ""
        token = try values.decodeIfPresent(String.self, forKey: .token) ?? ""
        picture = try values.decodeIfPresent(String.self, forKey: .picture) ?? ""
        walletCurrencyCode = try values.decodeIfPresent(String.self, forKey: .walletCurrencyCode) ?? "INR"
        addressLocation = try values.decodeIfPresent([Double].self, forKey: .addressLocation) ?? [0.0, 0.0]
        isGoHome = try values.decodeIfPresent(Int.self, forKey: .isGoHome) ?? 0
        
        if let value = try? values.decodeIfPresent(String.self, forKey: .alpha2), !value.isEmpty { //must fill value only if not nil and not empty //Don't override value if nil or empty
            alpha2 = value
        }
        
        totalRedeemPoint = try values.decodeIfPresent(Double.self, forKey: .totalRedeemPoint) ?? 0.0
        driverRedeemPointValue = try values.decodeIfPresent(Double.self, forKey: .driverRedeemPointValue) ?? 0.0
        driverMinimumPointRequireForWithdrawal = try values.decodeIfPresent(Int.self, forKey: .driverMinimumPointRequireForWithdrawal) ?? 0
        
    }
    
    init() {
        accountId = ""
        picture = ""
        address = ""
        admintypeid = ""
        bankId = ""
        city = ""
        country = ""
        countryPhoneCode = ""
        email = ""
        firstName = ""
        isActive = FALSE
        isApproved = FALSE
        isAvailable = FALSE
        isDocumentUploaded = FALSE
        isSendMoney = false
        isDocumentsExpired = false
        isPartnerApprovedByAdmin = FALSE
        isVehicleDocumentUploaded = false
        lastName = ""
        loginBy = ""
        phone = ""
        providerId = ""
        rate = 0.0
        rateCount = 0
        serviceType = ""
        socialUniqueId = ""
        token = ""
        countryDetail = CountryDetail.init()
        driverRedeemPointValue = 0
        driverMinimumPointRequireForWithdrawal = 0
        gender_type = 0
    }
    
    mutating func fillProviderWith(provider:Provider) {
        accountId = provider.accountId
        picture = provider.picture
        address = provider.address
        admintypeid = provider.admintypeid
        bankId = provider.bankId
        city = provider.city
        country = provider.country
        countryPhoneCode = provider.countryPhoneCode
        email = provider.email
        firstName = provider.firstName
        isActive = provider.isActive
        isApproved = provider.isApproved
        isAvailable = provider.isAvailable
        isDocumentUploaded = provider.isDocumentUploaded
        isSendMoney = provider.isSendMoney
        isDocumentsExpired = provider.isDocumentsExpired
        isPartnerApprovedByAdmin = provider.isPartnerApprovedByAdmin
        isVehicleDocumentUploaded = provider.isVehicleDocumentUploaded
        lastName = provider.lastName
        loginBy = provider.loginBy
        phone = provider.phone
        providerId = provider.id
        rate = provider.rate
        rateCount = provider.rateCount
        serviceType = provider.serviceType
        socialUniqueId = provider.socialUniqueId
        token = provider.token
        languages = provider.languages
        providerType = provider.providerType
        walletCurrencyCode = provider.walletCurrencyCode
        alpha2 = provider.alpha2
        gender_type = provider.gender_type
    }
}
