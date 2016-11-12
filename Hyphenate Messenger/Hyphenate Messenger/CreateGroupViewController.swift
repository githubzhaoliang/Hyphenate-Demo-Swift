//
//  CreateGroupViewController.swift
//  Hyphenate Messenger
//
//  Created by peng wan on 11/10/16.
//  Copyright © 2016 Hyphenate Inc. All rights reserved.
//

import UIKit

class CreateGroupViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupNavigationBar()
    }
    
    func setupNavigationBar() {
        self.title = NSLocalizedString("Create", comment: "Create")
        let cancelButton = UIButton(type: .custom)
        cancelButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        cancelButton.setTitleColor(UIColor(red: 0, green: 186.0/255, blue: 110.0/255, alpha: 1), for: .normal)
        cancelButton.setTitleColor(UIColor(red: 0, green: 186.0/255, blue: 110.0/255, alpha: 1), for: .highlighted)
        cancelButton.setTitle(NSLocalizedString("Cancel", comment: "Cancel"), for: .normal)
        cancelButton.setTitle(NSLocalizedString("Cancel", comment: "Cancel"), for: .highlighted)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        cancelButton.addTarget(self, action: #selector(CreateGroupViewController.cancelAction), for: .touchUpInside)
        let barbuttonItem = UIBarButtonItem(customView: cancelButton)
        self.navigationItem.setRightBarButton(barbuttonItem, animated: false)
    }

    func cancelAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createNewChatAction(_ sender: AnyObject) {
    }

    @IBAction func createNewGroupAction(_ sender: AnyObject) {
    }
}
