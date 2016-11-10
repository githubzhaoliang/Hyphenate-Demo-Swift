//
//  ContactsTableViewController.swift
//  Hyphenate Messenger
//
//  Created by peng wan on 11/3/16.
//  Copyright © 2016 Hyphenate Inc. All rights reserved.
//


import Foundation
import Hyphenate

class GroupsTableViewController: UITableViewController {
    
    var groups = [EMGroup]()
    
    func loadGroupsFromServer() {
        weak var weakSelf = self
        
        EMClient.shared().groupManager.getJoinedGroupsFromServer { (aList: [Any]?, aError: EMError?) in
            if let _ = aList as? [EMGroup]{
                for group in aList as! [EMGroup] {
                    weakSelf!.groups.append(group)
                }
                DispatchQueue.main.async(execute: {() -> Void in
                    weakSelf!.tableView.reloadData()
                })
            }
        }
    }
    
    func addContactAction() {
        let createGroupVewController = CreateGroupViewController(nibName: "CreateGroupViewController", bundle: nil)
        let navigationController = UINavigationController(rootViewController: createGroupVewController)
        self.present(navigationController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImage(named: "iconAdd")
        let rightButtonItem:UIBarButtonItem = UIBarButtonItem(image: image, landscapeImagePhone: image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(GroupsTableViewController.addContactAction))
        navigationItem.rightBarButtonItem = rightButtonItem
        
        self.title = "Groups"
        tableView.register(UINib(nibName: "GroupTableViewCell", bundle: nil), forCellReuseIdentifier: GroupTableViewCell.reuseIdentifier())
        loadGroupsFromServer()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GroupTableViewCell.reuseIdentifier()) as! GroupTableViewCell
        let group = groups[indexPath.row]
        cell.groupNameLabel.text = group.subject
        cell.memberCountLabel.text = "\(group.membersCount) members"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let chatController = ChatTableViewController(conversationID: groups[indexPath.row].groupId, conversationType: EMConversationTypeChat)
        chatController?.title = groups[indexPath.row].subject
        chatController?.hidesBottomBarWhenPushed = true
        self.navigationController!.pushViewController(chatController!, animated: true)
    }
        

}
