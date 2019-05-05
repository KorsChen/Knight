//
//  Kpipeline.swift
//  Knight
//
//  Created by 陈志鹏 on 2018/8/5.
//  Copyright © 2018 ChenZhiPeng. All rights reserved.
//

import Foundation

struct KFF_Pipeline_Opaque
{
    var ffp: FFPlayer?
    var is_videotoolbox_open: Int32
}

let func_open_audio_output: @convention(c) (UnsafeMutablePointer<KFF_Pipeline>?, UnsafeMutablePointer<FFPlayer>?) -> UnsafeMutablePointer<SDL_Aout>? = { pipeline, ffp in
    return SDL_AoutIos_CreateForAudioUnit()
}

let func_open_video_decoder: @convention(c) (UnsafeMutablePointer<KFF_Pipeline>?, UnsafeMutablePointer<FFPlayer>?) -> UnsafeMutablePointer<KFF_Pipenode>? = { pipeline, ffp in
    var node: UnsafeMutablePointer<KFF_Pipenode>? = nil
    //    OpaquePointer to UnsafeMutablePointer<struce> 不透明指针转UnsafeMutablePointer
    let opaque = unsafeBitCast(pipeline?.pointee.opaque, to: UnsafeMutablePointer<KFF_Pipeline_Opaque>.self)
    //  如果配置了ffp->videotoolbox，会优先去尝试打开硬件解码器
    if ffp?.pointee.videotoolbox != 0 {
        node = ffpipenode_create_video_decoder_from_videotoolbox(ffp: ffp)
    }
    if node == nil {
        //如果硬件解码器打开失败，则会自动切换至软解
        node = ffpipenode_create_video_decoder_from_ffplay(ffp);
        ffp?.pointee.stat.vdec_type = Int64(FFP_PROPV_DECODER_AVCODEC)
        opaque.pointee.is_videotoolbox_open = 0
    } else {
        ffp?.pointee.stat.vdec_type = Int64(FFP_PROPV_DECODER_VIDEOTOOLBOX)
        opaque.pointee.is_videotoolbox_open = 1
    }
    ffp_notify_msg2(ffp, FFP_MSG_VIDEO_DECODER_OPEN, opaque.pointee.is_videotoolbox_open)
    return node
}


var g_pipeline_class: SDL_Class {
    get {
        let value = SDL_Class(name: UnsafePointer(strdup("ffpipeline_Knight".cString(using: .utf8))))
        return value
    }
    set {
        
    }
}

func ffpipeline_create_from_ios(ffp: UnsafeMutablePointer<FFPlayer>?) -> UnsafeMutablePointer<KFF_Pipeline>? {
    guard let pipeline = ffpipeline_alloc(&g_pipeline_class, MemoryLayout<KFF_Pipeline_Opaque>.size) else {
        return nil
    }
    let opaque = unsafeBitCast(pipeline.pointee.opaque, to: UnsafeMutablePointer<KFF_Pipeline_Opaque>.self)
    opaque.pointee.ffp = ffp?.pointee
    //函数指针在播放器初始化时赋值
    pipeline.pointee.func_open_video_decoder = func_open_video_decoder
    pipeline.pointee.func_open_audio_output = func_open_audio_output
    return pipeline
}

