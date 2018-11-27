//
//  EditProfileVC.swift
//  Smack
//
//  Created by Rauan on 11/5/18.
//  Copyright © 2018 Rauan. All rights reserved.
//

import UIKit

protocol ExitDelegate {
    func exitTo ()
}

class EditProfileVC: UIViewController {

    @IBOutlet weak var newNameTxt: UITextField!
    
    @IBOutlet weak var bgView: UIView!
    var exitTo : (() -> ())?
    var exitDelegate : ExitDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()

        // Do any additional setup after loading the view.
    }

    func setUpView() {
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(EditProfileVC.closeTap(_:)))
        bgView.addGestureRecognizer(closeTouch)
        
        
        newNameTxt.attributedPlaceholder = NSAttributedString(string: "New Name", attributes: [NSAttributedString.Key.foregroundColor : smackPurplePlaceholder])
    }
    
    
    @objc func closeTap(_ recognizer: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func closeBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
  
    @IBAction func changeNameBtn(_ sender: Any) {
        guard  let newName = newNameTxt.text,  newNameTxt.text != "" else {return}
        
        AuthServices.instance.changeUserName(newName: newName) { (success) in
            if success {
                self.newNameTxt.text = ""
                self.dismiss(animated: true, completion: nil)
                NotificationCenter.default.post(name: NOTIF_USERNAME_CHANGED, object: nil)
            }
        }
    }
    
    @IBAction func deleteUserBtn(_ sender: Any) {
        AuthServices.instance.deleteUser(id: UserDataService.instance.id) { [weak self](success) in
            if success {
               NotificationCenter.default.post(name: NOTIF_USER_DELETED, object: nil)
                self?.dismiss(animated: true)
//                self?.exitTo?()
                self?.exitDelegate?.exitTo()
            }
        }
    }
}
