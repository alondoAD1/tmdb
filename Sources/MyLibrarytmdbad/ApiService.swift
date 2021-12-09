//
//  ApiService.swift
//  tmdbtest
//
//  Created by A on 05/12/21.
//

import Foundation
import UIKit
import RNCryptor


public class ApiService {
    
    let sto                         = Storage()
    let dataCrypt                   = CryptData()

    public let apiKey               = "7662169d6cde796d24b257cd0f8a268e"
    let getTokenMethod              = "authentication/token/new"
    public let baseURLSecureString  = "https://api.themoviedb.org/3/"

    let loginMethod                 = "authentication/token/validate_with_login"
    let getSessionIdMethod          = "authentication/session/new"
    let getUserIdMethod             = "account"
    let oncryptKey                  = "xDnMQpKDSREksd342JKS"
    
    var usr                         = "RicardoAD"
    var pas                         = "123456aD"
    var token                       = String()
    public var userID               = Int()
    public var sessionID            = String()
        
    public init() {}

    public typealias ApiComplet = (_ success: Bool, _ requestTok: String, _ userID: Int, _ SessionID: String, _ error: String) -> Void
    public typealias Completition = (_ success: Bool,_ error: String) -> Void
        
    public func Apirequest(completion: @escaping Completition) {
        if (UserDefaults.standard.string(forKey: Storage.userKeyDefault) == nil) {
            let urlString = baseURLSecureString + getTokenMethod + "?api_key=" + apiKey
            let url = NSURL(string: urlString)!
            let request = NSMutableURLRequest(url: url as URL)
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            let session = URLSession.shared
            let task = session.dataTask(with: request as URLRequest) { data, response, downloadError in
                if let error = downloadError {
                    completion(false, "No se completo la solicitud apireq \(error)")
                } else {
                    let parsedResult = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                    if let requestTok = parsedResult["request_token"] as? String {
                        self.token = requestTok
                        self.loginWithToken(requestTok, completion)
                        completion(false, "Token creado")

                    } else {
                        completion(false, "No se encontro request_token in \(parsedResult)")
                    }
                }
            }
            task.resume()
        } else { completion(true, "Inicio sin ningun problema") }
    }
        func loginWithToken(_ requestToken: String,_ completion: @escaping Completition) {

            let parameters = "?api_key=\(apiKey)&request_token=\(requestToken)&username=\(self.usr)&password=\(self.pas)"
        let urlString = baseURLSecureString + loginMethod + parameters
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(url: url as URL)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, downloadError in
            if let error = downloadError {
                completion(false, "No se completo la solicitud login \(error)")
            } else {
                let parsedResult = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                if let success = parsedResult["success"] as? Bool {
                    completion(false,  "Login status: \(success)")
                    self.getSessionID(requestToken, completion: completion)
                } else {
                    if let status_code = parsedResult["status_code"] as? Int {
                        let message = parsedResult["status_message"]
                        completion(false,  "\(status_code): \(message!)")

                    } else {
                        completion(false, "No se encontro success in \(parsedResult)")

                    }
                }
            }
        }
        task.resume()
    }
    
    func getSessionID(_ requestToken: String, completion: @escaping Completition) {
        let parameters = "?api_key=\(apiKey)&request_token=\(requestToken)"
        let urlString = baseURLSecureString + getSessionIdMethod + parameters
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(url: url as URL)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, downloadError in
            if let error = downloadError {
                completion(false,  "No se completo la solicitud session \(error)")
            } else {
                let parsedResult = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                if let sessionID = parsedResult["session_id"] as? String {
                    self.sessionID = sessionID
                    self.getUserID(sessionID, completion: completion)
                    completion(false,  "Session ID creada")

                } else {
                    completion(false,  "No se encontro session_id in \(parsedResult)")
                }
            }
        }
        task.resume()

    }
    
    func getUserID(_ sessionID: String, completion: @escaping Completition) {
        let urlString = baseURLSecureString + getUserIdMethod + "?api_key=" + apiKey + "&session_id=" + sessionID
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(url: url as URL)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, downloadError in
            if let error = downloadError {
                completion(false, "No se completo la solicitud userid \(error)")
            } else {
                let parsedResult = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                if let userID = parsedResult["id"] as? Int {
                    self.userID = userID
                    
                    Storage.username    = self.dataCrypt.encrypt(textEncrypt: self.usr)
                    Storage.password    = self.dataCrypt.encrypt(textEncrypt: self.pas)
                    Storage.token       = self.dataCrypt.encrypt(textEncrypt: self.token)
                    Storage.sessionID   = self.dataCrypt.encrypt(textEncrypt: self.sessionID)
                    Storage.userID      = self.dataCrypt.encrypt(textEncrypt: String(userID))
                    completion(true, "Inicio sin ningun problema")
                    
                } else {
                    completion(false, "No se encontro user id in \(parsedResult)")
                    
                }
            }
        }
        task.resume()
    }

    
    

    
}

