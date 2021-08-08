//
//  AdMobManager.swift
//  IQ Solution
//
//  Created by Hius on 12/12/20.
//

import GoogleMobileAds
import UIKit

class AdMobManager: NSObject, GADUnifiedNativeAdDelegate {

    static let shared = AdMobManager()

    var interstitial: GADInterstitial!
    var bannerView: GADBannerView!

    var fullRootViewController: UIViewController!

    var nativeAdView: GADUnifiedNativeAdView!

    var adLoader: GADAdLoader!

    var heightConstraint: NSLayoutConstraint?

    override init() {
        super.init()
        self.createAndLoadInterstitial()
    }

    func loadAdNative() {
        if PaymentManager.shared.isPurchase() {
            return
        } else {
            adLoader = GADAdLoader(adUnitID: nativeAdID, rootViewController: fullRootViewController,
                adTypes: [.unifiedNative], options: nil)
            adLoader.delegate = self
            adLoader.load(GADRequest())
        }
    }


    func loadAdFull(inVC: UIViewController) {
        if PaymentManager.shared.isPurchase() { return }
        if interstitial.isReady {
            interstitial.present(fromRootViewController: inVC)
        }
    }

}

extension AdMobManager: GADBannerViewDelegate {
    func loadBannerView(inVC: UIViewController) {
        if PaymentManager.shared.isPurchase() {
            return
        } else {
            let bannerView = GADBannerView.init(adSize: kGADAdSizeSmartBannerPortrait)
            bannerView.translatesAutoresizingMaskIntoConstraints = false
            inVC.view.addSubview(bannerView)
            inVC.view.addConstraints(
                [NSLayoutConstraint(item: bannerView,
                    attribute: .bottom,
                    relatedBy: .equal,
                    toItem: inVC.bottomLayoutGuide,
                    attribute: .top,
                    multiplier: 1,
                    constant: 0),
                    NSLayoutConstraint(item: bannerView,
                        attribute: .centerX,
                        relatedBy: .equal,
                        toItem: inVC.view,
                        attribute: .centerX,
                        multiplier: 1,
                        constant: 0)
                ])

            bannerView.adUnitID = bannerAdID
            bannerView.rootViewController = inVC
            bannerView.delegate = self
            let request = GADRequest()
            bannerView.load(request)
        }
    }

    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.alpha = 0
        UIView.animate(withDuration: 1, animations: {
            bannerView.alpha = 1
        })
    }
}

extension AdMobManager: GADInterstitialDelegate {

    func createAndLoadInterstitial() {
        if PaymentManager.shared.isPurchase() {
            return
        } else {
            interstitial = GADInterstitial(adUnitID: interAdID)
            interstitial.delegate = self
            interstitial.load(GADRequest())
        }

    }

    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        self.createAndLoadInterstitial()
    }
}

extension AdMobManager: GADVideoControllerDelegate {
    func videoControllerDidEndVideoPlayback(_ videoController: GADVideoController) {
    }
}

extension AdMobManager: GADAdLoaderDelegate {
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
        print("\(adLoader) failed with error: \(error.localizedDescription)")
    }
}

extension AdMobManager: GADUnifiedNativeAdLoaderDelegate {
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADUnifiedNativeAd) {
        nativeAdView.nativeAd = nativeAd

        // Set ourselves as the native ad delegate to be notified of native ad events.
        nativeAd.delegate = self

        // Deactivate the height constraint that was set when the previous video ad loaded.
        heightConstraint?.isActive = false

        // Populate the native ad view with the native ad assets.
        // The headline and mediaContent are guaranteed to be present in every native ad.
        (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline
        nativeAdView.mediaView?.mediaContent = nativeAd.mediaContent

        // Some native ads will include a video asset, while others do not. Apps can use the
        // GADVideoController's hasVideoContent property to determine if one is present, and adjust their
        // UI accordingly.
        let mediaContent = nativeAd.mediaContent
        if mediaContent.hasVideoContent {
            // By acting as the delegate to the GADVideoController, this ViewController receives messages
            // about events in the video lifecycle.
            mediaContent.videoController.delegate = self
            mediaContent.videoController.setMute(true)
        }

        // This app uses a fixed width for the GADMediaView and changes its height to match the aspect
        // ratio of the media it displays.
        if let mediaView = nativeAdView.mediaView, nativeAd.mediaContent.aspectRatio > 0 {
            heightConstraint = NSLayoutConstraint(item: mediaView,
                attribute: .height,
                relatedBy: .equal,
                toItem: mediaView,
                attribute: .width,
                multiplier: CGFloat(1 / nativeAd.mediaContent.aspectRatio),
                constant: 0)
            heightConstraint?.isActive = true
        }

        // These assets are not guaranteed to be present. Check that they are before
        // showing or hiding them.
//        (nativeAdView.bodyView as? UILabel)?.text = nativeAd.body
//        nativeAdView.bodyView?.isHidden = nativeAd.body == nil

        (nativeAdView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
        nativeAdView.callToActionView?.isHidden = nativeAd.callToAction == nil

        (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon?.image
        nativeAdView.iconView?.isHidden = nativeAd.icon == nil

//        (nativeAdView.starRatingView as? UIImageView)?.image = imageOfStars(from: nativeAd.starRating)
//        nativeAdView.starRatingView?.isHidden = nativeAd.starRating == nil
//
//        (nativeAdView.storeView as? UILabel)?.text = nativeAd.store
//        nativeAdView.storeView?.isHidden = nativeAd.store == nil
//
//        (nativeAdView.priceView as? UILabel)?.text = nativeAd.price
//        nativeAdView.priceView?.isHidden = nativeAd.price == nil

//        (nativeAdView.advertiserView as? UILabel)?.text = nativeAd.advertiser
//        nativeAdView.advertiserView?.isHidden = nativeAd.advertiser == nil

        // In order for the SDK to process touch events properly, user interaction should be disabled.
        nativeAdView.callToActionView?.isUserInteractionEnabled = false
    }

}

