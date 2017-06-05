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
    @IBOutlet weak var zappingBtn: UIButton!
    @IBOutlet weak var startOverBtn: UIButton!
    @IBOutlet weak var optionsBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setLocalization()
    }

    func setLocalization() {
        let backItem = UIBarButtonItem()
        backItem.title = NSLocalizedString("Back", comment: "Previous page")
        self.navigationItem.backBarButtonItem = backItem
        self.title = NSLocalizedString("Demo", comment: "Player page")
        naviPlayerBtn.setTitle(NSLocalizedString("Enter Player Page", comment: "Player page"), for: UIControlState.normal)
        zappingBtn.setTitle(NSLocalizedString("Enter Zapping Page", comment: "Zapping page"), for: UIControlState.normal)
        startOverBtn.setTitle(NSLocalizedString("Start Over Page", comment: "Start Over Page"), for: UIControlState.normal)
        optionsBtn.setTitle(NSLocalizedString("Options", comment: "Options"), for: UIControlState.normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func touchUpInsideZappingBtn(_ sender: Any) {
        
        let vc = ZappingViewController() //change this to your class name

        vc.title = NSLocalizedString("Zapping", comment: "Zapping Title")
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func touchUpInsidePlayerBtn(_ sender: Any) {

        let vc = PlayerViewController()
        vc.title = NSLocalizedString("Player", comment: "Player Title")
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func touchUpInsideOptions(_ sender: Any) {
        let vc = PlayerModeViewController()
        vc.title = NSLocalizedString("Mode", comment: "Mode")
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func touchUpInsideStartOverBtn(_ sender: Any) {
        let vc = StartOverPlayerVCNew(nibName: "PlayerViewController", bundle: nil)
        vc.title = NSLocalizedString("Start Over Page", comment: "StartOver Title")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}
