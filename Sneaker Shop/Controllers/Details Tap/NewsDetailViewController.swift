//
//  NewsDetailViewController.swift
//  Sneaker Shop
//
//  Created by Thuận Nguyễn Văn on 11/01/2021.
//

import UIKit
import HTMLKit
import WebKit
import JGProgressHUD

class NewsDetailViewController: UIViewController {
    
    
    private let headerView: UIView = {
        let hearderView = UIView()
        return hearderView
    }()
    let nameLabel = UILabel()
    
    private let webView: WKWebView = {
        let prefs = WKPreferences()
        prefs.javaScriptEnabled = false
        let config = WKWebViewConfiguration()
        config.preferences = prefs
        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }()
    private let hud = JGProgressHUD()
    
    public var urlString = ""    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(headerView)
        view.addSubview(webView)
       
        webView.navigationDelegate = self
        guard let url = URL(string: urlString) else {
            return
        }
        webView.load(URLRequest(url: url))
        
        
        //Loading Delay
        hud.textLabel.text = "Loading"
        hud.show(in: self.view)
        self.webView.scrollView.subviews.forEach { $0.isUserInteractionEnabled = false }
    }
    override func viewDidLayoutSubviews() {
        headerView.frame = CGRect(x: 30.0, y: 0.0, width: view.width - 60 , height: 80)
        webView.frame = CGRect(x: 0.0, y: headerView.bottom, width: view.width, height: view.height - 30.0)
        configureHeaderView()
    }
    

    private func configureHeaderView(){
        //Back Button
        let backButton = UIButton()
        //        backButton.backgroundColor = #colorLiteral(red: 0.9999160171, green: 1, blue: 0.9998720288, alpha: 1)
        backButton.tintColor = #colorLiteral(red: 0.3333024085, green: 0.3333537579, blue: 0.3332862258, alpha: 1)
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
    
    @objc private func didTapBackButton(){
        self.dismiss(animated: true, completion: nil)
    }
    
}




extension NewsDetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hud.dismiss()
    }
}
