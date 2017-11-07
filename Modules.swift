//
//  Modules.swift
//  Epic Eats
//
//  Created by Andreas Östman on 2017-10-20.
//  Copyright © 2017 Epic Eats. All rights reserved.
//

import Foundation

struct Module {
    
    let path: String
    
    init(path: String) {
        self.path = path
    }
    
    static let profile = Module(path: "profile")
    static let login = Module(path: "login")
    static let news = Module(path: "news")
    static let inbox = Module(path: "inbox")
    static let sell = Module(path: "sell")
    static let browse = Module(path: "browse")
    static let follows = Module(path: "follows")
    static let following = Module(path: "following")
    
}
