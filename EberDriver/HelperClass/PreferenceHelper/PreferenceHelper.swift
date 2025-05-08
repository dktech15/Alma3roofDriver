//
//  PreferenceHelper.swift
//  tableViewDemo
//
//  Created by Elluminati on 12/01/17.
//  Copyright © 2017 tag. All rights reserved.
//

import UIKit

class PreferenceHelper: NSObject {
    
    // MARK: Setting Preference Keys
    private let KEY_GOOGLE_KEY = "google_key";
    private let KEY_GOOGLE_PLACES_AUTOCOMPLETE_KEY = "google_autocomplete_key";
    private let KEY_STRIPE_KEY = "stripe_key";
    private let KEY_APPLE_USER_NAME = "apple_user_name"
    private let KEY_APPLE_EMAIL = "apple_email"
    private let KEY_CONTACT_EMAIL = "contact_email"
    private let KEY_CONTACT_NUMBER = "contact_number"
    private let KEY_LANGUAGE = "language"
    private let KEY_TERMS_AND_CONDITION = "terms_and_condition"
    private let KEY_PRIVACY_AND_POLICY = "privacy_and_policy"
    private let KEY_IS_EMAIL_VERIFICATION = "email_verification"
    private let KEY_IS_PHONE_NUMBER_VERIFICATION = "phone_number_verification"
    private let KEY_IS_REQUIRED_FORCE_UPDATE = "is_force_update_required"
    private let KEY_IS_PATH_DRAW = "is_path_draw"
    private let KEY_PRE_TRIP_TIME = "pre_trip_time"
    private let KEY_LATEST_VERSION = "latest_version"
    // MARK: User Preference Keys
    private let KEY_IS_PICKUP_ALERT_SOUND_ON = "is_pickup_alert_sound_on"
    private let KEY_IS_REQUEST_ALERT_SOUND = "is_request_alert_sound_on";
    private let KEY_IS_ADMIN_DOCUMENT_MANDATORY = "is_admin_document_mandatory";
    // MARK: User Preference Keys
    private let KEY_USER_ID = "user_id"
    private let KEY_SESSION_TOKEN = "session_token"
    private let KEY_DEVICE_TOKEN = "device_token";
    private let KEY_HEAT_MAP_ON = "heat_map_on"
    private let KEY_GOING_HOME_ON = "going_home_on"
    private let KEY_GO_HOME_ON = "go_home_on"
    private let KEY_GOING_HOME_ADDRESS_ON = "going_home_address_on"
    private let KEY_CHAT_NAME = "chat_name"
    private let KEY_TWILLIO_ENABLE = "twillio_enable"
    private let KEY_IS_PROVIDER_INITIATE_TRIP = "is_provider_initiate_trip"
    private let KEY_IS_PROVIDER_SHOW_ETA = "is_provider_show_eta"
    private let KEY_LANGUAGE_CODE = "language_code"
    private let KEY_FIREBASE_ACCESS_TOKEN = "firebase_access_token"
    private let KEY_IMAGE_BASE_URL = "imageBaseURL"
    static let KEY_CURRENT_APP_MODE = "current_app_mode"
    private let IS_USER_SOCIAL_LOGIN = "is_user_social_login"
    private let KEY_MIN_MOBILE_LENGTH = "minimum_phone_number_length"
    private let KEY_MAX_MOBILE_LENGTH = "maximum_phone_number_length"
    private let IS_FAKE_GPS_ON = "getIsFakeGpsOn"
    private let CUSTOM_LOCATION = "custom_location"
    private let paypal_client_id = "paypal_client_id"
    private let paypal_environment = "paypal_environment"
    private let KEY_MINIMUM_REDEEM_POINTS = "minimum_redeem_points"
    private let KEY_TOTAL_REDEEM_POINTS = "total_redeem_points"
    private let KEY_REDEEM_POINTS_VALUES = "redeem_points_values"
    private let KEY_WALLET_CURRNCY_CODE = "wallet_currency_code"
    private let KEY_LOGIN_OTP = "is_provider_login_using_otp"
    private let KEY_SET_SEND_MONEY = "isSendMoney"
    private let is_show_user_details_in_provider_app = "is_show_user_details_in_provider_app"
    private let KEY_BIOMATRIC_VERIFICATION = "is_allow_biometric_verification_for_driver"
    private let KEY_BIOMATRIC_VERIFICATION_SETTING = "is_provider_using_biomatric_verification"
    private let KEY_FIREBASE = "android_user_app_gcm_key"
    private let COUNTRY_PHONE_CODE = "countryPhoneCode"
    private let DRIVER_REDEEM_POINT = "driverRedeemPointValue"
    private let IS_GENDER_SHOW = "GenderShow"
    let ph = UserDefaults.standard;
    static let preferenceHelper = PreferenceHelper()
    private override init(){}
    
    // MARK: Getter Setters
    func getLanguageCode() -> String {
        return (ph.value(forKey: KEY_LANGUAGE_CODE) as? String) ?? "en"
    }
    func setLanguageCode(code: String) {
        ph.set(code, forKey: KEY_LANGUAGE_CODE);
        ph.synchronize();
    }
    func setIsShowEta(_ isOn: Bool) {
        ph.set(isOn, forKey: KEY_IS_PROVIDER_SHOW_ETA);
        ph.synchronize();
    }

    func getIsShowEta() -> Bool {
        return (ph.value(forKey: KEY_IS_PROVIDER_SHOW_ETA) as? Bool) ?? true
    }

    func setChatName(_ name:String){
        ph.set(name, forKey: KEY_CHAT_NAME);
        ph.synchronize();
    }
    
    func getChatName() -> String{
        return (ph.value(forKey: KEY_CHAT_NAME) as? String) ?? ""
    }
    
    func setIsTwillioEnable(_ isEnable: Bool) {
        ph.set(isEnable, forKey: KEY_TWILLIO_ENABLE);
        ph.synchronize();
    }
    
    func getIsTwillioEnable() -> Bool {
        return (ph.value(forKey: KEY_TWILLIO_ENABLE) as? Bool) ?? false
    }
    
    func setIsGenderShow(_ isEnable: Bool) {
        ph.set(isEnable, forKey: IS_GENDER_SHOW);
        ph.synchronize();
    }
    
    func getIsGenderShow() -> Bool {
        return (ph.value(forKey: IS_GENDER_SHOW) as? Bool) ?? false
    }
    
    
    func setIsHeatMapOn(_ isHeatMap: Bool) {
        ph.set(isHeatMap, forKey: KEY_HEAT_MAP_ON);
        ph.synchronize();
    }
    
    func getIsHeatMapOn() -> Bool {
        return (ph.value(forKey: KEY_HEAT_MAP_ON) as? Bool) ?? true
    }
    
    func setGoingHomeOn(_ isHeatMap: Bool) {
        ph.set(isHeatMap, forKey: KEY_GOING_HOME_ON);
        ph.synchronize();
    }
    
    func getGoingHomeOn() -> Bool {
        return (ph.value(forKey: KEY_GOING_HOME_ON) as? Bool) ?? false
    }
    
    func setGoHomeOn(_ isHeatMap: Bool) {
        ph.set(isHeatMap, forKey: KEY_GO_HOME_ON);
        ph.synchronize();
    }
    
    func getGoHomeOn() -> Bool {
        return (ph.value(forKey: KEY_GO_HOME_ON) as? Bool) ?? true
    }
    
    func setGoingHomeAddressOn(_ isHeatMap: Bool) {
        ph.set(isHeatMap, forKey: KEY_GOING_HOME_ADDRESS_ON);
        ph.synchronize();
    }
    
    func getGoingHomeAddressOn() -> Bool {
        return (ph.value(forKey: KEY_GOING_HOME_ADDRESS_ON) as? Bool) ?? false
    }
    
    func setContactEmail(_ email:String){
        ph.set(email, forKey: KEY_CONTACT_EMAIL);
        ph.synchronize();
    }
    
    func getContactEmail() -> String{
        return (ph.value(forKey: KEY_CONTACT_EMAIL) as? String) ?? ""
    }
    
    func setContactNumber(_ contact:String) {
        ph.set(contact, forKey: KEY_CONTACT_NUMBER);
        ph.synchronize();
    }
    
    func getContactNumber() -> String {
        return (ph.value(forKey: KEY_CONTACT_NUMBER) as? String) ?? ""
    }
    
    func setTermsAndCondition(_ url:String) {
        ph.set(url, forKey: KEY_TERMS_AND_CONDITION);
        ph.synchronize();
    }
    
    func getTermsAndCondition() -> String {
        return (ph.value(forKey: KEY_TERMS_AND_CONDITION) as? String) ?? ""
    }
    
    func setPrivacyPolicy(_ url:String) {
        ph.set(url, forKey: KEY_PRIVACY_AND_POLICY);
        ph.synchronize();
    }
    
    func getPrivacyPolicy() -> String {
        return (ph.value(forKey: KEY_PRIVACY_AND_POLICY) as? String) ?? ""
    }
    
    func setIsEmailVerification(_ isEmailVerification: Bool) {
        ph.set(isEmailVerification, forKey: KEY_IS_EMAIL_VERIFICATION);
        ph.synchronize();
    }
    
    func getIsEmailVerification() -> Bool {
        return (ph.value(forKey: KEY_IS_EMAIL_VERIFICATION) as? Bool) ?? false
    }
    
    func setIsPhoneNumberVerification(_ isPhoneNumberVerification: Bool) {
        ph.set(isPhoneNumberVerification, forKey: KEY_IS_PHONE_NUMBER_VERIFICATION);
        ph.synchronize();
    }
    
    func getIsPhoneNumberVerification() -> Bool {
        return (ph.value(forKey: KEY_IS_PHONE_NUMBER_VERIFICATION) as? Bool) ?? false
    }
    
    func setIsRequiredForceUpdate(_ fUpdate: Bool) {
        ph.set(fUpdate, forKey: KEY_IS_REQUIRED_FORCE_UPDATE);
        ph.synchronize();
    }
    
    func getIsRequiredForceUpdate() -> Bool {
        return (ph.value(forKey: KEY_IS_REQUIRED_FORCE_UPDATE) as? Bool) ?? false
    }
    
    func setGoogleKey(_ googleKey:String) {
        ph.set(googleKey, forKey: KEY_GOOGLE_KEY);
        ph.synchronize();
    }
    
    func getGoogleKey() -> String {
        return (ph.value(forKey: KEY_GOOGLE_KEY) as? String) ?? ""
    }
    
    func setStripeKey(_ stripeKey:String) {
        ph.set(stripeKey, forKey: KEY_STRIPE_KEY);
        ph.synchronize();
    }
    
    func getStripeKey() -> String {
        return (ph.value(forKey: KEY_STRIPE_KEY) as? String) ?? ""
    }
    
    func setIsProviderInitiateTrip(_ isOn: Bool) {
        ph.set(isOn, forKey: KEY_IS_PROVIDER_INITIATE_TRIP);
        ph.synchronize();
    }
    
    func getIsProviderInitiateTrip() -> Bool {
        return (ph.value(forKey: KEY_IS_PROVIDER_INITIATE_TRIP) as? Bool) ?? true
    }
    
    func setIsPathdraw(_ isPathDraw: Bool) {
        ph.set(isPathDraw, forKey: KEY_IS_PATH_DRAW);
        ph.synchronize();
    }
    
    func getIsPathdraw() -> Bool {
        return (ph.value(forKey: KEY_IS_PATH_DRAW) as? Bool) ?? false
    }
    
    func setIsRequsetAlertSoundOn(_ isOn: Bool) {
        ph.set(isOn, forKey: KEY_IS_REQUEST_ALERT_SOUND);
        ph.synchronize();
    }
    
    func getIsRequsetAlertSoundOn() -> Bool {
        return (ph.value(forKey: KEY_IS_REQUEST_ALERT_SOUND) as? Bool) ?? true
    }
    
    func setIsPickupAlertSoundOn(_ isOn: Bool) {
        ph.set(isOn, forKey: KEY_IS_PICKUP_ALERT_SOUND_ON);
        ph.synchronize();
    }
    
    func getIsPickupAlertSoundOn() -> Bool {
        return (ph.value(forKey: KEY_IS_PICKUP_ALERT_SOUND_ON) as? Bool) ?? true
    }
    
    func setPreSchedualTripTime(_ timeInMin:Int) {
        ph.set(timeInMin, forKey: KEY_PRE_TRIP_TIME);
        ph.synchronize();
    }
    
    func getPreSchedualTripTime() -> Int {
        return (ph.value(forKey: KEY_PRE_TRIP_TIME) as? Int) ?? 0
    }
    
    func setLatestVersion(_ version:String) {
        ph.set(version, forKey: KEY_LATEST_VERSION);
        ph.synchronize();
    }
    
    func getLatestVersion() -> String {
        return (ph.value(forKey: KEY_LATEST_VERSION) as? String) ?? ""
    }
    
    // MARK: Preference User Getter Setters
    func setDeviceToken(_ token:String) {
        ph.set(token, forKey: KEY_DEVICE_TOKEN);
        ph.synchronize();
    }
    
    func setLanguage(_ index:Int) {
        ph.set(index, forKey: KEY_LANGUAGE);
        ph.synchronize();
    }
    
    func getLanguage() -> (Int) {
        return (ph.value(forKey: KEY_LANGUAGE) as? Int) ?? 1
    }
    
    func getDeviceToken() -> String {
        return (ph.value(forKey: KEY_DEVICE_TOKEN) as? String) ?? ""
    }
    
    func setUserId(_ userId:String) {
        ph.set(userId, forKey: KEY_USER_ID);
        ph.synchronize();
    }
    
    func getUserId() -> String {
        return (ph.value(forKey: KEY_USER_ID) as? String) ?? ""
    }
    
    func setSessionToken(_ sessionToken:String) {
        ph.set(sessionToken, forKey: KEY_SESSION_TOKEN);
        ph.synchronize();
    }
    
    func getSessionToken() -> String {
        return (ph.value(forKey: KEY_SESSION_TOKEN) as? String) ?? ""
    }
    
    func clearAll() {
        ph.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        ph.synchronize();
    }

    func setGooglePlacesAutocompleteKey(_ googleKey:String)
    {
        ph.set(googleKey, forKey: KEY_GOOGLE_PLACES_AUTOCOMPLETE_KEY);
        ph.synchronize();
    }
    func getGooglePlacesAutocompleteKey() -> String
    {
        return (ph.value(forKey: KEY_GOOGLE_PLACES_AUTOCOMPLETE_KEY) as? String) ?? ""
    }
    func setSigninWithAppleUserName(_ username:String) {
        ph.set(username, forKey: KEY_APPLE_USER_NAME)
        ph.synchronize()
    }
    
    func getSigninWithAppleUserName() -> String {
        return (ph.value(forKey: KEY_APPLE_USER_NAME) as? String) ?? ""
    }
    
    func setSigninWithAppleEmail(_ email:String) {
        ph.set(email, forKey: KEY_APPLE_EMAIL)
        ph.synchronize()
    }
    
    func getSigninWithAppleEmail() -> String {
        return (ph.value(forKey: KEY_APPLE_EMAIL) as? String) ?? ""
    }
    
    func getCurrentAppMode() -> Int {
        return (ph.value(forKey: PreferenceHelper.KEY_CURRENT_APP_MODE) as? Int) ?? 0
    }
    
    func setCurrentAppMode(_ length:Int) {
        ph.set(length, forKey: PreferenceHelper.KEY_CURRENT_APP_MODE);
        ph.synchronize();
    }
    
    func setImageBaseUrl(_ str:String)
    {
        ph.set(str, forKey: KEY_IMAGE_BASE_URL);
        ph.synchronize();
    }
    
    func getImageBaseUrl() -> String?
    {
        return (ph.value(forKey: KEY_IMAGE_BASE_URL) as? String)
    }
    
    func removeImageBaseUrl() {
        ph.removeObject(forKey: KEY_IMAGE_BASE_URL)
        ph.synchronize()
    }
    
    func setAuthToken(_ token:String) {
        ph.set(token, forKey: KEY_FIREBASE_ACCESS_TOKEN)
        ph.synchronize()
    }
    func getAuthToken() -> String {
        return (ph.value(forKey: KEY_FIREBASE_ACCESS_TOKEN) as? String) ?? ""
    }
    
    func setMinMobileLength(_ int:Int) {
        ph.set(int, forKey: KEY_MIN_MOBILE_LENGTH)
        ph.synchronize()
    }
    
    func getMinMobileLength() -> Int {
        return (ph.value(forKey: KEY_MIN_MOBILE_LENGTH) as? Int) ?? 7
    }
    
    func setMaxMobileLength(_ int:Int) {
        ph.set(int, forKey: KEY_MAX_MOBILE_LENGTH)
        ph.synchronize()
    }
    
    func getMaxMobileLength() -> Int {
        return (ph.value(forKey: KEY_MAX_MOBILE_LENGTH) as? Int) ?? 12
    }
    
    func getIsUseSocialLogin() -> Bool
    {
        return (ph.value(forKey: IS_USER_SOCIAL_LOGIN) as? Bool) ?? false
    }

    func setIsUseSocialLogin(_ bool:Bool)
    {
        ph.set(bool, forKey: IS_USER_SOCIAL_LOGIN);
        ph.synchronize();
    }
    
    func getIsFakeGpsOn() -> Bool
    {
        return (ph.value(forKey: IS_FAKE_GPS_ON) as? Bool) ?? false
    }

    func setIsFakeGpsOn(_ bool:Bool)
    {
        ph.set(bool, forKey: IS_FAKE_GPS_ON);
        ph.synchronize();
    }
    
    func setCustomLocation(_ arr:[Double]) {
        ph.set(arr, forKey: CUSTOM_LOCATION);
        ph.synchronize();
    }
    
    func getCustomLocation() -> [Double] {
        return ph.value(forKey: CUSTOM_LOCATION) as? [Double] ?? []
    }
    
    func setPaypalClientId(_ id:String)
    {
        ph.set(id, forKey: paypal_client_id);
        ph.synchronize();
    }
    
    func getPaypalClientId() -> String
    {
        return (ph.value(forKey: paypal_client_id) as? String) ?? ""
    }
    
    func setPaypalEnvironment(_ string:String)
    {
        ph.set(string, forKey: paypal_environment);
        ph.synchronize();
    }
    
    func getPaypalEnvironment() -> String
    {
        return (ph.value(forKey: paypal_environment) as? String) ?? ""
    }
    func setMinimumRedeemPoints(_ string:Int)
    {
        ph.set(string, forKey: KEY_MINIMUM_REDEEM_POINTS);
        ph.synchronize();
    }
    
    func getMinimumRedeemPoints() -> Int
    {
        return (ph.value(forKey: KEY_MINIMUM_REDEEM_POINTS) as? Int) ?? 0
    }
    func setTotalRedeemPoints(_ string:Double)
    {
        ph.set(string, forKey: KEY_TOTAL_REDEEM_POINTS);
        ph.synchronize();
    }
    func getTotalRedeemPoints() -> Double
    {
        return (ph.value(forKey: KEY_TOTAL_REDEEM_POINTS) as? Double) ?? 0.0
    }
    func setRedeemPointsValue(_ string:Double)
    {
        ph.set(string, forKey: KEY_REDEEM_POINTS_VALUES);
        ph.synchronize();
    }
    func getRedeemPointsValue() -> Double
    {
        return (ph.value(forKey: KEY_REDEEM_POINTS_VALUES) as? Double) ?? 0.0
    }
    
    func setWalletCurrencyCode(_ string:String)
    {
        ph.set(string, forKey: KEY_WALLET_CURRNCY_CODE);
        ph.synchronize();
    }
    func getWalletCurrencyCode() -> String
    {
        return (ph.value(forKey: KEY_WALLET_CURRNCY_CODE) as? String) ?? ""
    }
    
    func setIsSendMoney(_ bool:Bool)
    {
        ph.set(bool, forKey: KEY_SET_SEND_MONEY);
        ph.synchronize();
    }
    func getIsSendMoney() -> Bool
    {
        return (ph.value(forKey: KEY_SET_SEND_MONEY) as? Bool) ?? false
    }
    
    func setDriverRedeemPointValue(_ string:Double)
    {
        ph.set(string, forKey: DRIVER_REDEEM_POINT);
        ph.synchronize();
    }
    func getDriverRedeemPointValue() -> Double
    {
        return (ph.value(forKey: DRIVER_REDEEM_POINT) as? Double) ?? 0.0
    }
    
    func setIsLoginWithOTP(_ bool:Bool)
    {
        ph.set(bool, forKey: KEY_LOGIN_OTP);
        ph.synchronize();
    }
    func getIsLoginWithOTP() -> Bool
    {
        return (ph.value(forKey: KEY_LOGIN_OTP) as? Bool) ?? false
    }
    
    func setIsShowUserDetailInTrip(_ bool:Bool)
    {
        ph.set(bool, forKey: is_show_user_details_in_provider_app);
        ph.synchronize();
    }
    func getIsShowUserDetailInTrip() -> Bool
    {
        return (ph.value(forKey: is_show_user_details_in_provider_app) as? Bool) ?? false
    }
    
    func setAllowBiomatricVerification(_ bool:Bool)
    {
        ph.set(bool, forKey: KEY_BIOMATRIC_VERIFICATION);
        ph.synchronize();
    }
    func getAllowBiomatricVerification() -> Bool
    {
        return (ph.value(forKey: KEY_BIOMATRIC_VERIFICATION) as? Bool) ?? false
    }
    
    func setBiomatricVerification(_ bool:Bool)
    {
        ph.set(bool, forKey: KEY_BIOMATRIC_VERIFICATION_SETTING);
        ph.synchronize();
    }
    func getBiomatricVerification() -> Bool
    {
        return (ph.value(forKey: KEY_BIOMATRIC_VERIFICATION_SETTING) as? Bool) ?? false
    }
    func setFireBaseKey(_ string:String)
    {
        ph.set(string, forKey: KEY_FIREBASE);
        ph.synchronize();
    }
    func getFireBaseKey() -> String
    {
        return (ph.value(forKey: KEY_FIREBASE) as? String) ?? ""
    }
    
    func setCountryCode(_ string:String)
    {
        ph.set(string, forKey: COUNTRY_PHONE_CODE);
        ph.synchronize();
    }
    func getCountryCode() -> String
    {
        return (ph.value(forKey: COUNTRY_PHONE_CODE) as? String) ?? ""
    }
}
