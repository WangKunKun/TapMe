//
//  WKTapView.swift
//  点我加一
//
//  Created by wangkun on 2017/8/29.
//  Copyright © 2017年 wangkun. All rights reserved.
//

import UIKit
import SnapKit
import RandomKit

protocol WKTapViewDelegate {
    func tapViewClick(count:Int,view:WKTapView)
}

class WKTapView: UIView {

    private var label = UILabel()
    var count = 1{
        didSet{
            label.text = String.init(count)
            self.setColor()
        }
    } //当前数值
    var line = 0//列
    var row = 0//行
    var delegate:WKTapViewDelegate?
    
    var index:Int {
        get{
            return line * 5 + row
        }
    }
    
    func setColor() {
        self.backgroundColor = WKColorSelecter.getBGColor(count: count)
        label.textColor = WKColorSelecter.getTextColor(count: count)
    }
    
    init(randomMax:Int) {
        super.init(frame: CGRect.zero)
        self.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.right.bottom.top.equalTo(self);
        }
        label.textAlignment = NSTextAlignment.center
        count = Xoroshiro.withThreadLocal { randomGenerator in
            let value = Int.random(in: Range.init(uncheckedBounds: (lower: 1, upper: randomMax)), using: &randomGenerator)
            return value ?? 1
        }

        label.text = String.init(count)
        self.setColor()
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tap(tap:)))
        self.addGestureRecognizer(tap)
    }
    
    //结束动画
    func end()  {
        //阻尼系数-稳定比
        //速率-不稳定到稳定状态下的速率？
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1.5, options: [.curveLinear], animations: {
            self.transform = self.transform.scaledBy(x: 0.5, y: 0.5)
        }) { (flag) in
            if flag {
               UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 5.0, options: [.curveLinear], animations: {
                self.transform = CGAffineTransform.identity
               }, completion: nil)
            }
        }
        
        
        
    }
    
    func tap(tap:UITapGestureRecognizer) {
        self.count += 1
        delegate?.tapViewClick(count: count,view: self)
    }
    
    //判断是否相邻
    func isAdjacent(_ With:WKTapView) -> Bool {
        
        if self.line == With.line {
            let rowSub = self.row - With.row
            return rowSub == 1 || rowSub == -1;
        }
        
        if self.row == With.row {
            let lineSub = self.line - With.line
            return lineSub == 1 || lineSub == -1;
        }
        return false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //判断是否相等
    func wkIsEqual(_ object: WKTapView) -> Bool {
        return self.line == object.line && self.row == object.row;
    }
    
    override var description: String
    {
        get{
            return "line = \(self.line),row = \(self.row),count= \(self.count)"
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
