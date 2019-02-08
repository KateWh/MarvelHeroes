//
//  TableViewCell.swift
//  MarvelHeroes
//
//  Created by ket on 30.01.2019.
//  Copyright © 2019 ket. All rights reserved.
//

import UIKit
import SDWebImage

class HeroesTableVC: UITableViewController {
    let marvelHeroes = HeroesViewModel()
    var allHeroesData: [Hero] = []
    var characterDataWrapper: [CharacterDataWrapper]? = nil


    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        updateData()
    }

    // get retrieve heroes data
    func updateData() {
        let offset = characterDataWrapper?[0].data.offset
        marvelHeroes.getHeroes(withLimit: 12, withOffset: offset ?? 0) { (result) in
            switch result {
            case .success(let allAboutHero):
                self.allHeroesData += allAboutHero.data.results
                self.characterDataWrapper = [allAboutHero] as [CharacterDataWrapper]?
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)

            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var detailLink = ""
        var wikiLink = ""
        // find "wiki" key among data
        for url in allHeroesData[indexPath.row].urls {
            if url.type == "wiki" {
                wikiLink = url.url
            } else {
                detailLink = url.url
            }
        }
        // go to "wiki" link or "detail" link
        if wikiLink != "" {
            wikiLink.insert("s", at: wikiLink.index(wikiLink.startIndex, offsetBy: 4))
            self.performSegue(withIdentifier: "goToHeroInfo", sender: URL(string: wikiLink))
        } else {
            detailLink.insert("s", at: detailLink.index(detailLink.startIndex, offsetBy: 4))
            self.performSegue(withIdentifier: "goToHeroInfo", sender: URL(string: detailLink))
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allHeroesData.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HeroTableViewCell
        cell.updateCell(withResults: allHeroesData[indexPath.row])
        // pagination cells
        print(tableView.indexPathsForVisibleRows![0][1] + 4)
        if (tableView.indexPathsForVisibleRows! != []) && (tableView.indexPathsForVisibleRows![0][1] + 4) == allHeroesData.count {
            updateData()
        }
        
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let WebVC = segue.destination as? WebVC
        WebVC?.heroLink = sender as? URL
    }
    
}
