//
//  EMUserModel.swift
//  Hyphenate Messenger
//
//  Created by peng wan on 11/14/16.
//  Copyright © 2016 Hyphenate Inc. All rights reserved.
//

import UIKit

class EMUserModel: NSObject, IEMUserModel, IEMRealtimeSearch {
    
    var hyphenateId: String?
    var nickname: String?
    {
        set {
            self.nickname = newValue
        }
        
        get
        {
            if self.nickname?.characters.count == 0 {
                return self.hyphenateId
            } else {
                return self.nickname
            }
        }
    }
    
    var avatarURLPath: String?
    var defaultAvatarImage: UIImage?
    var searchKey: String?
    {
        set
        {
            self.searchKey = newValue
        }
        
        get
        {
            if (self.nickname?.characters.count)! > 0 {
                return self.nickname
            } else {
                return self.hyphenateId
            }
        }
    }
    
    required init(hyphenateId: String) {
        super.init()
        self.hyphenateId = hyphenateId
        self.nickname = ""
        self.defaultAvatarImage = UIImage(named: "default_avatar.png")
    }
    
    

    
}
