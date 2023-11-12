//
//  OnTheMapErrorResponse.swift
//  [P02] OnTheMap
//
//  Created by aia on 06/11/2023.
//

import Foundation

struct OnTheMapErrorResponse: Codable {
    let status: Int
    let error: String
}

extension OnTheMapErrorResponse: LocalizedError {
    var errorDescription: String? {
        return error
    }
}
