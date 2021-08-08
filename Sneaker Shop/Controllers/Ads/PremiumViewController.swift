
import UIKit
import SwiftyStoreKit
import GoogleMobileAds
import StoreKit
import MBProgressHUD

enum PurchaseType: Int {
    case weekly
    case monthly
    case yearly
}

class PremiumViewController: UIViewController {
    var purchaseType: PurchaseType = .yearly
    private let backButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "backXXX"), for: .normal)
        return btn
    }()
    
    private let buyButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Buy - $9.99", for: .normal)
        btn.layer.cornerRadius = 8.0
        btn.backgroundColor = .green
        return btn
    }()
    
    private let restoreButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Restore Account", for: .normal)
        btn.layer.cornerRadius = 8.0
        btn.backgroundColor = .red
        return btn
    }()
    
    
    //label
    private let premiumLabel:UILabel = {
        let lbl = UILabel()
        lbl.text = "PREMIUM"
        lbl.font = lbl.font.withSize(50)
        lbl.textAlignment = .center
        lbl.textColor = #colorLiteral(red: 0.9657692313, green: 0.5421426892, blue: 0.3422194719, alpha: 1)
        return lbl
    }()
    
    private let unlimitedLabel:UILabel = {
        let lbl = UILabel()
        lbl.text = "Unlimited Access to All Features In One Year"
        lbl.lineBreakMode = NSLineBreakMode.byWordWrapping
        lbl.numberOfLines = 2
        lbl.font = lbl.font.withSize(24)
        lbl.textAlignment = .center
        lbl.textColor = .black
        return lbl
    }()
    

    private let contentLabelOne:UILabel = {
        let lbl = UILabel()
        lbl.text = "Forget about ads and limit"
        lbl.lineBreakMode = NSLineBreakMode.byWordWrapping
        lbl.numberOfLines = 2
        lbl.font = lbl.font.withSize(18)
        lbl.textAlignment = .center
        lbl.textColor = .black
        return lbl
    }()
    private let contentLabelTwo:UILabel = {
        let lbl = UILabel()
        lbl.text = "Keep your sensitive data safely hidden"
        lbl.lineBreakMode = NSLineBreakMode.byWordWrapping
        lbl.numberOfLines = 2
        lbl.font = lbl.font.withSize(18)
        lbl.textAlignment = .center
        lbl.textColor = .black
        return lbl
    }()
    private let contentLabelThree:UILabel = {
        let lbl = UILabel()
        lbl.text = "Get rid of useless files super fast"
        lbl.lineBreakMode = NSLineBreakMode.byWordWrapping
        lbl.numberOfLines = 2
        lbl.font = lbl.font.withSize(18)
        lbl.textAlignment = .center
        lbl.textColor = .black
        return lbl
    }()
    private let contentLabelFour:UILabel = {
        let lbl = UILabel()
        lbl.text = "Give you more best Sales"
        lbl.lineBreakMode = NSLineBreakMode.byWordWrapping
        lbl.numberOfLines = 2
        lbl.font = lbl.font.withSize(18)
        lbl.textAlignment = .center
        lbl.textColor = .black
        return lbl
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubView()
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        buyButton.addTarget(self, action: #selector(didTapBuyButton), for: .touchUpInside)
        restoreButton.addTarget(self, action: #selector(didTapRestoreButton), for: .touchUpInside)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        premiumLabel.frame = CGRect(x: 50.0, y: 60.0, width: view.width - 100.0, height: 80.0)
        backButton.frame = CGRect(x: premiumLabel.right - 20.0 , y: 35.0, width: 50.0, height: 50.0)
        unlimitedLabel.frame = CGRect(x: 50.0, y: premiumLabel.bottom, width: view.width - 100.0, height: 100.0)
        
        contentLabelOne.frame = CGRect(x: 50.0, y: unlimitedLabel.bottom + 20.0, width: view.width - 100.0, height: 50.0)
        contentLabelTwo.frame = CGRect(x: 50.0, y: contentLabelOne.bottom, width: view.width - 100.0, height: 50.0)
        contentLabelThree.frame = CGRect(x: 50.0, y: contentLabelTwo.bottom, width: view.width - 100.0, height: 50.0)
        contentLabelFour.frame = CGRect(x: 50.0, y: contentLabelThree.bottom, width: view.width - 100.0, height: 50.0)
        
        
        let xLength = (view.width - 200.0)/2
        let yLength = (view.height - contentLabelFour.bottom - 100.0)/2 + contentLabelFour.bottom
        buyButton.frame = CGRect(x: xLength , y: yLength , width: 200.0, height: 50.0)
        restoreButton.frame = CGRect(x: xLength, y: buyButton.bottom + 10.0 , width: 200.0, height: 50.0)
        
        
        
    }
    
    
    
    
    func purchasePro(type: PurchaseType){
        var productId = PRODUCT_ID_YEARLY
        if type == .yearly {
            productId = PRODUCT_ID_YEARLY
        }
        SwiftyStoreKit.purchaseProduct(productId, quantity: 1, atomically: false) { result in
            switch result {
            case .success(let product):
                // fetch content from your server, then:
                if product.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(product.transaction)
                }
                let dateFormatter : DateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MMM-dd HH:mm:ss"
                let date = Date()
                let dateString = dateFormatter.string(from: date)
                let interval = date.timeIntervalSince1970
                PaymentManager.shared.savePurchase(time: interval)
                print("Purchase Success: \(product.productId)")
                let fastCleanVC = NewsViewController()
                self.navigationController?.pushViewController(fastCleanVC, animated: true)
            case .error(let error):
                switch error.code {
                case .unknown: print("Unknown error. Please contact support")
                case .clientInvalid: print("Not allowed to make the payment")
                case .paymentCancelled: break
                case .paymentInvalid: print("The purchase identifier was invalid")
                case .paymentNotAllowed: print("The device is not allowed to make the payment")
                case .storeProductNotAvailable: print("The product is not available in the current storefront")
                case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                default: print((error as NSError).localizedDescription)
                }
            }
        }
    }
    
    
    @objc private func didTapBackButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapBuyButton() {
        purchaseType = .yearly
        self.purchasePro(type: .yearly)
    }
    
    @objc private func didTapRestoreButton() {
        SwiftyStoreKit.restorePurchases(atomically: false) { results in
            if results.restoreFailedPurchases.count > 0 {
                print("Restore Failed: \(results.restoreFailedPurchases)")
            }
            else if results.restoredPurchases.count > 0 {
                for purchase in results.restoredPurchases {
                    // fetch content from your server, then:
                    if purchase.needsFinishTransaction {
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                }
                let dateFormatter : DateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MMM-dd HH:mm:ss"
                let date = Date()
                let dateString = dateFormatter.string(from: date)
                let interval = date.timeIntervalSince1970
                PaymentManager.shared.savePurchase(time: interval)
//                print("Purchase Success: \(product.productId)")
                let fastCleanVC = NewsViewController()
                self.navigationController?.pushViewController(fastCleanVC, animated: true)
            }
            else {
                print("Nothing to Restore")
            }
        }
    }
    
    
    private func addSubView(){
        view.addSubview(backButton)
        view.addSubview(buyButton)
        view.addSubview(restoreButton)
        view.addSubview(premiumLabel)
        view.addSubview(unlimitedLabel)
        view.addSubview(contentLabelOne)
        view.addSubview(contentLabelTwo)
        view.addSubview(contentLabelThree)
        view.addSubview(contentLabelFour)
    }
}
