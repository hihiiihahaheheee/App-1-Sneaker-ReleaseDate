

import Foundation
import UIKit
import RealmSwift

class ProductDetailModel: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var product_id: String = ""
    @objc dynamic var image: String = ""
    
    func initLoad(_ json:  [String: Any]) -> ProductDetailModel{
        if let temp = json["id"] as? String { id = temp }
        if let temp = json["product_id"] as? String { product_id  = temp }
        if let temp = json["image"] as? String { image = "http://soleinsider.com/public/products/" + temp }
        return self
    }
}
