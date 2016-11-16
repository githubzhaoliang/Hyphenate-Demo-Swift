//
//  PublicGroupsTableViewController.swift
//  Hyphenate Messenger
//
//  Created by peng wan on 11/13/16.
//  Copyright © 2016 Hyphenate Inc. All rights reserved.
//

import UIKit

enum FetchPublicGroupState: Int {
    case FetchPublicGroupState_Normal
    case FetchPublicGroupState_Loading
    case FetchPublicGroupState_Nomore
}

class PublicGroupsTableViewController: UITableViewController, GroupUIProtocol {
    
    let KPUBLICGROUP_PAGE_COUNT =  50

    var isSearching: Bool
    
    override convenience init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK - GroupUIProtocol Delegate methods
    
    internal func joinPublicGroup(groupModel: EMGroupModel) {
        self.requestGroupModel = groupModel
        if let group = groupModel.group, group.setting.style == EMGroupStylePublicOpenJoin {
            self.joinToPublicGroup(groupID: group.groupId)
        } else {
            let alert = UIAlertController(title: "", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "ok"), style: .cancel, handler:  { (alertAction) in
                let messageTextfield = alert.textFields?.first
                var messageString = ""
                if (messageTextfield?.text?.characters.count)! > 0 {
                    messageString = (messageTextfield?.text)!
                }
                self.requestToJoinPublicGroup(groupID: (self.requestGroupModel?.group?.groupId)!, message: messageString)
            }))
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: "cancel"), style: .cancel, handler: nil))
            
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }

    internal func removeSelectOccupants(modelArray: [EMUserModel]) {
        
    }

    internal func addSelectOccupants(modelArray: [EMUserModel]) {
        
    }


    var publicGroups =  [EMGroupModel]()
    var searchResults: [EMGroupModel]?
    {
        set {
            self.searchResults = newValue
        }
        
        get {
            if self.searchResults == nil {
                self.searchResults = []
            }
            
            return self.searchResults
        }
            
    }
    
    var cursor: String?
    var requestGroupModel: EMGroupModel?
    var appliedDataSource: [String]?
    {
        set
        {
            self.appliedDataSource = newValue
        }
        
        get
        {
            if self.appliedDataSource != nil {
                self.appliedDataSource = []
                let joinedGroups = EMClient.shared().groupManager.getJoinedGroups()
                
                joinedGroups?.forEach({ (group) in
                    self.appliedDataSource?.append((group as! EMGroup).groupId)
                })
            }
            
            return self.appliedDataSource
        }
    }
    
    var loadState: FetchPublicGroupState
    var isSeaching: Bool
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let _ = self.appliedDataSource
        

    }
    
    func setSearchState(isSearching: Bool) {
        
    }
    
    // MARK - Load Data
    
    func fetchPublicGroups() {
        self.loadState = FetchPublicGroupState.FetchPublicGroupState_Loading
        self.tableView .reloadSections(IndexSet([1]), with: .none)
        
        EMClient.shared().groupManager.getPublicGroupsFromServer(withCursor: self.cursor, pageSize: self.KPUBLICGROUP_PAGE_COUNT) { (result, error) in
            
            if error == nil {
                self.cursor = result?.cursor
                
                for group in (result?.list)! {
                    if let model = EMGroupModel(object: group) {
                        self.publicGroups.append(model)
                    }
                }
                self.loadState = FetchPublicGroupState.FetchPublicGroupState_Normal
                if self.cursor?.characters.count == 0 {
                    self.loadState = FetchPublicGroupState.FetchPublicGroupState_Nomore
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func reloadRequestedAppliedDataSource() {
        
        if let requestGroupModel = self.requestGroupModel, let group = requestGroupModel.group {
            DispatchQueue.main.async {
                self.appliedDataSource?.append(group.groupId)
                let index = self.publicGroups.index(of: requestGroupModel)
                let indexPath = IndexPath(row: index!, section: 0)
                self.tableView.beginUpdates()
                self.tableView.reloadRows(at: [indexPath], with: .none)
                self.tableView.endUpdates()
                self.requestGroupModel = nil
            }
        }
    }
    
    // MARK - Join Public Group
    
    func joinToPublicGroup(groupID: String) {
        EMClient.shared().groupManager.joinPublicGroup(groupID) { (group, error) in
            if error != nil {
                self.reloadRequestedAppliedDataSource()
            }
        }
    }
    
    func requestToJoinPublicGroup(groupID: String, message: String) {
        EMClient.shared().groupManager.request(toJoinPublicGroup: groupID, message: message) { (group, error) in
            if error != nil {
                self.reloadRequestedAppliedDataSource()
            }
        }
    }
    
    // MARK - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if (self.loadState != FetchPublicGroupState.FetchPublicGroupState_Nomore && !self.isSearching) {
            return 2;
        }
        return 1;
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.isSeaching {
            return (self.searchResults?.count)!
        }
        
        if self.loadState != FetchPublicGroupState.FetchPublicGroupState_Nomore, section == 1 {
            return 1
        }
        
        return self.publicGroups.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    //MARK - UIScrollViewDelegate
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (scrollView.contentOffset.y >= max(0, scrollView.contentSize.height - scrollView.frame.size.height) + 50) {
            if self.loadState == FetchPublicGroupState.FetchPublicGroupState_Normal {
                self.fetchPublicGroups()
            }
        }
    }
}
