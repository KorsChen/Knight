//
//  KMediaControl.swift
//  Knight
//
//  Created by ChenZhiPeng on 2018/7/12.
//  Copyright © 2018 ChenZhiPeng. All rights reserved.
//

import UIKit

class KMediaControl: UIControl
{
    weak var delegate: KMediaPlaybackDelegate?
    
    var isMediaSliderBeginDragged = false
    
    @IBOutlet weak var overlayPanel: UIControl!
    
    @IBOutlet weak var bottomPanel: UIView!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var pauseBtn: UIButton!
    @IBOutlet weak var mediaProgressSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var totalDurationLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        refreshMediaControl()
    }
    
    func showNotFade() {
        overlayPanel.isHidden = false
        cancelDelayedHide()
        refreshMediaControl()
    }
    
    func showAndFade() {
        showNotFade()
        perform(#selector(hide), with: nil, afterDelay: 5)
    }
    
    @objc func hide() {
        overlayPanel.isHidden = true
        cancelDelayedHide()
    }
    
    func cancelDelayedHide() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(hide), object: nil)
    }
    
    func beginDragMediaSlider() {
        isMediaSliderBeginDragged = true
    }
    
    func endDragMediaSlider() {
        isMediaSliderBeginDragged = false
    }
    
    func continueDragMediaSlider() {
        refreshMediaControl()
    }
    
    @objc func refreshMediaControl() {
        //duration
        let duration = delegate == nil ? 0 : delegate!.duration
        let intDuration = duration + 0.5
        if intDuration > 0 {
            mediaProgressSlider.maximumValue = Float(duration)
            totalDurationLabel.text = String(format: "%02d:%02d", Int(intDuration / 60), Int(intDuration.truncatingRemainder(dividingBy: 60)))
        } else {
            totalDurationLabel.text = "--:--"
            mediaProgressSlider.maximumValue = 1.0
        }
        
        //position
        var position: TimeInterval
        if isMediaSliderBeginDragged {
            position = TimeInterval(mediaProgressSlider.value)
        } else {
            position = delegate == nil ? 0 : delegate!.currentPlaybackTime
        }
        let intPosition = position + 0.5
        if intDuration > 0 {
            mediaProgressSlider.value = Float(position)
        } else {
            mediaProgressSlider.value = 0.0
        }
        currentTimeLabel.text = String(format: "%02d:%02d", Int(intPosition / 60), Int(intPosition.truncatingRemainder(dividingBy: 60)))
        
        if let isPlaying = delegate?.isPlaying() {
            playBtn.isHidden = isPlaying
            pauseBtn.isHidden = !isPlaying
        }

        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(refreshMediaControl), object: nil)
        if !overlayPanel.isHidden {
            self.perform(#selector(refreshMediaControl), with: nil, afterDelay: 0.5)
        }
    }
}
