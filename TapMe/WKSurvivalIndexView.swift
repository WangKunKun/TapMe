//
//  WKSurvivalIndexView.swift
//  TapMe
//
//  Created by wangkun on 2017/9/5.
//  Copyright © 2017年 wangkun. All rights reserved.
//

import UIKit

class WKSurvivalIndexView: UIView {

    private var viewWidth = 0
    
    private let maxCount = 5
    private var presentCount = 5
    {
        didSet{
            let color = presentCount > 1 ? self.normalColor : self.warningColor
            for view in self.viewArr {
                let index = self.viewArr.index(of: view)!
                view.snp.updateConstraints({ (make) in
                    make.width.equalTo( index > presentCount - 1 ? 0 : self.viewWidth)
                })
                UIView.animate(withDuration: 0.23) {
                    view.alpha = index > self.presentCount - 1 ? 0 : 1
                    view.backgroundColor = color
                    self.layoutIfNeeded()
                }
            }
        }
    }
    private var normalColor:UIColor
    private var warningColor:UIColor
    private var viewArr = Array<UIView>()
    
    var dieblock:voidClosureType?
    
    init() {
        normalColor = UIColor.colorWithRGB(red: 195, green: 253, blue: 86)
        warningColor = UIColor.colorWithRGB(red: 238, green: 117, blue: 113)
        super.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth - 50, height: 50))
        self.backgroundColor = UIColor.colorWithRGB(red: 164, green: 164, blue: 164)
        let space = 5
        self.viewWidth = (Int(self.wkWidth) - (maxCount + 1) * space) / maxCount
        self.layer.cornerRadius = 5
        var offsetX = space
        
        for _ in 0..<maxCount {
            let view = UIView.init()
            view.backgroundColor = self.normalColor
            view.layer.cornerRadius = 5
            self.addSubview(view)
            view.snp.makeConstraints({ (make) in
                make.left.equalTo(self).offset(offsetX)
                make.width.equalTo(viewWidth)
                make.top.equalTo(self).offset(5)
                make.bottom.equalTo(self).offset(-5)
            })
            offsetX += viewWidth + space
            viewArr.append(view)
        }
    }
    
    
    func changeCount(flag:Bool) {
        objc_sync_enter(self)
        if flag {
            addCount()
        }
        else
        {
            subCount()
        }
        objc_sync_exit(self)
    }
    
    private func addCount()  {
        if presentCount >= maxCount {
            return
        }
        self.presentCount += 1

    }
    
    private func subCount()  {
        if presentCount <= 0 {
            //结束
            self.dieblock?()
            return
        }
        self.presentCount -= 1
        if presentCount <= 0 {
            //结束
            self.dieblock?()
        }

    }
    
    func resetUI() {
        self.presentCount = self.maxCount
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
