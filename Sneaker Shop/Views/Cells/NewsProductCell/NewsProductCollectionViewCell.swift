//
//  NewsProductCollectionViewCell.swift
//  Sneaker Shop
//
//  Created by Thuận Nguyễn Văn on 14/12/2020.
//

import UIKit

class NewsProductCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var boderTop: UIView!
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var labelProduct: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.backgroundColor = .white
        
        //Set Border
        boderTop.backgroundColor = #colorLiteral(red: 0.972763598, green: 0.6047756076, blue: 0.4429819882, alpha: 1)
        //Set Left Image:
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleToFill
        imgView.layer.cornerRadius = 4
        imgView.image = UIImage(named: "test")
        
        
        //Set Name Title
        labelProduct.textAlignment = .left
        labelProduct.textColor = .black
        labelProduct.font = .systemFont(ofSize: 18)
        labelProduct.lineBreakMode = NSLineBreakMode.byWordWrapping
        labelProduct.numberOfLines = 3
        
    }

}
