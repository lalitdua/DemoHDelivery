//
//  RestaurantsVC.swift
//  HaatDemo
//
//  Created by Dhairya on 26/09/24.
//

import UIKit

class RestaurantsVC: UIViewController {

    @IBOutlet weak var viewHeadingLoc: UIView!
    @IBOutlet weak var tblRestaurants: UITableView!
    
    let restaurantViewModel: RestaurantViewModel = RestaurantViewModel()
    var restaurantDataModel: RestaurantModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        self.viewHeadingLoc.clipsToBounds = true
        self.viewHeadingLoc.layer.cornerRadius = self.viewHeadingLoc.frame.height/2
        self.viewHeadingLoc.layer.borderWidth = 0.5
        self.viewHeadingLoc.layer.borderColor = UIColor(named: "grayTextColor")?.cgColor
        
        self.tblRestaurants.separatorColor = .clear
        
        
        // Register the xib file for the cell
        self.tblRestaurants.register(UINib(nibName: "BannerTableViewCell", bundle: nil), forCellReuseIdentifier: "BannerTableViewCell")
        self.tblRestaurants.register(UINib(nibName: "TagsTableViewCell", bundle: nil), forCellReuseIdentifier: "TagsTableViewCell")
        self.tblRestaurants.register(UINib(nibName: "HorizontalCategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "HorizontalCategoryTableViewCell")
        self.tblRestaurants.register(UINib(nibName: "CategoryBannerTableViewCell", bundle: nil), forCellReuseIdentifier: "CategoryBannerTableViewCell")
        self.tblRestaurants.register(UINib(nibName: "VerticalCategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "VerticalCategoryTableViewCell")
        
                
        self.getHomePageData()
        
        
    }
    

    func getHomePageData() {
        restaurantViewModel.getRestaurantHomePageDataListingFromServer { restaurantModel in
            self.restaurantDataModel = restaurantModel
            self.tblRestaurants.reloadData()
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension RestaurantsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2 + (self.restaurantDataModel?.categories ?? []).count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.restaurantDataModel?.mainPageBanners?.banners?.count ?? 0 > 0 ? 1 : 0
        }
        else if section == 1 {
            return self.restaurantDataModel?.tags?.tags?.count ?? 0 > 0 ? 1 : 0
        }
        else {
            let mdlCategory = self.restaurantDataModel!.categories![section - 2]
            if (mdlCategory.elementType == "MarketHorizontalCategory" || mdlCategory.elementType == "RestaurantHorizontalCategory") && mdlCategory.stores?.count ?? 0 > 0 {
                return 1
            }
            else if (mdlCategory.elementType == "MarketVerticalCategory" || mdlCategory.elementType == "RestaurantVerticalCategory") && mdlCategory.stores?.count ?? 0 > 0 {
                return 1
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 328
        }
        else if indexPath.section == 1 {
            return 200
        }
        else  {
            let mdlCategory = self.restaurantDataModel!.categories![indexPath.section - 2]
            if mdlCategory.elementType == "MarketHorizontalCategory" || mdlCategory.elementType == "RestaurantHorizontalCategory"  {
                return 345
            }
            else if (mdlCategory.elementType == "MarketVerticalCategory" || mdlCategory.elementType == "RestaurantVerticalCategory") && mdlCategory.stores?.count ?? 0 > 0 {
                if (mdlCategory.isOpenData ?? false) == false {
                    if mdlCategory.stores?.count ?? 0 > 2 {
                        if mdlCategory.stores?.count ?? 0 < 5 {
                            return 590
                        }
                        return 650
                    }
                    else {
                        return 340
                    }
                }
                else {
                    let countValue = (mdlCategory.stores?.count ?? 0) / 2
                    return countValue > 0 ? CGFloat(64 + (293 * countValue) - 72) : UITableView.automaticDimension
                }
            }
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Banner View
        if indexPath.section == 0 {
            //Banner View
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "BannerTableViewCell", for: indexPath) as? BannerTableViewCell else {
                return UITableViewCell()
            }
            
            cell.configure(with: self.restaurantDataModel?.mainPageBanners?.banners ?? [], timeInterval: self.restaurantDataModel?.mainPageBanners?.interval ?? 1)
            
            cell.selectionStyle = .none
            return cell
        }
        //Tags View Cell
        else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TagsTableViewCell", for: indexPath) as? TagsTableViewCell else {
                return UITableViewCell()
            }
            
            cell.configure(with: self.restaurantDataModel?.tags?.tags ?? [], title: self.restaurantDataModel?.tags?.title ?? "")
            
            cell.selectionStyle = .none
            return cell
        }
        // Categroy Horizontal Market View
        else {
            let mdlCategory = self.restaurantDataModel!.categories![indexPath.section - 2]
            if mdlCategory.elementType == "MarketHorizontalCategory" && mdlCategory.backgroundColor != nil && mdlCategory.topImage?.serverImage != nil && mdlCategory.topImageType == 1 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryBannerTableViewCell", for: indexPath) as? CategoryBannerTableViewCell else {
                    return UITableViewCell()
                }
                
                cell.configure(with: mdlCategory.stores ?? [], topBanner: mdlCategory.topImage?.serverImage ?? "", colorBg: mdlCategory.backgroundColor ?? "")
                
                cell.selectionStyle = .none
                return cell
            }
            else if mdlCategory.elementType == "MarketHorizontalCategory" || mdlCategory.elementType == "RestaurantHorizontalCategory"  {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "HorizontalCategoryTableViewCell", for: indexPath) as? HorizontalCategoryTableViewCell else {
                    return UITableViewCell()
                }
                
                cell.configure(with: mdlCategory.stores ?? [], title: mdlCategory.name ?? "", isSponsered: mdlCategory.isSponsored ?? false, viewAll: mdlCategory.viewAll ?? false)
                
                cell.selectionStyle = .none
                return cell
            }
            else if mdlCategory.elementType == "MarketVerticalCategory" || mdlCategory.elementType == "RestaurantVerticalCategory" {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "VerticalCategoryTableViewCell", for: indexPath) as? VerticalCategoryTableViewCell else {
                    return UITableViewCell()
                }
                
                cell.lblTitle.text = mdlCategory.name
                cell.lblSposnsered.isHidden = !(mdlCategory.isSponsored ?? false)
                
                cell.btnViewAll.clipsToBounds = true
                cell.btnViewAll.layer.cornerRadius = 6.0
                cell.btnViewAll.isHidden = !(mdlCategory.viewAll ?? false)
                
                cell.configure(with: mdlCategory.stores ?? [], isOpenCell: mdlCategory.isOpenData ?? false)
                
                if (mdlCategory.isOpenData ?? false) == true {
                    cell.btnShowMore.setTitle("Show less", for: .normal)
                    cell.btnShowMore.setImage(UIImage(systemName: "chevron.up"), for: .normal)
                }
                else {
                    cell.btnShowMore.setTitle("Show more", for: .normal)
                    cell.btnShowMore.setImage(UIImage(systemName: "chevron.down"), for: .normal)
                }
                cell.btnShowMore.addTarget(self, action: #selector(btnShowMoreOrShowLessPressed(sender:)), for: .touchUpInside)
                
                cell.selectionStyle = .none
                return cell
            }
            else {
                return UITableViewCell()
            }
        }
    }
    
    @objc func btnShowMoreOrShowLessPressed(sender: UIButton) {
        let cell = sender.superview?.superview?.superview?.superview as! UITableViewCell
        let indexPath = self.tblRestaurants.indexPath(for: cell)
        var mdlCategory = self.restaurantDataModel!.categories![indexPath!.section - 2]
        if mdlCategory.isOpenData == true {
            mdlCategory.isOpenData = false
        }
        else {
            mdlCategory.isOpenData = true
        }
        self.tblRestaurants.reloadData()
    }
    
}
