//
//  MainImageCollectionViewCell.swift
//  Sneaker Shop
//
//  Created by Thuận Nguyễn Văn on 17/12/2020.
//

import UIKit

class MainImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        imgView.image = UIImage(named: "img3")
        imgView.layer.masksToBounds = true
        imgView.layer.borderWidth = 1
        imgView.layer.borderColor = #colorLiteral(red: 0.9643060565, green: 0.6017367244, blue: 0.4431582093, alpha: 1)
        imgView.layer.cornerRadius = 5
    }
}
