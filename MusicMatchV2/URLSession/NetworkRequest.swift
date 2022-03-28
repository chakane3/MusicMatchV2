//
//  NetworkRequest.swift
//  MusicMatchV2
//
//  Created by Chakane Shegog on 3/28/22.
//

import Foundation

/*
    We use an enum so catch some potential errors that could occur when running this app
*/
public enum NetworkError: Error {
    case badURL(String)
    case noResponse
    case networkClientError(Error)
    case noData
    case decodingError(Error)
    case encodingError(Error)
    case badStatusCode(Int)
    case badMimeType(String)
}

private struct CacheKey {
    static let lastModifiedDate = "Last Modified Cached Date"
}

public class NetworkRequest {
    public static let shared = NetworkRequest()
    private var urlSession: URLSession
    private var isCaching = true
    
    // asserts a singleton design pattern
    private init() {
        urlSession = URLSession(configuration: .default)
    }
    
    private func verifyCacheDate(for lastModifiedTimeInterval: TimeInterval, maxCacheDays: Int) {
        // create 2 Date() objects for TimeIntervals
        let lastModifiedDate = Date(timeIntervalSince1970: lastModifiedTimeInterval)
        let todaysDate = Date(timeIntervalSince1970: Date().timeIntervalSince1970)
        
        // get an instance of the users calendar
        let calendar = Calendar.current
        
        // get the difference between 2 Date() objects
        let components = calendar.dateComponents([.day], from: lastModifiedDate, to: todaysDate)
        
        // extract the dat value from the DateCmponent
        let differenceInDates = components.day ?? 0
        
        // clear the urlCache if maxCacheDays has expired
        if differenceInDates >= maxCacheDays {
            urlSession.configuration.urlCache?.removeAllCachedResponses()
            isCaching = false
        }
    }
    
    // perform the network request given a URLRequest
    public func performDataTask(with request: URLRequest, maxCacheDays: Int = 0, completion: @escaping (Result<Data, NetworkError>) -> ()) {
        // check if the cache shou;d be clared based on an X amount of days since the last modified date of the saved cache
        
        // get the cache date
        if let lastModifiedTimeInterval = UserDefaults.standard.object(forKey: CacheKey.lastModifiedDate) as? TimeInterval {
            // if time has expired, clear the cache
            verifyCacheDate(for: lastModifiedTimeInterval, maxCacheDays: maxCacheDays)
        }
        
        if isCaching {
            if let cachedResponse = urlSession.configuration.urlCache?.cachedResponse(for: request),
               let _ = cachedResponse.response as? HTTPURLResponse {
                let data = cachedResponse.data
                completion(.success(data))
                return
            }
        }
        
        /* setup URLSession dataTask()
            dataTask(with:completionHandler:) - Creates a task that retrieves the content of a URL based on its request object, and calls a handler upon completion.
                                                A completionHandler is called when the load request is complete. This handler is executed on the delegate queue.
                                                The completion handlertakes in 3  parameters:
                                                (1) data - which returned by the server
                                                (2) response - An object that provides response metadata like HTTP headers and status code. when we make an HTTP request
                                                               the returned object is an HTTPURLResponse object.
                                                (3) error - This is an object which indicates why the request failed, nil, or if the request was successful.
         
         The return value for our datatask is a new session data task.
        */
        let dataTask = urlSession.dataTask(with: request) { (data, response, error) in
            // check for network client errors
            if let error = error {
                completion(.failure(.networkClientError(error)))
                return
            }
            
            // downcast URLResponse to HTTPURLResponse for the statuscode property
            guard let urlResponse = response as? HTTPURLResponse else {
                completion(.failure(.noResponse))
                return
            }
            
            // unwrap the data object
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            // validate that the status code is in the 200 range
            switch urlResponse.statusCode {
            case 200...299: break
            default:
                completion(.failure(.badStatusCode(urlResponse.statusCode)))
                return
            }
            
            // save the last modified cache date
            let cachedDate = Date().timeIntervalSince1970
            UserDefaults.standard.set(cachedDate, forKey: CacheKey.lastModifiedDate)
            
            // capture our network data
            completion(.success(data))
        }
        dataTask.resume()
    }
}
