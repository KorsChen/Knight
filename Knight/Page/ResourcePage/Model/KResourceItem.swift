//
//  LHOtherProfile.swift
//  leihou
//
//  Created by 陈志鹏 on 2018/5/10.
//  Copyright © 2018 KorsChen. All rights reserved.
//

import UIKit

let normalTextColor = #colorLiteral(red: 0.1058823529, green: 0.05098039216, blue: 0.1294117647, alpha: 1)

enum LHGender: Int {
    case unknow = 0, man, woman
}

class KResourceItem
{
    var nickname: String!
    var avator: String!
    var introduce: String!
    var url: String!
    var gender = LHGender.unknow
    
    init(nickname: String, avator: String, introduce: String, url: String) {
        self.nickname = nickname
        self.avator = avator
        self.introduce = introduce
        self.url = url
    }
}
