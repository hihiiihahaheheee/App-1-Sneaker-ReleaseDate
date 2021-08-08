//
//  PaymentManager.swift
//  IQ Solution
//
//  Created by Hius on 12/12/20.
//

import UIKit

class PaymentManager: NSObject {

    static let shared = PaymentManager()

    var isVerifyError = true

    func isPurchase() -> Bool {
        if let time = UserDefaults.standard.value(forKey: "purchaseTime") as? TimeInterval {
            let timeInterval = Date().timeIntervalSince1970
            if timeInterval > time {
                return false
            }
            return true
        }
        return false
    }
    

    func savePurchase(time: TimeInterval) {
        UserDefaults.standard.setValue(time, forKey: "purchaseTime")
    }
}
