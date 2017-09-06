//
//  WKColorExtension.swift
//  商家端Swift
//
//  Created by 天下宅 on 16/9/12.
//  Copyright © 2016年 天下宅. All rights reserved.
//

import Foundation
import UIKit
extension UIColor
{
    public static func colorWithRGB(red:CGFloat,green:CGFloat,blue:CGFloat) -> UIColor
    {
        return UIColor.init(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1)
    }
    
    public static func color(WithHexString hexString:String) -> UIColor
    {
        
        
        
        
        var cString = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        if cString.hasPrefix("0X"){cString = cString.substring(from: cString.index(cString.startIndex, offsetBy: 2))}
        if cString.hasPrefix("#"){cString = cString.substring(from: cString.index(cString.startIndex, offsetBy: 1))}
        if cString.characters.count != 6 {return UIColor.clear}
        
        let rString = cString.substring(to: cString.index(cString.startIndex, offsetBy: 2))
        cString = cString.substring(from: cString.index(cString.startIndex, offsetBy: 2))
        let gString = cString.substring(to: cString.index(cString.startIndex, offsetBy: 2))
        cString = cString.substring(from: cString.index(cString.startIndex, offsetBy: 2))
        let bString = cString
        
        print(rString + gString + bString)
        
        var r:UInt32 = 0
        var g:UInt32 = 0
        var b:UInt32 = 0
        
        Scanner.init(string: rString).scanHexInt32(&r)
        Scanner.init(string: gString).scanHexInt32(&g)
        Scanner.init(string: bString).scanHexInt32(&b)
        
        
        print("\(r) - \(g) - \(b)")
        
        return UIColor.colorWithRGB(red: CGFloat.init(r), green: CGFloat.init(g), blue: CGFloat.init(b))
    }
}
