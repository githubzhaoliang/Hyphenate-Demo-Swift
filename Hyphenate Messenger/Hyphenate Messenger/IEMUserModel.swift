//
//  IEMUserModel.swift
//  Hyphenate Messenger
//
//  Created by peng wan on 11/14/16.
//  Copyright © 2016 Hyphenate Inc. All rights reserved.
//

import UIKit

protocol IEMUserModel {
    
    var hyphenateId: String? { get }
    var nickname: String? { get }
    var avatarURLPath: String? { get }
    var defaultAvatarImage: UIImage? { get }
    
    init(hyphenateId:String)
}
