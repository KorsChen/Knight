//
//  KRootVC.swift
//  Knight
//
//  Created by ChenZhiPeng on 2018/7/5.
//  Copyright © 2018 ChenZhiPeng. All rights reserved.
//

import UIKit
import MobileCoreServices
import Lottie

class KRootVC: KBaseVC
{
    lazy var tableView: UITableView = {
        let table = UITableView(frame: CGRect(x: 0, y: cWidgetHeight.topBar + 30, width: view.width, height: view.height - cWidgetHeight.topBar - 20))
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.isScrollEnabled = false
        return table
    }()
    
    lazy var titleArray: [String] = {
        let array = [
            "本地文件",
            "相册影音",
            "链接播放",
            "ASMR"
        ]
        return array
    }()
    
    lazy var animationViewArray = [AnimationView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "发现"
        view.addSubview(tableView)
        view.backgroundColor = UIColor.white
        
        setupAnimation()

        var fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        do {
            var resourceValues = URLResourceValues()
            resourceValues.isExcludedFromBackup = true
            try fileURL.setResourceValues(resourceValues)
        } catch { print("failed to set resource value") }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        playAnimation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        stopAnimation()
    }
 
    func setupAnimation() {
        setupAnimation(name: "funky_chicken",
                       superView: tableView,
                       frame: CGRect(x: (tableView.width - 130)/2, y: tableView.height - 135, width: 130, height: 130))
        setupAnimation(name: "hiragana_a",
                       superView: tableView,
                       frame: CGRect(x: tableView.width - 80, y: tableView.height - 100, width: 70, height: 70))
        setupAnimation(name: "airplane_flying",
                       superView: tableView,
                       frame: CGRect(x: 10, y: 150, width: 70, height: 70))
        setupAnimation(name: "rabbit",
                       superView: view,
                       frame: CGRect(x: (tableView.width - 70)/2, y: cWidgetHeight.navBar, width: 70, height: 70))
        setupAnimation(name: "jumping_banano",
                       superView: tableView,
                       frame: CGRect(x: 5, y: tableView.height - 150, width: 80, height: 80))
        setupAnimation(name: "happy_tree",
                       superView: tableView,
                       frame: CGRect(x: tableView.width - 80, y: 50, width: 70, height: 70))
        
        NotificationCenter.default.addObserver(self, selector: #selector(playAnimation), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func playAnimation() {
        for view in animationViewArray {
            if !view.isAnimationPlaying {
                view.play()
            }
        }
    }
    
    @objc func stopAnimation() {
        for view in animationViewArray {
            if view.isAnimationPlaying {
                view.stop()
            }
        }
    }
    
    func setupAnimation(name: String, superView: UIView, frame: CGRect) {
        let view = AnimationView(name: name)
        view.frame = frame
        view.stop()
        animationViewArray.append(view)
        superView.addSubview(view)
    }
}

extension KRootVC: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "play")
        if nil == cell {
            cell = UITableViewCell(style: .default, reuseIdentifier: "play")
        }
        cell?.selectionStyle = .none
//        cell!.textLabel?.text = titleArray[indexPath.row]
        let btn = UIButton(frame: CGRect(x: (view.width - 200) / 2, y: 20, width: 200, height: 40))
        btn.setAttributedTitle(NSAttributedString(string: titleArray[indexPath.row], attributes: [
            NSAttributedString.Key.foregroundColor : UIColor.black,
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)
            ]), for: .normal)
        btn.backgroundColor = UIColor.yellow
        btn.layer.cornerRadius = btn.height / 2
        btn.layer.masksToBounds = true
        btn.tag = indexPath.row
        btn.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        cell?.addSubview(btn)
        cell?.textLabel?.textAlignment = .center
        return cell!
    }
    
    @objc func btnAction(sender: UIButton) {
        switch sender.tag {
        case 0:
            navigationController?.pushViewController(KLocalFolderVC(), animated: true)
            
        case 1:
            startMediaBrowserFromViewController()
            
        case 2:
            navigationController?.pushViewController(KInputURLVC(), animated: true)
            
        case 3:
            navigationController?.pushViewController(KResourceVC(), animated: true)
        default:
            break
        }
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }    
}

extension KRootVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let mediaType = info[.mediaType] as! String
        if mediaType == kUTTypeMovie as String {
            if let url = info[.mediaURL] as? URL {
                dismiss(animated: true) { [weak self] in
                    self?.navigationController?.present(KMoviePlayVC(url: url, title: ""), animated: true, completion: nil)
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func startMediaBrowserFromViewController() {
        if !UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            return
        }
        
        let mediaUI = UIImagePickerController()
        mediaUI.sourceType = .savedPhotosAlbum
        mediaUI.mediaTypes = [kUTTypeMovie as String]
        mediaUI.allowsEditing = false
        mediaUI.delegate = self
        
        present(mediaUI, animated: true, completion: nil)
    }
}
