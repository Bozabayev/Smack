//
//  AuthService.swift
//  Smack
//
//  Created by Rauan on 10/30/18.
//  Copyright © 2018 Rauan. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AuthServices {
    
    static let instance = AuthServices()
    
    let defaults = UserDefaults.standard
    
    var isLoggedIn : Bool {
        get {
            return defaults.bool(forKey: LOGGED_IN_KEY)
        }
        set {
            defaults.set(newValue, forKey: LOGGED_IN_KEY)
        }
    }
    
    var authToken : String {
        get {
            return defaults.value(forKey: TOKKEN_KEY) as! String
        }
        set {
            defaults.set(newValue, forKey: TOKKEN_KEY)
        }
    }
    
    var userEmail : String {
        get {
            return defaults.value(forKey: USER_EMAIL) as! String
        }
        set {
            defaults.set(newValue, forKey: USER_EMAIL)
        }
    }
    
    
    func registerUser(email: String, password: String, completion: @escaping CompletionHandler) {
        
        let lowerCaseEmail = email.lowercased()
        
        let body: [String: Any] = [
        
            "email": lowerCaseEmail,
            "password": password
        ]
    
        Alamofire.request(URL_REGISTER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseString { (response) in
            
            if response.result.error == nil {
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func loginUser(email: String, password: String, completion: @escaping CompletionHandler) {
        
        
        let lowerCaseEmail = email.lowercased()
        
        let body: [String: Any] = [
            
            "email": lowerCaseEmail,
            "password": password
        ]
        
        Alamofire.request(URL_LOGIN, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else {return}
                var json : JSON?
                do {
                     json = try JSON(data: data)
                }catch {
                    print("json encoding error")
                }
                guard let unwJSON = json else {
                    print("unwrapping problem of JSON")
                    return
                }
                self.userEmail = unwJSON["user"].stringValue
                self.authToken = unwJSON["token"].stringValue
                
                self.isLoggedIn = true
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
        
    }
    
    func createUser(name: String, email: String, avatarName: String, avatarColor: String, completion: @escaping CompletionHandler) {
        
        let lowerCaseEmail = email.lowercased()
        
        let body: [String: Any] = [
            
            "name": name,
            "email": lowerCaseEmail,
            "avatarName": avatarName,
            "avatarColor": avatarColor
        ]
        
        
        Alamofire.request(URL_USER_ADD, method: .post, parameters: body, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            
            if response.result.error == nil {
                guard let data = response.data else {return}
                
                self.setUserInfo(data: data)
                
               
                completion(true)
                
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
        
    }
    
    
    func findUserByEmail(completion: @escaping CompletionHandler) {
        
        Alamofire.request("\(URL_USER_BY_EMAIL)\(userEmail)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            
            if response.result.error == nil {
                guard let data = response.data else {return}
                self.setUserInfo(data: data)
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
        
    }
    
    func setUserInfo(data: Data) {
        var json: JSON?
        do {
            json = try JSON(data: data)
        } catch {
            print("enconding json error")
        }
        guard let unwJSON = json else {
            print("unwrapping json error")
            return
        }
        let id = unwJSON["_id"].stringValue
        let avatarColor = unwJSON["avatarColor"].stringValue
        let avatarName = unwJSON["avatarName"].stringValue
        let email = unwJSON["email"].stringValue
        let name = unwJSON["name"].stringValue
        
        UserDataService.instance.setUserData(id: id, avatarColor: avatarColor, avatarName: avatarName, email: email, name: name)
        
    }
    
    
    
    func changeUserName(newName: String, completion: @escaping CompletionHandler) {
        
        
        let body : [String: Any] = [
            "name" : newName
        ]
        
        Alamofire.request("\(URL_USER_CHANGE)\(UserDataService.instance.id)", method: .put, parameters: body, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else {return}
                var json: JSON?
                do
                {
                    json = try JSON(data: data)
                } catch {
                    print("json encoding error")
                }
              
                UserDataService.instance.changeUserName(name: newName)
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func deleteUser(id: String, completion: @escaping CompletionHandler) {
        
        let body : [String: Any] = [
            "_id" : id
        ]
        
        Alamofire.request("\(URL_USER_CHANGE)\(UserDataService.instance.id)", method: .delete, parameters: body, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil {
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
        
        
    }
    
    
    
}



