//
//  KInputURLVC.swift
//  Knight
//
//  Created by 陈志鹏 on 2018/7/25.
//  Copyright © 2018 ChenZhiPeng. All rights reserved.
//

import UIKit

class KInputURLVC: KBaseVC
{
    lazy var textView: UITextView = {
        let v = UITextView(frame: CGRect(x: 5, y: cWidgetHeight.topBar, width: view.width - 10, height: view.height - cWidgetHeight.topBar))
        v.delegate = self
        v.becomeFirstResponder()
        v.text = "http://wm.video.huajiao.com/vod-wm-huajiao-bj/142629060_4-1532008851-c3a52740-2b9e-fad7.mp4"
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(textView)
        
        setupNavbar()
        
        title = "请输入地址"
    }
    
    func setupNavbar() {
        let rightBtn = UIButton(frame: CGRect(x:0, y: 0, width: 44, height: 44))
        rightBtn.setAttributedTitle(NSAttributedString(string: "播放", attributes: [
            .font : UIFont.systemFont(ofSize: 15),
            .foregroundColor : #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            ]),
                                    for: .normal)
        rightBtn.addTarget(self, action: #selector(clickPlayBtn), for: .touchUpInside)
        
        let spaceR = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        if #available(iOS 11.0, *) {
            spaceR.width = 15
        } else {
            spaceR.width = -10
        }
        navigationItem.setRightBarButtonItems([spaceR, UIBarButtonItem(customView: rightBtn)], animated: true)
    }
    
    @objc func clickPlayBtn() {
        guard textView.text.count > 0 else {
            return
        }
        let url = URL(string: textView.text)!
        
        if let scheme = url.scheme?.lowercased(), scheme == "http" || scheme == "https" || scheme == "rtmp" {
            KMoviePlayVC.presntFromeVC(vc: self, title: "", url: url) {
                
            }
        }
    }
}

extension KInputURLVC: UITextViewDelegate
{
    func textViewDidEndEditing(_ textView: UITextView) {
        
    }
}
