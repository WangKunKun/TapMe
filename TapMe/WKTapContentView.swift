//
//  WKTapContentView.swift
//  TapMe
//
//  Created by wangkun on 2017/8/29.
//  Copyright © 2017年 wangkun. All rights reserved.
//

import UIKit
import RandomKit
class WKTapContentView: UIView,WKTapViewDelegate {

    private let animTime = 0.5
    private let width = Int((screenWidth - 40) / 5.0)//tapview宽度
    private let height = Int((screenWidth - 40) / 5.0)//tapview高度
    private let line = 5//列
    private let row = 5//行
    private let canMergeCount = 3//可消除的数量
    private var score = 0//记录分数
    {
        didSet{
            self.scoreBlock?(String.init(self.score))
        }
    }
    
    private var presentCount = 5//当前得到的最大值
    private var maxCount = 8//随机count的最大值
    
    private var datasource = Array<WKTapView>()//原始数组
    private var dismissArr = Array<WKTapView>()//将要消失的数组
    private var needAddIndexTuples = Array<(line:Int,row:Int)>()//需要新增的i，j数组
    
    lazy var contentWidth:Int =
    {
        return self.width * self.row
    }()
    lazy var maxCountStr:String =
    {
        return String.init(self.maxCount)
    }()
    var scoreBlock:strClosureType?
    var surCountBlock:boolClosureType?

    
    init() {
        super.init(frame: CGRect.zero)
    }
    
    
    func setInterFace() {

        for i in 0..<line {
            for j in 0..<row {
                let tapView = WKTapView.init(randomMax:self.presentCount)
                datasource.append(tapView)
                self.addSubview(tapView)
                tapView.line = i
                tapView.row = j
                tapView.delegate = self
                //优化初始化动画
                tapView.wkTop = CGFloat(-(height))
                tapView.wkWidth = CGFloat(width)
                tapView.wkHeight = CGFloat(height)
                tapView.wkLeft = CGFloat(j * width)
            }
        }
        self.updateUI()
                
    }
    
    func tapViewClick(count: Int, view: WKTapView) {
        self.findSameCountView(view)
        if dismissArr.count >= canMergeCount {
            self.testMenthod()
            //记录分数
            self.addScore()
            //移除第一个
            dismissArr.remove(at: 0)
            for tapView in dismissArr {
                if datasource.contains(tapView) {
                    self.checkMove(tapView)
                    let index =  datasource.index(of: tapView)!
                    self.datasource.remove(at:index)
                    //完善动画
                    tapView.snp.remakeConstraints({ (make) in
                        make.top.equalTo(self).offset((view.row == tapView.row ? view.line : tapView.line) * height)
                        make.left.equalTo(self).offset((view.line == tapView.line ? view.row : tapView.row) * width)
                        make.width.height.equalTo(width)
                    })
                    //移动
                    UIView.animate(withDuration: animTime / 2.0, animations: {
                        tapView.alpha = 0.2
                        self.layoutIfNeeded()
                    }, completion: { (flag) in
                        if flag{
                            tapView.removeFromSuperview()
                        }
                    })
                }
            }
            self.dismissArr.removeAll()
            view.count += 1;
            presentCount = presentCount < view.count ? view.count : presentCount
            self.updateUI()
        }
        else
        {
            //减一次次数
            self.surCountBlock?(false)
        }
        self.dismissArr.removeAll()
        
    }

    
    func updateUI() {
        //添加新数据
        for (line,row) in needAddIndexTuples {
            //保障最大值为8
            let tapView = WKTapView.init(randomMax:(self.presentCount > self.maxCount ? self.maxCount : self.presentCount))
            datasource.append(tapView)
            self.addSubview(tapView)
            tapView.line = line
            tapView.row = row
            tapView.wkTop = CGFloat(-width)
            tapView.wkWidth = CGFloat(width)
            tapView.wkHeight = CGFloat(height)
            tapView.wkLeft = CGFloat(row * width)
            tapView.delegate = self
            tapView.alpha = 0
        }
        self.needAddIndexTuples.removeAll()
        self.layoutIfNeeded()
        //刷新ui 构建动画
        for tapView in datasource {
            tapView.snp.remakeConstraints({ (make) in
                make.top.equalTo(self).offset(tapView.line * height)
                make.left.equalTo(self).offset(tapView.row * width)
                make.width.equalTo(width)
                make.height.equalTo(height)
            })

        }
        
        
        UIView.animate(withDuration: animTime, animations: {
            for tapView in self.datasource {
                tapView.alpha = 1
            }
            self.layoutIfNeeded()
        }, completion: { (flag) in
            if(flag)
            {
                //同步锁
                objc_sync_enter(self)
                for tapView in self.datasource {
                    //递归测试点击
                    self.dismissArr.removeAll()
                    self.findSameCountView(tapView)
                    if self.dismissArr.count >= 3 {
                        self.dismissArr.removeAll()
                        self.surCountBlock?(true)
                        self.tapViewClick(count: tapView.count, view: tapView)
                        break
                    }
                    else
                    {
                        self.dismissArr.removeAll()
                    }
                }
                objc_sync_exit(self)

            }
        })
        
    }
    
    //移除数组数据
    func cleanCheckArr()  {
        self.dismissArr.removeAll()
        self.needAddIndexTuples.removeAll()
    }
    //记录移动
    func checkMove(_ tapView:WKTapView) {
        
        let index =  tapView.index
        //计算需要move的index
        let moveIndex = index - row
        if  moveIndex >= 0 {
            var view:WKTapView?
            for tmpView in datasource {
                if tmpView.index == moveIndex {
                    view = tmpView
                    break
                }
            }
            //递归判断 是否需要移动
            if (view != nil) {
                self.checkMove(view!)
                //修改位置信息
                view!.line = tapView.line
                view!.row = tapView.row
            }
            else
            {
                //记录缺失位置
                let tuple = (line:tapView.line,row:tapView.row)
                needAddIndexTuples.append(tuple)
            }

        }
        else
        {
            //记录缺失的位置
            let tuple = (line:tapView.line,row:tapView.row)
            needAddIndexTuples.append(tuple)
            
        }
    }
    
    //获得相邻可消除的view
    func findSameCountView(_ source: WKTapView) {
        //过滤掉可能出现的异常情况
        for tmp in self.dismissArr {
            if tmp.index == source.index {
                return;
            }
        }
        dismissArr.append(source)
        for tapView in datasource {
            //如果不相等，并且相邻，并且count相等
            if !tapView.wkIsEqual(source) && tapView.isAdjacent(source) && source.count == tapView.count {
                //再次判断是否相等
                var flag = false
                for tmp in self.dismissArr {
                    if tmp.index == tapView.index {
                        flag = true
                        break
                    }
                }
                if !flag {
                    self.findSameCountView(tapView)
                }
            }
        }
    }
    
    func addScore()
    {
        for tapView in self.dismissArr {
            self.score += tapView.count * 10
        }
    }
    
    func theEnd() {
        //结束
        for tapView in self.datasource {
            tapView.end()
            self.score += tapView.count * 10
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //测试方法打印数据
    func testMenthod()  {
        
        let newArr = self.dismissArr
        var index = 1
        var printScore = self.score
        print("dismissCount = \(self.dismissArr.count)")
        print("添加分数之前 = \(printScore)")
        for tapView in self.dismissArr {
            if index <= newArr.count - 1 {
                if tapView.wkIsEqual(newArr[index]) {
                    print("大人出错了");
                }
            }
            index += 1
            print(tapView)
            printScore += tapView.count
        }
        print("添加分数之后 = \(printScore)")

    }
    
    func resetUI() {
        for tapView in self.datasource {
            tapView.removeFromSuperview()
        }
        self.datasource.removeAll()
        self.needAddIndexTuples.removeAll()
        self.dismissArr.removeAll()
        self.presentCount = 5
        self.maxCount = 5
        self.score = 0
        self.setInterFace()
    }
    
    //延时方法 未使用 这个方法很好
    
    typealias Task = (_ cancel : Bool) -> Void
    func delay(_ time: TimeInterval, task: @escaping ()->()) ->  Task? {
        
        func dispatch_later(block: @escaping ()->()) {
            let t = DispatchTime.now() + time
            DispatchQueue.main.asyncAfter(deadline: t, execute: block)
        }
        var closure: (()->Void)? = task
        var result: Task?
        
        let delayedClosure: Task = {
            cancel in
            if let internalClosure = closure {
                if (cancel == false) {
                    DispatchQueue.main.async(execute: internalClosure)
                }
            }
            closure = nil
            result = nil
        }
        
        result = delayedClosure
        
        dispatch_later {
            if let delayedClosure = result {
                delayedClosure(false)
            }
        }
        return result
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
