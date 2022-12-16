import Foundation
import UIKit




final class Utils {
    
    static let shared = Utils()
    var lang = "en"
    
    static func formattedDateFromString(dateString: String, withFormat format: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = format
            
            return outputFormatter.string(from: date)
        }
        
        return nil
    }
    

    static func convertDouble(_ a: Double, maxDecimals max: Int) -> Double {
        let stringArr = String(a).split(separator: ".")
        let decimals = Array(stringArr[1])
        var string = "\(stringArr[0])."

        var count = 0;
        for n in decimals {
            if count == max { break }
            string += "\(n)"
            count += 1
        }

        let double = Double(string)!
        return double
    }
    static func searchStringEdited(query: String) -> String{
        
           
        let queryString = String(query).split(separator: " ")
        let searchString = queryString.joined(separator: "+")
       
        
        return searchString

    }
    
}
         

    

extension String {
    func localizableStr(lang: String) -> String{
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment:"")
    }
   
}

func langChange(str: String,lang:String) -> String{
    let str = str.localizableStr(lang: lang)
    return str
}
