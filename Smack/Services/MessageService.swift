//
//  MessageService.swift
//  Smack
//
//  Created by Rauan on 11/1/18.
//  Copyright © 2018 Rauan. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class MessageService {
    static let instance = MessageService()
    
    var channels = [Channel] ()
    var messages = [Message] ()
    var selectedChannel : Channel?
    var unreadChannels = [String]()
    
    func findAllChannels(completion: @escaping CompletionHandler) {
        
        Alamofire.request(URL_GET_CHANNELS, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else {return}
                var json : JSON?
                do
                {
                    json = try JSON(data: data)
                } catch {
                    print("encoding json error")
                }
                guard let unwJSON = json?.array else {
                    print("unwrapping json error")
                    return
                }
                for item in unwJSON {
                    
                    let name = item["name"].stringValue
                    let channelDescription = item["description"].stringValue
                    let id = item["_id"].stringValue
                    let channel = Channel.init(channelTitle: name, channelDescription: channelDescription, id: id)
                    self.channels.append(channel)
                }
                NotificationCenter.default.post(name: NOTIF_CHANNEL_IS_LOADED, object: nil)
                completion(true)
                
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    
    func findAllMessagesForChannels(channelId: String, completion: @escaping CompletionHandler) {
        Alamofire.request("\(URL_GET_MESSAGES)\(channelId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil {
                self.clearMessages()
                guard let data = response.data else {return}
                var json : JSON?
                do
                {
                    json = try JSON(data: data)
                } catch {
                    print("encoding json error")
                }
                guard let unwJSON = json?.array else {
                    print("unwrapping json error")
                    return
                }
                for item in unwJSON {
            
                    let messageBody = item["messageBody"].stringValue
                    let channelId = item["channelId"].stringValue
                    let id = item["_id"].stringValue
                    let userName = item["userName"].stringValue
                    let userAvatar = item["userAvatar"].stringValue
                    let userAvatarColor = item["userAvatarName"].stringValue
                    let timeStamp = item["timeStamp"].stringValue
                    
                    let message = Message(message: messageBody, userName: userName, channelId: channelId, userAvatar: userAvatar, userAvatarColor: userAvatarColor,  id: id, timeStamp: timeStamp)
                    self.messages.append(message)
        
                }
                print(self.messages.count)
                completion(true)
            } else {
                print(response.result.error as Any)
                completion(false)
            }
        }
    }
    
    func clearMessages() {
        messages.removeAll()
    }
    
    func clearChannels() {
        channels.removeAll()
    }
    
    
    
    
    
    
    
}
