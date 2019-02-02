//
//  ViewController.swift
//  MarvelHeroes
//
//  Created by ket on 30.01.2019.
//  Copyright © 2019 ket. All rights reserved.
//

import UIKit
import WebKit

class WebVC: UIViewController {

    @IBOutlet weak var webViewHero: WKWebView!
    @IBOutlet weak var progressViewHero: UIProgressView!
    var detailLink = URL(string: "")

    override func viewDidLoad() {
        super.viewDidLoad()
        webViewHero.load(URLRequest(url: detailLink!))
        webViewHero.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        progressViewHero.setProgress(Float(webViewHero.estimatedProgress), animated: true)
        progressViewHero.isHidden = webViewHero.estimatedProgress == 1

    }

}

