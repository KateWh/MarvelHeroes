//
//  PrototypeHero.swift
//  MarvelHeroes
//
//  Created by ket on 30.01.2019.
//  Copyright © 2019 ket. All rights reserved.
//

import UIKit

class HeroTableViewCell: UITableViewCell {
    
    @IBOutlet weak var heroNameLabel: UILabel!
    @IBOutlet weak var heroImageLabel: UIImageView!
    @IBOutlet weak var firstYearAppearsInComicsLabel: UILabel!
    @IBOutlet var detailsAboutHeroLabels: [UILabel]!
    @IBOutlet weak var comicsLabel: UILabel!
    @IBOutlet weak var seriesLabel: UILabel!
    @IBOutlet weak var storiesLabel: UILabel!
    @IBOutlet weak var eventsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // set corner radius to details labels
        for label in detailsAboutHeroLabels {
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
    
    // find the earliest date when the hero first appeared
    func findEarliestDate(from results: Hero) -> String {
        var dateArray = [String]()
        for comics in results.comics.items {
            let comicsDate = matches(for: "\\([0-9]{4}\\)", in: comics.name)
            if comicsDate != [] {
                dateArray.append(comicsDate[0])
            }
        }
        return dateArray.sorted(by: < ).first ?? "(????)"
    }

    // assembled the cell
    func updateCell(withResults results: Hero) {
        // replase "http" with "https", because source link looks like "http", and iOS is angry 😡!

        let imageLink = "https" + results.thumbnail.path.dropFirst(4) + "." + results.thumbnail.extension
        self.heroImageLabel.sd_setImage(with: URL(string: imageLink), completed: nil)
        self.heroNameLabel.text = String(results.name)
        self.firstYearAppearsInComicsLabel.text = findEarliestDate(from: results)
        self.comicsLabel.text = String(results.comics.available)
        self.seriesLabel.text = String(results.series.available)
        self.storiesLabel.text = String(results.stories.available)
        self.eventsLabel.text = String(results.events.available)
    }

}
