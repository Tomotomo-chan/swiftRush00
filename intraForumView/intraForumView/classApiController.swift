//
//  classApiController.swift
//  intraForumView
//
//  Created by Corentin DROUET on 10/7/17.
//  Copyright © 2017 Corentin DROUET / Mathilde Ressier. All rights reserved.
//

import Foundation

class APIController {
    weak var delegate: API42Delegate?
    var token: String?
    let credentials: credentialsStruct?
    
    func 
    
    init(newDelegate: API42Delegate?, newCredentials: credentialsStruct) {
        self.delegate = newDelegate
        self.credentials = newCredentials
        let options = ("client_id=" + (self.credentials?.UID!)! + "&client_secret=" + (self.credentials?.Secret!)! + "&grant_type=client_credentials").data(using: String.Encoding.utf8)
        let url = URL(string: "https://api.intra.42.fr/oauth/token")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = options
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if let err = error {
                print(err)
            } else if let d = data {
                do {
                    if let dic: NSDictionary = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        print(dic)
                        if let newToken = dic["access_token"] as? String {
                            self.token = newToken
                            DispatchQueue.main.async {
                                self.delegate?.treatTopic(str: self.token!)
                            }
                        }
                    }
                } catch (let err) {
                    print(err)
                }
            }
        }
        task.resume()
    }
    
    func tryToConnect() {
        if let validToken = self.token {
            let url = URL(string: "https://signin.intra.42.fr/users/sign_in")
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer " + validToken, forHTTPHeaderField: "Authorization")
            print("0")
            let task = URLSession.shared.dataTask(with: request) {
                (data, response, error) in
                print("1")
                print(response!)
                if let err = error {
                    print(err)
                } else if let d = data {
                    print("2")
                    print(d)
                    do {
                        if let dic: NSArray = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray {
                                print("3")
                                print(dic)
                        }
                    } catch (let err) {
                        print(err)
                    }
                }
            }
            task.resume()
        }
    }
}
