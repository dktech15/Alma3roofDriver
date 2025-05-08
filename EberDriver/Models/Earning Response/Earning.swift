import Foundation
public class Earning
{
    public var sectionTitle:String?
    public var title:String?
    public var price:String?
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [Earning] {
        var models:[Earning] = []
        for _ in array {
            models.append(Earning(sectionTitle:"",title:"",price:"0.00"))
        }
        return models
    }
    
    required public init!(sectionTitle:String = "",title:String = "",price:String = "0.00") {
        
        self.sectionTitle = sectionTitle
        self.title = title
        self.price = price
        
    }
    public func dictionaryRepresentation() -> [String:Any] {
        
         var dictionary:[String:Any] = [:]
        
        dictionary["sectionTitle"] = self.sectionTitle
        dictionary["title"] = self.title
        dictionary["price"] = self.price
        
        return dictionary
    }
}
