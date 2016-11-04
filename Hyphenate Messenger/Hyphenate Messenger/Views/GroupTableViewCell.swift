//
//  BaseTableViewCell.swift
//  Hyphenate Messenger
//
//  Created by Peng Wan on 11/3/16.
//  Copyright © 2016 Hyphenate Inc. All rights reserved.
//

import Foundation
import UIKit



class GroupTableViewCell:UITableViewCell{

    @IBOutlet weak var groupPhotoView: UIImageView!
    
    @IBOutlet weak var groupNameLabel: UILabel!
    
    @IBOutlet weak var memberCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        groupPhotoView.layer.cornerRadius = groupPhotoView.frame.size.height/2
        groupPhotoView.clipsToBounds = true
    }
    
    class func reuseIdentifier() -> String {
        return "GroupTableViewCell"
    }
}
