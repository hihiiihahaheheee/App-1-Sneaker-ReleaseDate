        
        import UIKit
        
        typealias ApiCompletion = (_ data: Any?, _ error: Error?) -> ()
        
        typealias ApiParam = [String: Any]
        
        enum ApiMethod: String {
            case GET = "GET"
            case POST = "POST"
        }
        extension String {
            func addingPercentEncodingForURLQueryValue() -> String? {
                let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
                return self.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
            }
        }
        
        extension Dictionary {
            func stringFromHttpParameters() -> String {
                let parameterArray = self.map { (key, value) -> String in
                    let percentEscapedKey = (key as! String).addingPercentEncodingForURLQueryValue()!
                    if value is String {
                        let percentEscapedValue = (value as! String).addingPercentEncodingForURLQueryValue()!
                        return "\(percentEscapedKey)=\(percentEscapedValue)"
                    }
                    else {
                        return "\(percentEscapedKey)=\(value)"
                    }
                }
                return parameterArray.joined(separator: "&")
            }
        }
        class APIService:NSObject {
            static let shared: APIService = APIService()
            
            func requestSON(_ url: String,
                            param: ApiParam?,
                            method: ApiMethod,
                            loading: Bool,
                            completion: @escaping ApiCompletion)
            {
                var request:URLRequest!
                
                // set method & param
                if method == .GET {
                    if let paramString = param?.stringFromHttpParameters() {
                        request = URLRequest(url: URL(string:"\(url)?\(paramString)")!)
                    }
                    else {
                        request = URLRequest(url: URL(string:url)!)
                    }
                }
                else if method == .POST {
                    request = URLRequest(url: URL(string:url)!)
                    
                    // content-type
                    let headers: Dictionary = ["Content-Type": "application/json"]
                    request.allHTTPHeaderFields = headers
                    
                    do {
                        if let p = param {
                            request.httpBody = try JSONSerialization.data(withJSONObject: p, options: .prettyPrinted)
                        }
                    } catch { }
                }
                
                request.timeoutInterval = 30
                request.httpMethod = method.rawValue
                
                //
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    
                    DispatchQueue.main.async {
                        // check for fundamental networking error
                        guard let data = data, error == nil else {
                            completion(nil, error)
                            return
                        }
                        
                        // check for http errors
                        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200, let res = response {
                        }
                        
                        if let resJson = self.convertToJson(data) {
                            completion(resJson, nil)
                        }
                        else if let resString = String(data: data, encoding: .utf8) {
                            completion(resString, error)
                        }
                        else {
                            completion(nil, error)
                        }
                    }
                }
                task.resume()
            }
            
            private func convertToJson(_ byData: Data) -> Any? {
                do {
                    return try JSONSerialization.jsonObject(with: byData, options: [])
                } catch {
                    //            self.debug("convert to json error: \(error)")
                }
                return nil
            }
    
            
            //Get Product 
            func GetProduct(closure: @escaping (_ response: [ProductModel]?, _ error: Error?) -> Void) {
                requestSON("http://soleinsider.com/mobileapi/releaseDatesUnformatted", param: nil, method: .GET, loading: true) { (data, error) in
                    if let d = data as? [[String: Any]]
                    {
                        var listProductReturn:[ProductModel] = [ProductModel]()
                        for item in d {
                            var productAdd:ProductModel = ProductModel()
                            productAdd = productAdd.initLoad(item)
                            listProductReturn.append(productAdd)
                        }
                        closure(listProductReturn,nil)
                    }
                    else
                    {
                        closure(nil,nil)
                    }
                    
                }
            }
            
            //Get Detail Product
            func GetDetailProduct(linkData: String,closure: @escaping (_ response: [ProductDetailModel]?, _ error: Error?) -> Void) {
                requestSON(linkData, param: nil, method: .GET, loading: true) { (data, error) in
                    if let d = data as? [[String: Any]]
                    {
                        var listProductReturn:[ProductDetailModel] = [ProductDetailModel]()
                        for item in d {
                            var productAdd:ProductDetailModel = ProductDetailModel()
                            productAdd = productAdd.initLoad(item)
                            listProductReturn.append(productAdd)
                        }
                        closure(listProductReturn,nil)
                    }
                    else
                    {
                        closure(nil,nil)
                    }
                    
                }
            }
            
            
            
            
            
            
            
            //Get News Product
            func GetNewsProduct( closure: @escaping (_ response: [NewsProductModel]?, _ error: Error?) -> Void) {
                requestSON("http://soleinsider.com/mobileapi/news", param: nil, method: .GET, loading: true) { (data, error) in
                    if let d = data as? [[String: Any]]
                    {
                        var listProductDetailReturn:[NewsProductModel] = [NewsProductModel]()
                        for item in d {
                            var productAdd:NewsProductModel = NewsProductModel()
                            productAdd = productAdd.initLoad(item)
                            listProductDetailReturn.append(productAdd)
                        }
                        closure(listProductDetailReturn,nil)
                    }
                    else
                    {
                        closure(nil,nil)
                    }
                    
                }
            }
            
            
            //Sale Product
            func GetSaleProduct( closure: @escaping (_ response: [SaleProductModel]?, _ error: Error?) -> Void) {
                requestSON("http://api.shopstyle.com/api/v2/products?&fts=nike+sneakers&pid=uid3600-8502060-94&?&fl=d101&fl=d100&&fl=p20:27&limit=75", param: nil, method: .GET, loading: true) { (data, error) in
                    if let d = data as? [String: Any]
                    {
                        var listProductReturn:[SaleProductModel] = [SaleProductModel]()
                        if let product = d["products"] as? [[String:Any]]{
                            for item in product {
                                var productAdd:SaleProductModel = SaleProductModel()
                                productAdd = productAdd.initLoad(item)
                                listProductReturn.append(productAdd)
                            }
                        }
                        closure(listProductReturn,nil)
                    }
                    else
                    {
                        closure(nil,nil)
                    }
                }
            }
            
            
            
        }
        
