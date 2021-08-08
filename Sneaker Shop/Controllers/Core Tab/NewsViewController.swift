//
//  NewsViewController.swift
//  Sneaker Shop
//
//  Created by Thuận Nguyễn Văn on 12/12/2020.
//

import UIKit
import Kingfisher
import SafariServices
import UserNotifications
class NewsViewController: UIViewController {
    
    
    let searchField = UITextField()
    let searchButton = UIButton()
    let logoButton = UIButton()
    var listBackUpData = [NewsProductModel]()
    var listData = [NewsProductModel]()
    private let headerView:UIView = {
        let header = UIView()
        header.clipsToBounds = true
        return header
    }()
    
    private let headerLabel:UILabel = {
        let label = UILabel()
        label.text = "News"
        label.font = label.font.withSize(18)
        label.textColor = #colorLiteral(red: 0.333101809, green: 0.3331646025, blue: 0.3330978155, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    
    //Content Collection View:
    private let contentView:UIView = {
        let contentV = UIView()
        return contentV
    }()
    private var myCollectionView:UICollectionView?
    override func viewDidLoad() {
        super.viewDidLoad()
        //Load Check Purchase
        
        if PaymentManager.shared.isPurchase(){
        
        }else{
            DispatchQueue.main.async {
                let vc = PremiumViewController()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }
        
        //End Purchase
        view.backgroundColor = #colorLiteral(red: 0.9454912543, green: 0.9456531405, blue: 0.9454810023, alpha: 1)        
        addSubViews()
        self.getNewsProduct(){_,_ in}
        
        searchField.delegate = self
        searchButton.addTarget(self, action: #selector(didTapSearchButton), for: .touchUpInside)
        logoButton.addTarget(self, action: #selector(didTapLogoButton), for: .touchUpInside)
        
        //Notification
        
        //Step1: Ask for permission
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
        }
        
        //Step2: Create Notification Content
        let content = UNMutableNotificationContent()
        content.title = "News"
        content.body = "discover more shoes"
        
        //Step3: Create Notification Trigger
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 86400, repeats: true)
        
        //Step4: Create Request
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        //Step5: Register the request
        center.add(request) { (error) in
            //Check the error parameter
        }
        
        //End Notification       

    }
    
    func getNewsProduct(andCompletion completion:@escaping (_ moviesResponse: [NewsProductModel], _ error: Error?) -> ()) {
        APIService.shared.GetNewsProduct() { (response, error) in
            if let listDataResponse = response{
                //Handle Data :
                self.listData = listDataResponse
                for item in self.listData {
                    let html = item.descriptionx
                    let htmlArray = html.components(separatedBy: " ")
                    let temLinkImg = htmlArray[4]
                    if temLinkImg.contains("https://www") == false {
                        self.listData.removeAll(){value in
                            return value == item
                        }
                    }
                }
                self.listBackUpData = self.listData
                DispatchQueue.main.async {
                    self.myCollectionView?.reloadData()
                }
            }
            completion(self.listData, error)
        }
    }
    override func viewDidLayoutSubviews() {
        //Assign Frame
        super.viewDidLayoutSubviews()
        headerView.frame = CGRect(x: 0.0, y: 0.0, width: view.width, height: 110)
        configureHeaderView()
        headerLabel.frame = CGRect(x: 0.0, y: headerView.bottom, width: view.width, height: 50)        
        contentView.frame = CGRect(x: 0.0, y: headerLabel.bottom , width: view.width, height: view.bottom - headerLabel.bottom )
        configureContentCollectionView()
        
    }
    private func configureHeaderView(){
        //Add LogoButton

        logoButton.setImage(UIImage(named: "imgLogo"), for: .normal)
        headerView.addSubview(logoButton)
        logoButton.frame = CGRect(x: 12.0, y: 57.0,width: 50, height: 50)
        
        //Add Search Field
        searchField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        searchField.returnKeyType = .continue
        searchField.leftViewMode = .always
        searchField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        searchField.layer.masksToBounds = true
        searchField.layer.cornerRadius = 8.0
        searchField.layer.backgroundColor = #colorLiteral(red: 0.9883330464, green: 0.8827822804, blue: 0.8284615874, alpha: 1)
        searchField.layer.borderWidth = 1.0
        searchField.layer.borderColor = #colorLiteral(red: 0.9688166976, green: 0.603492558, blue: 0.4447279274, alpha: 1)
        headerView.addSubview(searchField)
        searchField.frame = CGRect(x: 81.0, y: 57.0, width: headerView.width - (81 + 45 ), height: 50)
        
        //Add Search Button
        let searchImage = UIImage(named: "searchImage")
        searchButton.setImage(searchImage, for: .normal)
        searchButton.tintColor = .white
        searchButton.layer.masksToBounds = true
        searchButton.layer.cornerRadius = 8.0
        searchButton.backgroundColor = #colorLiteral(red: 0.9657692313, green: 0.5421426892, blue: 0.3422194719, alpha: 1)
        searchButton.setTitleColor( .white ,for: .normal)
        headerView.addSubview(searchButton)
        searchButton.frame = CGRect(x: searchField.right - 50.0, y: 57.0, width: 50, height: 50)
        
    }
    
    private func configureContentCollectionView(){
        //Add CollectionView
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: contentView.width - 50 , height: 100)
        myCollectionView = UICollectionView(frame: CGRect(x: 0 , y: 0, width: contentView.width , height: contentView.height), collectionViewLayout: layout)
        myCollectionView?.register(UINib(nibName: "NewsProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "NewsProductCollectionViewCell")
        myCollectionView?.backgroundColor = #colorLiteral(red: 0.9454912543, green: 0.9456531405, blue: 0.9454810023, alpha: 1) 
        contentView.addSubview(myCollectionView ?? UICollectionView())
        myCollectionView?.dataSource = self
        myCollectionView?.delegate = self
    }
    
    //Button
    @objc private func didTapSearchButton(){
        searchField.resignFirstResponder()
        if let textSearch = searchField.text {
            if textSearch != "" {
                listData.removeAll()
                for item in listBackUpData {
                    if item.title.lowercased().contains(textSearch.lowercased()) {
                        listData.append(item)
                    }
                }
                myCollectionView?.reloadData()
            }
            else {
                listData = listBackUpData
                myCollectionView?.reloadData()
            }
        }
        else{
            listData = listBackUpData
            myCollectionView?.reloadData()
        }
    }
    
    @objc private func didTapLogoButton(){
        let vc = SettingViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    
    //Add Sub View:
    private func addSubViews(){
        view.addSubview(headerView)
        self.view.addSubview(headerLabel)
        self.view.addSubview(contentView)
    }
}

//Entension:
extension NewsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsProductCollectionViewCell", for: indexPath) as! NewsProductCollectionViewCell

        //Handlding Image
        let html = listData[indexPath.row].descriptionx
        var linkImg = ""
        let htmlArray = html.components(separatedBy: " ")
        let temLinkImg = htmlArray[4]
        let linkImgArray = temLinkImg.components(separatedBy: "\"")
        if linkImgArray.count >= 2 {
            linkImg = linkImgArray[1]
        }
        //Set Value
        let url = URL(string: linkImg)
        cell.imgView.kf.setImage(with:url)
        cell.labelProduct.text = listData[indexPath.row].title
        return cell
    }
}

extension NewsViewController: UICollectionViewDelegate {
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //ads
        if indexPath.row % 2 == 0{
            if PaymentManager.shared.isPurchase(){
                return
            }
            else{
                AdMobManager.shared.loadAdFull(inVC: self)
            }
        }
        //End Ads
        
        //Get URL String From Data
        let html = listData[indexPath.row].descriptionx
        var linkWeb = ""
        let htmlArray = html.components(separatedBy: " ")
        let tempLinkWeb = htmlArray[1]
        linkWeb = tempLinkWeb.components(separatedBy: "'")[1]
        let vc = NewsDetailViewController()
        vc.urlString = linkWeb
        vc.nameLabel.text = listData[indexPath.row].title
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
        

        
    }
}
extension NewsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad){
            return CGSize(width: UIScreen.main.bounds.width, height: 120)
        }else{
            let width = (Int(collectionView.bounds.size.width))
            return CGSize(width: width, height: 120)
        }
    }
}

extension NewsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchField.resignFirstResponder()
        return true
    }
}
