//
//  WKColorSelecter.swift
//  TapMe
//
//  Created by wangkun on 2017/9/4.
//  Copyright © 2017年 wangkun. All rights reserved.
//

import UIKit

class WKColorSelecter: NSObject {
    
    static let bgColors:Array<UIColor> = [UIColor.colorWithRGB(red: 144, green: 238, blue: 154),
                                        UIColor.colorWithRGB(red: 157, green: 182, blue: 247),
                                        UIColor.colorWithRGB(red: 245, green: 195, blue: 98),
                                        UIColor.colorWithRGB(red: 239, green: 138, blue: 115),
                                         UIColor.colorWithRGB(red: 182, green: 95, blue: 223),
                                         UIColor.colorWithRGB(red: 104, green: 85, blue: 246),
                                         UIColor.colorWithRGB(red: 237, green: 105, blue: 199),
                                         UIColor.colorWithRGB(red: 235, green: 73, blue: 83),
                                         UIColor.colorWithRGB(red: 250, green: 224, blue: 98),
                                         UIColor.colorWithRGB(red: 234, green: 61, blue: 116),
                                         UIColor.colorWithRGB(red: 138, green: 227, blue: 95)]
    static let textColors:Array<UIColor> = [ UIColor.colorWithRGB(red: 70, green: 157, blue: 62),
                                           UIColor.colorWithRGB(red: 107, green: 133, blue: 199),
                                           UIColor.colorWithRGB(red: 191, green: 106, blue: 38),
                                           UIColor.colorWithRGB(red: 181, green: 51, blue: 26),
                                           UIColor.colorWithRGB(red: 249, green: 223, blue: 166),
                                           UIColor.colorWithRGB(red: 215, green: 209, blue: 251),
                                           UIColor.colorWithRGB(red: 250, green: 227, blue: 101),
                                           UIColor.colorWithRGB(red: 251, green: 235, blue: 165),
                                           UIColor.colorWithRGB(red: 236, green: 104, blue: 78),
                                           UIColor.colorWithRGB(red: 248, green: 248, blue: 248),
                                           UIColor.colorWithRGB(red: 45, green: 100, blue: 143)]
    
    
    static func getBGColor(count:Int) -> UIColor
    {
        return bgColors[(count-1)%bgColors.count]
    }
    
    static func getTextColor(count:Int) -> UIColor
    {
        return textColors[(count-1)%textColors.count]
    }
}
