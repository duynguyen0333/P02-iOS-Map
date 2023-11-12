//
//  UserProfile.swift
//  [P02] OnTheMap
//
//  Created by aia on 08/11/2023.
//

import Foundation

class UserProfileModel : Codable {
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
