//
//  CircleImage.swift
//  Smack
//
//  Created by Rauan on 10/31/18.
//  Copyright © 2018 Rauan. All rights reserved.
//

import UIKit

@IBDesignable

class CircleImage: UIImageView {

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    

    func setUpView() {
        
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
        
    }
    
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setUpView()
    }
}
