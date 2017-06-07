//
//  PlayerModeViewController.swift
//  PlayerDemo
//
//  Created by TimChen on 2017/6/5.
//  Copyright © 2017年 dogtim. All rights reserved.
//

import UIKit

class PlayerBuilder {
    static func build(_ uiMode: String, playerMode: String, urls: [CellItem]) -> UIViewController {
        let vc : UIViewController
        if(uiMode == "Zapping") {
            vc = ZappingViewController()
            (vc as? ZappingViewController)?.setCallback(callback: { (page) in
                let urlIndex = page % urls.count
                let controller = getController(playerMode, url: urls[urlIndex].name)
                controller.setURL(url: URL(string: urls[urlIndex].name)!, describe : "")
                
                return controller
            })
            vc.title = NSLocalizedString("Zapping", comment: "Zapping Title")
        } else {
            vc = getController(playerMode, url: urls[0].name)
            vc.title = NSLocalizedString("Player", comment: "Player Title")
        }

        return vc
    }
    
    static func getController(_ mode : String, url: String) -> PlayerViewController {
        let vc : PlayerViewController
        
        if(mode == "Normal") {
            vc = PlayerViewController()
        } else {
            vc = StartOverPlayerVCNew(nibName: "PlayerViewController", bundle: nil)
        }
        vc.setURL(url: URL(string: url)!, describe : "")
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
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        info = createInfo()

    }

    func createInfo() -> Array<Array<CellItem>> {
        var temp : Array<Array<CellItem>>
        temp = Array<Array<CellItem>>()
        temp.append(createModeInfo(sources: ["Single","Zapping"]))
        temp.append(createModeInfo(sources: ["Normal", "StartOver"]))
        temp.append(createModeInfo(sources: getUrls()))
        temp.append(createModeInfo(sources: ["Next"]))
        
        return temp
    }
    
    func getUrls() -> Array<String> {
        let fileUrl : URL = Bundle.main.url(forResource: "urls", withExtension: "txt")!
        
        //reading
        do {
            let text2 = try String(contentsOf: fileUrl, encoding: String.Encoding.utf8)
            let array = text2.components(separatedBy: .newlines)
            
            
            return array.filter({ $0.hasPrefix("http")})
        }
        catch {
            /* error handling here */
        }
        return []
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
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byCharWrapping
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == info.count - 1) { // Last one button
            
            var uiMode = info[0].filter({ (CellItem) -> Bool in
                CellItem.isSelected == true
            })
            
            var playerMode = info[1].filter({ (CellItem) -> Bool in
                CellItem.isSelected == true
            })
            
            var urls = info[2].filter({ (CellItem) -> Bool in
                CellItem.isSelected == true
            })
            
            self.navigationController?.pushViewController(
                PlayerBuilder.build(uiMode[0].name, playerMode: playerMode[0].name, urls: urls),
                animated: true)

        } else if (indexPath.section == info.count - 2) {
            
            let cell = tableView.cellForRow(at: indexPath)
            
            if(info[indexPath.section][indexPath.row].isSelected) {
                cell?.accessoryType = .none
                info[indexPath.section][indexPath.row].isSelected = false
            } else {
                cell?.accessoryType = .checkmark
                info[indexPath.section][indexPath.row].isSelected = true
            }
            
        } else {
            let selectedCell = tableView.cellForRow(at: indexPath)
            let rowsCount = self.tableView.numberOfRows(inSection: indexPath.section)
            for i in 0..<rowsCount  {
                let cell = self.tableView.cellForRow(at: IndexPath(row: i, section: indexPath.section))
                if (cell == selectedCell) {
                    cell?.accessoryType = .checkmark
                    info[indexPath.section][i].isSelected = true
                } else {
                    cell?.accessoryType = .none
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
        case 2:
            return "Select URLs"
        default:
            return "Action"
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        if(section == info.count - 2) {
            return 90
        } else {
            
            return 30
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
}
