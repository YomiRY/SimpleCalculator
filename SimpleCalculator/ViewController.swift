//
//  ViewController.swift
//  SimpleCalculator
//
//  Created by yomi on 2017/11/13.
//  Copyright © 2017年 yomi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var mLbResult: UILabel!
    @IBOutlet weak var mLbOperation: UILabel!
    
    var mCurText:String = ""
    var mIsNeedClr = false
    var mPrevOperator:OperationConstants!
    var mPrevResult:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reset()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func reset() {
        mLbResult.text = "0"
        mPrevResult = "0"
        mCurText = "0"
        mLbOperation.text = ""
        mPrevOperator = nil;
    }
    
    // MARK: do calculate
    func calculate(_ operation:OperationConstants) {
        if operation == .PERCENT || operation == .POSITIVE_NEGATIVE_CHANGE {
            if operation == .PERCENT {
                self.mLbResult.text = "\(Double(self.mLbResult.text!)! / Double(100))"
            } else {
                self.mLbResult.text = "\(Double(self.mLbResult.text!)! * Double(-1))"
            }
            return;
        } else if (self.mLbResult.text?.isEmpty)! {
            self.mLbResult.text = self.mCurText;
        } else if self.mPrevOperator != nil {
            // 先算前一次的結果
            switch (self.mPrevOperator!) {
            case .PLUS:
                self.mCurText = self.mCurText.isEmpty ? String(0) : self.mCurText;
                self.mLbResult.text = "\(Double(self.mPrevResult)! + Double(self.mCurText)!)";
                break;
            case .MINUS:
                self.mCurText = self.mCurText.isEmpty ? String(0) : self.mCurText;
                self.mLbResult.text = "\(Double(mPrevResult)! - Double(self.mCurText)!)";
                break;
            case .MULTIPLE:
                self.mCurText = self.mCurText.isEmpty ? String(1) : self.mCurText;
                self.mLbResult.text = "\(Double(mPrevResult)! * Double(self.mCurText)!)";
                break;
            case .DIVIDER:
                self.mCurText = self.mCurText.isEmpty ? String(1) : self.mCurText;
                self.mLbResult.text = "\(Double(mPrevResult)! / Double(self.mCurText)!)";
                break;
            default:
                break;
            }
        }
        //Remove Trailing Zeros From Double
        self.mLbResult.text = String(format: "%g", Double(self.mLbResult.text!)!)
        
        if operation == .EQUAL {
            self.mPrevOperator = nil
            self.mLbOperation.text = ""
        } else {
            self.mPrevOperator = operation
        }
    }
    
    // MARK: - onNumberBtnClick
    @IBAction func onNumberBtnClick(_ btn: UIButton) {
        if(self.mIsNeedClr) {
            // if previous is operator, then we need clear and cache some status
            self.mPrevResult = mLbResult.text
            self.mCurText = "";
            self.mIsNeedClr = false
        }
        
        mCurText.append("\(btn.tag)")
        mLbResult.text = mCurText
        
        // 去掉多餘的0, 避免 00000.. 的現象
        if self.mCurText.first == "0", self.mCurText.count > 1, !self.mCurText.contains(".") {
            self.mCurText.removeFirst()
        }
        self.mLbResult.text = self.mCurText;
    }
    
    // MARK: - onOperationBtnClick
    @IBAction func onOperationBtnClick(_ btn: UIButton) {
        let operationStr:String = btn.titleLabel?.text ?? ""
        
        if operationStr.isEmpty {
            return
        }
        
        let operation:OperationConstants? = OperationConstants(rawValue:operationStr)
        
        if operation == nil {
            return
        }
        
        switch operation! {
        case .CLR:
            reset()
        case .DIVIDER, .MULTIPLE, .MINUS, .PLUS, .EQUAL, .PERCENT, .POSITIVE_NEGATIVE_CHANGE:
            if operation! == .EQUAL || operation! == .PERCENT || operation! == .POSITIVE_NEGATIVE_CHANGE {
                self.mIsNeedClr = false
            } else {
                self.mIsNeedClr = true
                self.mLbOperation.text! = operationStr
            }
            
            self.calculate(operation!)
        case .DOT:
            mCurText.append((btn.titleLabel?.text)!)
        }
    }
}

