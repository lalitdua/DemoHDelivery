//
//  BannerTableViewCell.swift
//  HaatDemo
//
//  Created by Dhairya on 29/09/24.
//

import UIKit
import Kingfisher

class BannerTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionViews: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var bannerDataArr = [Banner]()
    var x = 1
    var timeInterval = 1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.collectionViews.delegate = self
        self.collectionViews.dataSource = self
        self.collectionViews.register(UINib(nibName: "BannerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BannerCollectionViewCell")
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(with bannerArr: [Banner], timeInterval: Int) {
        self.bannerDataArr = bannerArr
        self.timeInterval = timeInterval
        self.setTimerForAutoScroll()
        self.pageControl.numberOfPages = self.bannerDataArr.count
        self.collectionViews.reloadData()
    }
    
    // add timer for auto scrolling
    func setTimerForAutoScroll() {
        let _ = Timer.scheduledTimer(timeInterval: TimeInterval(self.timeInterval), target: self, selector: #selector(BannerTableViewCell.autoScroll), userInfo: nil, repeats: true)
    }
    
    // create auto scroll
    @objc func autoScroll() {
        self.pageControl.currentPage = x
        if self.x < self.bannerDataArr.count {
            let indexPath = IndexPath(item: x, section: 0)
            self.collectionViews.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            self.x = self.x + 1
        } else {
            self.x = 0
            self.collectionViews.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.bannerDataArr.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let bannerModel = self.bannerDataArr[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCollectionViewCell", for: indexPath) as! BannerCollectionViewCell
        
        cell.imgBanner.kf.setImage(with: URL(string: "https://im-staging.haat.delivery/\(bannerModel.image?.serverImage ?? "")"))
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.size.width, height: 327)
    }
    
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if (context.nextFocusedItem != nil) {
            self.collectionViews.scrollToItem(at: context.nextFocusedItem as! IndexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    
}
