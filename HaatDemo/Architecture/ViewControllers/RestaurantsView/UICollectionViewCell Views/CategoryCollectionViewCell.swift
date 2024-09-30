//
//  CategoryCollectionViewCell.swift
//  HaatDemo
//
//  Created by Dhairya on 29/09/24.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgCate: UIImageView!
    @IBOutlet weak var lblCateName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblNew: UILabel!
    @IBOutlet weak var lblOpenUntil: UILabel!
    @IBOutlet weak var viewCate: UIView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
