//
//  ContainerViewController.swift
//  MarvelHeroes
//
//  Created by vit on 3/26/19.
//  Copyright © 2019 ket. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {

    var controller: UIViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        //configureHeroesTableViewController()
    }

    func configureHeroesTableViewController() {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "HeroesTVC")
        self.navigationController?.pushViewController(controller!, animated: false)
    }

    func configureMenuViewController() {
        
    }
}
