//
//  ApiConstant.swift
//  HaatDemo
//
//  Created by Dhairya on 29/09/24.
//


import UIKit
import Foundation



let homePageAPI = "https://user-app-staging.haat-apis.com/api/user/main-page/by-area/1?type=Restaurant"
let ordersPageAPI = "https://user-new-app-staging.internal.haat.delivery/api/Orders/v2/GetHistoryOrders/"
let trackingAPI = "https://user-app-staging.internal.haat.delivery/api/orders/driver-location-credentials"


struct APIConstants {
    static let statusCode               = "statusCode"
    static let response                 = "response"
    static let data                     = "data"
    static let message                  = "message"
    static let responseType             = "responseType"
    static let deviceToken              = "1234567890"
}

struct GenericErrorMessages {
    static let internalServerError      = "Something went wrong. Try again."
    static let noInternet               = "No internet connection."
}



