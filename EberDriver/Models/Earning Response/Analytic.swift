import Foundation
public class Analytic
{
    
    public var title:String?
    public var value:String?
    
    
    required public init!(title:String,value:String) {
        self.title = title
        self.value = value
        
    }
    public func dictionaryRepresentation() -> [String:Any] {
        
         var dictionary:[String:Any] = [:]
        dictionary["title"] = self.title
        dictionary["value"] = self.value
        return dictionary
    }
}
