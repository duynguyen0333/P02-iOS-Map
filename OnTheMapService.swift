//
//  OnTheMapService.swift
//  [P02] OnTheMap
//
//  Created by aia on 06/11/2023.
//

import Foundation

class OnTheMapService {
    static var studentLocations: [StudentInformationModel] = []
    
    struct Auth {
        static var userId = ""
        static var sessionId = ""
        static var objectId = ""
        static var firstName = ""
        static var lastName = ""
    }
    
    enum Endpoints {
        static let baseUrl = "https://onthemap-api.udacity.com/v1/"
        
        case login
        case getStudentLocations
        case getUserInformation
        case postStudentLocations

        var stringValue: String {
            switch self {
                case .login: return Endpoints.baseUrl + "session"
                case .getStudentLocations: return Endpoints.baseUrl + "StudentLocation?limit=50&order=-updatedAt"
                case .getUserInformation: return Endpoints.baseUrl + "users/" + Auth.userId
                case .postStudentLocations: return Endpoints.baseUrl + "StudentLocation"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func login(email: String, password: String, completionHandler: @escaping (Bool, Error?) -> Void) {
        let request = LoginRequest(username: email, password: password)
        ServiceCommand.taskForPostRequest(configKey: "udacity", url: Endpoints.login.url, request: request, responseType: LoginResponse.self) { (response, error) in
            if let response = response {
                Auth.sessionId = response.session.id
                Auth.userId = response.account.key
            
                getUserInformation { (success, error) in
                    if success {
                        print("Login Success")
                    }
                }
                completionHandler(true, nil)
            } else {
                completionHandler(false, error)
            }
        }
    }
    
    class func getUserInformation(completionHandler: @escaping (Bool, Error?) -> Void) {
        ServiceCommand.taskForGetRequest(configKey: "udacity", url: Endpoints.getUserInformation.url, responseType: UserProfileModel.self ) { response, error in
            if let response = response {
                print("UserData response \(response.firstName)")
                Auth.firstName = response.firstName
                Auth.lastName = response.lastName
                print("UserData \(Auth.firstName)")
                completionHandler(true, nil)
            } else {
                completionHandler(false, error)
            }
        } 
    }
    
    // MARK: Get all locations
    class func getStudentLocations(completionHandler: @escaping ([StudentInformationModel]?, Error?) -> Void) {
        ServiceCommand.taskForGetRequest(configKey: "", url: Endpoints.getStudentLocations.url, responseType: StudentsModel.self ) { response, error in
            if let response = response {
                print(response.results)
                completionHandler(response.results, nil)
            } else {
                completionHandler([], error)
            }
        }
    }
    
    class func postStudentLocation(studentLocation: StudentInformationModel, completionHandler: @escaping (Bool, Error?) -> Void) {
        print("request \(studentLocation)")
        ServiceCommand.taskForPostRequest(configKey: "", url: Endpoints.postStudentLocations.url, request: studentLocation, responseType: StudentLocationResponse.self) { (response, error) in
            guard let response = response else {
                Auth.objectId = response?.objectId ?? ""
                completionHandler(false, error)
                return
            }
            print("Success save location \(String(describing: response.objectId))")
            completionHandler(true, nil)
        }
    }
    
    class func logout(completionHandler: ((Bool, Error?) -> Void)? = nil) {
        var request = URLRequest(url: URL(string: Endpoints.login.stringValue)!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
    
        let completionHandler = { (success: Bool, error: Error?) in
            DispatchQueue.main.async {
                completionHandler?(success, error)
            }
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            Auth.sessionId = ""
            Auth.userId = ""

            guard let data = data else {
                completionHandler(false, error)
                return
            }
            let range = 5..<data.count
            let newData = data.subdata(in: 5..<data.count)
            completionHandler(true, nil)
        }
        task.resume()
    }
}
