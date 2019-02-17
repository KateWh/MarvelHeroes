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
    let marvelHeroesViewModel = HeroesViewModel()
    var spinner = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // create spinner to refresh footer animation
        spinner = UIActivityIndicatorView(style: .whiteLarge)
        spinner.stopAnimating()
        spinner.hidesWhenStopped = true
        spinner.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 60)
        spinner.color = #colorLiteral(red: 1, green: 0.9729014094, blue: 0.05995802723, alpha: 1)
        tableView.tableFooterView = spinner
        
        tableView.separatorColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)

        marvelHeroesViewModel.updateData { (error) in
            if error == nil {
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let heroInfoLink = marvelHeroesViewModel.getHeroInfoLink(forIndexPath: indexPath)
        // go to hero info web page
        self.performSegue(withIdentifier: "goToHeroInfo", sender: URL(string: heroInfoLink))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return marvelHeroesViewModel.allHeroesData.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HeroTableViewCell
        cell.updateCell(withResults: marvelHeroesViewModel.allHeroesData[indexPath.row])
        
        return cell
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        return footerView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
       return 40
    }
    
    // pagination cells
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !(indexPath.row + 1 < marvelHeroesViewModel.allHeroesData.count) {
            spinner.startAnimating()
            // reload data
            marvelHeroesViewModel.updateData { (error) in
                guard error == nil else { return }
                tableView.reloadData()
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let WebVC = segue.destination as? WebVC
        WebVC?.heroLink = sender as? URL
    }
    
}
