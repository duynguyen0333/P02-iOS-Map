//
//  UserData.swift
//  [P02] OnTheMap
//
//  Created by aia on 06/11/2023.
//

import Foundation

struct UserDataResponse: Codable {
    let firstName: String
    let lastName: String
    let nickname: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case nickname
    }
}
