//
//  KFFOptions.swift
//  Knight
//
//  Created by ChenZhiPeng on 2018/7/9.
//  Copyright © 2018 ChenZhiPeng. All rights reserved.
//

import Foundation

enum KFFP_Category_Define: Int {
    case format = 1, codec, sws, player, swr
}

class KFFOptions
{
    var showHudView = false
    
    var optionCategories = [KFFP_Category_Define : [String : Any]]()
    var playerOptions = [String : Any]()
    var formatOptions = [String : Any]()
    var codecOptions = [String : Any]()
    var swsOptions = [String : Any]()
    var swrOptions = [String : Any]()
    
    init() {
        optionCategories[.player] = playerOptions
        optionCategories[.format] = formatOptions
        optionCategories[.codec] = codecOptions
        optionCategories[.sws] = swsOptions
        optionCategories[.swr] = swrOptions
    }
    
    class func optionsByDefault() -> KFFOptions {
        let options = KFFOptions()
        
        options.setOption(value: 30, key: "max-fps", category: .player)
        options.setOption(value: 0, key: "framedrop", category: .player)
        options.setOption(value: 3, key: "video-pictq-size", category: .player)
        options.setOption(value: 1, key: "videotoolbox", category: .player)
        options.setOption(value: 960, key: "videotoolbox-max-frame-width", category: .player)
        
        options.setOption(value: 0, key: "auto_convert", category: .format)
        options.setOption(value: 1, key: "reconnect", category: .format)
        options.setOption(value: 30 * 1000 * 1000, key: "timeout", category: .format)
        
        return options
    }
    
    func applyTo(mediaPlayer: UnsafeMutablePointer<KPlayerStruct>!) {
        for (valueKey, valueDic) in optionCategories {
            for (key, content) in valueDic {
                if content is Int64 {
                    KPlayer.shared.setOptionInit(mp: mediaPlayer, optCategory: valueKey, name: key, value: content as! Int64)
                } else if content is String {
                    KPlayer.shared.setOption(mp: mediaPlayer, optCategory: valueKey, name: key, value: content as! String)
                }
            }
        }
    }
    
    func setOption(value: Int64, key: String, category: KFFP_Category_Define) {
        if nil != optionCategories[category] {
            optionCategories[category]![key] = value
        }
    }
}
