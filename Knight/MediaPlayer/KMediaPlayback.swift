//
//  KMediaPlayback.swift
//  Knight
//
//  Created by ChenZhiPeng on 2018/7/12.
//  Copyright © 2018 ChenZhiPeng. All rights reserved.
//

import Foundation

enum KMPMovieScalingMode: Int {
    case none, aspectFit, aspectFill, fill
}

enum KMPMoviePlaybackState: Int {
    case stopped, playing, paused, interrupted, seekingForward, seekingBackward
}

struct KMPMovieLoadState: OptionSet {
    let rawValue: UInt
    static let unknown = KMPMovieLoadState(rawValue: 0)
    static let playAble = KMPMovieLoadState(rawValue: 1 << 0)
    // Playback will be automatically started in this state when shouldAutoplay is YES
    static let playThroughOK = KMPMovieLoadState(rawValue: 1 << 1)
    // Playback will be automatically paused in this state, if started
    static let stalled = KMPMovieLoadState(rawValue: 1 << 2)
}

enum KMPMovieFinishReason {
    case playbackEnded, playbackError, userExited
}

let KMPMediaPlaybackIsPreparedToPlayDidChangeNotif = "com.mediaPlayer.playback.preparedPlay.change.notif"

let KMPMoviePlayerPlaybackStateDidChangeNotif = "com.meidaPlayer.movie.playback.state.change.notif"
let KMPMoviePlayerLoadStateDidChangeNotif = "com.mediaPlayer.movie.load.state.change.notif"
let KMPMoviePlayerPlaybackDidFinishNotif = "com.mediaPlayer.movie.finish.notif"

let KMPMoviePlayerPlaybackDidFinishReasonUserInfoKey = "com.mediaPlayer.movie.finish.reason.userinfo"
let KMPMovieNaturalSizeAvailableNotif = "com.mediaPlayer.natural.size.available.notif"

let KMPMoviePlayerDidSeekCompleteNotif = "com.mediaPlayer.movie.seek.complete.notif"
let KMPMoivePlayerDidSeekCompleteTargetKey = "com.mediaPlayer.movie.seek.complete.targetKey"
let KMPMoviePlayerDidSeekCompleteErrorKey = "com.mediaPlayer.movie.seek.compltet.errorKey"
let KMPMoviePlayerAccurateSeekCompleteNotif = "com.mediaPlayer.movie.accurate.seek.complete.notif"
let KMPMoviePlayerAccurateSeekCompleteCurPos = "com.mediaPlayer.movie.accurate.seek.complete.curPos"


// MARK: - video deal notif
let KMPMoviePlayerVideoDecoderOpenNotif = "com.mediaPlayer.moive.video.decoder.open.notif"
let KMPMoviePlayerFirstVideoFrameDecodedNotif = "com.mediaPlayer.movie.first.video.frame.decoded.notif"
let KMPMoviePlayerFirstVideoFrameRenderedNotif = "com.mediaPlayer.movie.first.video.frame.rendered.notif"
let KMPMoviePlayerSeekVideoStartNotif = "com.mediaPlayer.movie.seek.video.start.notif"

// MARK: - audio deal notif
let KMPMoviePlayerFirstAudioFrameRenderedNotif = "com.mediaPlayer.movie.first.audio.frame.rendered.notif"
let KMPMoviePlayerFirstAudioFrameDecodedNotif = "com.mediaPlayer.movie.first.audio.frame.decoded.notif"
let KMPMoviePlayerSeekAudioStartNotif = "com.mediaPlayer.movie.seek.Audio.start.notif"


let KMPMoviePlayerOpenInputNotif = "com.mediaPlayer.movie.open.input.notif"
let KMPMoviePlayerFindStreamInfoNotif = "com.meidaPlayer.movie.find.stream.info.notif"
let KMPMoviePlayerComponentOpenNotif = "com.meidaPlayer.movie.component.open.notif"

protocol KMediaPlaybackDelegate: class {
    
    var view: UIView { get }
    var currentPlaybackTime: TimeInterval { get set }
    var duration: TimeInterval { get }
    var playableDuration: TimeInterval { get }
    var naturalSize: CGSize { get }
    
    var shouldAutoPlay: Bool { get set }
    var isPreparedToPlay: Bool { get }
    
    var isSeekBuffering: Double  { get }
    var bufferingProgess: Double { get }
    var isAudioSync: Double { get }
    var isVideoSync: Double { get }
    
    var playbackVolume: Float { get set }
    var playbackRate: Float { get set }
    
    var loadState: KMPMovieLoadState { get set }
    var scalingMode: KMPMovieScalingMode { get set }
    var playbackState: KMPMoviePlaybackState { get }
    
    func prepareToplay()
    func play()
    func pause()
    func stop()
    func isPlaying() -> Bool
    func shutdown()
    func setPauseInBackground(pause: Bool)
}

enum KMediaEvent: Int {
    case willHttpOpen = 1,
    didHttpOpen = 2,
    willHttpSeek = 3,
    didHttpSeek = 4,
    
    ctrl_willTcpOpen = 0x20001,
    ctrl_didTcpOpen = 0x20002,
    ctrl_willHttpOpen = 0x20003,
    ctrl_willLiveOpen = 0x20005,
    ctrl_willConcatSegmenmtOpen = 0x20007
}

class KMediaUrlOpenData
{
    var event: KMediaEvent!
    
    var _url: String!
    var url: String {
        get {
            return _url
        }
        set {
            isHandle = true
            if url != newValue {
                isUrlChanged = true
                _url = newValue
            }
        }
    }
    
    var segmentIndex = 0
    var retryCounter = 0
    var error = 0
    var fd = 0
    
    var isHandle = false
    var isUrlChanged = false
    
    init(urlStr: String, mediaEvent: KMediaEvent, segment: Int, retryCount: Int) {
        url = urlStr
        event = mediaEvent
        segmentIndex = segment
        retryCounter = retryCount
    }
}

protocol KMediaUrlOpenDelegate: NSObjectProtocol {
    func willOpenUrl(urlOpenData: KMediaUrlOpenData)
}

protocol KMediaNativeInvokeDelegate: class {
    func invoke(event: KMediaEvent, attributes: [String : Any])
}
