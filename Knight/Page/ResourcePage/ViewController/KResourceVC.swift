//
//  LHMyFriendVC.swift
//  leihou
//
//  Created by 陈志鹏 on 2018/5/17.
//  Copyright © 2018 KorsChen. All rights reserved.
//

import UIKit
import Toast_Swift

class KResourceVC: KBaseVC
{
    let segmentH: CGFloat = 30
    lazy var segmentOirginY: CGFloat = cWidgetHeight.topBar + segmentH
    
    lazy var model = KResourceModel()
    
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView(frame: CGRect(x: 0,
                                                y: segmentOirginY,
                                                width: cMainScreen.width,
                                                height: cMainScreen.height - segmentOirginY))
        scroll.contentSize = CGSize(width: cMainScreen.width * 3, height:cMainScreen.height - segmentOirginY)
        scroll.showsHorizontalScrollIndicator = false
        scroll.bounces = false
        scroll.isPagingEnabled = true
        scroll.addSubview(videoTable)
        scroll.addSubview(chinaTable)
        scroll.addSubview(foreignTable)
        scroll.delegate = self
        return scroll
    }()
    
    lazy var videoTable: UITableView = {
        let table = UITableView(frame: CGRect(x: 0, y: 0, width: cMainScreen.width, height: cMainScreen.height - segmentOirginY))
        table.separatorStyle = .none
        table.delegate = self
        table.dataSource = self
        table.bounces = false
        return table
    }()
    
    lazy var chinaTable: UITableView = {
        let table = UITableView(frame: CGRect(x: videoTable.right, y: 0, width: cMainScreen.width, height: cMainScreen.height - segmentOirginY))
        table.separatorStyle = .none
        table.delegate = self
        table.dataSource = self
        table.bounces = false
        return table
    }()
    
    lazy var foreignTable: UITableView = {
        let table = UITableView(frame: CGRect(x: chinaTable.right, y: 0, width: cMainScreen.width, height: cMainScreen.height - segmentOirginY))
        table.separatorStyle = .none
        table.delegate = self
        table.dataSource = self
        table.bounces = false
        return table
    }()
    
    lazy var segmentView: KCustomSegmentView = {
        let view = KCustomSegmentView(titleArray: ["视频","中文","海外"],
                                       titleColor: normalTextColor,
                                       titleSelectedColor: normalTextColor,
                                       titleFont: UIFont.systemFont(ofSize: 16, weight: .light),
                                       titleSelectedFont: UIFont.systemFont(ofSize: 16, weight: .semibold),
                                       sliderColor: #colorLiteral(red: 1, green: 0.9333333333, blue: 0.07058823529, alpha: 1),
                                       defaultIndex: 0,
                                       frame: CGRect(x: 0, y: cWidgetHeight.topBar, width: cMainScreen.width, height: 30),
                                       action: { [weak self] (index) in
                                        self?.scrollView.contentOffset = CGPoint(x: (self?.scrollView.width)! * CGFloat(index), y: 0)
        })
        return view
    }()
    
    override func viewDidLoad() {
        title = "ASMR"
        view.addSubview(segmentView)
        view.addSubview(scrollView)
        
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension KResourceVC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case videoTable:
            return model.videoArray.count
        case chinaTable:
            return model.chinaArray.count
        case foreignTable:
            return model.foreignArray.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return KResourceCell.cellHeight()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case videoTable:
            var cell = tableView.dequeueReusableCell(withIdentifier: KResourceCell.identify()) as? KResourceCell
            if nil == cell {
                cell = KResourceCell(style: .default, reuseIdentifier: KResourceCell.identify())
            }
            if model.videoArray.count > indexPath.row {
                cell!.updateInfo(data: model.videoArray[indexPath.row])
            }
            return cell!
        case chinaTable:
            var cell = tableView.dequeueReusableCell(withIdentifier: KResourceCell.identify()) as? KResourceCell
            if nil == cell {
                cell = KResourceCell(style: .default, reuseIdentifier: KResourceCell.identify())
            }
            if model.chinaArray.count > indexPath.row {
                cell!.updateInfo(data: model.chinaArray[indexPath.row])
            }
            return cell!
        case foreignTable:
            var cell = tableView.dequeueReusableCell(withIdentifier: KResourceCell.identify()) as? KResourceCell
            if nil == cell {
                cell = KResourceCell(style: .default, reuseIdentifier: KResourceCell.identify())
            }
            if model.foreignArray.count > indexPath.row {
                cell!.updateInfo(data: model.foreignArray[indexPath.row])
            }
            return cell!
        default:
            return UITableViewCell()
        }
    }
}

extension KResourceVC: UIScrollViewDelegate
{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == videoTable || scrollView == chinaTable || scrollView == foreignTable {
            return
        }
        let index = Int(scrollView.contentOffset.x / scrollView.width)
        if segmentView.btnArray.count > index {
            segmentView.btnAction(sender: segmentView.btnArray[index])
        }
    }
}
