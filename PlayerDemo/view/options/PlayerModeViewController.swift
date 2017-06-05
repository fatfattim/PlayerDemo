//
//  PlayerModeViewController.swift
//  PlayerDemo
//
//  Created by TimChen on 2017/6/5.
//  Copyright © 2017年 dogtim. All rights reserved.
//

import UIKit


class PlayerBuilder {
    static func build(_ uiMode: String, playerMode: String) -> UIViewController {
        let vc : UIViewController
        if(uiMode == "Zapping") {
            vc = ZappingViewController() //change this to your class name
            
            vc.title = NSLocalizedString("Zapping", comment: "Zapping Title")
        } else {
            vc = PlayerViewController() //change this to your class name
            vc.title = NSLocalizedString("Player", comment: "Player Title")
        }
        return vc
    }
}

class PlayerModeViewController: UITableViewController {
    
    var info = [
        ["Single","Zapping"],
        ["Normal", "StartOver"],
        ["Next"]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        tableView.register(
            UITableViewCell.self, forCellReuseIdentifier: "Cell")

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return info.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return info[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        
        if(indexPath.section == 2) {
            cell.accessoryType = .none
            cell.textLabel?.textAlignment = .center
        } else if(indexPath.row == 0) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        if let myLabel = cell.textLabel {
            myLabel.text =
            "\(info[indexPath.section][indexPath.row])"
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 2) {
            
            var uiMode = ""
            
            let rowsCount = self.tableView.numberOfRows(inSection: 0)
            
            for i in 0..<rowsCount  {
                let cell = self.tableView.cellForRow(at: IndexPath(row: i, section: 0))!
                // your custom code (deselecting)
                
                if (cell.accessoryType == .checkmark) {
                    uiMode = (cell.textLabel?.text)!
                }
            }
            
            self.navigationController?.pushViewController( PlayerBuilder.build(uiMode, playerMode: ""), animated: true)

        } else {
            let selectedCell = tableView.cellForRow(at: indexPath)
            let rowsCount = self.tableView.numberOfRows(inSection: indexPath.section)
            for i in 0..<rowsCount  {
                let cell = self.tableView.cellForRow(at: IndexPath(row: i, section: indexPath.section))!
                // your custom code (deselecting)
                
                if (cell == selectedCell) {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
            }
            
        }
    }

    func numberOfSectionsInTableView(
        tableView: UITableView) -> Int {
        return info.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        switch section
        {
        case 0:
            return "UI Mode"
        case 1:
            return "Player Mode"
        default:
            return "Other Devices"
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
}
