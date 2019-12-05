//
//  LHWebVC.swift
//  leihou
//
//  Created by 陈志鹏 on 6/11/18.
//  Copyright © 2018 KorsChen. All rights reserved.
//

import UIKit
import WebKit

class KWebVC: KBaseVC
{
    var url: String!
    
    lazy var webView: WKWebView = {
        let v = WKWebView(frame: CGRect(x: 0, y: cWidgetHeight.topBar, width: view.width, height: view.height - cWidgetHeight.topBar))
        automaticallyAdjustsScrollViewInsets = false
        v.load(URLRequest(url: URL(string: url)!))
        v.navigationDelegate = self
        return v
    }()
    
    convenience init(webUrl: String, titleStr: String) {
        self.init(nibName: nil, bundle: nil)
        url = webUrl
        title = titleStr
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }

}

extension KWebVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.scrollView.isScrollEnabled = true
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
    }
}
