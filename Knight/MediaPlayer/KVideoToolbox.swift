//
//  KVideoToolbox.swift
//  Knight
//
//  Created by 陈志鹏 on 2018/8/8.
//  Copyright © 2018 ChenZhiPeng. All rights reserved.
//

import Foundation

struct KVideoToolBox
{
    public var opaque: OpaquePointer!
    
    public var decode_frame: (@convention(c) (OpaquePointer?) -> Int32)!
    
    public var free: (@convention(c) (OpaquePointer?) -> Void)!
}

fileprivate func videoToolboxCreateInternal(isAsync: Bool, ffp: UnsafeMutablePointer<FFPlayer>, ic: UnsafeMutablePointer<AVCodecContext>) ->  UnsafeMutablePointer<KVideoToolBox>? {
    guard let vtb = mallocz(MemoryLayout<KVideoToolBox>.size)?.assumingMemoryBound(to: KVideoToolBox.self) else {
        return nil
    }
    if isAsync {
        vtb.pointee.opaque = videotoolbox_async_create(ffp, ic)
        vtb.pointee.decode_frame = videotoolbox_async_decode_frame
        vtb.pointee.free = videotoolbox_async_free
    } else {
        vtb.pointee.opaque = videotoolbox_sync_create(ffp, ic)
        vtb.pointee.decode_frame = videotoolbox_sync_decode_frame
        vtb.pointee.free = videotoolbox_sync_free
    }
    if vtb.pointee.opaque == nil {
        free(vtb)
        return nil
    }
    return vtb
}

func videoToolboxAsyncCreate(ffp: UnsafeMutablePointer<FFPlayer>!, ic: UnsafeMutablePointer<AVCodecContext>!) -> UnsafeMutablePointer<KVideoToolBox>! {
    return videoToolboxCreateInternal(isAsync: true, ffp: ffp, ic: ic)
}

func videoToolboxSyncCreate(ffp: UnsafeMutablePointer<FFPlayer>!, ic: UnsafeMutablePointer<AVCodecContext>!) -> UnsafeMutablePointer<KVideoToolBox>! {
    return videoToolboxCreateInternal(isAsync: false, ffp: ffp, ic: ic)
}




struct KFF_Pipenode_Opaque
{
    var pipeline: UnsafeMutablePointer<KFF_Pipenode>!
    
    var ffp: UnsafeMutablePointer<FFPlayer>!
    
    var decoder: UnsafeMutablePointer<FFDecoder>?
    
    var context: UnsafeMutablePointer<KVideoToolBox>?
    
    var avctx: UnsafeMutablePointer<AVCodecContext>! // not own
    
    var video_fill_thread: UnsafeMutablePointer<SDL_Thread>!
    
    var _video_fill_thread: SDL_Thread
}

fileprivate func videotoolbox_video_thread(_ arg: UnsafeMutableRawPointer!) -> Int32 {
    let opaque = arg!.assumingMemoryBound(to: KFF_Pipenode_Opaque.self)
    let isVideoState = opaque.pointee.ffp?.pointee.is
    let d = isVideoState?.pointee.viddec
    
    while true {
        if isVideoState!.pointee.abort_request > 0 || d!.queue.pointee.abort_request > 0 {
            return -1
        }
        guard let ret = opaque.pointee.context?.pointee.decode_frame(opaque.pointee.context?.pointee.opaque) else {
            continue
        }
        if ret < 0 {
            return 0
        }
    }
}

fileprivate func func_destroy(_ node: UnsafeMutablePointer<KFF_Pipenode>!) {

}

fileprivate func func_run_sync(_ node: UnsafeMutablePointer<KFF_Pipenode>!) -> Int32 {
    let opaque = node.pointee.opaque.assumingMemoryBound(to: KFF_Pipenode_Opaque.self)
    let ret = videotoolbox_video_thread(opaque)
    if opaque.pointee.context != nil {
        opaque.pointee.context!.pointee.free(opaque.pointee.context!.pointee.opaque)
        free(opaque.pointee.context)
        opaque.pointee.context = nil
    }
    return ret
}

public func ffpipenode_create_video_decoder_from_videotoolbox(ffp: UnsafeMutablePointer<FFPlayer>?) -> UnsafeMutablePointer<KFF_Pipenode>? {
    if ffp == nil || ffp?.pointee.is == nil {
        return nil
    }
    guard let node = ffpipenode_alloc(MemoryLayout<KFF_Pipenode_Opaque>.size) else {
        return nil
    }
    memset(node, Int32(MemoryLayout<KFF_Pipenode>.size), 0)
    
    let isVideoState = ffp!.pointee.is
    let opaque = node.pointee.opaque.assumingMemoryBound(to: KFF_Pipenode_Opaque.self)
    node.pointee.func_destroy = func_destroy
    node.pointee.func_run_sync = func_run_sync
    opaque.pointee.ffp = ffp
    let dec = withUnsafeMutablePointer(to: &isVideoState!.pointee.viddec) {UnsafeMutableRawPointer($0)}
    opaque.pointee.decoder = dec.assumingMemoryBound(to: FFDecoder.self)
    opaque.pointee.avctx = opaque.pointee.decoder?.pointee.avctx
    switch opaque.pointee.avctx.pointee.codec_id {
    case AV_CODEC_ID_H264: fallthrough
    case AV_CODEC_ID_HEVC:
        if ffp!.pointee.vtb_async > 0 {
            opaque.pointee.context = videoToolboxAsyncCreate(ffp: ffp, ic: opaque.pointee.avctx)
        } else {
            opaque.pointee.context = videoToolboxSyncCreate(ffp: ffp, ic: opaque.pointee.avctx)
        }
    default:
        ffpipenode_free(node)
        return nil
    }
    if opaque.pointee.context == nil {
        ffpipenode_free(node)
        return nil
    }
    return node
}
