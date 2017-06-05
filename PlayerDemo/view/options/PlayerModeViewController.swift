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
            
            if(playerMode == "Normal") {
                vc = ZappingViewController()
                (vc as? ZappingViewController)?.doSomething(callback: { (page) in
                    let controller = StartOverPlayerVCNew(nibName: "PlayerViewController", bundle: nil)
                    let urlIndex = page % 2
                    
                    if (urlIndex == 0) {
                        controller.setURL(url: URL(string: "http://linear.demo.kkstream.tv/poc.m3u8")!, describe : "apple demo m3u8")
                    } else {
                        controller.setURL(url : URL(string: "http://linear.demo.kkstream.tv/poc2.m3u8")!, describe : "Live")
                    }
                    return controller
                })
            } else {
                vc = ZappingViewController()
                (vc as? ZappingViewController)?.doSomething(callback: { (page) in
                    let controller = PlayerViewController()
                    let urlIndex = page % 2
                    
                    if (urlIndex == 0) {
                        controller.setURL(url: URL(string: "http://linear.demo.kkstream.tv/poc.m3u8")!, describe : "apple demo m3u8")
                    } else {
                        controller.setURL(url : URL(string: "http://linear.demo.kkstream.tv/poc2.m3u8")!, describe : "Live")
                    }
                    return controller
                })
            }
            
            vc.title = NSLocalizedString("Zapping", comment: "Zapping Title")
        } else {
            
            if(playerMode == "Normal") {
                vc = PlayerViewController()
            } else {
                vc = StartOverPlayerVCNew(nibName: "PlayerViewController", bundle: nil)
            }
            
            vc.title = NSLocalizedString("Player", comment: "Player Title")
        }
        return vc
    }
}

class PlayerModeViewController: UITableViewController {

    var info : Array<Array<CellItem>> = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        tableView.register(
            UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        info = createInfo()

    }

    func createInfo() -> Array<Array<CellItem>> {
        var temp : Array<Array<CellItem>>
        temp = Array<Array<CellItem>>()
        temp.append(createModeInfo(sources: ["Single","Zapping"]))
        temp.append(createModeInfo(sources: ["Normal", "StartOver"]))
        temp.append(createModeInfo(sources: ["Next"]))
        return temp
    }
    
    func createModeInfo(sources : Array<String>) -> Array<CellItem> {
        var temp : Array<CellItem> = []
        
        
        for (index,element) in sources.enumerated() {
            let item = CellItem()
            item.name = element
            if(index == 0 && element != "Next") {
                item.isSelected = true
            }
            temp.append(item)
        }
        return temp
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
        if(indexPath.section == info.count - 1) {
            cell.textLabel?.textAlignment = .center
        }
        
        if(info[indexPath.section][indexPath.row].isSelected) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        if let myLabel = cell.textLabel {
            myLabel.text =
            "\(info[indexPath.section][indexPath.row].name)"
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == info.count - 1) {
            
            var uiMode = ""
            
            let rowsCount = self.tableView.numberOfRows(inSection: 0)
            
            for i in 0..<rowsCount  {
                let cell = self.tableView.cellForRow(at: IndexPath(row: i, section: 0))!
                // your custom code (deselecting)
                
                if (cell.accessoryType == .checkmark) {
                    uiMode = (cell.textLabel?.text)!
                }
            }
            
            self.navigationController?.pushViewController(PlayerBuilder.build(uiMode, playerMode: ""), animated: true)

        } else {
            let selectedCell = tableView.cellForRow(at: indexPath)
            let rowsCount = self.tableView.numberOfRows(inSection: indexPath.section)
            for i in 0..<rowsCount  {
                let cell = self.tableView.cellForRow(at: IndexPath(row: i, section: indexPath.section))!
                // your custom code (deselecting)
                
                if (cell == selectedCell) {
                    cell.accessoryType = .checkmark
                    info[indexPath.section][i].isSelected = true
                } else {
                    cell.accessoryType = .none
                    info[indexPath.section][i].isSelected = false
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
