//
//  LoginRequest.swift
//  [P02] OnTheMap
//
//  Created by aia on 06/11/2023.
//

import Foundation

class LoginRequest : Codable {
    let udacity: CredentialModel
    
    init(username: String, password: String) {
        udacity = CredentialModel(username: username, password: password)
    }
}
