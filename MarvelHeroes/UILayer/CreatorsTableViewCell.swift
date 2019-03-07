//
//  CreatorsTableViewCell.swift
//  MarvelHeroes
//
//  Created by ket on 3/7/19.
//  Copyright © 2019 ket. All rights reserved.
//

import UIKit

class CreatorsTableViewCell: UITableViewCell {

    @IBOutlet weak var creatorsNameLabel: UILabel!
    @IBOutlet weak var creatorsImageLabel: UIImageView!
    @IBOutlet weak var creatorsFirstYearAppearsInComicsLabel: UILabel!
    @IBOutlet var creatorsDetailsAboutHeroLabels: [UILabel]!
    @IBOutlet weak var creatorsComicsLabel: UILabel!
    @IBOutlet weak var creatorsSeriesLabel: UILabel!
    @IBOutlet weak var creatorsStoriesLabel: UILabel!
    @IBOutlet weak var creatorsEventsLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // set corner radius to details labels
        for label in creatorsDetailsAboutHeroLabels {
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



    // assembled the cell
    func updateCell(withResults results: Creators) {
        // replase "http" with "https", because source link looks like "http", and iOS is angry 😡!
        let imageLink = "https" + results.thumbnail.path.dropFirst(4) + "." + results.thumbnail.extension
        self.creatorsImageLabel.sd_setImage(with: URL(string: imageLink), completed: nil)
        self.creatorsNameLabel.text = String(results.fullName)
    }

}
