//
//  LHTableView.swift
//  leihou
//
//  Created by 陈志鹏 on 6/8/18.
//  Copyright © 2018 KorsChen. All rights reserved.
//

import UIKit

class KTableView: UITableView
{    
    var superVC: UIViewController!
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(style: UITableView.Style, vc: UIViewController) {
        self.init(frame: CGRect(x: 0, y: cWidgetHeight.topBar, width: cMainScreen.width, height: cMainScreen.height - cWidgetHeight.topBar), style: style)
        superVC = vc
        backgroundColor = UIColor.white
        separatorStyle = .none
        if #available(iOS 11.0, *) {
            contentInsetAdjustmentBehavior = .never
        } else {
            superVC.automaticallyAdjustsScrollViewInsets = false
        }
        delegate = superVC as? UITableViewDelegate
        dataSource = superVC as? UITableViewDataSource
    }
}
