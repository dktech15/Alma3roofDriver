//
//	SettingResponse.swift
//
//	Create by MacPro3 on 7/9/2018
//	Copyright © 2018. All rights reserved.


import Foundation

struct Setting : Codable {
    
    let adminPhone : String?
    let contactUsEmail : String?
    let iosProviderAppForceUpdate : Bool?
    let iosProviderAppGoogleKey : String?
    var ios_places_autocomplete_key : String!
    let iosProviderAppVersionCode : String?
    let isTip : Bool?
    let isToll : Bool?
    let providerEmailVerification : Bool?
    let scheduledRequestPreStartMinute : Int?
    let stripePublishableKey : String?
    let isTwilioCallMasking : Bool!
    let providerSms : Bool!
    let providerPath : Bool!
    let isProviderInitiateTrip: Bool!
    let imageBaseUrl: String!
    let isShowEstimationInProviderApp: Bool!
    var termsCondition : String!
    var privacyPolicyUrl : String!
    var is_provider_social_login = false
    var is_allow_biomatric_verification: Bool!
    var isDriverGoHome : Bool!
    var isDriverGoHomeChangeAddress : Bool!
    
    var minimum_phone_number_length: Int = 7
    var maximum_phone_number_length: Int = 12
    
    var paypal_client_id = ""
    var paypal_environment = ""
    var android_provider_app_gcm_key : String!
    var is_provider_login_using_otp = false
    var is_show_user_details_in_provider_app = false

    enum CodingKeys: String, CodingKey {
        case adminPhone = "admin_phone"
        case contactUsEmail = "contactUsEmail"
        case iosProviderAppForceUpdate = "ios_provider_app_force_update"
        case iosProviderAppGoogleKey = "ios_provider_app_google_key"
        case ios_places_autocomplete_key = "ios_places_autocomplete_key"
        case iosProviderAppVersionCode = "ios_provider_app_version_code"
        case isProviderInitiateTrip = "is_provider_initiate_trip"
        case isTip = "is_tip"
        case isToll = "is_toll"
        case providerEmailVerification = "providerEmailVerification"
        case scheduledRequestPreStartMinute = "scheduled_request_pre_start_minute"
        case stripePublishableKey = "stripe_publishable_key"
        case isTwilioCallMasking = "twilio_call_masking"
        case providerSms = "providerSms"
        case providerPath = "providerPath"
        case imageBaseUrl = "image_base_url"
        case isShowEstimationInProviderApp = "is_show_estimation_in_provider_app"
        case termsCondition = "terms_and_condition_url"
        case privacyPolicyUrl = "privacy_policy_url"
        case minimum_phone_number_length = "minimum_phone_number_length"
        case maximum_phone_number_length = "maximum_phone_number_length"
        case is_provider_social_login = "is_provider_social_login"
        case isDriverGoHome = "is_driver_go_home"
        case is_allow_biomatric_verification = "is_allow_biometric_verification_for_driver"
        case isDriverGoHomeChangeAddress = "is_driver_go_home_change_address"
        case paypal_client_id = "paypal_client_id"
        case paypal_environment = "paypal_environment"
        case is_provider_login_using_otp = "is_provider_login_using_otp"
        case is_show_user_details_in_provider_app = "is_show_user_details_in_provider_app"
        case android_provider_app_gcm_key = "android_provider_app_gcm_key"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        adminPhone = try values.decodeIfPresent(String.self, forKey: .adminPhone) ?? ""
        contactUsEmail = try values.decodeIfPresent(String.self, forKey: .contactUsEmail)  ?? ""
        iosProviderAppForceUpdate = try values.decodeIfPresent(Bool.self, forKey: .iosProviderAppForceUpdate) ?? false
        iosProviderAppGoogleKey = try values.decodeIfPresent(String.self, forKey: .iosProviderAppGoogleKey) ?? ""
        ios_places_autocomplete_key = try values.decodeIfPresent(String.self, forKey: .ios_places_autocomplete_key) ?? ""
        iosProviderAppVersionCode = try values.decodeIfPresent(String.self, forKey: .iosProviderAppVersionCode) ?? ""
        isTip = try values.decodeIfPresent(Bool.self, forKey: .isTip) ?? false
        isToll = try values.decodeIfPresent(Bool.self, forKey: .isToll) ?? false
        providerEmailVerification = try values.decodeIfPresent(Bool.self, forKey: .providerEmailVerification) ?? false
        scheduledRequestPreStartMinute = try values.decodeIfPresent(Int.self, forKey: .scheduledRequestPreStartMinute) ?? 0
        stripePublishableKey = try values.decodeIfPresent(String.self, forKey: .stripePublishableKey) ?? ""
        isTwilioCallMasking = try values.decodeIfPresent(Bool.self, forKey: .isTwilioCallMasking) ?? false
        providerSms = try values.decodeIfPresent(Bool.self, forKey: .providerSms) ?? false
        providerPath = try values.decodeIfPresent(Bool.self, forKey: .providerPath) ?? false
        isProviderInitiateTrip = try values.decodeIfPresent(Bool.self, forKey: .isProviderInitiateTrip) ?? false
         isShowEstimationInProviderApp = try values.decodeIfPresent(Bool.self, forKey: .isShowEstimationInProviderApp) ?? false
        imageBaseUrl = try values.decodeIfPresent(String.self, forKey: .imageBaseUrl) ?? ""
        termsCondition = try values.decodeIfPresent(String.self, forKey: .termsCondition) ?? ""
        privacyPolicyUrl = try values.decodeIfPresent(String.self, forKey: .privacyPolicyUrl) ?? ""
        android_provider_app_gcm_key = try values.decodeIfPresent(String.self, forKey: .android_provider_app_gcm_key) ?? ""
        
        let lhs = Utility.currentAppVersion()
        let rhs = Utility.getLatestVersion()
        if lhs.compare(rhs, options: .numeric) == .orderedDescending {
            is_provider_social_login = false
        } else {
            is_provider_social_login = try values.decodeIfPresent(Bool.self, forKey: .is_provider_social_login) ?? false
        }
        
        minimum_phone_number_length = try values.decodeIfPresent(Int.self, forKey: .minimum_phone_number_length) ?? 7
        maximum_phone_number_length = try values.decodeIfPresent(Int.self, forKey: .maximum_phone_number_length) ?? 12
        isDriverGoHome = try values.decodeIfPresent(Bool.self, forKey: .isDriverGoHome) ?? false
        is_allow_biomatric_verification = try values.decodeIfPresent(Bool.self, forKey: .is_allow_biomatric_verification) ?? false
        isDriverGoHomeChangeAddress = try values.decodeIfPresent(Bool.self, forKey: .isDriverGoHomeChangeAddress) ?? false
        paypal_client_id = try values.decodeIfPresent(String.self, forKey: .paypal_client_id) ?? ""
        paypal_environment = try values.decodeIfPresent(String.self, forKey: .paypal_environment) ?? ""
        is_provider_login_using_otp = try values.decodeIfPresent(Bool.self, forKey: .is_provider_login_using_otp) ?? false
        is_show_user_details_in_provider_app = try values.decodeIfPresent(Bool.self, forKey: .is_show_user_details_in_provider_app) ?? false
    }
}

struct AppSettingResponse : Codable{
    
    var settingDetail : Setting?
    let success : Bool!
    let providerDetail : ProviderDetail?
    //var tripDetail : [TripsRespons] = []
    //var firstTrip : TripsRespons?
    var tripDetail : [String] = []
    var firstTrip : String?
    let nearTripDetail : TripsRespons?
    var isGenderShow: Bool!

    enum CodingKeys: String, CodingKey {
        case settingDetail = "setting_detail"
        case success = "success"
        case providerDetail = "provider_detail"
        case tripDetail = "trip_detail"
        case nearTripDetail = "near_trip_detail"
        case isGenderShow = "isGenderShow"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        settingDetail = try values.decodeIfPresent(Setting.self, forKey: .settingDetail)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        isGenderShow = try values.decodeIfPresent(Bool.self, forKey: .isGenderShow)
        providerDetail = try values.decodeIfPresent(ProviderDetail?.self, forKey: .providerDetail) as? ProviderDetail
        tripDetail = try values.decodeIfPresent([String].self, forKey: .tripDetail) ?? []
        if let value = try? values.decodeIfPresent([String].self, forKey: .tripDetail) {
            if value.count > 0 {
                if let first = tripDetail.first {
                    firstTrip = first
                }
            }
        }
        
        nearTripDetail = (try values.decodeIfPresent(TripsRespons?.self, forKey: .nearTripDetail)) as? TripsRespons
    }
}
