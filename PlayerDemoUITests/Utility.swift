//
//  Utility.swift
//  PlayerDemo
//
//  Created by TimChen on 2017/6/2.
//  Copyright © 2017年 dogtim. All rights reserved.
//

import Foundation

class Utility {
    
    static func get(key : String) -> String {
        return NSLocalizedString(key, bundle: Bundle(for: PlayerDemoUITests.self), comment: "")
    }
}
