//
//  OrdersVC.swift
//  HaatDemo
//
//  Created by Dhairya on 26/09/24.
//

import UIKit
import Kingfisher

class OrdersVC: UIViewController {
    
    @IBOutlet weak var tblOrders: UITableView!
    
    var page = 1
    var isLoadingData = false
    var hasMoreData = true
    
    let ordersViewModel: OrdersViewModel = OrdersViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.tblOrders.separatorColor = .clear
        self.fetchOrdersListingData(pageNumber: self.page)
    }
    
    func fetchOrdersListingData(pageNumber: Int) {
        guard !isLoadingData && hasMoreData else { return }
        isLoadingData = true
        self.tblOrders.tableFooterView = createLoadingFooter()
        ordersViewModel.getOrderListingDataFromServer(page: pageNumber) { dataModel in
            DispatchQueue.main.async {
                // Hide the footer view if there's an error
                self.isLoadingData = false
                self.tblOrders.tableFooterView = nil
                self.tblOrders.reloadData()
            }
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


extension OrdersVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func createLoadingFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.tblOrders.frame.width, height: 50))
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.center = footerView.center
        activityIndicator.startAnimating()
        footerView.addSubview(activityIndicator)
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return ordersViewModel.arrOrdersListing.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let modelOrder = ordersViewModel.arrOrdersListing[section]
        return (modelOrder.restaurantDetail?.meals?.count ?? 0) + 2 + (modelOrder.restaurantDetail?.deals?.count ?? 0) + (modelOrder.restaurantDetail?.products?.count ?? 0)
    }
    
    @objc func btnTrackOrderPressed(sender: UIButton) {
        let storyBoard = UIStoryboard(name: "Orders", bundle: nil)
        let childVC = storyBoard.instantiateViewController(withIdentifier: "TrackOrdersVC") as! TrackOrdersVC
        self.navigationController?.pushViewController(childVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mdlOrder = ordersViewModel.arrOrdersListing[indexPath.section]
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellHeader", for: indexPath)
            
            let lblOrderId = cell.viewWithTag(52) as! UILabel
            lblOrderId.text = "\(mdlOrder.restaurantId ?? 0) (\(mdlOrder.id ?? 0))"
            
            let lblOrderedAt = cell.viewWithTag(53) as! UILabel
            lblOrderedAt.text = self.formatDateString(mdlOrder.orderDate ?? "", returnFormat: "dd/MM/yyyy HH:mm")
            
            let lblReferenceNumber = cell.viewWithTag(54) as! UILabel
            lblReferenceNumber.text = "\(mdlOrder.id ?? 0)"
            
            let lblArrivedAt = cell.viewWithTag(55) as! UILabel
            lblArrivedAt.text = ""
            if self.formatDateString(mdlOrder.arriveDate ?? "", returnFormat: "HH:mm") != "" {
                lblArrivedAt.text = "Arrived At " + self.formatDateString(mdlOrder.arriveDate ?? "", returnFormat: "HH:mm")!
            }
            
            let imgBusiness = cell.viewWithTag(56) as! UIImageView
            imgBusiness.kf.setImage(with: URL(string: "https://im-staging.haat.delivery/\(mdlOrder.restaurantDetail?.details?.icon ?? "")"))
            
            let lblBusinessName = cell.viewWithTag(57) as! UILabel
            lblBusinessName.text = mdlOrder.restaurantDetail?.details?.name
            
            let btnTrackOrder = cell.viewWithTag(112) as! UIButton
            btnTrackOrder.addTarget(self, action: #selector(btnTrackOrderPressed(sender:)), for: .touchUpInside)
            
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row == ((mdlOrder.restaurantDetail?.meals?.count ?? 0) + (mdlOrder.restaurantDetail?.deals?.count ?? 0) + (mdlOrder.restaurantDetail?.products?.count ?? 0) + 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellFooter", for: indexPath)
            
            let lblSubtotal = cell.viewWithTag(62) as! UILabel
            lblSubtotal.text = currencySymbol + "\(mdlOrder.restaurantPrice ?? 0)"
            
            let lblDeliveryFee = cell.viewWithTag(63) as! UILabel
            lblDeliveryFee.text = currencySymbol + "0"
            
            let lblServiceFee = cell.viewWithTag(64) as! UILabel
            lblServiceFee.text = currencySymbol + "\(mdlOrder.serviceFee ?? 0)"
            
            let lblRedeemCoin = cell.viewWithTag(65) as! UILabel
            lblRedeemCoin.text = "- " + currencySymbol + "0"
            
            let lblTotal = cell.viewWithTag(66) as! UILabel
            lblTotal.text = currencySymbol + "\(mdlOrder.restaurantPrice ?? 0)"
            
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row > ((mdlOrder.restaurantDetail?.meals?.count ?? 0)) && indexPath.row < ((mdlOrder.restaurantDetail?.meals?.count ?? 0) + (mdlOrder.restaurantDetail?.deals?.count ?? 0) + 1) {
            
            let mdlDeals = mdlOrder.restaurantDetail!.deals![indexPath.row - ((mdlOrder.restaurantDetail?.meals?.count ?? 0) + 1)]
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellOrderItem", for: indexPath)
            
            let bgView = cell.viewWithTag(41)!
            bgView.addDottedBorderAtBottom()
            
            let imgMeals = cell.viewWithTag(42) as! UIImageView
            imgMeals.kf.setImage(with: URL(string: "https://im-staging.haat.delivery/\(mdlDeals.smallImage ?? "")"))
            
            let lblMealName = cell.viewWithTag(43) as! UILabel
            lblMealName.text = mdlDeals.name_HE
            
            let lblMealQty = cell.viewWithTag(44) as! UILabel
            lblMealQty.text = "Qty: \(mdlDeals.quantity ?? 0)"
            
            let lblPrice = cell.viewWithTag(45) as! UILabel
            lblPrice.text = currencySymbol + "\(mdlDeals.finalPriceWithExtrasToDisplay ?? 0)"
            
            cell.selectionStyle = .none
            return cell
            
        }
        else if indexPath.row > ((mdlOrder.restaurantDetail?.meals?.count ?? 0) + (mdlOrder.restaurantDetail?.deals?.count ?? 0)) && indexPath.row < ((mdlOrder.restaurantDetail?.meals?.count ?? 0) + (mdlOrder.restaurantDetail?.deals?.count ?? 0) + (mdlOrder.restaurantDetail?.products?.count ?? 0) + 1) {
            
            let mdlProducts = mdlOrder.restaurantDetail!.products![indexPath.row - ((mdlOrder.restaurantDetail?.meals?.count ?? 0) + (mdlOrder.restaurantDetail?.deals?.count ?? 0) + 1)]
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellOrderItem", for: indexPath)
            
            let bgView = cell.viewWithTag(41)!
            bgView.addDottedBorderAtBottom()
            
            let imgMeals = cell.viewWithTag(42) as! UIImageView
            if mdlProducts.productImages?.count ?? 0 > 0 {
                imgMeals.kf.setImage(with: URL(string: "https://im-staging.haat.delivery/\(mdlProducts.productImages?[0].smallImageUrl ?? "")"))
            }
            else {
                imgMeals.image = nil
            }
            
            let lblMealName = cell.viewWithTag(43) as! UILabel
            lblMealName.text = mdlProducts.name?.he
            
            let lblMealQty = cell.viewWithTag(44) as! UILabel
            lblMealQty.text = "Qty: \(mdlProducts.quantity ?? 0)"
            
            let lblPrice = cell.viewWithTag(45) as! UILabel
            lblPrice.text = currencySymbol + "\(mdlProducts.finalPriceWithExtrasToDisplay ?? 0)"
            
            cell.selectionStyle = .none
            return cell
            
        }
        else {
            let mdlMeals = mdlOrder.restaurantDetail!.meals![indexPath.row - 1]
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellOrderItem", for: indexPath)
            
            let bgView = cell.viewWithTag(41)!
            bgView.addDottedBorderAtBottom()
            
            let imgMeals = cell.viewWithTag(42) as! UIImageView
            imgMeals.kf.setImage(with: URL(string: "https://im-staging.haat.delivery/\(mdlMeals.smallImage ?? "")"))
            
            let lblMealName = cell.viewWithTag(43) as! UILabel
            lblMealName.text = mdlMeals.name
            
            let lblMealQty = cell.viewWithTag(44) as! UILabel
            lblMealQty.text = "Qty: \(mdlMeals.quantity ?? 0)"
            
            let lblPrice = cell.viewWithTag(45) as! UILabel
            lblPrice.text = currencySymbol + "\(mdlMeals.finalPriceWithExtrasToDisplay ?? 0)"
            
            cell.selectionStyle = .none
            return cell
        }
    }
    
    // ScrollView did scroll: Detect if the last row is visible
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRows = self.tblOrders.indexPathsForVisibleRows
        let mdlOrder = ordersViewModel.arrOrdersListing[self.ordersViewModel.arrOrdersListing.count - 1]
        
        let lastIndexPath = IndexPath(row: ((mdlOrder.restaurantDetail?.meals?.count ?? 0) + (mdlOrder.restaurantDetail?.deals?.count ?? 0) + (mdlOrder.restaurantDetail?.products?.count ?? 0) + 1), section: self.ordersViewModel.arrOrdersListing.count - 1)
        
        if visibleRows?.contains(lastIndexPath) == true {
            if !isLoadingData {
                self.page += 1
                self.fetchOrdersListingData(pageNumber: page)
            }
        }
    }
    
    func formatDateString(_ input: String, returnFormat: String) -> String? {
        let dateFormatter = DateFormatter()
        
        // Set the input date format
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSS"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        // Convert string to Date
        guard let date = dateFormatter.date(from: input) else {
            return ""
        }
        
        // Set the output date format
        dateFormatter.dateFormat = returnFormat
        
        // Convert Date to formatted string
        return dateFormatter.string(from: date)
    }
    
}
