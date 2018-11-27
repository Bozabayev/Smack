//
//  ChannelVC.swift
//  Smack
//
//  Created by Rauan on 10/29/18.
//  Copyright © 2018 Rauan. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    
    
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var userImg: CircleImage!
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){}
    
    
        override func viewDidLoad() {
        super.viewDidLoad()
            tableView.delegate = self
            tableView.dataSource = self
        self.revealViewController()?.rearViewRevealWidth = self.view.frame.size.width - 60
            NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.channelsLoaded(_:)), name: NOTIF_CHANNEL_IS_LOADED, object: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.setChangedUserName(_:)), name: NOTIF_USERNAME_CHANGED, object: nil)
            
           NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.userDeleted(_:)), name: NOTIF_USER_DELETED, object: nil)
            
            SocketService.instance.getChannel { (success) in
                if success {
                    self.tableView.reloadData()
                }
            }
            
            SocketService.instance.getMessage { (newMessage) in
                if newMessage.channelId != MessageService.instance.selectedChannel?.id && AuthServices.instance.isLoggedIn {
                    MessageService.instance.unreadChannels.append(newMessage.channelId)
                    self.tableView.reloadData()
                }
            }
            
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        setUserInfo()
    }
    

    
    @IBAction func LoginBtnPressed(_ sender: Any) {
        if AuthServices.instance.isLoggedIn {
            let profile = ProfileVC()
            profile.modalPresentationStyle = .custom
            present(profile, animated: true, completion: nil)
        } else {
              performSegue(withIdentifier: TO_LOGIN, sender: nil)
        }
    }
    
    @objc func userDataDidChange(_ notif: Notification) {
       setUserInfo()
    }
    
    @objc func userDeleted(_ notif: Notification) {
        UserDataService.instance.logOutUser()
        setUserInfo()
    }
    
    
    @objc func channelsLoaded(_ notif: Notification) {
        tableView.reloadData()
    }
    
    @objc func setChangedUserName(_ notif: Notification ) {
        
            loginBtn.setTitle(UserDataService.instance.name, for: .normal)
        
    }
    
    func setUserInfo() {
        
        if AuthServices.instance.isLoggedIn {
            loginBtn.setTitle(UserDataService.instance.name, for: .normal)
            userImg.image = UIImage(named: UserDataService.instance.avatarName)
            userImg.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
        } else {
            loginBtn.setTitle("Login", for: .normal)
            userImg.image = UIImage(named: "profileDefault")
            userImg.backgroundColor = UIColor.clear
            tableView.reloadData()
        }
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "channelCell", for: indexPath) as? ChannelCell {
            let channel = MessageService.instance.channels[indexPath.row]
            cell.configureCell(channel: channel)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    
    
    @IBAction func addChannelBtn(_ sender: Any) {
        if AuthServices.instance.isLoggedIn {
            let addChannel = AddChannelVC()
            addChannel.modalPresentationStyle = .custom
            present(addChannel, animated: true, completion: nil)
        } 
       
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = MessageService.instance.channels[indexPath.row]
        MessageService.instance.selectedChannel = channel
        
        if MessageService.instance.unreadChannels.count > 0 {
            MessageService.instance.unreadChannels = MessageService.instance.unreadChannels.filter{$0 != channel.id}
        }
        
        let index = IndexPath(row: indexPath.row, section: 0)
        tableView.reloadRows(at: [index], with: .none)
        tableView.selectRow(at: index, animated: false, scrollPosition: .none)
        
        NotificationCenter.default.post(name: NOTIF_CHANNEL_SELECTED, object: nil)
        self.revealViewController()?.revealToggle(animated: true)
    }
    
    
}
