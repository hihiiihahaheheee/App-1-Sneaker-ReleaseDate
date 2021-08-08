
import Foundation
import UIKit
import RealmSwift

class NewsProductModel: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var descriptionx : String = ""
    @objc dynamic var source: String = ""
    @objc dynamic var category: String = ""
    @objc dynamic var slug: String = ""
    @objc dynamic var hashx: String = ""
    @objc dynamic var create_at: String = ""
    @objc dynamic var update_at: String = ""
    
    func initLoad(_ json:  [String: Any]) -> NewsProductModel{
        if let temp = json["id"] as? String { id = temp }
        if let temp = json["title"] as? String { title  = temp }
        if let temp = json["description"] as? String { descriptionx = temp }
        if let temp = json["source"] as? String { source = temp }
        if let temp = json["category"] as? String { category  = temp }
        if let temp = json["slug"] as? String { slug = temp }
        if let temp = json["hashx"] as? String { hashx = temp }
        if let temp = json["create_at"] as? String { create_at  = temp }
        if let temp = json["update_at"] as? String { update_at = temp }
        return self
    }
}
