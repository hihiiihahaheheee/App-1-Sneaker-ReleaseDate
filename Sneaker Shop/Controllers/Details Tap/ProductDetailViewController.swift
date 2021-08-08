//
//  ProductDetailViewController.swift
//  Sneaker Shop
//
//  Created by Thuận Nguyễn Văn on 18/12/2020.
//

import UIKit
import RealmSwift
class ProductDetailViewController: UIViewController {
    public var productData = ProductModel()
    
    
    public var listData = [ProductModel]()
    private var listDataDetail = [ProductDetailModel]()
    var countTap = 0
    let realm = try! Realm()
    
    
    
    
    //FooterView
    let dateLabel = UILabel()
    let priceLabel = UILabel()
    
    //Header
    let nameLabel = UILabel()
    private let headerView:UIView = {
        let v = UIView()
        v.backgroundColor = #colorLiteral(red: 0.9450184703, green: 0.9451507926, blue: 0.944976747, alpha: 1)
        return v
    }()
    
    private let contentView:UIView = {
        let v = UIView()
        v.backgroundColor = .white
        return v
    }()
    let mainImageView = UIImageView()
    private var myCollectionView:UICollectionView?
    
    
    
    private let footerView:UIView = {
        let v = UIView()
        v.backgroundColor = #colorLiteral(red: 0.9450184703, green: 0.9451507926, blue: 0.944976747, alpha: 1)
        return v
    }()
    private var footerCollectionView:UICollectionView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9450184703, green: 0.9451507926, blue: 0.944976747, alpha: 1)
        addSubViews()
        self.getProduct(){_,_ in}
        self.getProductDetail(){_,_ in}
        
    }
    override func viewDidAppear(_ animated: Bool) {
        myCollectionView?.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        myCollectionView?.reloadData()
    }
    
    
    
    //Data Json
    func getProduct(andCompletion completion:@escaping (_ moviesResponse: [ProductModel], _ error: Error?) -> ()) {
        APIService.shared.GetProduct() { (response, error) in
            if let listData = response{
                self.listData = listData
                DispatchQueue.main.async {
                    self.footerCollectionView?.reloadData()
                }
            }
            completion(self.listData, error)
        }
    }
    
    func getProductDetail(andCompletion completion:@escaping (_ moviesResponse: [ProductDetailModel], _ error: Error?) -> ()) {
        APIService.shared.GetDetailProduct(linkData: productData.link) { (response, error) in
            if let listData = response{
                self.listDataDetail = listData
                DispatchQueue.main.async {
                    self.myCollectionView?.reloadData()
                }
            }
            completion(self.listDataDetail, error)
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headerView.frame = CGRect(x: 30.0, y: 0.0, width: view.width - 60 , height: 80)
        if UIDevice.current.userInterfaceIdiom == .pad {
            contentView.frame = CGRect(x: 30.0, y: headerView.bottom + 10, width: view.width - 60 , height: 420)
        }
        else{
            contentView.frame = CGRect(x: 30.0, y: headerView.bottom + 10, width: view.width - 60 , height: 220)
        }
        
        
        footerView.frame = CGRect(x: 30.0, y: contentView.bottom , width: view.width - 60, height: view.height - headerView.height - contentView.height)
        configureHeaderView()
        configureContentView()
        configureFooterView()
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
    
    
    private func configureContentView(){
        //Main Image View:
        contentView.layer.cornerRadius = 10
        mainImageView.frame = CGRect(x: contentView.width/6 , y: 10.0 , width: contentView.width*2/3 , height: contentView.height/1.5)
        contentView.addSubview(mainImageView)
        
        //Collection View:
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        myCollectionView = UICollectionView(frame: CGRect(x: 20.0 , y: mainImageView.bottom + 1.0 , width: contentView.width - 40.0 , height: (contentView.height - mainImageView.bottom - 5.0)), collectionViewLayout: layout)
        myCollectionView?.register(UINib(nibName: "MainImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MainImageCollectionViewCell")
        myCollectionView?.backgroundColor = .white
        myCollectionView?.showsHorizontalScrollIndicator = false
        myCollectionView?.showsVerticalScrollIndicator = false
        contentView.addSubview(myCollectionView ?? UICollectionView())
        myCollectionView?.dataSource = self
        myCollectionView?.delegate = self
    }
    
    private func configureFooterView() {
        //Label Date:
        dateLabel.textColor = #colorLiteral(red: 0.9643060565, green: 0.6017367244, blue: 0.4431582093, alpha: 1)
        dateLabel.font = dateLabel.font.withSize(16)
        dateLabel.frame = CGRect(x: 0.0, y: 18.0, width: footerView.width, height: 20)
        dateLabel.textAlignment = .left
        
        //Price Label:
        priceLabel.textColor = #colorLiteral(red: 0.3333024085, green: 0.3333537579, blue: 0.3332862258, alpha: 1)
        priceLabel.font = priceLabel.font.withSize(16)
        priceLabel.frame = CGRect(x: 0.0, y: dateLabel.bottom + 15.0, width: footerView.width, height: 20)
        priceLabel.textAlignment = .left
        
        //Similar Products Label:
        let similarProductLabel = UILabel()
        similarProductLabel.text = "Similar Products:"
        similarProductLabel.textColor = #colorLiteral(red: 0.3333024085, green: 0.3333537579, blue: 0.3332862258, alpha: 1)
        similarProductLabel.font = priceLabel.font.withSize(16)
        similarProductLabel.frame = CGRect(x: 0.0, y: priceLabel.bottom + 15.0, width: footerView.width, height: 20)
        similarProductLabel.textAlignment = .left
        
        
        
        //Footer Collecton View:
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: contentView.width - 50 , height: 100)
        layout.scrollDirection = .vertical
        footerCollectionView = UICollectionView(frame: CGRect(x: 0 , y: similarProductLabel.bottom +  15.0, width: footerView.width , height: footerView.height - similarProductLabel.bottom - 15.0 ), collectionViewLayout: layout)
        
        
        footerCollectionView?.register(UINib(nibName: "SharedProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SharedProductCollectionViewCell")
        footerCollectionView?.backgroundColor = #colorLiteral(red: 0.9454912543, green: 0.9456531405, blue: 0.9454810023, alpha: 1)
        footerView.addSubview(footerCollectionView ?? UICollectionView())
        footerCollectionView?.dataSource = self
        footerCollectionView?.delegate = self
        
        
        //Add Sub View For Footer View
        footerView.addSubview(dateLabel)
        footerView.addSubview(priceLabel)
        footerView.addSubview(similarProductLabel)
        
        //Button Acction Inside Footer View:
        
    }
    
    
    @objc private func didTapBackButton(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    private func addSubViews(){
        view.addSubview(headerView)
        view.addSubview(contentView)
        view.addSubview(footerView)
    }
    
    
}


extension ProductDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == myCollectionView {
            return listDataDetail.count
        } else {
            return listData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == myCollectionView{
            nameLabel.text = productData.name
            priceLabel.text = "Price : $" + productData.price
            dateLabel.text = productData.release_date
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainImageCollectionViewCell", for: indexPath) as! MainImageCollectionViewCell
            let url = URL(string: listDataDetail[indexPath.row].image)
            cell.imgView.kf.setImage(with:url)
            if countTap == 0 {
                let url2 = URL(string: listDataDetail[0].image)
                mainImageView.kf.setImage(with: url2)
            }
            return cell
        }
        else{
            updateData()
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SharedProductCollectionViewCell", for: indexPath) as! SharedProductCollectionViewCell
            let url = URL(string: listData[indexPath.row].image)
            cell.imgView.kf.setImage(with:url)
            cell.nameProduct.text = listData[indexPath.row].name
            cell.dateLabel.text = listData[indexPath.row].release_date
            cell.priceLabel.text = "$" + listData[indexPath.row].price
            
            
            
            //Handle Like Button:
            cell.heartButton.tag = indexPath.row
            cell.hateButton.tag = indexPath.row
            
            
            if listData[indexPath.row].likeHateStatus == "true" {
                cell.heartButton.setImage( UIImage(named: "heartTrue"), for: .normal)
                cell.hateButton.setImage(UIImage(named: "hateFalse"), for: .normal)
            }
            else if listData[indexPath.row].likeHateStatus == "false" {
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
        
    }
    
    private func updateData(){
        let result = realm.objects(ProductModel.self)
        let listAdd = Array(result)
        var countListData = 0
        while countListData < listData.count {
            var countRealm = 0
            while countRealm < listAdd.count {
                if listData[countListData].id == listAdd[countRealm].id {
                    listData[countListData] = listAdd[countRealm]
                }
                countRealm += 1
            }
            countListData += 1
        }
    }
    
    @objc private func didTapLikeButton(_ sender: UIButton){
        let i = sender.tag
        
        if listData[i].likeHateStatus == "true" {
            try! realm.write {
                listData[i].likeHateStatus = ""
                realm.add(listData[i], update: .all)
                updateData()
            }
            footerCollectionView?.reloadData()
        }
        else {
            try! realm.write {
                listData[i].likeHateStatus = "true"
                realm.add(listData[i], update: .all)
                updateData()
            }
            footerCollectionView?.reloadData()
        }
        
    }
    @objc private func didTapHateButton(_ sender: UIButton){
        let i = sender.tag
        if listData[i].likeHateStatus == "false" {
            try! realm.write {
                listData[i].likeHateStatus = ""
                realm.add(listData[i], update: .all)
                updateData()
            }
            footerCollectionView?.reloadData()
        }
        else{
            try! realm.write {
                listData[i].likeHateStatus = "false"
                realm.add(listData[i], update: .all)
                updateData()
            }
            footerCollectionView?.reloadData()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        if  collectionView == myCollectionView {
            countTap += 1
            let url = URL(string: listDataDetail[indexPath.row].image)
            mainImageView.kf.setImage(with: url)
        }
        if collectionView == footerCollectionView {
            countTap = 0
            productData = listData[indexPath.row]
            self.getProductDetail(){_,_ in}
            myCollectionView?.reloadData()
        }
        
    }
    
}


extension ProductDetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if collectionView == myCollectionView{
            if UIDevice.current.userInterfaceIdiom == .pad{
                return CGSize(width: 70 , height: 50)
            }
            return CGSize(width: 70, height: 50)
        }
        else{
            
            if UIDevice.current.userInterfaceIdiom == .pad{
                return CGSize(width: UIScreen.main.bounds.width/2 - 60 , height: 200)
            }
            return CGSize(width: UIScreen.main.bounds.width - 60 , height: 200)
            
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == footerView {
            if UIDevice.current.userInterfaceIdiom == .pad {
                return UIEdgeInsets(top: 0, left: 30.0, bottom: 0, right: 30.0)
            }
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    
    
}
