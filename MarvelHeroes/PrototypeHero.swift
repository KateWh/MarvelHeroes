//
//  PrototypeHero.swift
//  MarvelHeroes
//
//  Created by vitket team on 30.01.2019.
//  Copyright © 2019 vitket team. All rights reserved.
//

import UIKit
import SDWebImage

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

    func loadHero(about hero: Results) {
        let imageURL = "https" + hero.thumbnail.path.dropFirst(4) + "." + hero.thumbnail.extension

        nameHero.text = hero.name
        myImageView.sd_setImage(with: URL(string: imageURL), completed: nil)
    }
    
}
