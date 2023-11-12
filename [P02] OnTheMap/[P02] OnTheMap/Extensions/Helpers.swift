//
//  Helpers.swift
//  [P02] OnTheMap
//
//  Created by aia on 12/11/2023.
//

import Foundation

class StudentData : NSObject {
    var students = [StudentInformationModel]()
    
    class func sharedInstance() -> StudentData {
        struct Singleton {
            static var sharedInstance = StudentData()
        }
        return Singleton.sharedInstance
    }
}
