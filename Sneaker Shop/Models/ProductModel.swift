


import Foundation
import UIKit
import RealmSwift

class ProductModel: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var sku: String = ""
    @objc dynamic var image: String = ""
    @objc dynamic var link: String = ""
    @objc dynamic var desc: String = ""
    @objc dynamic var content: String = ""
    @objc dynamic var slug: String = ""
    @objc dynamic var price: String = ""
    @objc dynamic var coming_soon: String = ""
    @objc dynamic var views: String = ""
    @objc dynamic var nickname: String = ""
    @objc dynamic var resale: String = ""
    @objc dynamic var created_at: String = ""
    @objc dynamic var updated_at: String = ""
    @objc dynamic var product_id: String = ""
    @objc dynamic var release_date_calendar: String = ""
    @objc dynamic var release_date: String = ""
    @objc dynamic var yes_votes: String = ""
    @objc dynamic var no_votes: String = ""
    @objc dynamic var total_votes: String = ""
    @objc dynamic var likeHateStatus: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func initLoad(_ json:  [String: Any]) -> ProductModel{
        if let temp = json["id"] as? String { id = temp }
        if let temp = json["name"] as? String { name  = temp }
        if let temp = json["sku"] as? String { sku = temp }
        if let temp = json["image"] as? String { image = "http://soleinsider.com/public/products/" + temp }
        if (json["link"] as? String) != nil { link  = "http://soleinsider.com/public/mobile/getSlideShow?product_id=" + id }
        if let temp = json["description"] as? String { desc = temp }
        if let temp = json["content"] as? String { content = temp }
        if let temp = json["slug"] as? String { slug  = temp }
        if let temp = json["price"] as? String { price = temp }
        if let temp = json["coming_soon"] as? String { coming_soon = temp }
        if let temp = json["views"] as? String { views  = temp }
        if let temp = json["nickname"] as? String { nickname = temp }
        if let temp = json["resale"] as? String { resale = temp }
        if let temp = json["created_at"] as? String { created_at  = temp }
        if let temp = json["updated_at"] as? String { updated_at = temp }
        if let temp = json["product_id"] as? String { product_id = temp }
        if let temp = json["release_date_calendar"] as? String { release_date_calendar  = temp }
        if let temp = json["release_date"] as? String { release_date = temp }
        if let temp = json["yes_votes"] as? String { yes_votes = temp }
        if let temp = json["no_votes"] as? String { no_votes  = temp }
        if let temp = json["total_votes"] as? String { total_votes = temp }
        return self
    }
}
