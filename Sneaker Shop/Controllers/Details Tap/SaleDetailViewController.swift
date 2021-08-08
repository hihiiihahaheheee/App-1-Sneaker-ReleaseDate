import UIKit
import HTMLKit
import WebKit
import JGProgressHUD
import DoneHUD

class SaleDetailViewController: UIViewController {
    
    
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
    
    public var urlString = ""
    
    private let hud = JGProgressHUD()
    
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
        self.webView.scrollView.subviews.forEach { $0.isUserInteractionEnabled = false }
        //Loading Delay
        hud.textLabel.text = "Loading"
        hud.show(in: self.view)
        
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
        nameLabel.frame = CGRect(x: backButton.right + 10.0 , y:  headerView.bottom - 30.0 , width: headerView.width - backButton.width*3, height: 20)
        nameLabel.textAlignment = .center
        headerView.addSubview(nameLabel)
        //Get URL Button
        let getUrlButton = UIButton()
        getUrlButton.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        getUrlButton.tintColor = .black
        getUrlButton.layer.cornerRadius = 2
        getUrlButton.setTitle("Link", for: .normal)
        getUrlButton.titleLabel?.font = .systemFont(ofSize: 11)
        getUrlButton.layer.cornerRadius = 4
        getUrlButton.clipsToBounds = true
        getUrlButton.frame = CGRect(x: nameLabel.right + 5.0, y: headerView.bottom - 35.0 , width: 40, height: 30)
        getUrlButton.addTarget(self, action: #selector(didTapGetUrlButton), for: .touchUpInside)
        headerView.addSubview(getUrlButton)
    }
    
    @objc private func didTapBackButton(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapGetUrlButton() {
        UIPasteboard.general.string = urlString
        DoneHUD.showInView(view, message: "Done")
    }
    
}




extension SaleDetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hud.dismiss(afterDelay: 3.0)
    }
}

