//
//  LHBaseVC.swift
//  leihou
//
//  Created by 陈志鹏 on 2018/5/4.
//  Copyright © 2018 huajiao. All rights reserved.
//

import UIKit

class KBaseVC: UIViewController
{
    @objc func tapErrorView() {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        if !(rootNav?.visibleViewController is KRootVC) {
            let leftBtn = UIButton(frame: CGRect(x:0, y: 0, width: 40, height: 40))
            leftBtn.imageEdgeInsets = UIEdgeInsets(top: 11, left: 0, bottom: 11, right: 22)
            leftBtn.setImage(UIImage(named: "back_nor"), for: .normal)
            leftBtn.addTarget(self, action: #selector(goback), for: .touchUpInside)
            
            let spaceL = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            if #available(iOS 11.0, *) {
                spaceL.width = 15
            } else {
                spaceL.width = 0
            }
            navigationItem.setLeftBarButtonItems([spaceL, UIBarButtonItem(customView: leftBtn)], animated: false)
        }

    }
    
    @objc func goback() {
        navigationController?.popViewController(animated: true)
    }
    
    class func gotoVC(vc: UIViewController, animated: Bool) {
        if nil != rootNav {
            rootNav!.pushViewController(vc, animated: true)
        }
    }
}
