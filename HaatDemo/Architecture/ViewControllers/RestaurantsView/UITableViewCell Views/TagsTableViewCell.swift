//
//  TagsTableViewCell.swift
//  HaatDemo
//
//  Created by Dhairya on 29/09/24.
//

import UIKit

class TagsTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var lblTitles: UILabel!
    @IBOutlet weak var collectionViews: UICollectionView!
    
    var tagArr = [Tag]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.collectionViews.delegate = self
        self.collectionViews.dataSource = self
        self.collectionViews.register(UINib(nibName: "TagsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TagsCollectionViewCell")
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with tagArr: [Tag], title: String) {
        self.tagArr = tagArr
        self.lblTitles.text = title
        self.collectionViews.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tagArr.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let tagModel = self.tagArr[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagsCollectionViewCell", for: indexPath) as! TagsCollectionViewCell
        
        cell.lblTags.text = tagModel.name?.uppercased()
        cell.imgTags.kf.setImage(with: URL(string: "https://im-staging.haat.delivery/\(tagModel.images?.serverImage ?? "")"))
        cell.imgTags.clipsToBounds = true
        cell.imgTags.layer.cornerRadius = 6.0
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 116, height: 116)
    }
    
}
