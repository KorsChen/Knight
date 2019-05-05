//
//  KAudioKit.swift
//  Knight
//
//  Created by ChenZhiPeng on 2018/7/11.
//  Copyright © 2018 ChenZhiPeng. All rights reserved.
//

import Foundation
import AVFoundation

class KAudioKit
{
    var audioSessionInitialized = false
    
    static let shared = KAudioKit()
    
    private init() {
        
    }
    
    func setupAudioSession() {
        if false == audioSessionInitialized {
            NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption(notif:)), name: AVAudioSession.interruptionNotification, object: AVAudioSession.sharedInstance())
            
            audioSessionInitialized = true
        }
        
        do {
            if #available(iOS 10.0, *) {
                //playback只支持音频播放。音频不会被静音键和锁屏键静音。锁屏后依然可以播放。
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            } else {
//                try AVAudioSession.sharedInstance().setCategory(.playback)
            }

            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
    }
    
    func setActive(active: Bool) {
        do {
            if active {
                try AVAudioSession.sharedInstance().setActive(true)
            } else {
                try AVAudioSession.sharedInstance().setActive(false)
            }
        } catch {
            print(error)
        }
    }

    
    @objc func handleInterruption(notif: Notification) {
        let reason = notif.userInfo![AVAudioSessionInterruptionTypeKey] as? UInt
        switch reason {
        case AVAudioSession.InterruptionType.began.rawValue:
            setActive(active: false)
        case AVAudioSession.InterruptionType.ended.rawValue:
            setActive(active: true)
        default:
            break
        }
    }
}
