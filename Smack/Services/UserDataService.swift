//
//  UserDataService.swift
//  Smack
//
//  Created by Rauan on 10/31/18.
//  Copyright © 2018 Rauan. All rights reserved.
//

import Foundation


class UserDataService {
    
    static let instance = UserDataService()
    
    private(set) public var id = ""
    private(set) public var avatarColor = ""
    private(set) public var avatarName = ""
    private(set) public var email = ""
    private(set) public var name = ""
    
    func setUserData(id: String, avatarColor: String, avatarName: String, email: String, name: String) {
        self.avatarColor = avatarColor
        self.id = id
        self.avatarName = avatarName
        self.email = email
        self.name = name
    }
    
    func setAvatarName(avatarName: String) {
        
        self.avatarName = avatarName
    }
    
    func changeUserName(name: String) {
        self.name = name
    }
    
    func returnUIColor(components: String) -> UIColor {
        
        let scanner = Scanner(string: components)
        let skipped = CharacterSet(charactersIn: "[], ")
        let comma = CharacterSet(charactersIn: ",")
        scanner.charactersToBeSkipped = skipped
        
        var r, g, b, a : NSString?
        
        scanner.scanUpToCharacters(from: comma, into: &r)
        scanner.scanUpToCharacters(from: comma, into: &b)
        scanner.scanUpToCharacters(from: comma, into: &g)
        scanner.scanUpToCharacters(from: comma, into: &a)
        
        let defaultColor = UIColor.lightGray
        
        guard let rUnwrapped = r else {return defaultColor}
        guard let bUnwrapped = b else {return defaultColor}
        guard let gUnwrapped = g else {return defaultColor}
        guard let aUnwrapped = a else {return defaultColor}
        
        let rfloat = CGFloat(rUnwrapped.doubleValue)
        let bfloat = CGFloat(bUnwrapped.doubleValue)
        let gfloat = CGFloat(gUnwrapped.doubleValue)
        let afloat = CGFloat(aUnwrapped.doubleValue)
        
        let newUIColor = UIColor(red: rfloat, green: gfloat, blue: bfloat, alpha: afloat)
        
        return newUIColor
    }
    
    func logOutUser() {
        
        id = ""
        avatarColor = ""
        avatarName = ""
        name = ""
        email = ""
        AuthServices.instance.isLoggedIn = false
        AuthServices.instance.authToken = ""
        AuthServices.instance.userEmail = ""
        MessageService.instance.clearChannels()
        MessageService.instance.clearMessages()
    }
    
    
}
