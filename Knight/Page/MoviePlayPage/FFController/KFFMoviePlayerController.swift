//
//  KFFMoviePlayerController.swift
//  Knight
//
//  Created by ChenZhiPeng on 2018/7/6.
//  Copyright © 2018 ChenZhiPeng. All rights reserved.
//

import Foundation
import AVFoundation

class KWeakHolder
{
    var object: Any?
}

class KFFMoviePlayerController: NSObject
{
    //MARK: - KMediaPlaybackDelegate property
    private var _view: UIView!
    var view: UIView {
        get {
             return _view
        }
        set {
            _view = newValue
        }
    }
    
    private var _currentPlaybackTime: TimeInterval!
    var currentPlaybackTime: TimeInterval {
        get {
            guard nil != mediaPlayer else {
                return 0.0
            }
            
            let ret = KPlayer.shared.getCurrentPosition(mp: mediaPlayer)
            if ret.isNaN || ret.isInfinite {
                return -1.0
            }
            
            return ret / 1000
        }
        
        set {
            guard nil != mediaPlayer else {
                return
            }
            
            seeking = true
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: KMPMoviePlayerPlaybackStateDidChangeNotif), object: nil)
            bufferingPosition = 0
            KPlayer.shared.seekTo(mp: mediaPlayer, msec: newValue * 1000)
        }
    }
    
    var duration: TimeInterval {
        get {
            guard nil != mediaPlayer else {
                return 0.0
            }
            
            let ret = KPlayer.shared.getDuration(mp: mediaPlayer)
            if ret.isNaN || ret.isInfinite {
                return -1
            }
            
            return ret / 1000
        }
    }
    
    var playableDuration: TimeInterval {
        get {
            guard nil != mediaPlayer else {
                return 0.0
            }
            
            var demux_cache = TimeInterval(KPlayer.shared.getPlayAbleDuration(mp: mediaPlayer)) / 1000
            
            let buf_fowards = asyncStatistic.buf_forwards
            let bit_rate = KPlayer.shared.getPropertyInt64(mp: mediaPlayer, id: FFP_PROP_INT64_BIT_RATE, defautlValue: 0)
            
            if buf_fowards > 0 && bit_rate > 0 {
                let io_cache = Double(buf_fowards * 8 / bit_rate)
                demux_cache += io_cache
            }
            
            return demux_cache
        }
    }
    
    var bufferingProgess: Double = 0.0
    var shouldAutoPlay = true

    private var _loadState: KMPMovieLoadState!
    var loadState: KMPMovieLoadState {
        get {
            return _loadState
        }
        set {
            _loadState = newValue
        }
    }

    
    private var _scalingMode: KMPMovieScalingMode!
    var scalingMode: KMPMovieScalingMode {
        get {
            return _scalingMode
        }
        set {
            switch newValue {
            case .none:
                view.contentMode = .center
            case .aspectFit:
                view.contentMode = .scaleAspectFit
            case .aspectFill:
                view.contentMode = .scaleAspectFill
            case .fill:
                view.contentMode = .scaleToFill
            }
            _scalingMode = newValue
        }
    }
    
    
    //MARK: - KFFMoviePlayerController property
    var urlString: String!
    
    var msgPool = KFFMoivePlayerMessagePool()
    
    var shouldShowHudView = false
    var pauseInBackground = false
    var seeking = false
    var playingBeforeInterruption = true
    var keepScreenOnWhilePlaying = true
    var isPreparedToPlay = false
    
    var mediaPlayer: UnsafeMutablePointer<KPlayerStruct>!
    
    var isSeekBuffering: Double = 0.0
    var bufferingPosition: Double = 0.0
    var bufferingTime: Double = 0.0
    var isAudioSync: Double = 0.0
    var isVideoSync: Double = 0.0
    
    var asyncStatistic: AVAppAsyncStatistic!
    
    var fpsInMeta: CGFloat = 0.0
    var fpsAtOutput: CGFloat = 0.0
    var naturalSize = CGSize(width: 0, height: 0)
    
    
    var videoWidth: Double = 0.0
    var videoHeight: Double = 0.0
    var sampleAspectRatioNumerator: Double = 0.0
    var sampleAspectRatioDenominator: Double = 0.0
    
    lazy var glview: IJKSDLGLView = {
        let gl = IJKSDLGLView(frame: UIScreen.main.bounds)
        gl?.isThirdGLView = false
        return gl!
    }()
    
    var playbackState: KMPMoviePlaybackState {
        get {
            if nil == mediaPlayer {
                return .stopped
            }
            var mpState = KMPMoviePlaybackState.stopped
            let state = KPlayer.shared.getState(mp: mediaPlayer)
            switch state {
            case .stopped, .completed, .error, .end:
                mpState = .stopped
            case .idle, .initialized, .asyncPreparing, .pause:
                mpState = .paused
            case .prepared, .started:
                mpState = seeking ? .seekingForward : .playing
            }
            return mpState
        }
    }
    
    var notifManager = KNotificationManager()
    
    private var _isVideoToolboxOpen: Bool = false
    var isVideoToolboxOpen: Bool {
        get {
            guard nil != mediaPlayer else {
                return false
            }
            return _isVideoToolboxOpen
        }
        set {
            _isVideoToolboxOpen = newValue
        }
    }
    
    var playbackRate: Float {
        get {
            guard nil != mediaPlayer else {
                return 0.0
            }
            return KPlayer.shared.getPropertyFloat(mp: mediaPlayer, id: FFP_PROP_FLOAT_PLAYBACK_RATE, defautlValue: 0.0)
        }
        set {
            guard nil != mediaPlayer else {
                return
            }
            
            return KPlayer.shared.setPlaybackRate(mp: mediaPlayer, rate: newValue)
        }
    }
    
    var playbackVolume: Float {
        get {
            guard nil != mediaPlayer else {
                return 0.0
            }
            return KPlayer.shared.getPropertyFloat(mp: mediaPlayer, id: FFP_PROP_FLOAT_PLAYBACK_VOLUME, defautlValue: 1.0)
        }
        set {
            guard nil != mediaPlayer else {
                return
            }
            return KPlayer.shared.setPlaybackVolume(mp: mediaPlayer, volume: newValue)
        }
    }
    
    
    
    //MARK: - KFFMoviePlayerController func
    convenience init(url: URL, options: inout KFFOptions) {
        let urlStr = url.isFileURL ? url.path : url.absoluteString
        self.init(urlStr: urlStr, options: &options)
    }
    
    init(urlStr: String, options: inout KFFOptions) {
        super.init()
        KPlayer.shared.globalInit()

        urlString = urlStr
        // init player
 
        mediaPlayer = KPlayer.shared.mediaPlayerCreate(msg_loop: media_player_msg_loop)
        
        let holder = KWeakHolder()
        holder.object = self
        
        KPlayer.shared.setWeakThiz(mp: mediaPlayer, weak_thiz: Unmanaged.passUnretained(self).toOpaque())
        KPlayer.shared.setInjectOpaque(mp: mediaPlayer, opaque: Unmanaged.passUnretained(holder).toOpaque())
        KPlayer.shared.setIOInjectOpaque(mp: mediaPlayer, opaque: Unmanaged.passUnretained(holder).toOpaque())
        KPlayer.shared.setOptionInit(mp: mediaPlayer, optCategory: .player, name: "start-on-prepared", value: shouldAutoPlay ? 1 : 0)
        
        view = glview
        
        KPlayer.shared.mediaPlayerSetGLView(mp: mediaPlayer, glView: glview)
        KPlayer.shared.setOption(mp: mediaPlayer, optCategory: .player, name: "overlay-format", value: "fcc-_es2")
        
        // init audio sink
        KAudioKit.shared.setupAudioSession()
        options.applyTo(mediaPlayer: mediaPlayer)
        
        setScreenOn(on: true)
        
        registerApplicationObservers()
    }

    func setScreenOn(on: Bool) {
        KMediaModule.shared.mediaModuleIdleTimerDisabled = on
    }
        
    @objc func audioSessionInterrupt(notif: Notification) {
        let reason = notif.userInfo![AVAudioSessionInterruptionTypeKey] as! UInt
        switch AVAudioSession.InterruptionType(rawValue: reason)! {
        case .began:
            switch playbackState {
            case .paused, .stopped:
                playingBeforeInterruption = false
            default:
                playingBeforeInterruption = true
                break
            }
            pause()
            KAudioKit.shared.setActive(active: false)
        case .ended:
            KAudioKit.shared.setActive(active: true)
            if playingBeforeInterruption {
                play()
            }
        }
    }
    
    func registerApplicationObservers() {
        notifManager.addObserver(observer: self, aSelector: #selector(audioSessionInterrupt(notif:)), aName: AVAudioSession.interruptionNotification)
        notifManager.addObserver(observer: self, aSelector: #selector(applicationWillEnterForeground), aName:UIApplication.willEnterForegroundNotification)
        notifManager.addObserver(observer: self, aSelector: #selector(applicationDidBecomeActive), aName: UIApplication.didBecomeActiveNotification)
        notifManager.addObserver(observer: self, aSelector: #selector(applicationWillResignActive), aName: UIApplication.willResignActiveNotification)
        notifManager.addObserver(observer: self, aSelector: #selector(applicationDidEnterBackground), aName: UIApplication.didEnterBackgroundNotification)
        notifManager.addObserver(observer: self, aSelector: #selector(applicationWillTerminate), aName: UIApplication.willTerminateNotification)
    }
    
    //MARK: Application State
    @objc func applicationWillEnterForeground() {
        
    }
    
    @objc func applicationDidBecomeActive() {
        
    }
    
    @objc func applicationWillResignActive() {
        DispatchQueue.main.async {
            if self.pauseInBackground {
                self.pause()
            }
        }
    }
    
    @objc func applicationDidEnterBackground() {
        DispatchQueue.main.async {
            if self.pauseInBackground {
                self.pause()
            }
        }
    }
    
    @objc func applicationWillTerminate() {
        DispatchQueue.main.async {
            if self.pauseInBackground {
                self.pause()
            }
        }
    }
    
    @objc func shutdownWaitStop() {
        guard nil != mediaPlayer else {
            return
        }
        
        KPlayer.shared.stop(mp: mediaPlayer)
        KPlayer.shared.shutdown(mp: mediaPlayer)
        performSelector(onMainThread: #selector(shutdownClose), with: self, waitUntilDone: true)
    }
    
    @objc func shutdownClose() {
        guard nil != mediaPlayer else {
            return
        }
        
        KPlayer.shared.setWeakThiz(mp: mediaPlayer, weak_thiz: nil)
        KPlayer.shared.setInjectOpaque(mp: mediaPlayer, opaque: nil)
        KPlayer.shared.setIOInjectOpaque(mp: mediaPlayer, opaque: nil)
        KPlayer.shared.destroy(mp: mediaPlayer)
    }
    
    @objc func postEvent(msg: KFFMoviePlayerMessage?) {
        guard nil != msg && nil != msg?.message else {
            return
        }
        
        let avmsg = msg?.message
        let arg1 = Double(avmsg!.arg1)
        let arg2 = Double(avmsg!.arg2)
        
        switch KFFP_Message_State(rawValue: Int(avmsg!.what))! {
        case .flush:
            break
        case .error:
            setScreenOn(on: false)
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: KMPMoviePlayerPlaybackStateDidChangeNotif), object: self)
            
            NotificationCenter.default.post(name: Notification.Name(KMPMoviePlayerPlaybackDidFinishNotif), object: self, userInfo: [
                    KMPMoviePlayerPlaybackDidFinishReasonUserInfoKey :  KMPMovieFinishReason.playbackError,
                    "error" : avmsg!.arg1
                ])
        
        case .prepared:
            let vdec = KPlayer.shared.getPropertyInt64(mp: mediaPlayer, id: 20003, defautlValue: KFFP_Propv_Decoder_Type.unknown.rawValue)
            switch KFFP_Propv_Decoder_Type(rawValue: vdec)! {
            case .videoToolBox:
                break
            case .avcodec:
                break
            default:
                break
            }
            
            let rawMeta = KPlayer.shared.getMeta(mp: mediaPlayer)
            if nil != rawMeta {
                ijkmeta_lock(rawMeta)
                
                var newMediaMeta = [String: AnyObject]()
                
                fillMetaInternal(meta: &newMediaMeta, rawMeta: rawMeta, name: "format", defaultValue: nil)
                fillMetaInternal(meta: &newMediaMeta, rawMeta: rawMeta, name: "duration_us", defaultValue: nil)
                fillMetaInternal(meta: &newMediaMeta, rawMeta: rawMeta, name: "start_us", defaultValue: nil)
                fillMetaInternal(meta: &newMediaMeta, rawMeta: rawMeta, name: "bitrate", defaultValue: nil)
                
                fillMetaInternal(meta: &newMediaMeta, rawMeta: rawMeta, name: "video", defaultValue: nil)
                fillMetaInternal(meta: &newMediaMeta, rawMeta: rawMeta, name: "audio", defaultValue: nil)
                
                let video_stream = ijkmeta_get_int64_l(rawMeta, "video", -1)
                let audio_stream = ijkmeta_get_int64_l(rawMeta, "audio", -1)
                
                var streams = [[String : AnyObject]]()
                let count = ijkmeta_get_children_count_l(rawMeta)
                for i in 0 ..< count {
                    let streamRawMeta = ijkmeta_get_child_l(rawMeta, i)
                    var streamMeta = [String : AnyObject]()
                    
                    fillMetaInternal(meta: &streamMeta, rawMeta: streamRawMeta, name: "type", defaultValue: "unknow")
                    let type = ijkmeta_get_string_l(streamRawMeta, "type")
                    if nil != type {
                        fillMetaInternal(meta: &streamMeta, rawMeta: streamRawMeta, name: "codec_name", defaultValue: nil)
                        fillMetaInternal(meta: &streamMeta, rawMeta: streamRawMeta, name: "codec_profile", defaultValue: nil)
                        fillMetaInternal(meta: &streamMeta, rawMeta: streamRawMeta, name: "codec_long_name", defaultValue: nil)
                        fillMetaInternal(meta: &streamMeta, rawMeta: streamRawMeta, name: "bitrate", defaultValue: nil)
                        
                        if 0 == strcmp(type, "video") {
                            fillMetaInternal(meta: &streamMeta, rawMeta: streamRawMeta, name: "width", defaultValue: nil)
                            fillMetaInternal(meta: &streamMeta, rawMeta: streamRawMeta, name: "height", defaultValue: nil)
                            fillMetaInternal(meta: &streamMeta, rawMeta: streamRawMeta, name: "fps_num", defaultValue: nil)
                            fillMetaInternal(meta: &streamMeta, rawMeta: streamRawMeta, name: "fps_den", defaultValue: nil)
                            fillMetaInternal(meta: &streamMeta, rawMeta: streamRawMeta, name: "tbr_num", defaultValue: nil)
                            fillMetaInternal(meta: &streamMeta, rawMeta: streamRawMeta, name: "tbr_den", defaultValue: nil)
                            fillMetaInternal(meta: &streamMeta, rawMeta: streamRawMeta, name: "sar_num", defaultValue: nil)
                            fillMetaInternal(meta: &streamMeta, rawMeta: streamRawMeta, name: "sar_den", defaultValue: nil)

                            if video_stream == i {
                                let fps_num = ijkmeta_get_int64_l(streamRawMeta, "fps_num", 0)
                                let fps_den = ijkmeta_get_int64_l(streamRawMeta, "fps_den", 0)
                                if fps_num > 0 && fps_den > 0 {
                                    fpsInMeta = CGFloat(fps_num / fps_den)
                                }
                            }
                        }
                    } else {
                        fillMetaInternal(meta: &streamMeta, rawMeta: streamRawMeta, name: "sample_rate", defaultValue: nil)
                        fillMetaInternal(meta: &streamMeta, rawMeta: streamRawMeta, name: "channel_layout", defaultValue: nil)
                        
                        if audio_stream == i {
                            
                        }
                    }
                    
                    streams.append(streamMeta)
                }
                
                newMediaMeta["streams"] = streams as AnyObject
                ijkmeta_unlock(rawMeta)
            }
            
            KPlayer.shared.setPlaybackRate(mp: mediaPlayer, rate: playbackRate)
            KPlayer.shared.setPlaybackVolume(mp: mediaPlayer, volume: playbackVolume)
            
            isPreparedToPlay = true
            
            NotificationCenter.default.post(name: Notification.Name(KMPMediaPlaybackIsPreparedToPlayDidChangeNotif), object: self)
            loadState = [.playAble, .playThroughOK]
            
            NotificationCenter.default.post(name: Notification.Name(KMPMoviePlayerLoadStateDidChangeNotif), object: self)
        
        case .completed:
            setScreenOn(on: false)
            NotificationCenter.default.post(name: Notification.Name(rawValue: KMPMoviePlayerLoadStateDidChangeNotif), object: self)
            NotificationCenter.default.post(name: Notification.Name(rawValue: KMPMoviePlayerPlaybackDidFinishNotif), object: self, userInfo: [
                KMPMoviePlayerPlaybackDidFinishReasonUserInfoKey : KMPMovieFinishReason.playbackEnded
                ])
        
        case .video_size_changed:
            if arg1 > 0 {
                videoWidth = arg1
            }
            if arg2 > 0 {
                videoHeight = arg2
            }
            changeNaturalSize()
            
        case .sar_changed:
            if arg1 > 0 {
                sampleAspectRatioNumerator = arg1
            }
            if arg2 > 0 {
                sampleAspectRatioDenominator = arg2
            }
            changeNaturalSize()
            
        case .buffering_start:
            loadState = .stalled
            isSeekBuffering = arg1
            NotificationCenter.default.post(name: NSNotification.Name(KMPMoviePlayerLoadStateDidChangeNotif), object: self)
            isSeekBuffering = 0
            
        case .buffering_end:
            loadState = [.playAble, .playThroughOK]
            isSeekBuffering = arg1
            NotificationCenter.default.post(name: Notification.Name(KMPMoviePlayerLoadStateDidChangeNotif), object: self)
            NotificationCenter.default.post(name: Notification.Name(KMPMoviePlayerPlaybackStateDidChangeNotif), object: self)
            isSeekBuffering = 0
            
        case .buffering_update:
            bufferingPosition = arg1
            bufferingProgess = arg2
            
        case .buffering_byte_update:
            break;
            
        case .buffering_time_update:
            bufferingTime = arg1
            
        case .playback_state_changed:
            NotificationCenter.default.post(name: Notification.Name(KMPMoviePlayerPlaybackStateDidChangeNotif), object: self)
    
        case .seek_complete:
            NotificationCenter.default.post(name: Notification.Name(KMPMoviePlayerDidSeekCompleteNotif), object: self, userInfo: [
                KMPMoivePlayerDidSeekCompleteTargetKey : arg1,
                KMPMoviePlayerDidSeekCompleteErrorKey : arg2
                ])
            seeking = false
            
        case .video_decoder_open:
            isVideoToolboxOpen = arg1 > 0
            NotificationCenter.default.post(name: NSNotification.Name(KMPMoviePlayerVideoDecoderOpenNotif), object: self)
            
        case .video_rendering_start:
            NotificationCenter.default.post(name: NSNotification.Name(KMPMoviePlayerFirstVideoFrameRenderedNotif), object: self)
            
        case .audio_rendering_start:
            NotificationCenter.default.post(name: NSNotification.Name(KMPMoviePlayerFirstAudioFrameRenderedNotif), object: self)

        case .video_decoded_start:
            NotificationCenter.default.post(name: NSNotification.Name(KMPMoviePlayerFirstVideoFrameDecodedNotif), object: self)

        case .audio_decoded_start:
            NotificationCenter.default.post(name: NSNotification.Name(KMPMoviePlayerFirstAudioFrameDecodedNotif), object: self)
        
        case .open_input:
            NotificationCenter.default.post(name: NSNotification.Name(KMPMoviePlayerOpenInputNotif), object: self)
        
        case .find_stream_info:
            NotificationCenter.default.post(name: NSNotification.Name(KMPMoviePlayerFindStreamInfoNotif), object: self)

        case .component_open:
            NotificationCenter.default.post(name: NSNotification.Name(KMPMoviePlayerComponentOpenNotif), object: self)

        case .accurate_seek_complete:
            NotificationCenter.default.post(name: Notification.Name(KMPMoviePlayerAccurateSeekCompleteNotif), object: self, userInfo: [
                KMPMoviePlayerAccurateSeekCompleteCurPos : arg1,
                ])

        case .video_seek_rendering_start:
            isVideoSync = arg1
            NotificationCenter.default.post(name: NSNotification.Name(KMPMoviePlayerSeekVideoStartNotif), object: self)
            isVideoSync = 0
            
        case .audio_seek_rendering_start:
            isAudioSync = arg1
            NotificationCenter.default.post(name: NSNotification.Name(KMPMoviePlayerSeekAudioStartNotif), object: self)
            isAudioSync = 0
            
        default:
            break
        }
        msgPool.recycle(msg: msg)
    }
    
    let media_player_msg_loop: @convention(c) (UnsafeMutableRawPointer?) -> Int32 = { arg in
        let mp: UnsafeMutablePointer<KPlayerStruct>? = arg!.assumingMemoryBound(to: KPlayerStruct.self)
        guard let point = KPlayer.shared.setWeakThiz(mp: mp!, weak_thiz: nil) else {
            return 0
        }
//        ff_msg_loop (17): EXC_BAD_ACCESS (code=1, address=0x6c5f67736d5f6666)
        var ffpController: KFFMoviePlayerController? = Unmanaged<KFFMoviePlayerController>.fromOpaque(point).takeUnretainedValue()
        while nil != ffpController {
            let msg = ffpController!.msgPool.obtain()
            let message =  withUnsafeMutablePointer(to: &msg!.message) {UnsafeMutableRawPointer($0)}
            let retval = KPlayer.shared.getMsg(mp: mp!, msg: message.assumingMemoryBound(to: AVMessage.self), block: 1)
            if retval < 0 {
                break
            }
            ffpController?.performSelector(onMainThread: #selector(postEvent(msg:)), with: msg, waitUntilDone: false)
        }
//        KPlayer.shared.dec_ref(mp: mp!)
        return 0
    }

    //MARK: - av_format_control_message
//    let onInjectIOControl: @convention(c) (KFFMoviePlayerController, Any, Int, UnsafeMutableRawPointer?, size_t)  -> Int32 = {
//        mpc, delegate, type, data, data_size in
//        guard let realData = data?.load(as: AVAppTcpIOControl.self) else {
//            return 0
//        }
//        switch KMediaEvent(rawValue: type)! {
//        case .ctrl_willTcpOpen:
//            break
//        case .ctrl_didTcpOpen:
//            break
//        default:
//            break
//        }
//
//        if nil == data {
//            return 0
//        }
//
//        let urlStr = "string\(realData.ip)"
//        let openData = KMediaUrlOpenData(urlStr: urlStr, mediaEvent: KMediaEvent(rawValue: type)!, segment: 0, retryCount: 0)
//        openData.fd = Int(realData.fd)
//
//        return 0
//    }
//
//    let onInjectAsyncStatistic: @convention(c) (KFFMoviePlayerController, Int, UnsafeMutableRawPointer?, size_t) -> Int32 = {
//        mpc, type, data, data_size in
//        let realData = data?.load(as: AVAppAsyncStatistic.self)
//        mpc.asyncStatistic = realData
//        return 0
//    }
//
//    let onInectIJKIOStatistic: @convention(c) (KFFMoviePlayerController, Int, UnsafeMutableRawPointer?, size_t) -> Int32 = {
//        mpc, type, data, data_size in
//        let realData = data?.load(as: IjkIOAppCacheStatistic.self)
//        return 0
//    }
//
//    let onInjectOnHttpEvent: @convention(c) (KFFMoviePlayerController, Int, UnsafeMutableRawPointer?, size_t) -> Int32 = {
//        mpc, type, data, data_size in
//        let realData = data!.load(as: AVAppHttpEvent.self)
//
//        return 0
//    }
//
//    let ijkff: @convention(c) (UnsafeMutableRawPointer?, Int, UnsafeMutableRawPointer?, size_t) -> Int32 = {
//        opaque, message, data, data_size in
//        let weakHolder: KWeakHolder = Unmanaged<KWeakHolder>.fromOpaque(opaque!).takeUnretainedValue()
//        if let mpc = weakHolder.object as? KFFMoviePlayerController {
//
//        }
//
//        return 0
//    }
    
    func fillMetaInternal(meta: inout [String : AnyObject],
                          rawMeta: UnsafeMutablePointer<IjkMediaMeta>?,
                          name: String?,
                          defaultValue: String?) {
        guard nil == rawMeta || nil == name else {
            return
        }
        let value = ijkmeta_get_string_l(rawMeta, name!)
        if nil != value {
            meta[name!] = String(cString: value!) as AnyObject
        } else if nil != defaultValue {
            meta[name!] = defaultValue as AnyObject
        } else {
            meta.removeValue(forKey: name!)
        }
    }
    
    func changeNaturalSize() {
        willChangeValue(forKey: "naturalSize")
        if sampleAspectRatioNumerator > 0, sampleAspectRatioDenominator > 0 {
            naturalSize = CGSize(width: 1.0 * videoWidth * sampleAspectRatioNumerator / sampleAspectRatioDenominator, height: videoHeight)
        } else {
            naturalSize = CGSize(width: videoWidth, height: videoHeight)
        }
        didChangeValue(forKey: "naturalSize")
        
        if naturalSize.width > 0, naturalSize.height > 0 {
            NotificationCenter.default.post(name: NSNotification.Name(KMPMovieNaturalSizeAvailableNotif), object: self)
        }
    }
}

extension KFFMoviePlayerController: KMediaPlaybackDelegate
{
    //MARK: - KMediaPlaybackDelegate func
    func prepareToplay() {
        guard nil != mediaPlayer else {
            return
        }
        setScreenOn(on: keepScreenOnWhilePlaying)
        KPlayer.shared.setDataSource(mp: mediaPlayer, url: urlString)
        KPlayer.shared.setOption(mp: mediaPlayer, optCategory: .format, name: "safe", value: "0")
        KPlayer.shared.prepareAsync(mp: mediaPlayer)
    }
    
    func play() {
        guard nil != mediaPlayer else {
            return
        }
        setScreenOn(on: keepScreenOnWhilePlaying)
        KPlayer.shared.start(mp: mediaPlayer)
    }
    
    func pause() {
        guard nil != mediaPlayer else {
            return
        }
        KPlayer.shared.pause(mp: mediaPlayer)
    }
    
    func stop() {
        guard nil != mediaPlayer else {
            return
        }
        setScreenOn(on: false)
        KPlayer.shared.stop(mp: mediaPlayer)
    }
    
    func isPlaying() -> Bool {
        guard nil != mediaPlayer else {
            return false
        }
        return KPlayer.shared.isPlaying(mp: mediaPlayer)
    }
    
    func shutdown() {
        guard nil != mediaPlayer else {
            return
        }
        notifManager.removeAllObservers(observer: self)
        setScreenOn(on: false)
        
        performSelector(inBackground: #selector(shutdownWaitStop), with: self)
    }
    
    func setPauseInBackground(pause: Bool) {
        pauseInBackground = pause
    }
}
