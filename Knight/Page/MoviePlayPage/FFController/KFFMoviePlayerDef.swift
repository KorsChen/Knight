//
//  KFFMoviePlayerDef.swift
//  Knight
//
//  Created by ChenZhiPeng on 2018/7/20.
//  Copyright © 2018 ChenZhiPeng. All rights reserved.
//

import Foundation

enum KFFP_Propv_Decoder_Type: Int64 {
    case unknown = 0, avcodec, mediaCodec, videoToolBox
}

enum KFFP_Message_State: Int {
    case flush = 0,
    error = 100,
    prepared = 200,
    completed = 300,
    
    video_size_changed = 400,
    sar_changed = 401,
    video_rendering_start = 402,
    audio_rendering_start = 403,
    video_rotation_changed = 404,
    audio_decoded_start = 405,
    video_decoded_start = 406,
    open_input = 407,
    find_stream_info = 408,
    component_open = 409,
    video_seek_rendering_start = 410,
    audio_seek_rendering_start = 411,
    
    buffering_start = 500,
    buffering_end = 501,
    buffering_update = 502,
    buffering_byte_update = 503,
    buffering_time_update = 504,
    
    seek_complete = 600,
    
    playback_state_changed = 700,
    timed_text = 800,
    accurate_seek_complete = 900,
    get_img_state = 1000,
    
    video_decoder_open = 10001,
    
    req_start = 20001,
    req_pause = 20002,
    req_seek = 20003
}

class KFFMoviePlayerMessage: NSObject
{
    var message: AVMessage!
}

class KFFMoivePlayerMessagePool
{
    var array = [KFFMoviePlayerMessage]()
    
    func obtain() -> KFFMoviePlayerMessage? {
        var msg: KFFMoviePlayerMessage?
        
        objc_sync_enter(self)
        
        let count = array.count
        if array.count > 0 {
            msg = array[count - 1]
            array.removeLast()
        }
        objc_sync_exit(self)
        
        if nil == msg {
            msg = KFFMoviePlayerMessage()
        }
        
        return msg
    }

    func recycle( msg: KFFMoviePlayerMessage?) {
        guard nil == msg else {
            return
        }
//        msg_free_res(&msg!.message)
        objc_sync_enter(self)
        
        if array.count <= 10 {
            array.append(msg!)
        }
        
        objc_sync_exit(self)
    }
}
