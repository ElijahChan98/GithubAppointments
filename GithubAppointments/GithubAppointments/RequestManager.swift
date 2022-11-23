//
//  RequestManager.swift
//  GithubAppointments
//
//  Created by Bernadette Quennie Barrameda on 11/23/22.
//

import Foundation

public enum RequestMethod: String {
    case post = "POST"
    case put = "PUT"
    case get = "GET"
}

struct Constants {
    static let GITHUB_BASE_URL = "https://api.github.com"
    static let GITHUB_USERS = "/users"
}

class RequestManager {
    public static let shared = RequestManager()
    
    public func fetchGithubUsers(completion: @escaping (_ success: Bool, _ response: [String:Any]?) -> ()) {
        DispatchQueue.global().async {
            let dispatchGroup = DispatchGroup()

            dispatchGroup.enter()
            
            let url = "\(Constants.GITHUB_BASE_URL)\(Constants.GITHUB_USERS)"
            self.createGenericRequest(url: url, requestMethod: .get) { (success, response) in
                DispatchQueue.main.async {
                    completion(success, response)
                }
            }
            
            dispatchGroup.wait()
            
        }
    }
    
    public func fetchGithubUserProfile(username: String, completion: @escaping (_ success: Bool, _ response: [String:Any]?) -> ()) {
        DispatchQueue.global().async {
            let dispatchGroup = DispatchGroup()
            dispatchGroup.enter()
            
            let url = "\(Constants.GITHUB_BASE_URL)\(Constants.GITHUB_USERS)/\(username)"
            self.createGenericRequest(url: url, requestMethod: .get) { (success, response) in
                DispatchQueue.main.async {
                    completion(success, response)
                }
            }
            dispatchGroup.leave()
        }
        
    }
    
    private func createGenericRequest(url: String, requestMethod: RequestMethod, completion: @escaping (_ success: Bool, _ response: [String: Any]?) -> ()) {
        guard Reachability.isConnectedToNetwork() else {
            completion(false, nil)
            return
        }
        
        let session = URLSession.shared
        let urlString = url.urlString()
        let requestURL = URL(string: urlString)!
        let request = URLRequest(url: requestURL)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 401 {
                    }
                    else if httpResponse.statusCode == 500 {
                        //internal server error
                    }
                }
                
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        if let payload = json as? [String: Any] {
                            completion(true, payload)
                        }
                        else if let payloads = json as? [[String:Any]] {
                            //print(payloads)
                            completion(true, ["payloads" : payloads])
                        }
                    }
                    catch {
                        print("something went wrong")
                    }
                }
                else {
                    completion(false, nil)
                }
            }
        }
        task.resume()
    }
}
