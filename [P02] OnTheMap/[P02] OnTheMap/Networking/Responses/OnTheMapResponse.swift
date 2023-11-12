//
//  OnTheMapResponse.swift
//  [P02] OnTheMap
//
//  Created by aia on 06/11/2023.
//

import Foundation

struct OnTheMapResponse: Codable {
    let statusCode: Int
    let statusMessage: String
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}

extension OnTheMapResponse: LocalizedError {
    var errorDescription: String? {
        return statusMessage
    }
}
