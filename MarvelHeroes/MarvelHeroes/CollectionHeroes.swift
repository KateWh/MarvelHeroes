//
//  TableViewCell.swift
//  MarvelHeroes
//
//  Created by ket on 30.01.2019.
//  Copyright © 2019 ket. All rights reserved.
//

import UIKit
import SDWebImage

class CollectionHeroes: UITableViewController {
    let marvelHeroes = GetHeroes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateData()
    }
    
    
    func updateData() {
        marvelHeroes.getHeroes(withLimit: 20) { (error) in
            if error == nil {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                print("ERROR: No response from server!")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var detailHeroURL = ""
        var wikiLink = ""
        // find "wiki" key among data
        for url in marvelHeroes.allAboutHero[indexPath.row].urls {
            if url.type == "wiki" {
                wikiLink = url.url
            } else {
                detailHeroURL = url.url
            }
        }
        // go to "wiki" link of "detail" link
        if wikiLink != "" {
            wikiLink.insert("s", at: wikiLink.index(wikiLink.startIndex, offsetBy: 4))
            self.performSegue(withIdentifier: "goToHeroInfo", sender: URL(string: wikiLink))
        } else {
            detailHeroURL.insert("s", at: detailHeroURL.index(detailHeroURL.startIndex, offsetBy: 4))
            self.performSegue(withIdentifier: "goToHeroInfo", sender: URL(string: detailHeroURL))
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return marvelHeroes.allAboutHero.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PrototypeHero
        cell.updateCell(withResults: marvelHeroes.allAboutHero[indexPath.row])
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let WebVC = segue.destination as? WebVC
        WebVC?.newsLink = sender as? URL
    }
}
