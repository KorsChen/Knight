//
//  UIButton+ext.swift
//  leihou
//
//  Created by 陈志鹏 on 2018/6/1.
//  Copyright © 2018 huajiao. All rights reserved.
//

import UIKit

extension UIButton
{
    open override var isHighlighted: Bool {
        didSet {
            self.alpha = isHighlighted ? 0.5 : 1
        }
    }
}

