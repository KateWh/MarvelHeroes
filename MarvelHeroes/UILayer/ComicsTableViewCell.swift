//
//  ComicsTableViewCell.swift
//  MarvelHeroes
//
//  Created by ket on 3/7/19.
//  Copyright © 2019 ket. All rights reserved.
//

import UIKit

class ComicsTableViewCell: UITableViewCell {

    @IBOutlet weak var comicsNameLabel: UILabel!
    @IBOutlet weak var comicsImageLabel: UIImageView!
    @IBOutlet weak var comicsFirstYearAppearsLabel: UILabel!
    @IBOutlet var comicsDetailsLabels: [UILabel]!
    @IBOutlet weak var comicsCharactersLabel: UILabel!
    @IBOutlet weak var comicsSeriesLabel: UILabel!
    @IBOutlet weak var comicsStoriesLabel: UILabel!
    @IBOutlet weak var comicsCreatorsLabel: UILabel!
    @IBOutlet weak var comicsFormat: UILabel!
    @IBOutlet weak var comicsPages: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // set corner radius to details labels
        for label in comicsDetailsLabels {
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
    
    // find the earliest date when the comics first appeared
    func findEarliestDate(from results: Comics) -> String {
        var dateArray = [String]()
            let comicsDate = matches(for: "\\([0-9]{4}\\)", in: results.title)
            if comicsDate != [] {
                dateArray.append(comicsDate[0])
            }
        return dateArray.sorted(by: < ).first ?? "(????)"
    }

    // assembled the cell
    func updateCell(withResults results: Comics) {
        // replase "http" with "https", because source link looks like "http", and iOS is angry 😡!
        let imageLink = "https" + results.thumbnail.path.dropFirst(4) + "." + results.thumbnail.extension
        self.comicsFirstYearAppearsLabel.text = findEarliestDate(from: results)
        self.comicsImageLabel.sd_setImage(with: URL(string: imageLink), completed: nil)
        self.comicsNameLabel.text = results.title
        self.comicsPages.text = String(describing: results.pageCount)
        self.comicsCharactersLabel.text = String(describing: results.characters.available)
        self.comicsSeriesLabel.text = "1"
        self.comicsStoriesLabel.text = String(describing: results.stories.available)
        self.comicsCreatorsLabel.text = String(describing: results.creators.available)
        self.comicsFormat.text = String(describing: results.format)
    }

}
