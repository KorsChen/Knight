//
//  LHCustomSegmentView.swift
//  leihou
//
//  Created by 陈志鹏 on 2018/5/17.
//  Copyright © 2018 huajiao. All rights reserved.
//

import UIKit

class KCustomSegmentView: UIView
{
    lazy var btnArray = [UIButton]()
    lazy var titleArray = [String]()
    
    var selectedAction: ( (Int) -> () )?
    
    var titleColor: UIColor!
    var titleSelectedColor: UIColor!
    var titleFont: UIFont!
    var titleSelectedFont: UIFont!
    var selectedBtn: UIButton?
    var sliderColor: UIColor!
    
    let sliderH: CGFloat = 3
    
    lazy var sliderView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: height - sliderH, width: 18, height: sliderH))
        view.backgroundColor = sliderColor
        view.layer.masksToBounds = true
        view.layer.cornerRadius = view.height/2
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(titleArray: [String],
                     titleColor: UIColor,
                     titleSelectedColor: UIColor,
                     titleFont: UIFont,
                     titleSelectedFont: UIFont,
                     sliderColor: UIColor,
                     defaultIndex: Int,
                     frame: CGRect,
                     action: ( (Int) -> () )?) {
        self.init(frame: frame)
        self.titleArray = titleArray
        self.titleColor = titleColor
        self.titleSelectedColor = titleSelectedColor
        self.titleFont = titleFont
        self.titleSelectedFont = titleSelectedFont
        self.sliderColor = sliderColor
        selectedAction = action
        
        setupUI()
        btnAction(sender: btnArray[defaultIndex])
    }
    
    func setupUI() {
        guard titleArray.count != 0 else {
            return
        }
        
        for title in titleArray {
            let btn = UIButton(type: .custom)
            let atri = NSAttributedString(string: title, attributes: [
                .font : titleFont,
                .foregroundColor : titleColor
                ])
            btn.setAttributedTitle(atri, for: .normal)
            
            let atriS = NSAttributedString(string: title, attributes: [
               .font : titleSelectedFont,
               .foregroundColor : titleSelectedColor
                ])
            btn.setAttributedTitle(atriS, for: .selected)
            btn.backgroundColor = UIColor.clear
            btn.addTarget(self, action: #selector(btnAction(sender:)), for: .touchUpInside)
            
            addSubview(btn)
            addSubview(sliderView)
            btnArray.append(btn)
        }
        layoutSubviews()
    }
    
    @objc func btnAction(sender: UIButton) {
        guard sender != selectedBtn else {
            return
        }
        selectedBtn?.isSelected = false
        sender.isSelected = true
        selectedBtn = sender
        
        if nil != selectedAction {
            selectedAction!(btnArray.index(of: sender)!)
        }
        
        UIView.animate(withDuration: 0.2) {
            self.sliderView.centerX = sender.centerX
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let btnH = height - sliderH
        let btnW: CGFloat = 32
        let space = (width - CGFloat(titleArray.count) * btnW) / CGFloat(titleArray.count + 1)
        var originX = space
        for (index, btn) in btnArray.enumerated() {
            let btnRect = titleArray[index].textSizeWithFont(font: titleFont, constrainedToSize: CGSize(width: CGFloat(MAXFLOAT), height: btnH))
            btn.frame = CGRect(x: originX, y: 0, width: btnRect.width, height: btnH)
            originX = originX + btn.width + space
        }
    }
}
