//
//  StudentInformation.swift
//  [P02] OnTheMap
//
//  Created by aia on 06/11/2023.
//

import Foundation
import MapKit

struct StudentInformationModel: Codable {
    let firstName: String?
    let lastName: String?
    let longitude: Double?
    let latitude: Double?
    let mapString: String
    let mediaURL: String
    let uniqueKey: String
    var objectId: String? = nil
    var createdAt: String? = nil
    var updatedAt: String? = nil
    
    init(mapString: String, mediaURL: String, uniqueKey: String, location: CLLocationCoordinate2D) {
        self.firstName = "Nguyen"
        self.lastName = "Duy"
        self.longitude = location.longitude
        self.latitude = location.latitude
        self.mapString = mapString
        self.mediaURL = mediaURL
        self.uniqueKey = uniqueKey
    }
}

