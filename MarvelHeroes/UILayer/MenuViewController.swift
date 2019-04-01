//
//  MenuViewController.swift
//  MarvelHeroes
//
//  Created by vit on 3/26/19.
//  Copyright © 2019 ket. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    var controller: UIViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //configureHeroesTableViewController()
    }
    
    func configureHeroesTableViewController() {
        controller = self.storyboard?.instantiateViewController(withIdentifier: "HeroesTVC")
        self.navigationController?.pushViewController(controller!, animated: true)
    }
    
    deinit {
        print("----> DEINIT MenuViewController")
    }
}
