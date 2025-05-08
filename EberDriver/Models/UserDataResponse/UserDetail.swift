//
//	UserDetail.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct UserDetail : Codable {
    
    var address : String = ""
    var city : String = ""
    var country : String = ""
    var countryPhoneCode : String = ""
    var email : String = ""
    var firstName : String = ""
    var isApproved : Int = 0
    var isDocumentUploaded : Int = 0
    var isReferral : Int = 0
    var lastName : String = ""
    var loginBy : String = ""
    var phone : String = ""
    var user_type : Int = 0
    var support_phone_user : String = ""
    var rate : Double = 0.0
    var rateCount : Int = 0
    var referralCode : String = ""
    var socialIds : [String] = []
    var socialUniqueId : String = ""
    var token : String = ""
    var userId : String = ""
    var picture : String = ""
    
    enum CodingKeys: String, CodingKey {
        case address = "address"
        case city = "city"
        case country = "country"
        case countryPhoneCode = "country_phone_code"
        case email = "email"
        case firstName = "first_name"
        case isApproved = "is_approved"
        case isDocumentUploaded = "is_document_uploaded"
        case isReferral = "is_referral"
        case lastName = "last_name"
        case loginBy = "login_by"
        case phone = "phone"
        case support_phone_user = "support_phone_user"
        case user_type = "user_type"
        case rate = "rate"
        case rateCount = "rate_count"
        case referralCode = "referral_code"
        case socialIds = "social_ids"
        case socialUniqueId = "social_unique_id"
        case token = "token"
        case userId = "user_id"
        case picture = "picture"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        address = try values.decodeIfPresent(String.self, forKey: .address) ?? ""
        picture = try values.decodeIfPresent(String.self, forKey: .picture) ?? ""
        city = try values.decodeIfPresent(String.self, forKey: .city) ?? ""
        country = try values.decodeIfPresent(String.self, forKey: .country) ?? ""
        countryPhoneCode = try values.decodeIfPresent(String.self, forKey: .countryPhoneCode) ?? ""
        email = try values.decodeIfPresent(String.self, forKey: .email) ?? ""
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName) ?? ""
        isApproved = try values.decodeIfPresent(Int.self, forKey: .isApproved) ?? 0
        isDocumentUploaded = try values.decodeIfPresent(Int.self, forKey: .isDocumentUploaded) ?? 0
        isReferral = try values.decodeIfPresent(Int.self, forKey: .isReferral) ?? 0
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName) ?? ""
        loginBy = try values.decodeIfPresent(String.self, forKey: .loginBy) ?? ""
        phone = try values.decodeIfPresent(String.self, forKey: .phone) ?? ""
        support_phone_user = try values.decodeIfPresent(String.self, forKey: .support_phone_user) ?? ""
        user_type =  try values.decodeIfPresent(Int.self, forKey: .user_type) ?? 0
        rate = try values.decodeIfPresent(Double.self, forKey: .rate) ?? 0.0
        rateCount = try values.decodeIfPresent(Int.self, forKey: .rateCount) ?? 0
        referralCode = try values.decodeIfPresent(String.self, forKey: .referralCode) ?? ""
        socialIds = try values.decodeIfPresent([String].self, forKey: .socialIds) ?? []
        socialUniqueId = try values.decodeIfPresent(String.self, forKey: .socialUniqueId) ?? ""
        token = try values.decodeIfPresent(String.self, forKey: .token) ?? ""
        userId = try values.decodeIfPresent(String.self, forKey: .userId) ?? ""
    }
    
    init(dics: [String:Any]) {
        address = dics["address"] as? String ?? ""
        picture = dics["picture"] as? String ?? ""
        city = dics["city"] as? String ?? ""
        country = dics["country"] as? String ?? ""
        countryPhoneCode = dics["country_phone_code"] as? String ?? ""
        email = dics["email"] as? String ?? ""
        firstName = dics["first_name"] as? String ?? ""
        isApproved = dics["is_approved"] as? Int ?? 0
        isDocumentUploaded = dics["is_document_uploaded"] as? Int ?? 0
        isReferral = dics["is_referral"] as? Int ?? 0
        lastName = dics["last_name"] as? String ?? ""
        loginBy = dics["login_by"] as? String ?? ""
        phone = dics["phone"] as? String ?? ""
        support_phone_user = dics["support_phone_user"] as? String ?? ""
        user_type = dics["user_type"] as? Int ?? 0
        rate = dics["rate"] as? Double ?? 0
        rateCount = dics["rate_count"] as? Int ?? 0
        referralCode = dics["referral_code"] as? String ?? ""
        socialIds = dics["social_ids"] as? [String] ?? []
        socialUniqueId = dics["social_unique_id"] as? String ?? ""
        token = dics["token"] as? String ?? ""
        userId = dics["user_id"] as? String ?? ""
    }
}
