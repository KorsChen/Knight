//
//  KMediaPlayer.swift
//  Knight
//
//  Created by 陈志鹏 on 2018/8/4.
//  Copyright © 2018 ChenZhiPeng. All rights reserved.
//

import Foundation

struct KPlayerStruct
{
    var ref_count: Int32
    var mutex: pthread_mutex_t
    var ffplayer: UnsafeMutablePointer<FFPlayer>?
    
    var msg_loop: (@convention(c) (UnsafeMutableRawPointer?) -> Int32)?
    var msg_thread: UnsafeMutablePointer<SDL_Thread>?
    var _msg_thread: SDL_Thread
    
    var mp_state: Int32
    var data_source: UnsafeMutablePointer<Int8>?
    var weak_thiz: UnsafeMutableRawPointer?
    
    var restart: Int32
    var restart_from_beginning: Int32
    var seek_req: Int32
    var seek_msec: Int
}
