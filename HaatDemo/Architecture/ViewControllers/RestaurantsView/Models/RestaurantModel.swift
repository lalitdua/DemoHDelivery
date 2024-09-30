//
//  RestaurantModel.swift
//  HaatDemo
//
//  Created by Dhairya on 29/09/24.
//

import Foundation


// MARK: - RestaurantModel
struct RestaurantModel: Codable {
    let isInOperating: Bool?
    let closestArea: JSONNull?
    let areasContainer: AreasContainer?
    let appSettings: AppSettings?
    let areaSettings: AreaSettings?
    let tags: Tags?
    let mainPageBanners: MainPageBanners?
    let categories: [Category]?
}

// MARK: - AppSettings
struct AppSettings: Codable {
    let version: Version?
    let customerServicePhone: String?
    let imageServer: String?
    let currency: Currency?
    let appUpdateSettings: AppUpdateSettings?
}

// MARK: - AppUpdateSettings
struct AppUpdateSettings: Codable {
    let forceUpdateSettings, regularUpdateSettings: UpdateSettings?
}

// MARK: - UpdateSettings
struct UpdateSettings: Codable {
    let messageTitle, messageBody: String?
    let androidVersion, iosVersion: Int?
}

// MARK: - Currency
struct Currency: Codable {
    let currencyID: Int?
    let symbol, name: String?

    enum CodingKeys: String, CodingKey {
        case currencyID = "currencyId"
        case symbol, name
    }
}

// MARK: - Version
struct Version: Codable {
    let iosMinVersion, androidMinVersion: Int?
}

// MARK: - AreaSettings
struct AreaSettings: Codable {
    let areaStatus: Int?
    let isAnnouncement: Bool?
    let announcement, restrictionMessage: Announcement?
    let pickupWorkingHours, deliveryWorkingHours: [WorkingHour]?
    let aggregatedDeliveryWorkingHours, aggregatedPickupWorkingHours: [AggregatedWorkingHour]?
}

// MARK: - AggregatedWorkingHour
struct AggregatedWorkingHour: Codable {
    let fromDay, toDay, fromHour, toHour: Int?
    let type: Int?
}

// MARK: - Announcement
struct Announcement: Codable {
    let title, message: String?
}

// MARK: - WorkingHour
struct WorkingHour: Codable {
    let dayOfWeek, from, to, type: Int?
}

// MARK: - AreasContainer
struct AreasContainer: Codable {
    let areasInCountry, areasOutOfCountry, allAreas: [AllArea]?
}

// MARK: - AllArea
struct AllArea: Codable {
    let areaID: Int?
    let coordinates: [Coordinate]?
    let latitude, longitude, distance: Double?
    let name: String?
    let countryID: Int?
    let isNew, isReadyArea, isMarketReady, isRestaurantReady: Bool?

    enum CodingKeys: String, CodingKey {
        case areaID = "areaId"
        case coordinates, latitude, longitude, distance, name
        case countryID = "countryId"
        case isNew, isReadyArea, isMarketReady, isRestaurantReady
    }
}

// MARK: - Coordinate
struct Coordinate: Codable {
    let latitude, longitude: Double?
}

// MARK: - Category
struct Category: Codable {
    let title: Title?
    let maxRows, id, priority: Int?
    let elementType, name: String?
    let backgroundImage, topImage: BackgroundImage?
    let topImageType: Int?
    let isSponsored, viewAll: Bool?
    let backgroundColor: String?
    let stores: [Store]?
    let image: BackgroundImage?
    var isOpenData: Bool? = false
}

// MARK: - BackgroundImage
struct BackgroundImage: Codable {
    let serverImage, smallServerImage, blurhashImage: String?
}

// MARK: - Store
struct Store: Codable {
    let storeID: Int?
    let name, address: String?
    let opacity, distance: Double?
    let icon: BackgroundImage?
    let rating: Rating?
    let labels: [Label]?
    let closestWorkingHour: String?
    let is24Hours: Bool?
    let priority, status: Int?
    let isNew: Bool?
    let zoneID: JSONNull?
    let recommendedPriority: Int?
    let backgroundImage: BackgroundImage?
    let foregroundImage: [BackgroundImage]?
    let title, subTitle: String?

    enum CodingKeys: String, CodingKey {
        case storeID = "storeId"
        case name, address, opacity, distance, icon, rating, labels, closestWorkingHour, is24Hours, priority, status, isNew
        case zoneID = "zoneId"
        case recommendedPriority, backgroundImage, foregroundImage, title, subTitle
    }
}

// MARK: - Label
struct Label: Codable {
    let text, labelType: String?
}

// MARK: - Rating
struct Rating: Codable {
    let value: Double?
    let numberOfRatings: NumberOfRatings?
}

enum NumberOfRatings: String, Codable {
    case the1 = "1+"
    case the10 = "10+"
    case the100 = "100+"
    case the1000 = "1000+"
    case the200 = "200+"
    case the500 = "500+"
}

// MARK: - Title
struct Title: Codable {
    let text: JSONNull?
    let type: Int?
}

// MARK: - MainPageBanners
struct MainPageBanners: Codable {
    let interval: Int?
    let banners: [Banner]?
}

// MARK: - Banner
struct Banner: Codable {
    let businessID: Int?
    let businessName: BusinessName?
    let businessType: String?
    let linkedBanner: Bool?
    let image: BackgroundImage?

    enum CodingKeys: String, CodingKey {
        case businessID = "businessId"
        case businessName, businessType, linkedBanner, image
    }
}

// MARK: - BusinessName
struct BusinessName: Codable {
    let ar, enUS, he, fr: String?

    enum CodingKeys: String, CodingKey {
        case ar
        case enUS = "en-US"
        case he, fr
    }
}

// MARK: - Tags
struct Tags: Codable {
    let title: String?
    let tags: [Tag]?
}

// MARK: - Tag
struct Tag: Codable {
    let id: Int?
    let name: String?
    let images: BackgroundImage?
    let backgroundColor: JSONNull?
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
            return true
    }

    public var hashValue: Int {
       return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if !container.decodeNil() {
                    throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
            }
    }

    public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
    }
}
