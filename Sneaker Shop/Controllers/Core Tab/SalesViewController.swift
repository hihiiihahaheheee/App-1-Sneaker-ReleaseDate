//
//  SalesViewController.swift
//  Sneaker Shop
//
//  Created by Thuận Nguyễn Văn on 12/12/2020.
//

import UIKit
import SafariServices

class SalesViewController: UIViewController {

    
    var listData = [SaleProductModel]()
    var listBackUpData = [SaleProductModel]()
    var searchField = UITextField()
    let searchButton = UIButton()
    let logoButton = UIButton()
    
    
    struct Constants{
        static let connerRadius:CGFloat = 8.0
    }
    
    
    private let headerView:UIView = {
        let header = UIView()
        header.clipsToBounds = true
        return header
    }()
    
    private let headerLabel:UILabel = {
        let label = UILabel()
        label.text = "Sale"
        label.font = label.font.withSize(18)
        label.textColor = #colorLiteral(red: 0.333101809, green: 0.3331646025, blue: 0.3330978155, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    
    //Product Collection View Inside contentView:
    private let contentView:UIView = {
        let content = UIView()
        content.backgroundColor = .cyan
        return content
    }()
    private var myCollectionView:UICollectionView?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9454912543, green: 0.9456531405, blue: 0.9454810023, alpha: 1)
        addSubViews()
        self.getSaleProduct(){_,_ in}
        //Add search
        
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
        content.title = "Sale"
        content.body = "HOT Sale! Explore Now!"
        
        //Step3: Create Notification Trigger
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 7200, repeats: true)
        
        //Step4: Create Request
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        //Step5: Register the request
        center.add(request) { (error) in
            //Check the error parameter
        }
        
        //End Notification
        

    }
    
    //Data Json
    func getSaleProduct(andCompletion completion:@escaping (_ moviesResponse: [SaleProductModel], _ error: Error?) -> ()) {
        APIService.shared.GetSaleProduct() { (response, error) in
            if let listData = response{
                self.listData = listData
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
        headerView.frame = CGRect(x: 0.0, y: 0.0, width: view.width, height: 110 )
        configureHeaderView()
        headerLabel.frame = CGRect(x: 0.0, y: headerView.bottom, width: view.width, height: 50)
        contentView.frame = CGRect(x: 0.0, y: headerLabel.bottom , width: view.width, height: view.height - headerLabel.bottom)
        configureContentCollectionView()
    }
    
    private func configureHeaderView(){
        
        //Add LogoButton
        logoButton.setImage(UIImage(named: "imgLogo"), for: .normal)
        headerView.addSubview(logoButton)
        logoButton.frame = CGRect( x: 12.0, y: 57.0, width: 50, height: 50)
        
        //Add Search Field
        searchField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        searchField.returnKeyType = .continue
        searchField.leftViewMode = .always
        searchField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        searchField.layer.masksToBounds = true
        searchField.layer.cornerRadius = Constants.connerRadius
        searchField.layer.backgroundColor = #colorLiteral(red: 0.9883330464, green: 0.8827822804, blue: 0.8284615874, alpha: 1)
        searchField.layer.borderWidth = 1.0
        searchField.layer.borderColor = #colorLiteral(red: 0.9688166976, green: 0.603492558, blue: 0.4447279274, alpha: 1)
        headerView.addSubview(searchField)
        searchField.frame = CGRect(x: 81.0, y: 57.0, width: headerView.width - (81 + 45) , height: 50)
        
        //Add Search Button

        let searchImage = UIImage(named: "searchImage")
        searchButton.setImage(searchImage, for: .normal)
        searchButton.tintColor = .white
        searchButton.layer.masksToBounds = true
        searchButton.layer.cornerRadius = Constants.connerRadius
        searchButton.backgroundColor = #colorLiteral(red: 0.9657692313, green: 0.5421426892, blue: 0.3422194719, alpha: 1)
        searchButton.setTitleColor( .white ,for: .normal)
        headerView.addSubview(searchButton)
        searchButton.frame = CGRect( x: searchField.right - 50.0, y: 57.0, width: 50, height: 50)
    }
    
    private func configureContentCollectionView(){
        //Add CollectionView
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        myCollectionView = UICollectionView(frame: CGRect(x: 0 , y: 0, width: contentView.width , height: contentView.height), collectionViewLayout: layout)
        myCollectionView?.register(UINib(nibName: "SaleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SaleCollectionViewCell")
        myCollectionView?.backgroundColor = #colorLiteral(red: 0.9455111623, green: 0.9456469417, blue: 0.9454814792, alpha: 1)
        contentView.addSubview(myCollectionView ?? UICollectionView())
        myCollectionView?.dataSource = self
        myCollectionView?.delegate = self
    }
    
    
    //Button
    @objc private func didTapSearchButton(){
        searchField.resignFirstResponder()
        if let textSearch = searchField.text {
            print(textSearch)
            if textSearch != "" {
                listData.removeAll()
                for item in listBackUpData {
                    if item.brandedName.lowercased().contains(textSearch.lowercased()) {
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
        view.addSubview(headerLabel)
        view.addSubview(contentView)
    }
}

extension SalesViewController:  UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SaleCollectionViewCell", for: indexPath) as! SaleCollectionViewCell
        cell.nameProduct.text = listData[indexPath.row].brandedName
        cell.priceLabel.text = listData[indexPath.row].salePriceLabel
        cell.dateLabel.text = "Release Date: " + listData[indexPath.row].extractDate
        let url = URL(string: listData[indexPath.row].image)
        cell.imgView.kf.setImage(with:url)
        return cell
    
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        //Ads
        if PaymentManager.shared.isPurchase(){
            return
        }
        else{
            AdMobManager.shared.loadAdFull(inVC: self)
        }
        //End Ads
        
        let vc = SaleDetailViewController()
        vc.urlString = listData[indexPath.row].clickUrl
        vc.nameLabel.text = listData[indexPath.row].brandedName
        vc.modalPresentationStyle = .fullScreen        
        present(vc, animated: true)
        

    }
    
    
}

extension SalesViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if UIDevice.current.userInterfaceIdiom == .pad{
            return CGSize(width: UIScreen.main.bounds.width/2 - 60 , height: 200)
        }
        return CGSize(width: UIScreen.main.bounds.width - 60 , height: 200)
    }    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return UIEdgeInsets(top: 0, left: 30.0, bottom: 0, right: 30.0)
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

extension SalesViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchField.resignFirstResponder()
        return true
    }
}
