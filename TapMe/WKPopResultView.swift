//
//  WKPopResultView.swift
//  TapMe
//
//  Created by wangkun on 2017/9/6.
//  Copyright © 2017年 wangkun. All rights reserved.
//

import UIKit

class WKPopResultView: WKPopView {

    let topScoreLabel = UILabel()
    let presentScoreLabel = UILabel()
    let presentMaxCountLabel = UILabel()
    let resetBtn = UIButton.init(type: UIButtonType.custom)
    
    var resetBlock:voidClosureType?
    
    override init() {
        super.init()
        
        self.contentView.addSubview(self.topScoreLabel)
        topScoreLabel.numberOfLines = 2
        topScoreLabel.backgroundColor = UIColor.colorWithRGB(red: 191, green: 120, blue: 89)
        topScoreLabel.textColor = .white
        topScoreLabel.font = UIFont.systemFont(ofSize: 18)
        topScoreLabel.textAlignment = NSTextAlignment.center
        self.topScoreLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.contentView)
            make.top.equalTo(self.contentView).offset(10)
            make.height.equalTo(60)
        }
        
        self.contentView.addSubview(self.presentScoreLabel)
        presentScoreLabel.textColor = UIColor.colorWithRGB(red: 240, green: 152, blue: 55)
        presentScoreLabel.font = UIFont.systemFont(ofSize: 30)
        presentScoreLabel.textAlignment = NSTextAlignment.center
        self.presentScoreLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.contentView)
            make.top.equalTo(self.topScoreLabel.snp.bottom).offset(10)
            make.height.equalTo(35)
        }
        
        self.contentView.addSubview(self.presentMaxCountLabel)
        presentMaxCountLabel.font = UIFont.systemFont(ofSize: 24)
        presentMaxCountLabel.textAlignment = NSTextAlignment.center
        presentMaxCountLabel.layer.cornerRadius = 4
        presentMaxCountLabel.layer.masksToBounds = true
        self.presentMaxCountLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.presentScoreLabel.snp.bottom).offset(10)
            make.height.width.equalTo(50)
            make.centerX.equalTo(self.contentView)
        }
        
        self.contentView.addSubview(resetBtn)
        resetBtn.setTitle("再战", for: UIControlState.normal)
        resetBtn.layer.cornerRadius = 5
        resetBtn.backgroundColor = UIColor.colorWithRGB(red: 115, green: 215, blue: 125)
        resetBtn.addTarget(self, action: #selector(btnClick), for: UIControlEvents.touchUpInside)
        self.resetBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.contentView)
            make.top.equalTo(self.presentMaxCountLabel.snp.bottom).offset(20)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        
        self.contentView.snp.makeConstraints { (make) in
            make.width.equalTo(250)
            make.height.equalTo(280)
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(screenHeight / 2.0)
        }
        self.bgClickAutoDismiss = false
        self.contentView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
    }
    
    func setInterFace(maxCount:String,score:String) {
        self.presentMaxCountLabel.text = maxCount
        self.presentScoreLabel.text = score
        self.topScoreLabel.text = "世界第一\n\(score)"
        self.presentMaxCountLabel.textColor = WKColorSelecter.getTextColor(count: Int(maxCount) ?? 1)
        self.presentMaxCountLabel.backgroundColor = WKColorSelecter.getBGColor(count: Int(maxCount) ?? 1)

    }
    
    override func updateContentViewConstraints(flag: Bool) {
        self.contentView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self).offset(flag ? 0 : screenHeight / 2.0)
        }
    }
    
    func btnClick()  {
        self.show(flag: false)
        self.resetBlock?()
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
