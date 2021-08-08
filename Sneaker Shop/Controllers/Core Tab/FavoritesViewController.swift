//
//  FavoritesViewController.swift
//  Sneaker Shop
//
//  Created by Thuận Nguyễn Văn on 12/12/2020.
//

import UIKit
import RealmSwift

class FavoritesViewController: UIViewController {

    let realm = try! Realm()
    var listBackUpData = [ProductModel]()
    var listData = [ProductModel]()
    struct Constants{
        static let connerRadius:CGFloat = 8.0
    }
    let searchField = UITextField()
    let searchButton = UIButton()
    let logoButton = UIButton()
    
    
    private let headerView:UIView = {
        let header = UIView()
        header.clipsToBounds = true
        return header
    }()
    
    private let headerLabel:UILabel = {
        let label = UILabel()
        label.text = "Favorites"
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
        updateData()
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9454912543, green: 0.9456531405, blue: 0.9454810023, alpha: 1)
        addSubViews()
        myCollectionView?.reloadData()       
        
        searchField.delegate = self
        searchButton.addTarget(self, action: #selector(didTapSearchButton), for: .touchUpInside)
        logoButton.addTarget(self, action: #selector(didTapLogoButton), for: .touchUpInside)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateData()
        myCollectionView?.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        updateData()
        myCollectionView?.reloadData()
    }
    
    
    
    override func viewDidLayoutSubviews() {
        //Assign Frame
        super.viewDidLayoutSubviews()
        headerView.frame = CGRect(x: 0.0, y: 0.0, width: view.width, height: 110)
        configureHeaderView()
        headerLabel.frame = CGRect(x: 0.0, y: headerView.bottom, width: view.width, height: 50)
        contentView.frame = CGRect(x: 0.0, y: headerLabel.bottom , width: view.width, height: view.height - headerLabel.bottom)
        configureContentCollectionView()
   }
    
    private func configureHeaderView(){
        //Add LogoButton

        logoButton.setImage(UIImage(named: "imgLogo"), for: .normal)
        headerView.addSubview(logoButton)
        logoButton.frame = CGRect(x: 12.0, y: 57.0, width: 50, height: 50)
        
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
        searchField.frame = CGRect(
            x: 81.0,
            y: 57.0,
            width: headerView.width - (81 + 45)  ,
            height: 50)
        
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
        layout.itemSize = CGSize(width: contentView.width - 50 , height: 200)
        myCollectionView = UICollectionView(frame: CGRect(x: 0 , y: 0, width: contentView.width , height: contentView.height), collectionViewLayout: layout)
        myCollectionView?.register(UINib(nibName: "FavoriteCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FavoriteCollectionViewCell")
        myCollectionView?.backgroundColor = #colorLiteral(red: 0.9455111623, green: 0.9456469417, blue: 0.9454814792, alpha: 1)
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
                    if item.name.lowercased().contains(textSearch.lowercased()) {
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




extension FavoritesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCollectionViewCell", for: indexPath) as! FavoriteCollectionViewCell
        cell.heartButton.tag = indexPath.row
        cell.dateLabel.text = listData[indexPath.row].release_date
        cell.priceLabel.text = "$" + listData[indexPath.row].price
        cell.heartButton.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        cell.nameProduct.text = listData[indexPath.row].name
        let url = URL(string: listData[indexPath.row].image)
        cell.imgView.kf.setImage(with:url)
        return cell
    }
    
    
    private func updateData(){
        let result = realm.objects(ProductModel.self)
        let listAdd = Array(result)
        listData.removeAll()
        for item in listAdd {
            if item.likeHateStatus == "true" {
                listData.append(item)
            }
        }
        listBackUpData = listData
    }
    @objc private func didTapLikeButton(_ sender: UIButton){
        let i = sender.tag
        try! realm.write {
            listData[i].likeHateStatus = ""
            realm.add(listData[i], update: .all)
            updateData()
        }
        myCollectionView?.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        //ads
        if indexPath.row % 2 == 0 {
            if PaymentManager.shared.isPurchase(){
                return
            }
            else{
                AdMobManager.shared.loadAdFull(inVC: self)
            }
        }
        //End Ads
        
        let vc  = ProductDetailViewController()
        vc.productData = listData[indexPath.row]
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    
}

extension FavoritesViewController: UICollectionViewDelegateFlowLayout{
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

extension FavoritesViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchField.resignFirstResponder()
        return true
    }
}
