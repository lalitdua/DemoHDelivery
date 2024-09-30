//
//  MainTabBarVC.swift
//  HaatDemo
//
//  Created by Dhairya on 26/09/24.
//

import UIKit

class MainTabBarVC: UITabBarController, UITabBarControllerDelegate {

    var viewModel = MainTabViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.delegate = self
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.tabBar.tintColor = UIColor(named: "themeColor")
        if let tabBarItems = self.tabBar.items {
            for index in 0 ..< tabBarItems.count {
                if #available(iOS 15.0, *) {
                    let appearance = UITabBarAppearance()
                    appearance.configureWithOpaqueBackground()
                    UITabBar.appearance().standardAppearance = appearance
                    UITabBar.appearance().scrollEdgeAppearance = appearance // for scrollable content
                    UITabBar.appearance().tintColor = UIColor(named: "themeColor")
                }
                let tabBarItem = tabBarItems[index]
                let tabViewModel = self.viewModel.tabs[index]
                tabBarItem.image = UIImage(named: tabViewModel.imageName)
                tabBarItem.title = tabViewModel.title
//                tabBarItem.selectedImage = UIImage(named: tabViewModel.selectedImageName)
//                tabBarItem.imageInsets = UIEdgeInsets(top: -4, left: 0, bottom: -5, right: 0)
//                tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -4)
            }
        }
    }
    
    
//    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        tabTitle = "\(item.title ?? "Home")"
//        if tabTitle == "Challenges" || tabTitle == "Profile" || tabTitle == "Home" || tabTitle == "Search" {
//            UserDefaults.standard.removeObject(forKey: "FilterValues")
//        }
//    }
//    
//    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//        if let guestLogin = UserDefaults.standard.value(forKey: "GuestLogin") as? String {
//            if guestLogin ==  "true" {
//                if tabTitle == "Challenges" || tabTitle == "Profile" {
//                    gotoGuestPopUp()
//                    return false
//                }
//            } else {
//                return true
//            }
//        } else {
//            return true
//        }
//        return true
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
