//
//  EMGroupModel.swift
//  Hyphenate Messenger
//
//  Created by peng wan on 11/13/16.
//  Copyright © 2016 Hyphenate Inc. All rights reserved.
//

import UIKit

class EMGroupModel: NSObject, IEMRealtimeSearch, IEMConferenceModel {
    
    var searchKey: String?
    {
        set {
            self.searchKey = newValue
        }
        
        get {
            if (self.subject?.characters.count)! > 0 {
                return self.subject
            }
            return self.hyphenateId
        }
    }
    
    var hyphenateId: String?
    var subject: String?
    {
        set {
            self.subject = newValue
        }
        
        get {
            if self.subject?.characters.count == 0 {
                return self.hyphenateId
            }
            return self.subject
        }
    }
    var avatarURLPath: String?
    var defaultAvatarImage: UIImage?
    var group: EMGroup?
    
    required init?(object:Any) {
        
        if object is EMGroup {
            super.init()
            
            self.group = object as? EMGroup
            self.hyphenateId = self.group?.groupId
            self.subject = self.group?.subject
            self.defaultAvatarImage = UIImage(named: "default_avatar.png")
        } else {
            return nil
        }
    }
    
    

}
