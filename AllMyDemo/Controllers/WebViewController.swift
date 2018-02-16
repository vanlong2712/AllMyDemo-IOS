//
//  WebViewController.swift
//  AllMyDemo
//
//  Created by Long on 2/15/18.
//  Copyright © 2018 Long Dang. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

class WebViewController: UIViewController, WKUIDelegate{

    @IBOutlet weak var webView: WKWebView!
    
    var link: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()
        let myURL = URL(string: link)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }

    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        SVProgressHUD.dismiss()
    }
}
