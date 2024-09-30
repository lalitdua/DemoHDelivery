//
//  OrdersDataModel.swift
//  HaatDemo
//
//  Created by Dhairya on 29/09/24.
//

import Foundation


// MARK: - OrderDataModel
struct OrderDataModel: Codable {
    let id, paymentMethod: Int?
    let longitude, latitude: Double?
    let companyID: Int?
    let price: Double?
    let orderDate: String?
    let acceptedDate, pickedDate, arriveDate, meals: String?
    let estimationTime, driverPrice, restaurantPrice: Double?
    let withDriver: Bool?
    let restaurantId: Int?
    let startPrepare: String?
    let transactionCode, operatingSystem, deviceType: String?
    let rejectedDateByRestaurant, driverName, driverPhoneNumber: String?
    let timeToUser: Int?
    let userFeedBack: Bool?
    let donePrepare: String?
    let driverDescription, appVersion, creditCardToken, cardYear: String?
    let cardMonth, phoneNumber, userName, email: String?
    let payRestaurant, getFromClient, deliveryType: Int?
    let restaurantDetail: RestaurantDetail?
    let tokenCardType: Int?
    let serviceFee: Int?
    let deliveryFeeDetails: DeliveryFeeDetails?
    let currencyData: CurrencyData?
    let isCibus: Bool?
    let isRemake, isCanceled: Bool?
    let cocaColaCampaignDetails: CocaColaCampaignDetails?
    let credits: Int?
    let enableReorder: Bool?
}

// MARK: - CocaColaCampaignDetails
struct CocaColaCampaignDetails: Codable {
    let hasCocaColaBrand, isDone: Bool?
}

// MARK: - CurrencyData
struct CurrencyData: Codable {
    let symbol: String?
    let names: Names?
}

// MARK: - Names
struct Names: Codable {
    let ar, enUS, he: String?
}

// MARK: - DeliveryFeeDetails
struct DeliveryFeeDetails: Codable {
    let taskCost, userFee, originalUserFee: Int?
    let restaurantFeeCoverage, haatMarketingFeeCoverage, haatOperationFeeCoverage, userPricingModel: Int?
    let driverPricingModel: Int?
}

// MARK: - RestaurantDetail
struct RestaurantDetail: Codable {
    let details: Details?
    let meals: [Meal]?
    let products: [Products]?
    let deals: [Deals]?
}

struct Deals: Codable {
    let id: Int?
    let name_AR: String?
    let name_EN: String?
    let name_HE: String?
    let name_FR: String?
    let serverImage: String?
    let smallImage: String?
    let blurhash: String?
    let price: Double?
    let isPizza: Bool?
    let priority: Int?
    let mealTypePriority: Int?
    let quantity: Int?
    let finalPriceToDisplay: Double?
    let finalPriceOfExtrasToDisplay: Double?
    let finalPriceWithExtrasToDisplay: Double?
}

// MARK: - Details
struct Details: Codable {
    let id: Int?
    let name, nameAR, nameHE, nameEN: String?
    let address, addressAR, addressHE, addressEN: String?
    let latitude, longitude: Double?
    let havePrivateDelivery: Bool?
    let phoneNumber: String?
    let priority, restaurantCategoryID: Int?
    let images: [Image]?
    let icon, smallIcon: String?
    let status: Int?
    let type: String?
}

// MARK: - Image
struct Image: Codable {
    let id: Int?
    let serverImageURL: String?
    let smallImageURL: String?
    let priority: Int?
}

// MARK: - Meal
struct Meal: Codable {
    let id, quantity: Int?
    let mealContents: [MealContent]?
    let smallImage: String?
    let price: Double?
    let serverImage, blurhash, name, nameAR: String?
    let nameEN, nameHE, nameFR: String?
    let isPizza: Bool?
    let prioirty, mealTypePriority: Int?
    let isPartialMealContentPricing: Bool?
    let finalPriceToDisplay, finalPriceOfExtrasToDisplay, finalPriceWithExtrasToDisplay: Int?
}

struct ProductName: Codable {
    let ar: String?
    let he: String?
}

struct ProductImages: Codable {
    let id: Int?
    let priority: Int?
    let serverImageUrl: String?
    let smallImageUrl: String?
    let blurhash: String?
}

struct Products: Codable {
    let id: Int?
    let name: ProductName?
    let productImages: [ProductImages]?
    let discountPercentage: Double?
    let discountPrice: Double?
    let price: Double?
    let quantity: Int?
    let orderId: Int?
    let productId: Int?
    let supportDynamicPricing: Bool?
    let isBigItem: Bool?
    let finalWeight: Double?
    let finalPrice: Double?
    let finalWeightToDisplay: Double?
    let finalPriceToDisplay: Double?
    let strikedPriceToDisplay: Double?
    let finalPriceOfExtrasToDisplay: Double?
    let finalPriceWithExtrasToDisplay: Double?
    let quantityTypeToDisplay: Int?
    let unitTypeToDisplay: Int?
    let priceBeforeUpdateToDisplay: Double?
    let orderDealProductId: Int?
}

// MARK: - MealContent
struct MealContent: Codable {
    let id, type, price: Int?
    let smallImageURL, serverImageURL, name, nameAR: String?
    let nameEN, nameHE: String?
    let nameFR: String?
    let qty, mealContentType, group, priority: Int?
    let hideExtra, isPizza: Bool?
    let mealContentPrinting: Int?
}
