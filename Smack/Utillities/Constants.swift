//
//  Constants.swift
//  Smack
//
//  Created by Rauan on 10/29/18.
//  Copyright © 2018 Rauan. All rights reserved.
//

import Foundation


typealias CompletionHandler = (_ Succes: Bool) -> ()

let BASE_URL = "https://swiftchattychat.herokuapp.com/v1/"
let URL_REGISTER = "\(BASE_URL)account/register"
let URL_LOGIN = "\(BASE_URL)account/login"
let URL_USER_ADD = "\(BASE_URL)user/add"
let URL_USER_BY_EMAIL = "\(BASE_URL)user/byEmail/"
let URL_GET_CHANNELS = "\(BASE_URL)channel/"
let URL_GET_MESSAGES = "\(BASE_URL)message/byChannel/"
let URL_USER_CHANGE = "\(BASE_URL)user/"


let TO_LOGIN = "toLogin"
let TO_CREATE_ACCOUNT = "toCreateAccount"
let UNWIND = "unWindToChannel"
let TO_AVATAR_PICKER = "toAvatarPicker"

// User defaults
let LOGGED_IN_KEY = "loggedIn"
let TOKKEN_KEY = "token"
let USER_EMAIL = "userEmail"


let smackPurplePlaceholder = #colorLiteral(red: 0.2588235294, green: 0.3294117647, blue: 0.7254901961, alpha: 0.5)

let NOTIF_USER_DATA_DID_CHANGE = Notification.Name("notifUserDataChanged")
let NOTIF_CHANNEL_IS_LOADED = Notification.Name("channelsLoaded")
let NOTIF_CHANNEL_SELECTED = Notification.Name("channelSelected")
let NOTIF_USERNAME_CHANGED = Notification.Name("notifUserNameChande")
let NOTIF_USER_DELETED = Notification.Name("notifUserDeleted")


let HEADER = [
    "Content-Type": "application/json; charset=utf-8"
]

let BEARER_HEADER = [
    "Authorization": "Bearer \(AuthServices.instance.authToken)",
    "Content-Type": "application/json; charset=utf-8"
]
