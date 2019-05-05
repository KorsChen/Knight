//
//  KMediaModule.swift
//  Knight
//
//  Created by ChenZhiPeng on 2018/7/11.
//  Copyright © 2018 ChenZhiPeng. All rights reserved.
//

import Foundation

class KMediaModule
{
    var appIdLeTimerDisabled: Bool {
        didSet {
            updateIdleTimer()
        }
    }
    var mediaModuleIdleTimerDisabled: Bool {
        didSet {
            updateIdleTimer()
        }
    }
    
    static let shared = KMediaModule()
    
    private init() {
        appIdLeTimerDisabled = false
        mediaModuleIdleTimerDisabled = false
    }
    
    func updateIdleTimer() {
        UIApplication.shared.isIdleTimerDisabled = appIdLeTimerDisabled || mediaModuleIdleTimerDisabled
    }
}
