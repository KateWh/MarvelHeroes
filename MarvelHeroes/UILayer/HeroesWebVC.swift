//
//  ViewController.swift
//  MarvelHeroes
//
//  Created by ket on 30.01.2019.
//  Copyright © 2019 ket. All rights reserved.
//

import UIKit
import WebKit

class HeroesWebVC: UIViewController {

    var heroLink: URL?
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var progressBar: UIProgressView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        // loading hero data
        webView.load(URLRequest(url: heroLink!))
        // set progress line to zero
        progressBar.progress = 0.0
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        print("-->", Float(webView.estimatedProgress))
        progressBar.setProgress(Float(webView.estimatedProgress), animated: true)
        progressBar.isHidden = webView.estimatedProgress == 1
    }

}

