//
//  WKConstant.swift
//  TapMe
//
//  Created by wangkun on 2017/9/4.
//  Copyright © 2017年 wangkun. All rights reserved.
//

import Foundation
import UIKit

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

struct Platform {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
}
//闭包传值

//传数字
typealias intClosureType = (Int) -> ()
typealias strClosureType = (String) -> ()
typealias imageClosureType = (UIImage) -> ()
typealias voidClosureType = () -> ()
typealias boolClosureType = (Bool) -> ()
typealias boolClosureTypeReturnFloat = (Bool) -> (CGFloat)
