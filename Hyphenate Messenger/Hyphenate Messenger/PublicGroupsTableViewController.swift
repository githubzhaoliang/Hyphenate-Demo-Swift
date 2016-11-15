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

    override convenience init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK - GroupUIProtocol Delegate methods
    
    internal func joinPublicGroup(groupModel: [EMGroupModel]) {
        
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
    var requestGroupModel: EMGroupModel
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

    // MARK - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

}

protocol GroupUIProtocol {
    
    func addSelectOccupants(modelArray: [EMUserModel])
    func removeSelectOccupants(modelArray: [EMUserModel])
    func joinPublicGroup(groupModel: [EMGroupModel])
}
