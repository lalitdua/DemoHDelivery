//
//  OrdersViewModel.swift
//  HaatDemo
//
//  Created by Dhairya on 29/09/24.
//


import UIKit
import Foundation
import SVProgressHUD


class OrdersViewModel: NSObject {
    
    var arrOrdersListing = [OrderDataModel]()
    
    func getOrderListingDataFromServer(page: Int, _ result: @escaping([OrderDataModel]?) -> Void) {
        let headers: [String: String] = ["Authorization": "bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI5OTI0OTk2Ni0yMjlmLTRmOWMtODBiNi04ZjMzOWZhYmJmYWYiLCJqdGkiOiIzOTA2N2FlNi1mNzQyLTQ4YzItYmYzZC01YzI5Njc1NGMxN2YiLCJleHAiOjE4ODQyNDUwNzMsImF1ZCI6Imh0dHBzOi8vdXNlci1hcHAtc3RhZ2luZy5pbnRlcm5hbC5oYWF0LmRlbGl2ZXJ5In0.eOSsxHcTKrBDAqK5Z6NYf58MM86I4AjqsdytE97Bwes"]
        if page == 1 {
          SVProgressHUD.show()
        }
        ApiManager<[OrderDataModel]>.makeApiCallForGetPage(ordersPageAPI + "\(page)", headers: headers) { (response, model) in
            SVProgressHUD.dismiss()
            if page == 1 {
                self.arrOrdersListing = model ?? []
                result(model)
            }
            else {
                if model?.count ?? 0 > 0 {
                    self.arrOrdersListing.append(contentsOf: model ?? [])
                    result(model)
                }
                else {
                    result(model)
                }
            }
        }
    }
    
    func getMQTTDriverLocationCredentialsFromServer(_ result: @escaping(MQTTModel?) -> Void) {
        let headers: [String: String] = ["Accept-language": "en-US"]
        SVProgressHUD.show()
        ApiManager<MQTTModel>.makeApiCallForGetPage(trackingAPI, headers: headers) { (response, model) in
            SVProgressHUD.dismiss()
            result(model)
        }
    }
    
    
}
