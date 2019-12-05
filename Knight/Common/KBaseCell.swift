//
//  UITableViewCell+Ext.swift
//  leihou
//
//  Created by 陈志鹏 on 2018/5/10.
//  Copyright © 2018 KorsChen. All rights reserved.
//

import UIKit

class KBaseCell: UITableViewCell
{
    var tableView: UITableView?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func identify() -> String {
        return String(describing: type(of: self.classForCoder))
    }
    
    class func register(table: UITableView) {
        table.register(self.classForCoder(), forCellReuseIdentifier: identify())
    }
}
