//
//  TagListCell.swift
//  Sneaker Shop
//
//  Created by Thuận Nguyễn Văn on 28/12/2020.
//

import UIKit

class TagListCell: UICollectionViewCell {
    @IBOutlet weak var tagLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = .white
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = #colorLiteral(red: 0.9657692313, green: 0.5421426892, blue: 0.3422194719, alpha: 1)
        contentView.layer.cornerRadius = 10
        tagLabel.text = "Nike"
        tagLabel.textAlignment = .center
        tagLabel.font = tagLabel.font.withSize(14)
        tagLabel.textColor = #colorLiteral(red: 0.4678063989, green: 0.4678909779, blue: 0.4678010345, alpha: 1)
    }

}
