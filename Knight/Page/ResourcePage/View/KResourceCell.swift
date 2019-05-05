//
//  LHSearchPersonCell.swift
//  leihou
//
//  Created by 陈志鹏 on 2018/5/17.
//  Copyright © 2018 huajiao. All rights reserved.
//

import UIKit
import SDWebImage

class KResourceCell: KBaseCell
{
    var model: KResourceItem!
    
    lazy var avatarImg: UIImageView = {
        let img = UIImageView(frame: CGRect(x: 18, y: 15, width: 50, height: 50))
        img.layer.cornerRadius = img.height / 2
        img.layer.masksToBounds = true
        img.layer.borderColor = #colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9647058824, alpha: 1)
        img.layer.borderWidth = 1
        img.isUserInteractionEnabled = true
        return img
    }()
    
    lazy var nicknameLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 88,
                                          y: 18,
                                          width: cMainScreen.width - avatarImg.width - 100,
                                          height: 22))
        label.textColor = #colorLiteral(red: 0.1058823529, green: 0.05098039216, blue: 0.1294117647, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        
        return label
    }()
    
    lazy var introduceLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 88,
                                          y: 44,
                                          width: cMainScreen.width - avatarImg.width - 100,
                                          height: 18))
        label.textColor = #colorLiteral(red: 0.1058823529, green: 0.05098039216, blue: 0.1294117647, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        addSubview(avatarImg)
        addSubview(nicknameLabel)
        addSubview(introduceLabel)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(gotoWatch))
        addGestureRecognizer(tap)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        self.init(style: .default, reuseIdentifier: KResourceCell.identify())
    }
    
    func updateInfo(data: KResourceItem) {
        model = data
    
        avatarImg.sd_setImage(with: URL(string: data.avator), placeholderImage: nil, options: .retryFailed, completed: nil)
        nicknameLabel.text = data.nickname
        introduceLabel.text = data.introduce
    }
    
    class func cellHeight() -> CGFloat {
        return 80
    }
    
    @objc func gotoWatch() {
        rootNav!.present(KMoviePlayVC(url: URL(string: model.url)!, title: model.nickname), animated: true, completion: nil)
    }
    
//    @objc func btnAction(sender: UIButton) {
//        if sender == actBtn {
//            actBtn.isHidden = true
//            LHInterfaced.apiShared.followOther(userID: model.userID, success: { (result) in
//            }) { [weak self] (error) in
//                self?.actBtn.isHidden = false
//            }
//        }
//    }
}
