//
//  Const.swift
//  living
//
//  Created by 陈志鹏 on 26/03/2018.
//  Copyright © 2018 MJHF. All rights reserved.
//

import Foundation
import UIKit

/*
    Swift file Const
*/

//屏幕尺寸
let cMainScreen:(width: CGFloat, height: CGFloat) = (UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)

//是否是iPhoneX
let iPhoneXIs = (cMainScreen.height == 812 || cMainScreen.width == 812)

let ciPhoneXBottomPadding: CGFloat = iPhoneXIs ? 34 : 0

//通用控件尺寸
let cWidgetHeight:(statusBar: CGFloat, navBar: CGFloat, topBar: CGFloat, bottomBar: CGFloat) = (iPhoneXIs ? 44 : 20, 44,  iPhoneXIs ? 88 : 64, 45 + ciPhoneXBottomPadding)

typealias ActionBlock = (() -> ())?

var pushID: String?

let rootNav = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController

/*
    Objective-C file Const
 */
public class HJConst: NSObject
{

}

func isSimulator() -> Bool {
    var isSim = false
    #if arch(i386) || arch(x86_64)
    isSim = true
    #endif
    return isSim
}
