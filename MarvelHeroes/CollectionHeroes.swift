//
//  TableViewCell.swift
//  MarvelHeroes
//
//  Created by ket on 30.01.2019.
//  Copyright © 2019 ket. All rights reserved.
//

import UIKit

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
        marvelHeroes.getHeroes(withLimit: 5) { (error) in
            if error == nil {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                print("ERROR: No response from server!")
            }
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
        cell.loadHero(about: marvelHeroes.allAboutHero[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertLinks = UIAlertController(title: "Which way do you choose?" , message: "", preferredStyle: UIAlertController.Style.alert)

        alertLinks.addAction(UIAlertAction(
            title: "Wiki", style: .default, handler: { action in self.goToWebVC(for: "wiki", and: indexPath.row)}))

        alertLinks.addAction(UIAlertAction(title: "Detail", style: .default, handler: { action in self.goToWebVC(for: "detail", and: indexPath.row) }))

        alertLinks.addAction(UIAlertAction(title: "Comic link", style: .default, handler: { action in self.goToWebVC(for: "comiclink", and: indexPath.row) }))
        self.present(alertLinks, animated: true)

        alertLinks.addAction(UIAlertAction(title: "Cancel", style: .default , handler: nil))
    }

    func goToWebVC(for key: String, and hero: Int) {
        var detailLink = URL(string: "")
        for value in marvelHeroes.allAboutHero[hero].urls.enumerated() {
            if key == value.element.type {
               let ATSbandit = value.element.url
                detailLink = URL(string: "https" + ATSbandit.dropFirst(4))
            }
        }
        self.performSegue(withIdentifier: "goToHero", sender: detailLink)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let WebVC = segue.destination as? WebVC
        WebVC?.detailLink = sender as? URL
    }

}
