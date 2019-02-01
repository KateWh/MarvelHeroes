//
//  PrototypeHero.swift
//  MarvelHeroes
//
//  Created by ket on 30.01.2019.
//  Copyright © 2019 ket. All rights reserved.
//

import Foundation
import UIKit

class PrototypeHero: UITableViewCell {

    @IBOutlet weak var nameHero: UILabel!
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var firstYearAppearsInComics: UILabel!
    @IBOutlet var cornerRadiusForLabels: [UILabel]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        for label in cornerRadiusForLabels {
//            label.layer.cornerRadius = 5
//        }
    }
    
}
