//
//  HorizontalCategoryTableViewCell.swift
//  HaatDemo
//
//  Created by Dhairya on 29/09/24.
//

import UIKit

class HorizontalCategoryTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    
    @IBOutlet weak var lblTitles: UILabel!
    @IBOutlet weak var lblSponsered: UILabel!
    @IBOutlet weak var btnViewAll: UIButton!
    @IBOutlet weak var collectionViews: UICollectionView!
    
    
    var storeArray = [Store]()
    
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
    
    func configure(with storeArr: [Store], title: String, isSponsered: Bool, viewAll: Bool) {
        self.storeArray = storeArr
        self.lblTitles.text = title == "." ? "Recommended Restaurants" : title
        self.lblSponsered.isHidden = !isSponsered
        self.btnViewAll.isHidden = !viewAll
        self.collectionViews.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
        cell.lblCateName.numberOfLines = 2
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
        return CGSize(width: 148, height: 241)
    }
    
}
