//
//  ViewController.swift
//  TapMe
//
//  Created by wangkun on 2017/8/29.
//  Copyright © 2017年 wangkun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var tapContentView = WKTapContentView()
    var survivalView = WKSurvivalIndexView()
    lazy var popView:WKPopResultView = {
        let view = WKPopResultView()
        return view
    }()
    
    let scoreLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.colorWithRGB(red: 250, green: 238, blue: 247)
        //conentview
        self.view.addSubview(self.scoreLabel)
        scoreLabel.textAlignment = NSTextAlignment.center
        scoreLabel.textColor = UIColor.colorWithRGB(red: 94, green: 122, blue: 147)
        scoreLabel.font = UIFont.systemFont(ofSize: 18)
        scoreLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.view).offset(120)
            make.left.right.equalTo(self.view)
            make.height.equalTo(30)
        }
        
        self.view.addSubview(self.survivalView)
        survivalView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.scoreLabel.snp.bottom).offset(30)
            make.width.equalTo(screenWidth - 50)
            make.height.equalTo(30)
        }
        survivalView.dieblock = {[unowned self] in
            self.tapContentView.theEnd()
            //游戏结束
            //分数，最大值
            if self.popView.resetBlock == nil {
                self.popView.resetBlock = { [unowned self] in
                    self.resetUI()
                }
            }
            
            self.popView.setInterFace(maxCount: self.tapContentView.maxCountStr, score: self.scoreLabel.text ?? "0")
            self.popView.show(flag: true)
        }
        
        self.view.addSubview(tapContentView)
        tapContentView.snp.makeConstraints { (make) in
            make.width.height.equalTo(tapContentView.contentWidth);
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.survivalView.snp.bottom).offset(20);
        }
        tapContentView.backgroundColor = UIColor.darkGray
        tapContentView.setInterFace()
        tapContentView.scoreBlock =  { [unowned self] score in
            let ca = CATransition.init()
            ca.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//            ca.type = "cube"
            ca.type = kCATransitionPush
            ca.subtype = kCATransitionFromTop
            self.scoreLabel.layer.add(ca, forKey: nil);
            self.scoreLabel.text = score
        }
        tapContentView.surCountBlock = {[unowned self] flag in
            self.survivalView.changeCount(flag: flag)
        }
    }
    
    func resetUI()  {
        self.tapContentView.resetUI()
        self.survivalView.resetUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

