//
//  LHNavigationController.swift
//  leihou
//
//  Created by 陈志鹏 on 2018/5/29.
//  Copyright © 2018 KorsChen. All rights reserved.
//

import UIKit

class KNavigationBar: UINavigationBar, UIBarPositioningDelegate
{
    override func layoutSubviews() {
        super.layoutSubviews()
        for view in subviews {
//            view.layoutMargins = .zero
            if [
                "_UINavigationBarBackground",
                "_UIBarBackground",
                "_UINavigationBarBackIndicatorView",
                "UINavigationItemButtonView"
                ].contains(String(describing: type(of: view))) {
                if #available(iOS 11.0, *) {
                    view.removeFromSuperview()
                } else {
                    view.isHidden = true
                }
            }
            if ["_UINavigationBarContentView"].contains(String(describing: type(of: view))) {
                for buttonView in view.subviews {
                    if ["_UIButtonBarButton"].contains(String(describing: type(of: buttonView))) {
                        for backView in buttonView.subviews {
                            if ["_UIBackButtonContainerView"].contains(String(describing: type(of: backView))) {
                                backView.removeFromSuperview()
                            }
                        }
                    }
                }
            }
        }
    }
}

class KNavigationController: UINavigationController, UINavigationBarDelegate, UIBarPositioningDelegate
{
    init() {
        super.init(navigationBarClass: KNavigationBar.self, toolbarClass: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override init(rootViewController: UIViewController) {
        super.init(navigationBarClass: KNavigationBar.self, toolbarClass: nil)
        
        self.viewControllers = [rootViewController]
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
        interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait]
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
}

extension KNavigationController: UIGestureRecognizerDelegate
{
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return children.count > 1
    }
}
