//
//  LoginResponse.swift
//  [P02] OnTheMap
//
//  Created by aia on 06/11/2023.
//
import Foundation

struct LoginResponse: Codable {
    let account: Account
    let session: Session
}

struct Account: Codable {
    let registered: Bool
    let key: String
}

struct Session: Codable {
    let id: String
    let expiration: String
}
