//
//  CreatorsWebVC.swift
//  MarvelHeroes
//
//  Created by vit on 3/8/19.
//  Copyright © 2019 ket. All rights reserved.
//

import UIKit
import WebKit

class CreatorsWebVC: UIViewController {

    var creatorLink: URL?
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var progressBar: UIProgressView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.tintColor = #colorLiteral(red: 0.1126269036, green: 0.07627656838, blue: 0.01553396923, alpha: 1)
        // load creator data
        webView.load(URLRequest(url: creatorLink!))
        // set progress line to zero
        progressBar.progress = 0
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        print("-->", Float(webView.estimatedProgress))
        progressBar.setProgress(Float(webView.estimatedProgress), animated: true)
        progressBar.isHidden = webView.estimatedProgress == 1
    }
    

}
