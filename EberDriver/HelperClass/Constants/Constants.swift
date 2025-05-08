//
//  AlamofireHelper.swift
//  Store
//
//  Created by Elluminati on 07/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import Foundation
import UIKit

//MARK: - Abbreviation
let APPDELEGATE = UIApplication.shared.delegate as! AppDelegate
let preferenceHelper = PreferenceHelper.preferenceHelper

let passwordMinLength = 6
let passwordMaxLength = 20
let emailMinimumLength = 12
let emailMaximumLength = 64

let arrForLanguages:[(language:String,code:String)] = [(language: "English", code: "en"),(language: "عربى", code: "ar"),(language: "Española", code: "es"),(language: "Française", code: "fr"),(language: "German", code: "de")]

let TRIP_IS_ALREADY_CANCELLED = "408"
let TRIP_IS_ALREADY_ACCEPTED = "449"

let TRUE = 1
let FALSE = 0

let RESEND_CODE_TIME = 15

//Don't change this id in installtion or clone
let bundleId = "com.elluminati.eber.driver"
let applePayMerchantId = "merchant.com.elluminati.eber"

struct DialogTags {
    static let networkDialog:Int = 400
    static let tripBidingDialog:Int = 169
    static let locationPermision = 865
}

enum AppMode: Int {
    case live = 0
    case staging = 1
    case developer = 2
    
    ///App submition time defaultMode must be defaultMode = AppMode.developer
    static let defaultMode = AppMode.live
        
    static var currentMode: AppMode {
        get {
            if UserDefaults.standard.value(forKey: PreferenceHelper.KEY_CURRENT_APP_MODE) == nil {
                print("mode not found")
                return defaultMode
            } else {
                return AppMode(rawValue: preferenceHelper.getCurrentAppMode()) ?? defaultMode
            }
        } set {
            if AppMode.currentMode != newValue {
                print("App switch into new mode")
            }
            print("current mode \(newValue.rawValue)")
            preferenceHelper.setCurrentAppMode(newValue.rawValue)
        }
    }
}

struct WebService
{
    static var Common_URL = "https://api.alma3roof.ly/"
    static var BASE_URL : String {
        switch AppMode.currentMode {
        case .live:
//            return "https://api.alma3roof.ly/"
            return Common_URL
            //            return "https://apitest.loca.lt/"
        case .developer:
            //return "http://192.168.0.179:5000/"
//            return "https://api.alma3roof.ly/"
            return Common_URL
//            return "https://apitest.loca.lt/"
        case .staging:
//            return "https://api.alma3roof.ly/"
            return Common_URL
//            return "https://quickly-bright-lionfish.ngrok-free.app/"
//            return "https://apitest.loca.lt/"
        }
    }
    
    static var IMAGE_BASE_URL : String {
        if let value = preferenceHelper.getImageBaseUrl() {
            return value
        } else {
            switch AppMode.currentMode {
            case .live:
//                return "https://api.alma3roof.ly/"
                return Common_URL
//                return "https://apitest.loca.lt/"
            case .developer:
//                return "https://api.alma3roof.ly/"
                return Common_URL
                //                return "https://apitest.loca.lt/"
            case .staging:
//                return "https://api.alma3roof.ly/"
//                return "https://quickly-bright-lionfish.ngrok-free.app/"
                return Common_URL
//                return "https://apitest.loca.lt/"
            }
        }
    }
    
    static var HISTORY_BASE_URL : String {
        switch AppMode.currentMode {
        case .live:
            return "https://earning.alma3roof.ly/"
//            return "https://earning.loca.lt/"
        case .developer:
//            return "http://192.168.0.179:5001/"
            return "https://earning.alma3roof.ly/"
//            return "https://earning.loca.lt/"
        case .staging:
            return "https://earning.alma3roof.ly/"
//            return "https://earning.loca.lt/"
        }
    }
    
    static var PAYMENT_BASE_URL : String {
        switch AppMode.currentMode {
        case .live:
            return "https://payment.alma3roof.ly/"
//            return "https://payment.loca.lt/"
        case .developer:
            return "https://payment.alma3roof.ly/" //"http://192.168.0.102:5002/"
            //return "http://192.168.0.179:5002/"
//            return "https://payment.loca.lt/"
        case .staging:
            return "https://payment.alma3roof.ly/"
//            return "https://payment.loca.lt/"
        }
    }

    static let GET_SETTING_DETAIL = "get_provider_setting_detail"
    static let TERMS_CONDITION_URL = "get_provider_terms_and_condition"
    static let PRIVACY_POLICY_URL =  "get_provider_privacy_policy"

    /*Provider Related Web Service*/
    static let UPDATE_DEVICE_TOKEN = "updateproviderdevicetoken"
    static let GET_TYPELIST_SELETED_CITY = "typelist_selectedcountrycity";
    static let PROVIDER_UPDATE_TYPE = "providerupdatetype"
    static let CHECK_USER_REGISTER = "check_user_registered"
    static let GET_FARE_ESTIMATE = "getfareestimate"
    static let REGISTER = "providerregister"
    static let LOGIN = "providerslogin"
    static let LOGOUT = "providerlogout"
    static let TWILIO_CALL = "twilio_voice_call"
    static let GET_PROVIDER_DETAIL = "get_provider_detail"
    static let PROVIDER_TOGGLE_STATE = "togglestate";
    static let UPADTE_PROFILE = "providerupdatedetail";
    static let UPDATE_LOCATION =  "provider_location"
    static let GET_VERIFICATION_OTP = "verification"
    static let GET_OTP = "get_otp";
    static let GET_USER_DETAIL = "getuserdetail"
    static let FORGOT_PASSWORD = "forgotpassword"
    static let GET_COUTRIES = "get_country_city_list"
    static let GET_DOCUMENTS = "getproviderdocument"
    static let UPLOAD_DOCUMENT = "uploaddocument"
    static let UPDATE_PROVIDER_SETTING = "update_provider_setting"
    static let PROVIDER_HEAT_MAP = "provider_heat_map"
    static let PROVIDER_CREATETRIP = "provider_createtrip"
    
    //Web Bank Detail
    static let ADD_BANK_DETAIL = "add_bank_detail";
    static let GET_BANK_DETAIL = "get_bank_detail";
    static let DELETE_BANK_DETAIL = "delete_bank_detail";
    
    static let CANCEL_TRIP = "tripcancelbyprovider";
    static let SUBMIT_INVOICE = "provider_submit_invoice";
    static let CHECK_DESTINATION_ADDRESS = "check_destination"
    static let COMPLETE_TRIP = "completetrip";
    //Mass Notification
    static let MASS_NOTIFICATION = "fetch_mass_notification_for_user"
    //Send money
    static let SEND_MONEY_TO_FRIEND = "send_money_to_friend"
    static let SEARCH_USER_TO_SEND_MONEY = "search_user_to_send_money"
    static let SCHEDULE_TRIP = "get_pending_schedule_trip"
    static let ACCEPT_REJECT_SCHEDULE_TRIP = "accept_reject_dispatcher_schedule_trip"
    /* Trip Web-Service Methods*/
    static let CREATE_TRIP = "createtrip"
    static let CHECK_TRIP_STATUS = "providergettripstatus"
    static let GET_TRIPS = "gettrips"
    static let PAY_PAYMENT = "pay_payment"
    static let SET_TRIP_STATUS = "settripstatus";
    static let SET_TRIP_STOP_STATUS = "settripstopstatus"
    static let RESPOND_TRIP =  "respondstrip"
    
    /*History List Web-Service Methods*/
    static let GET_HISTORY_LIST = "history/providerhistory"
    static let GET_INVOICE = "getproviderinvoice"
    static let GET_HISTORY_DETAIL = "providertripdetail"
    
    
    /*Map Screen Service */
    static let GET_FAVOURITE_ADDRESS_LIST = "get_home_address"
    static let SET_FAVOURITE_ADDRESS_LIST = "set_home_address"
    static let GET_LANGUAGE_LIST = "getlanguages"
    static let GET_GOOGLE_PATH_FROM_SERVER = "getgooglemappath";
    static let SET_GOOGLE_PATH_FROM_SERVER = "setgooglemappath";
    static let SET_DESTINATION_ADDRESS = "usersetdestination";
    
    static let RATE_USER = "providergiverating";
    
    static let CHANGE_WALLET_STATUS = "change_user_wallet_status"
    
    static let WS_GET_WALLET_HISTORY = "earning/get_wallet_history"
    static let ADD_WALLET_AMOUNT = "add_wallet_amount"
    
    //Web Vehicle Service
    static let PROVIDER_ADD_VEHICLE = "provider_add_vehicle"
    static let PROVIDER_UPDATE_VEHICLE = "provider_update_vehicle_detail"
    static let PROVIDER_UPLOAD_VEHICLE_DOCUMENT = "upload_vehicle_document"
    static let PROVIDER_GET_VEHICLE_DOCUMENT = "upload_vehicle_document"
    static let PROVIDER_GET_VEHICLE_DETAIL = "get_provider_vehicle_detail"
    static let GET_VEHICLE_LIST = "get_provider_vehicle_list"
    static let SELECT_VEHICLE = "change_current_vehicle"
    
    static let GET_DAILY_EARNING = "get_provider_daily_earning_detail";
    static let GET_WEEKLY_EARNING = "get_provider_weekly_earning_detail";
    static let APPLY_REFFERAL = "apply_provider_referral_code"
    static let GET_PROVIDER_REFERAL_CREDIT = "get_provider_referal_credit"
    static let FAIL_STRIPE_INTENT_PAYMENT = "fail_stripe_intent_payment"
    static let PAY_STRIPE_INTENT_PAYMENT = "pay_stripe_intent_payment"
    static let GENERATE_FIREBASE_ACCESS_TOKEN = "generate_firebase_access_token"
    static let WS_DELETE_PROVIDER = "delete_provider"
    static let TOGGLE_GO_HOME = "toggle_go_home"
    static let WS_GET_TRIPS_DETAILS = "gettripsdetails"
    static let get_all_country_details = "get_all_country_details"
    static let USER_CHANGE_PAYMENT_TYPE = "userchangepaymenttype"
    
    /* Payment Related Web-Service Methods*/
    static let ADD_CARD = "payments/addcard"
    static let DEFAULT_CARD = "payments/card_selection"
    static let USER_GET_CARDS = "payments/cards"
    static let DELETE_CARD = "payments/delete_card"
    static let GET_STRIPE_PAYMENT_INTENT = "payments/get_stripe_payment_intent"
    static let GET_STRIPE_ADD_CARD_INTENT = "payments/get_stripe_add_card_intent"
    static let SEND_PAYSTACK_REQUIRED_DETAIL = "payments/send_paystack_required_detail"
    
    static let get_cancellation_reason = "get_cancellation_reason"
    static let GET_WITHDRAW_REDEEM_POINT_TO_WALLET = "withdraw_redeem_point_to_wallet"
    static let GET_REDEEM_POINT_HISTORY = "earning/get_redeem_point_history"
    static let WS_CHECK_OTP = "check_sms_otp"
    static let GET_PROVIDERS_LOGIN_OTP = "getprovidersloginotp"
    
    //HUB
    static let GET_PROVIDER_HUB_VEHICLE_LIST = "get_provider_hub_vehicle_list"
    static let PROVIDER_PICK_HUB_VEHICLE = "provider_pick_hub_vehicle"
    static let PROVIDER_DROP_HUB_VEHICLE = "provider_drop_hub_vehicle"
    static let GET_PROVIDER_HUB_LIST = "get_provider_hub_list"
}

struct MessageCode {
    static let USER_REGISTERED = "102"
}
struct PAYMENT_STATUS  {
    static let WAITING = 0
    static let COMPLETED = 1
    static let FAILED = 2

}
struct SEGUE {
    static let HOME_TO_LOGIN = "segueToLogin"
    static let HOME_TO_REGISTER = "segueToRegister"
    
    static let PHONE_TO_PASSWORD = "seguePhoneToPassword"
    static let PHONE_TO_REGISTER = "seguePhoneToRegister"
    static let WALLET_HISTORY = "segueToWalletHistory"
    static let FORGOT_PASSWORD_TO_NEW_PASSWORD = "segueForgotpasswordToNewpassword"
    static let PASSWORD_TO_FORGOT_PASSWORD = "seguePasswordToForgotPassword"
    
    static let LOGIN_TO_REFERRAL = "segueLoginToReferral"
    static let REGISTER_TO_REFERRAL = "segueRegisterToReferral"
    static let INTRO_TO_REFERRAL = "segueIntroToReferral"
    
    static let SET_DESTINATION_ADDRESS = "usersetdestination"
    static let TRIP_TO_FEEDBACK = "segueToFeedback"
    /*drawer SEGUE*/
    
    /*Map Segue*/
    static let MAP_TO_ADDRESS = "segueMapToAddress"
    static let HOME_TO_PROFILE = "segueHomeToProfile"
    static let HOME_TO_CONTACT_US = "segueHomeToContactUs"
    static let HOME_TO_SETTING = "segueHomeToSetting"
    static let HOME_TO_HISTORY = "segueHomeToHistory"
    static let HOME_TO_BANK_DETAIL = "segueHomeToBankDetail"
    static let HOME_TO_SHARE_REFERRAL = "segueHomeToShareReferral"
    static let HOME_TO_PAYMENT = "segueHomeToPayment"
    static let HOME_TO_REDEEM = "segueHomeToRedeem"
    static let HOME_TO_EARNING = "segueHomeToEarning"
    static let HOME_TO_DOCUMENTS =  "segueHomeToDocuments"
    static let HISTORY_TO_HISTORY_DETAIL = "segueHistoryToHistoryDetail"
    static let PAYMENT_TO_ADD_CARD = "seguePaymentToAddCard"
    static let EARNING_TO_WEEKLY = "segueEarnToWeek"
    static let EARNING_TO_DAILY = "segueEarnToDaily"
    
    static let TRIP_TO_INVOICE = "segueToInvoice"
    static let WALLET_HISTORY_TO_WALLET_HISTORY_DETAIL = "segueToWalletHistoryDetail"
    static let  PAYMENT_TO_PAYSTACK_WEBVIEW = "seguePaymentToPaystackWebview"

}

struct PARAMS {
    //Common
    static let IS_TRIP_UPDATED = "is_trip_updated"
    static let IS_WALLET =  "is_use_wallet"
    static let DOCUMENT_ID = "document_id"
    static let UNIQUE_CODE = "unique_code"
    static let EXPIRED_DATE = "expired_date"
    static let _ID = "_id"
    static let ID = "id"
    static let PROVIDER_IS_ACTIVE = "is_active";
    static let COUNTRY_ID = "country_id"
    static let IMAGE_URL = "picture_data"
    static let USER_ID = "user_id"
    static let FRIEND_ID = "friend_id"
    static let PAYMENT_ID = "payment_id"
    static let TRIP_ID = "trip_id"
    static let NEAR_DESTINATION_TRIP_ID = "near_destination_trip_id"
    static let TOKEN = "token"
    static let TYPE = "type"
    static let TYPE_ID = "typeid"
    static let WALLET = "wallet"
    static let TIP_AMOUNT = "tip_amount"
    static let SERVICE_TYPE_ID = "service_type_id"
    static let SERVICE_TYPE = "service_type"
    static let TIME = "time"
    static let DISTANCE = "distance"
    static let IS_SURGE_HOURS = "is_surge_hours"
    static let FIXED_PRICE = "fixed_price"
    static let IS_FIXED_FARE = "is_fixed_fare"
    static let CANCEL_TRIP_REASON = "cancel_reason";
    
    static let DESTINATION_LATITUDE = "destination_latitude"
    static let DESTINATION_LONGITUDE = "destination_longitude"
    
    static let D_LATITUDE = "d_latitude"
    static let D_LONGITUDE = "d_longitude"
    static let IS_REQUEST_TIMEOUT = "is_request_timeout"
    
    static let TRIP_DESTINATION_LATITUDE = "d_latitude"
    static let TRIP_DESTINATION_LONGITUDE = "d_longitude"
    static let TRIP_DESTINATION_ADDRESS = "destination_address"
    static let PROVIDER_STATUS = "is_provider_status"
    static let TOLL_AMOUNT = "toll_amount"
    static let SURGE_MULTIPLIER = "surge_multiplier";
    
    //Vehicle Params
    static let VEHICLE_ID = "vehicle_id"
    static let VEHICLE_YEAR = "passing_year"
    static let VEHICLE_NAME = "vehicle_name"
    static let VEHICLE_PLATE_NO = "plate_no"
    static let VEHICLE_COLOR = "color"
    static let VEHICLE_MODEL = "model"
    static let USER_TYPE_ID = "user_type_id"
    
    static let PICKUP_LATITUDE = "pickup_latitude"
    static let PICKUP_LONGITUDE = "pickup_longitude"
    static let TRIP_PICKUP_ADDRESS = "source_address"
    static let MAP_IMAGE = "map";
    
    static let RATING = "rating";
    static let REVIEW = "review";
    
    //Register login
    static let IS_PROVIDER_ACCEPTED = "is_provider_accepted"
    static let PHONE = "phone"
    static let PASSWORD = "password"
    static let EMAIL = "email"
    static let COUNTRY_PHONE_CODE = "country_phone_code"
    static let USER_SMS="userSms"
    static let SMS_OTP = "otpForSMS"
    static let EMAIL_OTP = "otpForEmail"
    static let APP_VERSION = "app_version"
    static let ADDRESS = "address";
    static let USER_APPROVED = "is_approved"
    static let FIRST_NAME = "first_name"
    static let LAST_NAME = "last_name"
    static let PICTURE = "picture"
    static let DEVICE_TOKEN = "device_token"
    static let DEVICE_TYPE = "device_type"
    static let PLACE_ID = "place_id"
    static let COUNTRY = "country"
    static let CITY = "city"
    static let CITY_ID = "city_id"
    static let LOGIN_BY = "login_by"
    static let SOCIAL_UNIQUE_ID = "social_unique_id"
    static let SOCIAL_IDS = "social_ids"
    static let REFERRAL_SKIP = "is_skip"
    static let OLD_PASSWORD = "old_password"
    static let NEW_PASSWORD = "new_password"
    static let REFERRAL_CODE = "referral_code"
    
    static let LAST_FOUR = "last_four"
    static let PAYMENT_TOKEN="payment_token";
    static let PAYMENT_MODE = "payment_mode";
    static let PAYMENT_TYPE = "payment_type";
    static let CARD_TYPE = "card_type"
    static let CARD_ID = "card_id"
    static let CARD_EXPIRY_DATE = "card_expiry_date"
    static let CARD_HOLDER_NAME = "card_holder_name"
    
    static let PROMO_CODE = "promocode"
    static let LATITUDE = "latitude"
    static let LONGITUDE = "longitude"
    static let BEARING = "bearing"
    static let PROVIDER_LANGUAGE = "language"
    static let PROVIDER_LANGUAGES = "languages"
    static let PROVIDER_ID = "provider_id"
    static let VEHICLE_ACCESSIBILITY = "accessibility"
    static let PROVIDER_GENDER = "received_trip_from_gender"
    static let DEVICE_TIMEZONE = "device_timezone"
    static let TIMEZONE = "timezone"
    static let DISTANCE_UNIT = "unit"
    static let EMAIL_VERIFICATION_ON = "userEmailVerification"
    static let USER_CREATE_TIME = "user_create_time"
    static let SCHEDULED_REQUEST_PRE_START_TIME = "scheduledRequestPreStartMinute"
    static let USER_PATH_DRAW = "userPath"
    static let NAME = "name";
    static let IS_ALWAYS_SHARE_RIDE_DETAIL = "is_always_share_ride_detail";
    static let EMERGENCY_CONTACT_DETAIL_ID = "emergency_contact_detail_id";
    
    /*history*/
    static let START_DATE = "start_date"
    static let END_DATE = "end_date";
    static let START_TIME = "start_time"
    static let DATE = "date"
    static let PAGE = "page"
    
    //Home And Work Address
    static let HOME_ADDRESS = "home_address"
    static let HOME_LATITUDE = "home_latitude";
    static let HOME_LONGITUDE = "home_longitude"
    static let WORK_ADDRESS = "work_address";
    static let WORK_LATITUDE = "work_latitude"
    static let WORK_LONGITUDE = "work_longitude";
    
    //Bank Detail Params
    static let BANK_DETEILS = "bankdetails";
    static let BANK_HOLDER_TYPE = "account_holder_type";
    static let BANK_HOLDER_ID = "bank_holder_id";
    static let BANK_NAME = "bank_name";
    static let BANK_BRANCH = "bank_branch";
    static let BANK_ACCOUNT_NUMBER = "account_number";
    static let BANK_CODE = "bank_code";

    static let BANK_ACCOUNT_HOLDER_NAME = "account_holder_name";
    static let BANK_ROUTING_NUMBER = "routing_number";
    static let BANK_PERSONAL_ID_NUMBER = "personal_id_number";
    static let BANK_DOCUMENT = "document";
    static let BANK_DOB = "dob";
    static let STATE_CODE = "state";
    static let POSTAL_CODE = "postal_code";
    static let GENDER = "gender";
    static let GOOGLE_PATH_START_LOCATION_TO_PICKUP_LOCATION = "googlePathStartLocationToPickupLocation"
    static let GOOGLE_PICKUP_LOCATION_TO_DESTINATION_LOCATION = "googlePickUpLocationToDestinationLocation"

    static let PAYMENT_METHOD = "payment_method"
    static let AMOUNT = "amount"
    static let PAYMENT_INTENT_ID = "payment_intent_id"
    static let PAYMENT_GATEWAY_TYPE = "payment_gateway_type"

    static let REFERENCE = "reference"
    static let REQUIRED_PARAM = "required_param"
    static let PIN = "pin"
    static let OTP = "otp"
    static let BIRTHDAY = "birthday"
    
    static let IS_GOING_HOME = "is_go_home"
    static let ADDRESS_LOCATION = "address_location"
    static let SOCIAL_ID = "social_id"
    static let TRIP_START_OTP = "trip_start_otp"
    static let bid_price = "bid_price"
    static let last_four = "last_four"
    static let user_type = "user_type"
    static let lang = "lang"
    static let is_apple_pay = "is_apple_pay"
    static let is_wallet_amount = "is_wallet_amount"
    static let REDEEM_POINT = "redeem_point"
    static let otp_sms = "otp_sms"
    static let is_register = "is_register"
    static let otp_mail = "otp_mail"
}

struct CONSTANT {
    static let MANUAL = "manual"
    static let SOCIAL = "social"
    static let IOS = "ios"
    static let SMS_VERIFICATION_ON = 1
    static let EMAIL_VERIFICATION_ON = 2
    static let SMS_AND_EMAIL_VERIFICATION_ON = 3
    static let DELIVERY_LIST = "delivery_list"
    static let SELECTED_STORE="selected_store"
    static let DELIVERY_STORE="delivery_store"
    static let TYPE_PROVIDER = 11
    static let INDIVIDUAL = "individual"
    static var STRIPE_KEY = ""
    static let UPDATE_URL = "https://apps.apple.com/in/app/alma3roof-driver/id6473368647"

    
    struct  DBPROVIDER {
        static let MESSAGES = "MESSAGES"
        static let MEDIA_MESSAGES = "media_message"
        static let USER = "user"
        static let IMAGE_STORAGE = "image_storage"
        static let VIDEO_STORAGE = "video_storage"
        static let EMAIL = "email"
        static let PASSWORD = "password"
    }
    
    struct MESSAGES {
        static let ID = "id"
        static let TYPE = "type"
        static let TEXT = "message"
        static let TIME = "time"
        static let STATUS = "is_read"
    }
}

struct PaymentMethod
{
    static let PayU_ID = "12"
    static let PayStack_ID = "11"
    static let Stripe_ID = "10"
    static let Paypal_ID = "14"
    static var Payment_gateway_type = ""
    static var PayTabs = "13"
    static var RazorPay = "15"
    static var New_payment = "16"

    struct VerificationParameter {
        static let SEND_PIN = "send_pin"
        static let SEND_OTP = "send_otp"
        static let SEND_PHONE = "send_phone"
        static let SEND_BIRTHDAY = "send_birthdate"
        static let SEND_ADDRESS = "send_address"

    }
}

struct DateFormat {
    static let TIME_FORMAT_AM_PM = "hh:mm a"
    static let WEB = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    static let DATE_TIME_FORMAT = "dd MMMM yyyy, HH:mm"
    
    static let HISTORY_TIME_FORMAT = "hh:mm a"
    static let DATE_FORMAT = "yyyy-MM-dd"
    static let DD_MM_YY = "dd-MM-yyyy"
    static let DATE_FORMAT_MONTH = "MMMM yyyy"
    static let DATE_MM_DD_YYYY = "MM/dd/yyyy"
    static let TIME_FORMAT_HH_MM = "HH:mm"
    static let DATE_TIME_FORMAT_AM_PM = "yyyy-MM-dd hh:mm a"
    static let MESSAGE_FORMAT = "yyyy-MM-dd, hh:mm a"
    static let SCHEDUALE_DATE_FORMATE = "EEEE d MMMM 'at' HH:mm"
    static let WEEK_FORMAT = "EEE, dd MMMM"
    static let DD_MMM_YY = "dd MMM yy"
    static let EARNING = "MMM dd, yyyy"
}

//MARK:- Driver Constant Types
struct AddressType {
    static let pickupAddress:Int = 0
    static let destinationAddress:Int = 1
    static let homeAddress:Int = 2
    static let workAddress:Int = 3
}

struct MeasureUnit {
    static let MINUTES = " min"
    static let KM = " Km"
    static let MILE = " Mile"
}

struct PaymentMode {
    static let CASH = 1
    static let CARD = 0
    static let APPLE_PAY = 2
    static let UNKNOWN = -1
}
struct MODULE_NAME  {
    static let PAMENTS  = "payments"
    static let HISTORY  = "history"
    static let EARNING  = "earning"
}
struct ProviderType {
    static let NORMAL = 0
    static let PARTNER = 1
    static let ADMIN = 2
    static let UNKNOWN = -1
}

enum WalletHistoryStatus:Int {
    case  ADDED_BY_ADMIN = 1
    case  ADDED_BY_CARD = 2
    case  ADDED_BY_REFERRAL = 3
    case  ORDER_CHARGED = 4
    case  ORDER_REFUND = 5
    case  ORDER_PROFIT = 6
    case  ORDER_CANCELLATION_CHARGE = 7
    case  WALLET_AMOUNT_RECEIVED_BY_FRIEND = 8
    case  WALLE_AMOUNT_SEND_TO_FRIEND = 9
//    case  WALLET_REQUEST_CHARGE = 8
    case  Unknown
    func text() -> String {
        switch self {
        case .ADDED_BY_ADMIN :
            return "WALLET_STATUS_ADDED_BY_ADMIN".localized   case .ADDED_BY_CARD : return "WALLET_STATUS_ADDED_BY_CARD".localized
        case .ADDED_BY_REFERRAL :
            return "WALLET_STATUS_ADDED_BY_REFERRAL".localized
        case .ORDER_CHARGED :
            return "WALLET_STATUS_ORDER_CHARGED".localized
        case .ORDER_REFUND :
            return "WALLET_STATUS_ORDER_REFUND".localized
        case .ORDER_PROFIT :
            return "WALLET_STATUS_ORDER_PROFIT".localized
        case .ORDER_CANCELLATION_CHARGE :
            return"WALLET_STATUS_ORDER_CANCELLATION_CHARGE".localized
        case .WALLET_AMOUNT_RECEIVED_BY_FRIEND :
            return "WALLET_STATUS_AMOUNT_RECEIVED_BY_FRIEND".localized
        case .WALLE_AMOUNT_SEND_TO_FRIEND :
            return "WALLET_STATUS_AMOUNT_SEND_TO_FRIEND".localized
        default:
            return "Unknown"
        }
    }
};
struct Global {
    static var imgPinPickup = UIImage(named: "asset-pin-pickup-location")!.imageWithColor()
    static var imgPinDestination = UIImage(named: "asset-pin-destination-location")!.imageWithColor()
    static var imgPinSource = UIImage(named: "asset-pin-source-location")!.imageWithColor()
    static var imgPinSourceDestination = UIImage(named: "asset-pin-source-destination")!.imageWithColor()

}


struct Google {
    static let GEOCODE_URL = WebService.BASE_URL + "gmapsapi/" +  "maps/api/geocode/json?"
    static let AUTO_COMPLETE_URL = WebService.BASE_URL + "gmapsapi/" +  "maps/api/place/autocomplete/json?"
    static let TIME_DISTANCE_URL = WebService.BASE_URL + "gmapsapi/" +  "maps/api/distancematrix/json?origins="
    static let DIRECTION_URL = WebService.BASE_URL + "gmapsapi/" +  "maps/api/directions/json?origin="

    //MARK: - Keys
    
    static var MAP_KEY = "AIzaSyAlpHJlDPSC1tnxwvqbdtJf8DAVv0NZ1ag"
    static var CLIENT_ID = "21449625851-d9dqrmg07pbi0qlaknek1n8m6eg5qjsl.apps.googleusercontent.com"

    /*Google Parameters*/
    static let OK = "OK"
    static let STATUS = "status"
    static let RESULTS = "results"
    static let GEOMETRY = "geometry"
    static let LOCATION = "location"
    static let ADDRESS_COMPONENTS = "address_components"
    static let LONG_NAME = "long_name"
    static let ADMINISTRATIVE_AREA_LEVEL_2 = "administrative_area_level_2"
    static let ADMINISTRATIVE_AREA_LEVEL_1 = "administrative_area_level_1"
    static let COUNTRY = "country"
    static let COUNTRY_CODE = "country_code"
    static let SHORT_NAME = "short_name"
    static let TYPES = "types"
    static let LOCALITY = "locality"
    static let PREDICTIONS = "predictions"
    static let LAT = "lat"
    static let LNG = "lng"
    static let NAME = "name"
    static let DESTINATION_ADDRESSES = "destination_addresses"
    static let ORIGIN_ADDRESSES = "origin_addresses"
    static let ROWS = "rows"
    static let ELEMENTS = "elements"
    static let DISTANCE = "distance"
    static let VALUE = "value"
    static let DURATION = "duration"
    static let TEXT = "text"
    static let ROUTES = "routes"
    static let LEGS = "legs"
    static let STEPS = "steps"
    static let POLYLINE = "polyline"
    static let POINTS = "points"
    static let ORIGIN = "origin"
    static let ORIGINS = "origins"
    static let DESTINATION = "destination"
    static let DESTINATIONS = "destinations"
    static let DESCRIPTION = "description"
    static let KEY = "key"
    static let EMAIL = "email"
    static let ID = "id"
    static let PICTURE = "picture"
    static let URL = "url"
    static let DATA = "data"
    static let RADIUS = "radius"
    static let FIELDS = "fields"
    static let ADDRESS = "address"
    static let FORMATTED_ADDRESS = "formatted_address"
    static let LAT_LNG = "latlng"
    static let STRUCTURED_FORMATTING = "structured_formatting"
    static let MAIN_TEXT = "main_text"
    static let SECONDARY_TEXT = "secondary_text"
    static let PLACE_ID = "place_id"

}

enum Day: Int {
    case SUN = 0
    case MON = 1
    case TUE = 2
    case WED = 3
    case THU = 4
    case FRI = 5
    case SAT = 6
    func text() -> String {
        switch self {
        case .SUN : return "SUN".localized
        case .MON : return "MON".localized
        case .TUE : return "TUE".localized
        case .WED : return "WED".localized
        case .THU: return "THU".localized
        case .FRI : return "FRI".localized
        case .SAT : return "SAT".localized
        }
    }
}

struct VehicleAccessibity {
    static let HANDICAP = "handicap";
    static let BABY_SEAT = "baby_seat";
    static let HOTSPOT = "hotspot";
}

struct Gender {
    static let MALE = "male";
    static let FEMALE = "female";
}

enum TripStatus: Int {
    case Accepted = 1
    case Coming = 2
    case Arrived = 4
    case Started = 6
    case End = 8
    case Completed = 9
    case Unknown
    func text() -> String {
        switch self {
        case .Accepted :
            return "TXT_TRIP_STATUS_ACCEPTED".localizedCapitalized
        case .Coming :
            return "TXT_TRIP_STATUS_COMING".localizedCapitalized
        case .Arrived :
            return "TXT_TRIP_STATUS_ARRIVED".localizedCapitalized
        case .Started :
            return "TXT_TRIP_STATUS_STARTED".localizedCapitalized
        case .End:
            return "TXT_TRIP_STATUS_END".localizedCapitalized
        case .Completed :
            return "TXT_TRIP_STATUS_COMPLETED".localizedCapitalized
        default:
            return "Unknown"
        }
    }
}

enum ProviderStatus: Int {
    case Accepted = 1
    case Rejected = 0
    case Pending = 2
}

struct TripType {
    
    static let NORMAL = 0
    
    static let VISITOR = 1
    static let HOTEL = 2
    static let DISPATCHER = 3
    static let SCHEDULE = 5
    static let PROVIDER = 6
    
    static let AIRPORT = 11
    static let ZONE = 12
    static let CITY = 13
}

//struct MenuOptions {
//
//    static var arrMenuOption: ([String],[UIImage]) {
//        
//        var arrImage = [ #imageLiteral(resourceName: "asset-menu-booking") ,#imageLiteral(resourceName: "asset-menu-history") , #imageLiteral(resourceName: "asset-menu-document") , #imageLiteral(resourceName: "asset-menu-setting"), #imageLiteral(resourceName: "asset-menu-earning"), #imageLiteral(resourceName: "asset-menu-referral"), #imageLiteral(resourceName: "asset-menu-payments"),#imageLiteral(resourceName: "asset-redeem"), #imageLiteral(resourceName: "asset-menu-contact-us")]
//        
//        var arrForMenu = [
//                          "TXT_MY_BOOKINGS".localized,
//                           "TXT_HISTORY".localized,
//                           "TXT_DOCUMENTS".localized,
//                           "TXT_SETTINGS".localized,
//                           "TXT_EARNING".localized,
//                           "TXT_REFERRAL".localized,
//                           "TXT_PAYMENTS".localized,
//                          "TXT_REDEEM".localized,
//                           "TXT_CONTACT_US".localized]
//        
//        if !ProviderSingleton.shared.isAutoTransfer {
//            if let index = arrForMenu.firstIndex(where: {$0 == "TXT_BANK_DETAIL".localized}) {
//                arrForMenu.remove(at: index)
//                arrImage.remove(at: index)
//            }
//        }
//
//        if ProviderSingleton.shared.provider.providerType == ProviderType.PARTNER {
//            arrForMenu = [
//                          "TXT_MY_BOOKINGS".localized,
//                               "TXT_HISTORY".localized,
//                               "TXT_DOCUMENTS".localized,
//                               "TXT_SETTINGS".localized,
//                               "TXT_CONTACT_US".localized]
//            arrImage = [ #imageLiteral(resourceName: "asset-menu-history") , #imageLiteral(resourceName: "asset-menu-document") , #imageLiteral(resourceName: "asset-menu-document"), #imageLiteral(resourceName: "asset-menu-setting"), #imageLiteral(resourceName: "asset-menu-contact-us")]
//        }
//        
//        if ProviderSingleton.shared.provider.providerType == ProviderType.ADMIN  {
//            arrForMenu.append("txt_hub".localized)
//            arrImage.append(UIImage(named: "asset-charging")!.withTintColor(.themeButtonBackgroundColor))
//        }
//        
//        
//        if !ProviderSingleton.shared.currentVehicle.isSelected {
//            if let index = arrForMenu.firstIndex(where: {$0 == "TXT_MY_BOOKINGS".localized}) {
//                arrForMenu.remove(at: index)
//                arrImage.remove(at: index)
//            }
//        }
//
//        return (arrForMenu,arrImage)
//    }
//}

struct MenuOptions {

    struct MenuSection {
        let title: String
        var items: [String]
        var icons: [UIImage]
    }

    static var sectionedMenu: [MenuSection] {
        var myAccountItems: [String] = []
        var myAccountIcons: [UIImage] = []

        var activityItems: [String] = []
        var activityIcons: [UIImage] = []

        var supportItems: [String] = []
        var supportIcons: [UIImage] = []

        let allItems = [
            ("TXT_MY_BOOKINGS".localized, #imageLiteral(resourceName: "asset-menu-booking")),
            ("TXT_HISTORY".localized, #imageLiteral(resourceName: "asset-menu-history")),
            ("TXT_DOCUMENTS".localized, #imageLiteral(resourceName: "asset-menu-document")),
            ("TXT_SETTINGS".localized, #imageLiteral(resourceName: "asset-menu-setting")),
            ("TXT_EARNING".localized, #imageLiteral(resourceName: "asset-menu-earning")),
            ("TXT_REFERRAL".localized, #imageLiteral(resourceName: "asset-menu-referral")),
            ("TXT_PAYMENTS".localized, #imageLiteral(resourceName: "asset-menu-payments")),
            ("TXT_REDEEM".localized, #imageLiteral(resourceName: "asset-redeem")),
            ("TXT_CONTACT_US".localized, #imageLiteral(resourceName: "asset-menu-contact-us"))
        ]

        for (text, icon) in allItems {
            switch text {
            case "TXT_PAYMENTS".localized, "TXT_DOCUMENTS".localized, "TXT_SETTINGS".localized:
                myAccountItems.append(text)
                myAccountIcons.append(icon)
            case "TXT_EARNING".localized, "TXT_MY_BOOKINGS".localized, "TXT_HISTORY".localized:
                activityItems.append(text)
                activityIcons.append(icon)
            case "TXT_CONTACT_US".localized, "TXT_REFERRAL".localized, "TXT_REDEEM".localized:
                supportItems.append(text)
                supportIcons.append(icon)
            default: break
            }
        }

        return [
            MenuSection(title: "My Account", items: myAccountItems, icons: myAccountIcons),
            MenuSection(title: "Activity", items: activityItems, icons: activityIcons),
            MenuSection(title: "Support", items: supportItems, icons: supportIcons)
        ]
    }
}


enum LoginBY {
    case email
    case phone
    case LoginWithOtp
}
