//
//  ServiceCommand.swift
//  [P02] OnTheMap
//
//  Created by aia on 07/11/2023.
//

import Foundation

import Foundation

class ServiceCommand {
    class func taskForGetRequest<ResponseType: Decodable>(configKey: String, url: URL, responseType: ResponseType.Type, completionHandler: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept") 
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            handleResponse(configKey: configKey, data: data, error: error,  responseType: responseType, completionHandler: completionHandler)
        }
        task.resume() 
        return task
    }
    
    class func taskForPostRequest<RequestType: Encodable, ResponseType: Decodable>(configKey: String, url: URL, request: RequestType, responseType: ResponseType.Type, completionHandler: @escaping (ResponseType?, Error?) -> Void) {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.httpBody = try! JSONEncoder().encode(request)
        
        print(String(data: urlRequest.httpBody!, encoding: .utf8) ?? "")
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            handleResponse(configKey: configKey, data: data, error: error, responseType: responseType, completionHandler: completionHandler)
        }
        
        task.resume()
    }

    private class func handleResponse<ResponseType: Decodable>(configKey: String, data: Data?, error: Error?, responseType: ResponseType.Type, completionHandler: @escaping (ResponseType?, Error?) -> Void) {
        let completionHandler = {(response: ResponseType?, error: Error?) in
            DispatchQueue.main.async {
                completionHandler(response, error)
            }
        }
        
        var currentData : Data

        guard let data = data else {
            completionHandler(nil, error)
            return
        }
                
        /// If have "Udacity" => remove 5
        if configKey == "udacity" {
            let range = 5..<data.count
            let newData = data.subdata(in: range)
            currentData = newData
        } else {
            currentData = data
        }
        
        do {
            let response = try JSONDecoder().decode(ResponseType.self, from: currentData)
            print("Response \(response)")
            completionHandler(response, nil)
        } catch {
            print ("Error \(error)")
            handleError(data: data, completionHandler: completionHandler)
        }
    }
    
    private class func handleError<ResponseType: Decodable>(data: Data, completionHandler: (ResponseType?, Error?) -> ()) {
        do {
            let errorResponse = try JSONDecoder().decode(OnTheMapErrorResponse.self, from: data)
            completionHandler(nil, errorResponse)
        } catch {
            completionHandler(nil, error)
        }
    }
}


