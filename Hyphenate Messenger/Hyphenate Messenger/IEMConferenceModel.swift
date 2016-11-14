//
//  IEMConferenceModel.swift
//  Hyphenate Messenger
//
//  Created by peng wan on 11/13/16.
//  Copyright © 2016 Hyphenate Inc. All rights reserved.
//

import UIKit

protocol IEMConferenceModel {

    var hyphenateId: String? {get}
    var subject: String? {get}
    var avatarURLPath: String? {get}
    var defaultAvatarImage: UIImage? {get}
    
    init?(object: Any)
}
