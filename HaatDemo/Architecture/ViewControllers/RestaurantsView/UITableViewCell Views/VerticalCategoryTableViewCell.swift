//
//  VerticalCategoryTableViewCell.swift
//  HaatDemo
//
//  Created by Dhairya on 29/09/24.
//

import UIKit

class VerticalCategoryTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnViewAll: UIButton!
    @IBOutlet weak var lblSposnsered: UILabel!
    @IBOutlet weak var collectionViews: UICollectionView!
    @IBOutlet weak var btnShowMore: UIButton!
    @IBOutlet weak var heightViewMore: NSLayoutConstraint!
    
    var storeArray = [Store]()
    var isOpenCell = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.collectionViews.delegate = self
        self.collectionViews.dataSource = self
        self.collectionViews.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with storeArr: [Store], isOpenCell: Bool) {
        self.storeArray = storeArr
        self.isOpenCell = isOpenCell
        self.btnShowMore.isHidden = false
        self.heightViewMore.constant = 64.0
        if self.storeArray.count < 5 {
            self.btnShowMore.isHidden = true
            self.heightViewMore.constant = 0.0
        }
        self.collectionViews.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.storeArray.count > 2 && !isOpenCell {
            return self.storeArray.count > 4 ? 4 : self.storeArray.count
        }
        return self.storeArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let storeModel = self.storeArray[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        
        cell.viewCate.clipsToBounds = true
        cell.viewCate.layer.cornerRadius = 6
        cell.viewCate.layer.borderWidth = 0.5
        cell.viewCate.layer.borderColor = UIColor(named: "grayTextColor")?.cgColor
        
        cell.lblCateName.text = storeModel.name
        cell.lblCateName.numberOfLines = 1
        cell.lblAddress.text = storeModel.address
        cell.imgCate.kf.setImage(with: URL(string: "https://im-staging.haat.delivery/\(storeModel.icon?.serverImage ?? "")"))
        
        if storeModel.isNew ?? false == true {
            cell.lblNew.text = "New!"
        }
        else {
            cell.lblNew.text = ""
        }
                
        cell.lblOpenUntil.text = "until " + self.formatTime(from: storeModel.closestWorkingHour ?? "")!
        
        return cell
    }
    
    func formatTime(from dateString: String) -> String? {
        // Create a DateFormatter to parse the original string
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        inputFormatter.timeZone = TimeZone(abbreviation: "UTC") // Set the time zone if needed

        // Attempt to convert the input string into a Date
        if let date = inputFormatter.date(from: dateString) {
            // Create another DateFormatter to output the desired time format
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "HH:mm"
            
            // Get the formatted time string
            return outputFormatter.string(from: date)
        } else {
            // Return nil if the input string is not a valid date format
            return ""
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width/2 - 40, height: 241)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
    
}
