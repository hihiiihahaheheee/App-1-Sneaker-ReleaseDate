

import Foundation
import UIKit
import RealmSwift

class SaleProductModel: Object {
    
    @objc dynamic var brandedName: String = ""
    @objc dynamic var salePriceLabel : String = ""
    @objc dynamic var extractDate : String = ""
    @objc dynamic var clickUrl : String = ""
    @objc dynamic var image : String = ""
 
    
    func initLoad(_ json:  [String: Any]) -> SaleProductModel{
        if let temp = json["brandedName"] as? String { brandedName = temp }
        if let temp = json["salePriceLabel"] as? String { salePriceLabel  = temp }
        if let temp = json["extractDate"] as? String { extractDate = temp }
        if let temp = json["clickUrl"] as? String { clickUrl  = temp }        
        
        if let temp = json["url"] as? String { image  = temp }
        
        if let image = json["image"] as? [String:Any] {
            if let imageSize = image["sizes"] as? [String:Any] {
                if let image1 = imageSize["Medium"] as? [String:Any] {
                    if let url = image1["url"] as? String {
                        self.image = url
                    }
                }
            }
        }
        return self
    }
}
