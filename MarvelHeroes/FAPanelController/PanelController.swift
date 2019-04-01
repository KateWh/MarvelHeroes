//
//  FAPanelController.swift
//  MarvelHeroes
//
//  Created by vit on 3/29/19.
//  Copyright © 2019 ket. All rights reserved.
//

import UIKit
import FAPanels

class PanelController: FAPanelController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let leftMenuVC: LeftMenuVC = mainStoryboard.instantiateViewController(withIdentifier: "LeftMenuVC") as! LeftMenuVC
        let centerVC: HeroesTableViewController = mainStoryboard.instantiateViewController(withIdentifier: "HeroesTVC") as! HeroesTableViewController
        let centerNavVC = UINavigationController(rootViewController: centerVC)
        
        _ = self.center(centerNavVC).left(leftMenuVC)
        
    }
    
}
