//
//  SettingViewController.swift
//  Sneaker Shop
//
//  Created by Thuận Nguyễn Văn on 11/01/2021.
//

import UIKit
import StoreKit
import DoneHUD

class SettingViewController: UIViewController {

    
    //Header
    let nameLabel = UILabel()
    private let headerView:UIView = {
        let v = UIView()
        return v
    }()
    
    private let logoImage: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "logoSetting")
        return v
    }()
    
    private let contentView:UIView = {
        let v = UIView()
        v.layer.cornerRadius = 15.0
        return v
    }()
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9455111623, green: 0.9456469417, blue: 0.9454814792, alpha: 1)
        addSubViews()
        nameLabel.text = "Setting"
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headerView.frame = CGRect(x: 30.0, y: 0.0, width: view.width - 60 , height: 80)        
        configHeaderView()
        logoImage.frame = CGRect(x: 30.0, y: headerView.bottom + 20.0, width: view.width - 60.0, height: 250.0)
        
        
//        var yLength = ((view.height - logoImage.bottom) - view.height/3)/2
        contentView.frame = CGRect(x: 30.0, y: logoImage.bottom + 20.0, width: view.width - 60.0, height: view.height/3)
        configureContentCollectionView()
    }
    
    
    
    
    private func configHeaderView(){
        //Back Button
        let backButton = UIButton()
        //        backButton.backgroundColor = #colorLiteral(red: 0.9999160171, green: 1, blue: 0.9998720288, alpha: 1)
        backButton.tintColor = #colorLiteral(red: 0.1479672389, green: 0.1602073631, blue: 0.1779892231, alpha: 1)
        backButton.layer.cornerRadius = 2
        backButton.setImage(UIImage(named: "backMedium"), for: .normal)
        backButton.frame = CGRect(x: 0.0, y: headerView.bottom - 35.0 , width: 30, height: 30)
        headerView.addSubview(backButton)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        
        //Name Product Label
        nameLabel.font = nameLabel.font.withSize(18)
        nameLabel.textColor = #colorLiteral(red: 0.3333024085, green: 0.3333537579, blue: 0.3332862258, alpha: 1)
        nameLabel.frame = CGRect(x: backButton.right + 10 , y:  headerView.bottom - 30.0 , width: headerView.width - backButton.width*2, height: 20)
        nameLabel.textAlignment = .center
        headerView.addSubview(nameLabel)
    }
    
    private func configureContentCollectionView(){
        let aboutButton = UIButton()
        aboutButton.setTitle("About Me", for: .normal)
        aboutButton.backgroundColor = #colorLiteral(red: 0.9727737308, green: 0.6034361124, blue: 0.4412645698, alpha: 1)
        aboutButton.layer.cornerRadius = 15.0
        aboutButton.layer.borderWidth = 1.0
        aboutButton.layer.borderColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        aboutButton.frame = CGRect(x: 10.0, y: 10.0, width: contentView.width - 20.0, height: (contentView.height - 50.0)/4)
        contentView.addSubview(aboutButton)
        
        
        let shareButton = UIButton()
        shareButton.setTitle("Share App", for: .normal)
        shareButton.backgroundColor = #colorLiteral(red: 0.9727737308, green: 0.6034361124, blue: 0.4412645698, alpha: 1)
        shareButton.layer.cornerRadius = 15.0
        shareButton.layer.borderWidth = 1.0
        shareButton.layer.borderColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        shareButton.frame = CGRect(x: 10.0, y: aboutButton.bottom + 10.0, width: contentView.width - 20.0, height: (contentView.height - 50.0)/4)
        contentView.addSubview(shareButton)
        
        
        let rateButton = UIButton()
        rateButton.setTitle("Rate App", for: .normal)
        rateButton.backgroundColor = #colorLiteral(red: 0.9727737308, green: 0.6034361124, blue: 0.4412645698, alpha: 1)
        rateButton.layer.cornerRadius = 15.0
        rateButton.layer.borderWidth = 1.0
        rateButton.layer.borderColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        rateButton.frame = CGRect(x: 10.0, y: shareButton.bottom + 10.0, width: contentView.width - 20.0, height: (contentView.height - 50.0)/4)
        contentView.addSubview(rateButton)
        
        
        let premiumButton = UIButton()
        premiumButton.setTitle("Go to Premium", for: .normal)
        premiumButton.backgroundColor = #colorLiteral(red: 0.9727737308, green: 0.6034361124, blue: 0.4412645698, alpha: 1)
        premiumButton.layer.cornerRadius = 15.0
        premiumButton.layer.borderWidth = 1.0
        premiumButton.layer.borderColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        premiumButton.frame = CGRect(x: 10.0, y: rateButton.bottom + 10.0, width: contentView.width - 20.0, height: (contentView.height - 50.0)/4)
        contentView.addSubview(premiumButton)
        
        //target
        aboutButton.addTarget(self, action: #selector(didTapAboutButton), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
        rateButton.addTarget(self, action: #selector(didTapRateButton), for: .touchUpInside)
        premiumButton.addTarget(self, action: #selector(didTapPremiumButton), for: .touchUpInside)
        
    }
    
    @objc private func didTapBackButton(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapAboutButton(){
        let alert = UIAlertController(title: "Developer", message: "Nguyen Van Thuan", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    @objc private func didTapShareButton(){
        UIPasteboard.general.string = "https://apps.apple.com/us/app/sneaker-release-date-pro/id1548719361?fbclid=IwAR00IqypDE3adcCbSrSGah0JmqeSDGKIaCPU-RaXpM3w761JN8A_s1PXVhY"
        DoneHUD.showInView(view, message: "Copy Done")
    }
    @objc private func didTapRateButton(){
        if #available(iOS 13.0, *) {
                    if let scene = UIApplication.shared.currentScene {
                        if #available(iOS 14.0, *) {
                            SKStoreReviewController.requestReview(in: scene)
                        } else {
                            SKStoreReviewController.requestReview()
                        }
                    }
                }
    }
    @objc private func didTapPremiumButton(){
        let vc = PremiumViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    
    
    
    private func addSubViews(){
        view.addSubview(headerView)
        view.addSubview(contentView)
        view.addSubview(logoImage)
    }
}

extension UIApplication {
    @available(iOS 13.0, *)
    var currentScene: UIWindowScene? {
        connectedScenes
            .first { $0.activationState == .foregroundActive } as? UIWindowScene
    }
}
