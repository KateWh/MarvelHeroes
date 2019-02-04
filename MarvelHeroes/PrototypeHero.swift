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
    @IBOutlet var labelsWithHeroData: [UILabel]!
    @IBOutlet weak var comicsLabel: UILabel!
    @IBOutlet weak var seriesLabel: UILabel!
    @IBOutlet weak var storiesLabel: UILabel!
    @IBOutlet weak var eventsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        for label in labelsWithHeroData {
            label.layer.cornerRadius = 5
            label.layer.masksToBounds = true
        }
    }
    
    // find matches in string by the RegEx pattern
    func matches(for regex: String, in text: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let nsString = text as NSString
            let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
            return results.map { nsString.substring(with: $0.range) }
        } catch let error {
            print(error)
            return []
        }
    }
    
    // find the greatest date when the hero first appeared
    func findGreatestDate(from results: Results) -> String {
        var dateArray = [String]()
        for item in results.comics.items {
            let comicsDateOfOneHero = matches(for: "\\([0-9]{4}\\)", in: item.name)
            if comicsDateOfOneHero != [] {
                dateArray.append(comicsDateOfOneHero[0])
            }
        }
        return dateArray.sorted(by: < ).first ?? "(????)"
    }

    // assembled the cell
    func updateCell(withResults results: Results) {
        var imageLink = results.thumbnail.path + "." + results.thumbnail.extension
        // insert "s" for "https", because source link looks like "http", and iOS is angry!
        imageLink.insert("s", at: imageLink.index(imageLink.startIndex, offsetBy: 4))
        self.myImageView.sd_setImage(with: URL(string: imageLink), completed: nil)
        self.nameHero.text = String(results.name)
        self.firstYearAppearsInComics.text = findGreatestDate(from: results)
        self.comicsLabel.text = String(results.comics.available)
        self.seriesLabel.text = String(results.series.available)
        self.storiesLabel.text = String(results.stories.available)
        self.eventsLabel.text = String(results.events.available)
    }
    
}
