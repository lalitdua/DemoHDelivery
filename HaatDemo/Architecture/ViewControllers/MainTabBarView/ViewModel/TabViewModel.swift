//
//  TabViewModel.swift
//  HaatDemo
//
//  Created by Dhairya on 26/09/24.
//

import Foundation

struct MainTabModel {
    
    var title: String
    var imageName: String
    
}

class MainTabViewModel: NSObject {
    
    var tabs: [MainTabModel] = [
        MainTabModel(title: "Restaurants", imageName: "restaurant"),
        MainTabModel(title: "Market", imageName: "market"),
        MainTabModel(title: "My Cart", imageName: "cart"),
        MainTabModel(title: "My Orders", imageName: "orders"),
        MainTabModel(title: "Profile", imageName: "profile")
    ]
    
}
