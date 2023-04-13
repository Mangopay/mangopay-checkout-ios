//
//  ItemCell.swift
//  WhenThenExampleCheckout
//
//  Created by Elikem Savie on 09/12/2022.
//

import UIKit

protocol ItemCellDelegate: AnyObject {
    func didTapBuy(sender: ItemCell)
}

class ItemCell: UICollectionViewCell {
    
    static let reuseId = "itemCellId"

   
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var logoImage: UIImageView!
    
    weak var delegate: ItemCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        logoImage.layer.cornerRadius = 8
    }
    
    @IBAction func didTapBuy(_ sender: UIButton) {
        delegate?.didTapBuy(sender: self)
    }

    func configure(_ product: Product) {
        self.logoImage.image = UIImage(named: product.imageName)
        nameLabel.text = product.name
        priceLabel.text = product.amountString
    }

}
