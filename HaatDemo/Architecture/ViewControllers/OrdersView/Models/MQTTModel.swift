//
//  MQTTModel.swift
//  HaatDemo
//
//  Created by Dhairya on 29/09/24.
//

import Foundation


struct MQTTModel: Codable {
    
    let userName: String?
    let clientId: String?
    let password: String?
    let topic: String?
    let host: String?
    let port: Int?
    let qos: Int?
    
}
