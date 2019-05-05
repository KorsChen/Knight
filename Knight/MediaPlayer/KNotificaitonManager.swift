//
//  KNotificaitonManager.swift
//  Knight
//
//  Created by ChenZhiPeng on 2018/7/12.
//  Copyright © 2018 ChenZhiPeng. All rights reserved.
//

import Foundation

class KNotificationManager
{
    var registeredNotifs = [NSNotification.Name : NSNotification.Name]()
        
    func addObserver(observer: Any, aSelector: Selector, aName: NSNotification.Name) {
        NotificationCenter.default.addObserver(observer, selector: aSelector, name: aName, object: nil)
        registeredNotifs[aName] = aName
    }
    
    func removeAllObservers(observer: Any) {
        for name in registeredNotifs.keys {
            NotificationCenter.default.removeObserver(observer, name: name, object: nil)
        }
    }
}
