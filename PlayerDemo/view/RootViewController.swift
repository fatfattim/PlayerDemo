//
//  RootViewController.swift
//  PlayerDemo
//
//  Created by TimChen on 2017/5/19.
//  Copyright © 2017年 dogtim. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    @IBOutlet weak var naviPlayerBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("touch viewDidLoad")
        setLocalization()
    }

    func setLocalization() {
        let backItem = UIBarButtonItem()
        backItem.title = NSLocalizedString("Back", comment: "Previous page")
        self.navigationItem.backBarButtonItem = backItem
        
        naviPlayerBtn.setTitle(NSLocalizedString("Enter Player Page", comment: "Previous page"), for: UIControlState.normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func touchUpInsidePlayerBtn(_ sender: Any) {
        print("touch player button")
        
        let playerVC = PlayerViewController()
        playerVC.title = NSLocalizedString("Player", comment: "Player Title")
        self.navigationController?.pushViewController(playerVC, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
