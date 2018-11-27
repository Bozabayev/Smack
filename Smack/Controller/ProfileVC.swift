//
//  ProfileVC.swift
//  Smack
//
//  Created by Rauan on 10/31/18.
//  Copyright © 2018 Rauan. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var bgView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileVC.setChangedUserName(_:)), name: NOTIF_USERNAME_CHANGED, object: nil)

    }

    @IBAction func closeProfilePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc func setChangedUserName(_ notif: Notification ) {
        userName.text = UserDataService.instance.name
    }
    
    func updateView() {
        userName.text = UserDataService.instance.name
        userEmail.text = UserDataService.instance.email
        profileImg.image = UIImage(named: UserDataService.instance.avatarName)
        profileImg.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
        
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(ProfileVC.closeTap(_:)))
        bgView.addGestureRecognizer(closeTouch)
        
    }
    
    @objc func closeTap(_ recognizer: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
        
    }

    @IBAction func logoutBtnPressed(_ sender: Any) {
        UserDataService.instance.logOutUser()
        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func editProfileBtn(_ sender: Any) {
        let editProfile = EditProfileVC()
        editProfile.modalPresentationStyle = .custom
//        editProfile.exitTo = {
//            self.dismiss(animated: true)
//        }
        editProfile.exitDelegate = self
        present(editProfile, animated: true, completion: nil)
        
        
    }
    
    
}

extension ProfileVC: ExitDelegate{
    func exitTo() {
        self.dismiss(animated: true)
    }
    
    
}
