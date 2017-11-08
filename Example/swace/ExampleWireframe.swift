//
//  ExampleWireframe.swift
//  Swace_Example
//
//  Created by Andreas Östman on 2017-11-07.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import swace

class ExampleWireframe: BaseWireframe, ReusableWireframe {

    static var didPrepare: Bool = false

    override func prepare(_ data: [String : Any]?) -> UIViewController? {
        guard !ExampleWireframe.didPrepare else { return tabbarControllerFromWindow(window!)?.selectedViewController }
        let view = super.prepare(data)
        ExampleWireframe.didPrepare = true
        return view
    }
}
