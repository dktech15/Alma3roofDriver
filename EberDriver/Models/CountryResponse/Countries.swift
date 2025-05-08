import Foundation

struct Country : Codable {

    var id : String  = ""
    var countryname : String  = ""
    var countryphonecode : String  = ""
    var flagUrl : String  = ""
    var phoneNumberLength : Int  = 10
    var phoneNumberMinLength : Int  = 8
    var alpha2:String = ""
    var cityList : [City] = []

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case countryname = "countryname"
        case countryphonecode = "countryphonecode"
        case flagUrl = "flag_url"
        case phoneNumberLength = "phone_number_length"
        case phoneNumberMinLength = "phone_number_min_length"
        case cityList = "city_list"
        case alpha2 = "alpha2"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? ""
        countryname = try values.decodeIfPresent(String.self, forKey: .countryname)  ?? ""
        countryphonecode = try values.decodeIfPresent(String.self, forKey: .countryphonecode)  ?? ""
        flagUrl = try values.decodeIfPresent(String.self, forKey: .flagUrl)  ?? ""
        phoneNumberLength = try values.decodeIfPresent(Int.self, forKey: .phoneNumberLength) ?? 10
        phoneNumberMinLength = try values.decodeIfPresent(Int.self, forKey: .phoneNumberMinLength) ?? 8
        cityList = try values.decodeIfPresent([City].self, forKey: .cityList) ?? []
        alpha2 = try values.decodeIfPresent(String.self, forKey: .alpha2) ?? ""
    }
    
 
}


public class CountryList: ModelNSObj
{
    public var countryPhoneCode : String!
    public var countryName : String!
    public var countryCode : String!
    public var phoneNumberLength : Int!
    public var phoneNumberMinLength : Int!
    public var countryFlag : String!
    public var alpha:String!
     var cityList : [City] = []
    
    
     class func modelsFromDictionaryArray() -> [CountryList]
    {
       let dict = [
          "alpha2" : "IN",
          "alpha3" : "IND",
          "timezones" : [
            "Asia/Kolkata"
          ],
          "code" : "+91",
          "currency_code" : "INR",
          "sign" : "₹",
          "name" : "India"
       ] as [String : Any]
        
        
        var models:CountryList = CountryList(dictionary: dict)!

        return [models]
    }
    
//    public class func modelsFromDictionaryArray() -> [CountryList]
//    {
//        var models:[CountryList] = []
//
//        guard let path = Bundle.main.path(forResource: "country_list", ofType: "json") else
//        {
//            return  []
//
//        }
//        let url = URL(fileURLWithPath: path)
//
//        do {
//
//            let data = try Data(contentsOf: url)
//            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
//            //printE(json)
//
//            guard let array = json as? [Any] else
//            {
//                return []
//            }
//            for country in array
//            {
//                models.append(CountryList(dictionary: country as! [String:Any])!)
//           }
//        }
//        catch {
//            print(error)
//        }
//
//        return models
//    }
    required public init?(dictionary: [String:Any])
    {
        countryPhoneCode = (dictionary["code"] as? String) ?? "+91"
        countryName = (dictionary["name"] as? String) ?? "India"
        countryCode = (dictionary["alpha2"] as? String) ?? "INR"
        
    }
 
    
}


