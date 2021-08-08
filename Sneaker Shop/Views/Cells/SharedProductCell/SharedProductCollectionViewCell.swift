//
//  SharedProductCollectionViewCell.swift
//  Sneaker Shop
//
//  Created by Thuận Nguyễn Văn on 15/12/2020.
//


import UIKit

class SharedProductCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var nameProduct: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var hateButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //Set::Value
        nameProduct.text = "Nike LeBron 7 CTL"
        priceLabel.text = "$" + "200.00"
        dateLabel.text = "Release Date: December 1st,2020"
        imgView.image = UIImage(named: "imgLogo")
        
        //Set:: Properties
        nameProduct.font = nameProduct.font.withSize(14)
        nameProduct.textColor = #colorLiteral(red: 0.3333024085, green: 0.3333537579, blue: 0.3332862258, alpha: 1)
        dateLabel.font = dateLabel.font.withSize(12)
        dateLabel.textColor = #colorLiteral(red: 0.9688166976, green: 0.603492558, blue: 0.4447279274, alpha: 1)
        priceLabel.font = nameProduct.font.withSize(16)
        priceLabel.textColor = #colorLiteral(red: 0.3333024085, green: 0.3333537579, blue: 0.3332862258, alpha: 1)
        priceLabel.textAlignment = .left
        heartButton.setImage(UIImage(named: "heartFalse"), for: .normal)
        hateButton.setImage(UIImage(named: "hateFalse"), for: .normal)
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = .white
        
        
    }

 
}
