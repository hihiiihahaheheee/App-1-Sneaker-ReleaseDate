//
//  HomeViewController.swift
//  Sneaker Shop
//
//  Created by Thuận Nguyễn Văn on 12/12/2020.
//

import UIKit
import RealmSwift

class HomeViewController: UIViewController  {
    
    
    //Status Like/Hate:
    let searchField = UITextField()
    let searchButton = UIButton()
    let logoButton = UIButton()
    
    var listCategory = ["All", "Nike",  "Jordan", "adidas", "Reebok"]
    var listData = [ProductModel]()
    var tempData = [ProductModel]()
    var listBackUpData = [ProductModel]()
    var selectIndex = 0
    
    let realm = try! Realm()
    
    struct Constants{
        static let connerRadius:CGFloat = 8.0
    }
    
    private let headerView:UIView = {
        let header = UIView()
        header.clipsToBounds = true
        return header
    }()
    
    
    //TagList View Controller
    private let tagListView:UIView = {
        let v = UIView()
        v.clipsToBounds = true
        return v
    }()
    private var tagCollectionView:UICollectionView?
    
    //Label Result Count
    private let resultCountLabel:UILabel = {
        let countLabel = UILabel()
        countLabel.text = "30 upcoming releases"
        countLabel.textColor = #colorLiteral(red: 0.4678168297, green: 0.4678877592, blue: 0.4678012729, alpha: 1)
        countLabel.backgroundColor = #colorLiteral(red: 0.9454912543, green: 0.9456531405, blue: 0.9454810023, alpha: 1)
        return countLabel
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
        myCollectionView?.reloadData()
        view.backgroundColor = #colorLiteral(red: 0.9454912543, green: 0.9456531405, blue: 0.9454810023, alpha: 1)
        tagListView.backgroundColor =  .yellow
        addSubViews()
        self.getProduct(){_,_ in}
        resultCountLabel.text = String(listData.count) + " upcoming releases"
        
        searchField.delegate = self
        searchButton.addTarget(self, action: #selector(didTapSearchButton), for: .touchUpInside)
        logoButton.addTarget(self, action: #selector(didTapLogoButton), for: .touchUpInside)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        myCollectionView?.reloadData()
    }

    
    //Data Json
    func getProduct(andCompletion completion:@escaping (_ moviesResponse: [ProductModel], _ error: Error?) -> ()) {
        APIService.shared.GetProduct() { (response, error) in
            if let listData = response{
                self.listData = listData
                self.tempData = listData
                DispatchQueue.main.async {
                    self.tagCollectionView?.reloadData()
                    self.myCollectionView?.reloadData()
                }
            }
            completion(self.listData, error)
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        //Assign Frame Header View:
        headerView.frame = CGRect(x: 0.0, y: 0.0, width: view.width, height: 110)
        configureHeaderView()
        //Assign Frame Tag List View:
        tagListView.frame = CGRect(x: 23.0, y: headerView.bottom + 17.0, width: view.width - 46 , height: 40 )
        configureTagListView()
        resultCountLabel.frame = CGRect(x: 30.0, y: tagListView.bottom + 10.0, width: view.width/2 , height: 30)
        contentView.frame = CGRect(x: 0.0, y: resultCountLabel.bottom + 15.0 , width: view.width, height: view.height - resultCountLabel.bottom - 15.0)
        
        configureContentCollectionView()
    }
    
    private func configureHeaderView(){
        
        //Add LogoButton
        logoButton.setImage(UIImage(named: "imgLogo"), for: .normal)
        headerView.addSubview(logoButton)
        logoButton.frame = CGRect(
            x: 12.0,
            y: 57.0,
            width: 50,
            height: 50)
        
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
        searchField.frame = CGRect( x: 81.0, y: 57.0, width: headerView.width - (81 + 45), height: 50)
        
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
    
    private func configureTagListView(){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        tagCollectionView = UICollectionView(frame: CGRect(x: 0 , y: 0, width: tagListView.width , height: tagListView.height), collectionViewLayout: layout)
        tagCollectionView?.showsHorizontalScrollIndicator = false
        tagCollectionView?.register(UINib(nibName: "TagListCell", bundle: nil), forCellWithReuseIdentifier: "TagListCell")
        tagCollectionView?.register(UINib(nibName: "TagListSelectedCell", bundle: nil), forCellWithReuseIdentifier: "TagListSelectedCell")
        tagCollectionView?.backgroundColor = #colorLiteral(red: 0.9454912543, green: 0.9456531405, blue: 0.9454810023, alpha: 1)
        tagListView.addSubview(tagCollectionView ?? UICollectionView())
        tagCollectionView?.dataSource = self
        tagCollectionView?.delegate = self
        
    }
    
    private func configureContentCollectionView(){
        //Add CollectionView
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        myCollectionView = UICollectionView(frame: CGRect(x: 0 , y: 0, width: contentView.width , height: contentView.height), collectionViewLayout: layout)
        myCollectionView?.register(UINib(nibName: "SharedProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SharedProductCollectionViewCell")
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
                tempData.removeAll()
                for item in listBackUpData {
                    if item.name.lowercased().contains(textSearch.lowercased()) {
                        tempData.append(item)
                    }
                }
                myCollectionView?.reloadData()
            }
            else {
                tempData = listBackUpData
                myCollectionView?.reloadData()
            }
        }
        else{
            tempData = listBackUpData
            myCollectionView?.reloadData()
        }
    }
    
    @objc private func didTapLogoButton(){
        let vc = SettingViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    //Add Sub View
    private func addSubViews(){
        view.addSubview(headerView)
        view.addSubview(tagListView)
        view.addSubview(contentView)
        view.addSubview(resultCountLabel)
    }
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == tagCollectionView {
            return listCategory.count
        }
        else {
            resultCountLabel.text = String(tempData.count) + " upcoming releases"
            return tempData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == myCollectionView {
            updateData()
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SharedProductCollectionViewCell", for: indexPath) as! SharedProductCollectionViewCell
            cell.nameProduct.text = tempData[indexPath.row].name
            let url = URL(string: tempData[indexPath.row].image)
            cell.imgView.kf.setImage(with:url)
            cell.heartButton.tag = indexPath.row
            cell.hateButton.tag = indexPath.row
            cell.priceLabel.text = "$" + tempData[indexPath.row].price
            cell.dateLabel.text = tempData[indexPath.row].release_date
            //Handle Like Button:
            if tempData[indexPath.row].likeHateStatus == "true" {
                cell.heartButton.setImage( UIImage(named: "heartTrue"), for: .normal)
                cell.hateButton.setImage(UIImage(named: "hateFalse"), for: .normal)
            }
            else if tempData[indexPath.row].likeHateStatus == "false" {
                cell.heartButton.setImage( UIImage(named: "heartFalse"), for: .normal)
                cell.hateButton.setImage(UIImage(named: "hateTrue"), for: .normal)
            }
            else{
                cell.heartButton.setImage( UIImage(named: "heartFalse"), for: .normal)
                cell.hateButton.setImage(UIImage(named: "hateFalse"), for: .normal)
            }
            cell.heartButton.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
            cell.hateButton.addTarget(self, action: #selector(didTapHateButton), for: .touchUpInside)
            return cell
        }
        //Tag List View
        else{
            
            if indexPath.row == self.selectIndex {
                let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "TagListSelectedCell", for: indexPath) as! TagListSelectedCell
                cell2.tagLabel.text = listCategory[indexPath.row]
                cell2.contentView.backgroundColor = #colorLiteral(red: 0.9731842875, green: 0.6057345271, blue: 0.4422224164, alpha: 1)
                cell2.tagLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                return cell2
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagListCell", for: indexPath) as! TagListCell
            cell.tagLabel.text = listCategory[indexPath.row]
            return cell
        }
    }
    
    private func updateData(){
        let result = realm.objects(ProductModel.self)
        let listAdd = Array(result)
        
        
        
        var countTempData = 0
        while countTempData < tempData.count {
            var countRealm = 0
            while countRealm < listAdd.count {
                if tempData[countTempData].id == listAdd[countRealm].id {
                    tempData[countTempData] = listAdd[countRealm]
                }
                countRealm += 1
            }
            countTempData += 1
        }
    }
    
    
    @objc private func didTapLikeButton(_ sender: UIButton){
        let i = sender.tag
        
        if tempData[i].likeHateStatus == "true" {
            try! realm.write {
                tempData[i].likeHateStatus = ""
                realm.add(tempData[i], update: .all)
                updateData()
            }
            myCollectionView?.reloadData()
        }
        else {
            try! realm.write {
                tempData[i].likeHateStatus = "true"
                realm.add(tempData[i], update: .all)
                updateData()
            }
            myCollectionView?.reloadData()
        }
    }
    
    @objc private func didTapHateButton(_ sender: UIButton){
        
        let i = sender.tag
        if tempData[i].likeHateStatus == "false" {
            try! realm.write {
                tempData[i].likeHateStatus = ""
                realm.add(tempData[i], update: .all)
                updateData()
            }
            myCollectionView?.reloadData()
        }
        else{
            try! realm.write {
                tempData[i].likeHateStatus = "false"
                realm.add(tempData[i], update: .all)
                updateData()
            }
            myCollectionView?.reloadData()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return UIEdgeInsets(top: 0, left: 30.0, bottom: 0, right: 30.0)
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        if collectionView == myCollectionView {
            
//            //Ads
//            if indexPath.row % 2 == 0{
//                //Ads
//                if PaymentManager.shared.isPurchase(){
//                    return
//                }
//                else{
//                    AdMobManager.shared.loadAdFull(inVC: self)
//                }
//            }
//            //End Ads
            
            let vc  = ProductDetailViewController()
            vc.productData = tempData[indexPath.row]
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)            
        }
        if collectionView == tagCollectionView {
            selectIndex = indexPath.row
            let tempLbl = listCategory[indexPath.row]
            if tempLbl != "All" {
                tempData.removeAll()
                for item in listData {
                    if item.name.contains(tempLbl) {
                        tempData.append(item)
                    }
                }
                listBackUpData = tempData
            }
            else{
                tempData = listData
                listBackUpData = tempData
            }
            resultCountLabel.text = String(tempData.count) + " upcoming releases"
            self.tagCollectionView?.reloadData()
            myCollectionView?.reloadData()
        }
    }
    
}


extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if  collectionView == myCollectionView {
            if UIDevice.current.userInterfaceIdiom == .pad{
                return CGSize(width: UIScreen.main.bounds.width/2 - 60 , height: 200)
            }
            return CGSize(width: UIScreen.main.bounds.width - 60 , height: 200)
        }
        else {
            //            if UIDevice.current.userInterfaceIdiom == .pad{
            //                return CGSize(width: UIScreen.main.bounds.width/5 , height: tagListView.height - 2)
            //            }
            return CGSize(width: UIScreen.main.bounds.width/5 , height: tagListView.height - 2)
        }
    }
}

extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchField.resignFirstResponder()
        return true
    }
}
