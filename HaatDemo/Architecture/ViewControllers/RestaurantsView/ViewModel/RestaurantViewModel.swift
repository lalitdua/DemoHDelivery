//
//  RestaurantViewModel.swift
//  HaatDemo
//
//  Created by Dhairya on 29/09/24.
//


import UIKit
import Foundation
import SVProgressHUD


class RestaurantViewModel: NSObject {
    
    func getRestaurantHomePageDataListingFromServer(_ result: @escaping(RestaurantModel?) -> Void) {
        let headers: [String: String] = ["Accept-language": "en-US"]
        SVProgressHUD.show()
        ApiManager<RestaurantModel>.makeApiCallForGetPage(homePageAPI, headers: headers) { (response, model) in
            SVProgressHUD.dismiss()
            result(model)
        }
    }
    
    
}
