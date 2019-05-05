//
//  KMoviePlayVC.swift
//  Knight
//
//  Created by ChenZhiPeng on 2018/7/6.
//  Copyright © 2018 ChenZhiPeng. All rights reserved.
//

import UIKit

class KMoviePlayVC: UIViewController
{
    var path: URL!
    
    @IBOutlet var mediaControl: KMediaControl!
    
    var videoTitle: String?
    var player: KMediaPlaybackDelegate!
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.all]
    }
        
    init(url: URL, title: String) {
        super.init(nibName: "KMoviePlayVC", bundle: nil)
        path = url
        videoTitle = title
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func presntFromeVC(vc: UIViewController, title: String, url: URL, block: ActionBlock) {
        let item = KHistoryItem()
        item.title = title
        item.url = url
//        KHistoryModel.shared.add(item: item)
        vc.present(KMoviePlayVC(url: url, title: title), animated: true, completion: block)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var options = KFFOptions.optionsByDefault()
        player = KFFMoviePlayerController(url: path, options: &options)
        player.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        player.view.frame = view.frame
        player.scalingMode = .aspectFit
        player.shouldAutoPlay = true
        
        view.autoresizesSubviews = true
        view.addSubview(player.view)
        view.addSubview(mediaControl)
        
        mediaControl.delegate = player
        mediaControl.titleLabel.text = videoTitle
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        installMovieNotifObservers()
        
        player.prepareToplay()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        player.shutdown()
        removeMovieNotifObservers()
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
//MARK: - IBAction
    @IBAction func onClickMediaControl(_ sender: KMediaControl) {
        mediaControl.showAndFade()
    }
    
    @IBAction func onClickOverlay(_ sender: UIControl) {
        mediaControl.hide()
    }
    
    @IBAction func onClickPlay(_ sender: UIButton) {
        player.play()
        mediaControl.refreshMediaControl()
    }
    
    @IBAction func onClickPause(_ sender: UIButton) {
        player.pause()
        mediaControl.refreshMediaControl()
    }
    
    //MARK: slider func
    @IBAction func didSliderTouchCancel(_ sender: UISlider) {
        mediaControl.endDragMediaSlider()
    }
    
    @IBAction func didSliderTouchDown(_ sender: UISlider) {
        mediaControl.beginDragMediaSlider()
    }
    
    @IBAction func didSliderTouchupInside(_ sender: UISlider) {
        player.currentPlaybackTime = Double(mediaControl.mediaProgressSlider.value)
        mediaControl.endDragMediaSlider()
    }
    
    @IBAction func didSliderTouchupOutside(_ sender: Any) {
        mediaControl.endDragMediaSlider()
    }
    
    @IBAction func didSliderValueChanged(_ sender: UISlider) {
        mediaControl.continueDragMediaSlider()
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
//MARK: - Movie Notifications
    func installMovieNotifObservers() {
//        NotificationCenter.default.addObserver(self, selector: #selector(), name: Notification.Name(KMPMediaPlaybackIsPreparedToPlayDidChangeNotif), object: player)
//        NotificationCenter.default.addObserver(self, selector: #selector(loadStateDidChange), name: Notification.Name(KMPMoviePlayerLoadStateDidChangeNotif), object: player)
//        NotificationCenter.default.addObserver(self, selector: #selector(), name: Notification.Name(KMPMoviePlayerPlaybackDidFinishNotif), object: player)
//        NotificationCenter.default.addObserver(self, selector: #selector(), name: Notification.Name(KMPMoviePlayerPlaybackStateDidChangeNotif), object: player)
    }
    
    func removeMovieNotifObservers() {
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: KMPMediaPlaybackIsPreparedToPlayDidChangeNotif), object: player)
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: KMPMoviePlayerLoadStateDidChangeNotif), object: player)
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: KMPMoviePlayerPlaybackDidFinishNotif), object: player)
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: KMPMoviePlayerPlaybackStateDidChangeNotif), object: player)
    }
    
   @objc func loadStateDidChange(notif: Notification) {
        let loadState = player.loadState
        if (UInt8(loadState.rawValue) & UInt8(KMPMovieLoadState.playThroughOK.rawValue)) != 0 {
            
        } else if (UInt8(loadState.rawValue) & UInt8(KMPMovieLoadState.stalled.rawValue)) != 0 {
            
        } else {
            
        }
    }
}

