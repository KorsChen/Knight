//
//  KPlayer.swift
//  Knight
//
//  Created by 陈志鹏 on 2018/8/2.
//  Copyright © 2018 ChenZhiPeng. All rights reserved.
//

import Foundation
import CoreFoundation

enum KPlayerState: Int32 {
    case idle = 0,
    initialized,
    asyncPreparing,
    prepared,
    started,
    pause,
    completed,
    stopped,
    error,
    end
}

class KPlayer
{
    static let shared = KPlayer()
    private init() { }
    
    func globalInit() {
        ffp_global_init()
    }
    
    func globalUnint() {
        ffp_global_uninit()
    }
    
    func create(msg_loop: @escaping @convention(c) (UnsafeMutableRawPointer?) -> Int32) -> UnsafeMutablePointer<KPlayerStruct>? {
        let mp = mallocz(MemoryLayout<KPlayerStruct>.size)?.assumingMemoryBound(to: KPlayerStruct.self)
        repeat {
            mp!.pointee.ffplayer = ffp_create()
            guard nil != mp!.pointee.ffplayer else {
                break
            }
            mp!.pointee.msg_loop = msg_loop
/**
     多线程无锁编程--原子计数操作：__sync_fetch_and_add, 性能上完爆线程锁, swift源码中用OSAtomicAdd32Barrier封装
     int32_t OSAtomicAdd32Barrier( int32_t theAmount, volatile int32_t *theValue ) {
             return __sync_fetch_and_add(theValue, theAmount) + theAmount;
     }
*/
            OSAtomicAdd32Barrier(1, &mp!.pointee.ref_count)
            pthread_mutex_init(&mp!.pointee.mutex, nil)
            return mp

        } while nil != mp
        
        destroy(mp: mp)
        return nil
    }
    
    func globalLogReport(user_report: Int32) {
        ffp_global_set_log_report(user_report)
    }
    
    func globalLogLevel(log_level: Int32) {
        ffp_global_set_log_level(log_level)
    }
    
    @discardableResult func setWeakThiz(mp: UnsafeMutablePointer<KPlayerStruct>, weak_thiz: UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer? {
        let prev_weak_thiz = mp.pointee.weak_thiz
        mp.pointee.weak_thiz = weak_thiz
        return prev_weak_thiz
    }
    
    func changeState(mp: UnsafeMutablePointer<KPlayerStruct>, state: KPlayerState) {
        mp.pointee.mp_state = state.rawValue
        ffp_notify_msg1(mp.pointee.ffplayer, FFP_MSG_PLAYBACK_STATE_CHANGED)
    }
    
    func checkState(state: Int32) -> Int32 {
        let mp_state = KPlayerState(rawValue: state)
        switch mp_state! {
        case .idle: fallthrough
        case .initialized: fallthrough
        case .asyncPreparing: fallthrough
        case .stopped: fallthrough
        case .error: fallthrough
        case .end:
            return EIJK_INVALID_STATE
        default:
            return 0
        }
    }

    func dec_ref(mp: UnsafeMutablePointer<KPlayerStruct>?) {
        guard mp != nil else {
            return
        }
    }
    
    func isPlaying(mp: UnsafeMutablePointer<KPlayerStruct>) -> Bool {
        if mp.pointee.mp_state == KPlayerState.prepared.rawValue ||
            mp.pointee.mp_state == KPlayerState.started.rawValue {
            return true
        }
        return false
    }
    
    func setInjectOpaque(mp: UnsafeMutablePointer<KPlayerStruct>, opaque: UnsafeMutableRawPointer?) {
        ffp_set_inject_opaque(mp.pointee.ffplayer, opaque)
    }
    
    func setIOInjectOpaque(mp: UnsafeMutablePointer<KPlayerStruct>, opaque: UnsafeMutableRawPointer?) {
        ffp_set_ijkio_inject_opaque(mp.pointee.ffplayer, opaque)
    }
    
    func setOption(mp: UnsafeMutablePointer<KPlayerStruct>, optCategory: KFFP_Category_Define, name: String, value: String) {
        pthread_mutex_lock(&mp.pointee.mutex)
        ffp_set_option(mp.pointee.ffplayer, Int32(optCategory.rawValue), strdup(name.cString(using: .utf8)), strdup(value.cString(using: .utf8)))
        pthread_mutex_unlock(&mp.pointee.mutex)
    }
    
    func setOptionInit(mp: UnsafeMutablePointer<KPlayerStruct>, optCategory: KFFP_Category_Define, name: String, value: Int64) {
        pthread_mutex_lock(&mp.pointee.mutex)
        ffp_set_option_int(mp.pointee.ffplayer, Int32(optCategory.rawValue), strdup(name.cString(using: .utf8)), value)
        pthread_mutex_unlock(&mp.pointee.mutex)
    }
    
    func setPlaybackRate(mp: UnsafeMutablePointer<KPlayerStruct>, rate: Float) {
        pthread_mutex_lock(&mp.pointee.mutex)
        ffp_set_playback_rate(mp.pointee.ffplayer, rate)
        pthread_mutex_unlock(&mp.pointee.mutex)
    }
    
    func setPlaybackVolume(mp: UnsafeMutablePointer<KPlayerStruct>, volume: Float) {
        pthread_mutex_lock(&mp.pointee.mutex)
        ffp_set_playback_volume(mp.pointee.ffplayer, volume)
        pthread_mutex_unlock(&mp.pointee.mutex)
    }
    
    func getPropertyFloat(mp: UnsafeMutablePointer<KPlayerStruct>, id: Int32, defautlValue: Float) -> Float {
        pthread_mutex_lock(&mp.pointee.mutex)
        let ret = ffp_get_property_float(mp.pointee.ffplayer, id, defautlValue)
        pthread_mutex_unlock(&mp.pointee.mutex)
        return ret
    }
    
    func getPropertyInt64(mp: UnsafeMutablePointer<KPlayerStruct>, id: Int32, defautlValue: Int64) -> Int64 {
        pthread_mutex_lock(&mp.pointee.mutex)
        let ret = ffp_get_property_int64(mp.pointee.ffplayer, id, defautlValue)
        pthread_mutex_unlock(&mp.pointee.mutex)
        return ret
    }
    
    func getMeta(mp: UnsafeMutablePointer<KPlayerStruct>) -> UnsafeMutablePointer<IjkMediaMeta>? {
        return ffp_get_meta_l(mp.pointee.ffplayer)
    }

    func shutdown(mp: UnsafeMutablePointer<KPlayerStruct>) {
        if mp.pointee.ffplayer != nil {
            ffp_stop_l(mp.pointee.ffplayer)
            ffp_wait_stop_l(mp.pointee.ffplayer)
        }
    }
    
    @discardableResult func setDataSource(mp: UnsafeMutablePointer<KPlayerStruct>, url: String) -> Int32 {
        pthread_mutex_lock(&mp.pointee.mutex)
        var retval: Int32 = 0
        let mp_state = KPlayerState(rawValue: mp.pointee.mp_state)
        switch mp_state! {
        case .initialized: fallthrough
        case .asyncPreparing: fallthrough
        case .prepared: fallthrough
        case .started: fallthrough
        case .pause: fallthrough
        case .completed: fallthrough
        case .stopped: fallthrough
        case .error: fallthrough
        case .end:
            retval = EIJK_INVALID_STATE
        default:
            if mp.pointee.data_source != nil {
                free(&mp.pointee.data_source)
            }
            mp.pointee.data_source = strdup(url.cString(using: .utf8))
            if nil == mp.pointee.data_source {
                retval = EIJK_OUT_OF_MEMORY
            }
            changeState(mp: mp, state: .initialized)
        }
        pthread_mutex_unlock(&mp.pointee.mutex)
        return retval
    }
    
    @discardableResult func prepareAsync(mp: UnsafeMutablePointer<KPlayerStruct>) -> Int32 {
        pthread_mutex_lock(&mp.pointee.mutex)
        var retval: Int32 = 0
        let mp_state = KPlayerState(rawValue: mp.pointee.mp_state)
        switch mp_state! {
        case .idle: fallthrough
        case .asyncPreparing: fallthrough
        case .prepared: fallthrough
        case .started: fallthrough
        case .pause: fallthrough
        case .completed: fallthrough
        case .error: fallthrough
        case .end:
            retval = EIJK_INVALID_STATE
        default:
            changeState(mp: mp, state: .asyncPreparing)
            msg_queue_start(&mp.pointee.ffplayer!.pointee.msg_queue)
            OSAtomicAdd32Barrier(1, &mp.pointee.ref_count)
            let thread = withUnsafeMutablePointer(to: &mp.pointee._msg_thread) {UnsafeMutableRawPointer($0)}
            mp.pointee.msg_thread = SDL_CreateThreadEx(thread.assumingMemoryBound(to: SDL_Thread.self), mp.pointee.msg_loop, mp, "ff_msg_loop")
            retval = ffp_prepare_async_l(mp.pointee.ffplayer, mp.pointee.data_source)
            if retval < 0 {
                changeState(mp: mp, state: .error)
            }
        }
        pthread_mutex_unlock(&mp.pointee.mutex)
        return retval
    }
    
    @discardableResult func start(mp: UnsafeMutablePointer<KPlayerStruct>) -> Int32 {
        pthread_mutex_lock(&mp.pointee.mutex)
        let retval = checkState(state: mp.pointee.mp_state)
        if retval == 0 {
            ffp_remove_msg(mp.pointee.ffplayer, FFP_REQ_START)
            ffp_remove_msg(mp.pointee.ffplayer, FFP_REQ_PAUSE)
            ffp_notify_msg1(mp.pointee.ffplayer, FFP_REQ_START)
        }
        pthread_mutex_unlock(&mp.pointee.mutex)
        return retval
    }
    
    @discardableResult func pause(mp: UnsafeMutablePointer<KPlayerStruct>) -> Int32 {
        pthread_mutex_lock(&mp.pointee.mutex)
        let retval = checkState(state: mp.pointee.mp_state)
        if retval == 0 {
            ffp_remove_msg(mp.pointee.ffplayer, FFP_REQ_START)
            ffp_remove_msg(mp.pointee.ffplayer, FFP_REQ_PAUSE)
            ffp_notify_msg1(mp.pointee.ffplayer, FFP_REQ_PAUSE)
        }
        pthread_mutex_unlock(&mp.pointee.mutex)
        return retval
    }
    
    @discardableResult func stop(mp: UnsafeMutablePointer<KPlayerStruct>) -> Int32 {
        pthread_mutex_lock(&mp.pointee.mutex)
        var retval: Int32
        let mp_state = KPlayerState(rawValue: mp.pointee.mp_state)
        switch mp_state! {
        case .idle: fallthrough
        case .initialized: fallthrough
        case .asyncPreparing: fallthrough
        case .stopped: fallthrough
        case .error: fallthrough
        case .end:
            retval = EIJK_INVALID_STATE
        default:
            ffp_remove_msg(mp.pointee.ffplayer, FFP_REQ_START)
            ffp_remove_msg(mp.pointee.ffplayer, FFP_REQ_PAUSE)
            retval = ffp_stop_l(mp.pointee.ffplayer)
            if retval >= 0 {
                changeState(mp: mp, state: .stopped)
            }
        }
        pthread_mutex_unlock(&mp.pointee.mutex)
        
        return retval
    }
    
    @discardableResult func seekTo(mp: UnsafeMutablePointer<KPlayerStruct>, msec: Double) -> Int32 {
        pthread_mutex_lock(&mp.pointee.mutex)
        let retval = checkState(state: mp.pointee.mp_state)
        mp.pointee.seek_req = 1
        mp.pointee.seek_msec = Int(msec)
        ffp_remove_msg(mp.pointee.ffplayer, FFP_REQ_SEEK)
        ffp_notify_msg2(mp.pointee.ffplayer, FFP_REQ_SEEK, Int32(msec))
        pthread_mutex_unlock(&mp.pointee.mutex)
        
        return retval
    }
    
    func getDuration(mp: UnsafeMutablePointer<KPlayerStruct>) -> Double {
        pthread_mutex_lock(&mp.pointee.mutex)
        let retval = Double(ffp_get_duration_l(mp.pointee.ffplayer))
        pthread_mutex_unlock(&mp.pointee.mutex)
        return retval
    }
    
    func getPlayAbleDuration(mp: UnsafeMutablePointer<KPlayerStruct>) -> Int {
        pthread_mutex_lock(&mp.pointee.mutex)
        let retval = ffp_get_playable_duration_l(mp.pointee.ffplayer)
        pthread_mutex_unlock(&mp.pointee.mutex)
        return retval
    }
    
    func getCurrentPosition(mp: UnsafeMutablePointer<KPlayerStruct>) -> Double {
        pthread_mutex_lock(&mp.pointee.mutex)
        var retval: Double
        if mp.pointee.seek_req > 0 {
            retval = Double(mp.pointee.seek_msec)
        } else {
            retval = Double(ffp_get_current_position_l(mp.pointee.ffplayer))
        }
        pthread_mutex_unlock(&mp.pointee.mutex)
        return retval
    }
    
    func getState(mp: UnsafeMutablePointer<KPlayerStruct>) -> KPlayerState {
        return KPlayerState(rawValue: mp.pointee.mp_state)!
    }
    
    func getMsg(mp: UnsafeMutablePointer<KPlayerStruct>,
                msg: UnsafeMutablePointer<AVMessage>,
                block: Int) -> Int32 {
        while true {
            var continue_wait_next_msg = false
            var retval = msg_queue_get(&mp.pointee.ffplayer!.pointee.msg_queue, msg, Int32(block))
            if retval <= 0 {
                return retval
            }
            
            switch msg.pointee.what {
            case FFP_MSG_PREPARED:
                pthread_mutex_lock(&mp.pointee.mutex)
                if mp.pointee.mp_state == KPlayerState.asyncPreparing.rawValue {
                    changeState(mp: mp, state: .prepared)
                }
                if nil == mp.pointee.ffplayer?.pointee.start_on_prepared {
                    changeState(mp: mp, state: .pause)
                }
                pthread_mutex_unlock(&mp.pointee.mutex)
            
            case FFP_MSG_COMPLETED:
                pthread_mutex_lock(&mp.pointee.mutex)
                mp.pointee.restart = 1
                mp.pointee.restart_from_beginning = 1
                changeState(mp: mp, state: .completed)
                pthread_mutex_unlock(&mp.pointee.mutex)
                
            case FFP_MSG_SEEK_COMPLETE:
                pthread_mutex_lock(&mp.pointee.mutex)
                mp.pointee.seek_req = 0
                mp.pointee.seek_msec = 0
                pthread_mutex_unlock(&mp.pointee.mutex)
                
            case FFP_REQ_START:
                continue_wait_next_msg = true
                pthread_mutex_lock(&mp.pointee.mutex)
                if checkState(state: mp.pointee.mp_state) == 0 {
                    if mp.pointee.restart != 0 {
                        if  mp.pointee.restart_from_beginning != 0 {
                            retval = ffp_start_from_l(mp.pointee.ffplayer, 0)
                            if retval == 0 {
                                changeState(mp: mp, state: .started)
                            }
                        } else {
                            retval = ffp_start_l(mp.pointee.ffplayer)
                            if retval == 0 {
                                changeState(mp: mp, state: .started)
                            }
                        }
                        mp.pointee.restart = 0
                        mp.pointee.restart_from_beginning = 0
                    } else {
                        retval = ffp_start_l(mp.pointee.ffplayer)
                        if retval == 0 {
                            changeState(mp: mp, state: .started)
                        }
                    }
                }
                pthread_mutex_unlock(&mp.pointee.mutex)
                
            case FFP_REQ_PAUSE:
                continue_wait_next_msg = true
                pthread_mutex_lock(&mp.pointee.mutex)
                if checkState(state: mp.pointee.mp_state) == 0 {
                    if ffp_pause_l(mp.pointee.ffplayer) == 0 {
                        changeState(mp: mp, state: .pause)
                    }
                }
                pthread_mutex_unlock(&mp.pointee.mutex)
                
            case FFP_REQ_SEEK:
                continue_wait_next_msg = true
                pthread_mutex_lock(&mp.pointee.mutex)
                if checkState(state: mp.pointee.mp_state) == 0 {
                    mp.pointee.restart_from_beginning = 0
                    if ffp_seek_to_l(mp.pointee.ffplayer, Int(msg.pointee.arg1)) == 0 {
                        
                    }
                }
                pthread_mutex_unlock(&mp.pointee.mutex)
                
            default:
                break
            }
            
            if continue_wait_next_msg {
                msg_free_res(msg)
                continue
            }
            
            return retval
        }
    }
    
    func mediaPlayerCreate(msg_loop: @escaping @convention(c) (UnsafeMutableRawPointer?) -> Int32) ->  UnsafeMutablePointer<KPlayerStruct>! {
        let mp = create(msg_loop: msg_loop)
        repeat {
            mp!.pointee.ffplayer!.pointee.vout = SDL_VoutIos_CreateForGLES2()
            if nil == mp!.pointee.ffplayer!.pointee.vout {
                break
            }
            mp!.pointee.ffplayer!.pointee.pipeline = ffpipeline_create_from_ios(ffp: mp!.pointee.ffplayer)
            if nil == mp!.pointee.ffplayer!.pointee.pipeline {
                break
            }
            return mp
        } while nil != mp
        
        KPlayer.shared.dec_ref(mp: mp)
        return nil
    }
    
    func mediaPlayerSetGLView(mp: UnsafeMutablePointer<KPlayerStruct>, glView:IJKSDLGLView) {
        pthread_mutex_lock(&mp.pointee.mutex)
        SDL_VoutIos_SetGLView(mp.pointee.ffplayer!.pointee.vout, glView)
        pthread_mutex_unlock(&mp.pointee.mutex)
    }
    
    func destroy(mp: UnsafeMutablePointer<KPlayerStruct>?) {
        guard nil != mp else {
            return
        }
        
        ffp_destroy(mp!.pointee.ffplayer)
        if nil != mp!.pointee.msg_thread {
            SDL_WaitThread(mp!.pointee.msg_thread, nil)
        }
        pthread_mutex_destroy(&mp!.pointee.mutex)
        free(withUnsafeMutablePointer(to: &mp!.pointee.data_source!.pointee) {UnsafeMutableRawPointer($0)})
        free(mp!)
    }
}
