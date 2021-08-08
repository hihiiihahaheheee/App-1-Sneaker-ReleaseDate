//
//  AdNativeCell.swift
//  IQ Solution
//
//  Created by Hius on 12/13/20.
//

import UIKit
import GoogleMobileAds

class AdNativeCell: UICollectionReusableView {

    @IBOutlet weak var nativeAdView: GADUnifiedNativeAdView!

    override func awakeFromNib() {
        super.awakeFromNib()
        AdMobManager.shared.nativeAdView = nativeAdView
    }

}
